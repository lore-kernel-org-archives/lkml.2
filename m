Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2BMSgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:36:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47070 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2BMSgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:36:10 -0500
Date: Mon, 13 Feb 2012 16:36:00 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] perf tools: Introduce check_target_maps() helper
Message-ID: <20120213183600.GF15955@infradead.org>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
 <1329118064-9412-5-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329118064-9412-5-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 13, 2012 at 04:27:36PM +0900, Namhyung Kim escreveu:
> The check_target_maps function is used to check given PID/TID/UID/CPU
> target options and warn if some combination is impossible. Also this
> can make some arguments of parse_target_uid() function useless as it
> is checked before the call via our new helper.

Here I think the naming should be:

  perf_target__validate(&rec->opts.target);

instead of check_target_maps(...)

I.e. prefix with the struct name followed by two _, that is the practice
in tools/perf/, at least in code I wrote :-)

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/builtin-record.c |    9 +++------
>  tools/perf/builtin-stat.c   |    3 +--
>  tools/perf/builtin-top.c    |   15 +++------------
>  tools/perf/util/usage.c     |   30 ++++++++++++++++++++++--------
>  tools/perf/util/util.h      |    4 +++-
>  5 files changed, 32 insertions(+), 29 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 7b50316136bf..9e209e3279e4 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -783,15 +783,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  		goto out_symbol_exit;
>  	}
>  
> -	rec->opts.maps.uid = parse_target_uid(rec->opts.maps.uid_str,
> -					      rec->opts.maps.target_tid,
> -					      rec->opts.maps.target_pid);
> +	check_target_maps(&rec->opts.maps);
> +
> +	rec->opts.maps.uid = parse_target_uid(rec->opts.maps.uid_str);
>  	if (rec->opts.maps.uid_str && rec->opts.maps.uid == UINT_MAX - 1)
>  		goto out_free_fd;
>  
> -	if (rec->opts.maps.target_pid != -1)
> -		rec->opts.maps.target_tid = rec->opts.maps.target_pid;
> -
>  	if (perf_evlist__create_maps(evsel_list, rec->opts.maps.target_pid,
>  				     rec->opts.maps.target_tid, rec->opts.maps.uid,
>  				     rec->opts.maps.cpu_list) < 0)
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 14a30c2b9fe0..f1f4e8f60a3e 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -1207,8 +1207,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  	if (add_default_attributes())
>  		goto out;
>  
> -	if (maps.target_pid != -1)
> -		maps.target_tid = maps.target_pid;
> +	check_target_maps(&maps);
>  
>  	evsel_list->threads = thread_map__new(maps.target_pid, maps.target_tid,
>  					      UINT_MAX);
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 36917458ea53..9e9a8de78899 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1207,21 +1207,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  
>  	setup_browser(false);
>  
> -	top.maps.uid = parse_target_uid(top.maps.uid_str, top.maps.target_tid,
> -					top.maps.target_pid);
> +	check_target_maps(&top.maps);
> +
> +	top.maps.uid = parse_target_uid(top.maps.uid_str);
>  	if (top.maps.uid_str != NULL && top.maps.uid == UINT_MAX - 1)
>  		goto out_delete_evlist;
>  
> -	/* CPU and PID are mutually exclusive */
> -	if (top.maps.target_tid > 0 && top.maps.cpu_list) {
> -		printf("WARNING: PID switch overriding CPU\n");
> -		sleep(1);
> -		top.maps.cpu_list = NULL;
> -	}
> -
> -	if (top.maps.target_pid != -1)
> -		top.maps.target_tid = top.maps.target_pid;
> -
>  	if (perf_evlist__create_maps(top.evlist, top.maps.target_pid,
>  				     top.maps.target_tid, top.maps.uid,
>  				     top.maps.cpu_list) < 0)
> diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
> index d0c013934f30..d235013600e5 100644
> --- a/tools/perf/util/usage.c
> +++ b/tools/perf/util/usage.c
> @@ -83,7 +83,7 @@ void warning(const char *warn, ...)
>  	va_end(params);
>  }
>  
> -uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
> +uid_t parse_target_uid(const char *str)
>  {
>  	struct passwd pwd, *result;
>  	char buf[1024];
> @@ -91,13 +91,6 @@ uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
>  	if (str == NULL)
>  		return UINT_MAX;
>  
> -	/* CPU and PID are mutually exclusive */
> -	if (tid > 0 || pid > 0) {
> -		ui__warning("PID/TID switch overriding UID\n");
> -		sleep(1);
> -		return UINT_MAX;
> -	}
> -
>  	getpwnam_r(str, &pwd, buf, sizeof(buf), &result);
>  
>  	if (result == NULL) {
> @@ -120,3 +113,24 @@ uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
>  
>  	return result->pw_uid;
>  }
> +
> +void check_target_maps(struct perf_maps_opts *maps)
> +{
> +	if (maps->target_pid != -1)
> +		maps->target_tid = maps->target_pid;
> +
> +	/* CPU and PID are mutually exclusive */
> +	if (maps->target_tid > 0 && maps->cpu_list) {
> +		ui__warning("PID/TID switch overriding CPU\n");
> +		sleep(1);
> +		maps->cpu_list = NULL;
> +	}
> +
> +	/* UID and PID are mutually exclusive */
> +	if (maps->target_tid > 0 && maps->uid_str) {
> +		ui__warning("PID/TID switch overriding UID\n");
> +		sleep(1);
> +		maps->uid_str = NULL;
> +	}
> +
> +}
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 232d17ef3e60..2573985f8408 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -242,10 +242,12 @@ unsigned long convert_unit(unsigned long value, char *unit);
>  int readn(int fd, void *buf, size_t size);
>  
>  struct perf_event_attr;
> +struct perf_maps_opts;
>  
>  void event_attr_init(struct perf_event_attr *attr);
>  
> -uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid);
> +uid_t parse_target_uid(const char *str);
> +void check_target_maps(struct perf_maps_opts *maps);
>  
>  #define _STR(x) #x
>  #define STR(x) _STR(x)
> -- 
> 1.7.9
