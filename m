Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2AaBbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:31:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34828 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2AaBbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:31:02 -0500
Date: Mon, 30 Jan 2012 23:30:54 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf: Add error message for EMFILE
Message-ID: <20120131013054.GB25293@infradead.org>
References: <1327972517-5055-1-git-send-email-namhyung.kim@lge.com>
 <1327972517-5055-2-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327972517-5055-2-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 31, 2012 at 10:15:16AM +0900, Namhyung Kim escreveu:
> When a user tries to open so many event on multiple tasks/cpus,
> perf_event_open syscall may fail with EMFILE. Provide an advice
> for that case.

I'll apply this one, but can you investigate a way to share this error
handling accross the tools?

A helper routine that doesn't call exit, but returns failure that will
then cause the tool to decide if it exits or what (TUI ones could
continue and the user could then select some other operation that would
work, etc).

It should standardize on ui__warning(), that already takes into account
if the UI is --stdio or --tui (in the future a GUI too), etc.

Thanks a lot!

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/builtin-record.c |    5 +++++
>  tools/perf/builtin-stat.c   |    4 ++++
>  tools/perf/builtin-top.c    |    3 ++-
>  3 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 32870eef952f..a334008a1853 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -249,6 +249,11 @@ try_again:
>  				ui__warning("The %s event is not supported.\n",
>  					    event_name(pos));
>  				exit(EXIT_FAILURE);
> +			} else if (err == EMFILE) {
> +				ui__warning("Too many events are opened.\n"
> +					    "Try again after reducing the number of events,\n"
> +					    "tasks and/or cpus.\n");
> +				exit(EXIT_FAILURE);
>  			}
>  
>  			printf("\n");
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 459b8620a5d9..7c5421c7af06 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -477,6 +477,10 @@ static int run_perf_stat(int argc __used, const char **argv)
>  				      "\t Consider tweaking"
>  				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
>  				      system_wide ? "system-wide " : "");
> +			} else if (errno == EMFILE) {
> +				error("Too many events are opened.\n"
> +				      "\t Try again after reducing the number of events,\n"
> +				      "\t tasks and/or cpus.");
>  			} else {
>  				error("open_counter returned with %d (%s). "
>  				      "/bin/dmesg may provide additional information.\n",
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index e8b033c074f9..987af3695218 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -899,7 +899,8 @@ try_again:
>  				goto out_err;
>  			} else if (err == EMFILE) {
>  				ui__warning("Too many events are opened.\n"
> -					    "Try again after reducing the number of events\n");
> +					    "Try again after reducing the number of events,\n"
> +					    "tasks and/or cpus.\n");
>  				goto out_err;
>  			}
>  
> -- 
> 1.7.9.rc1.dirty
