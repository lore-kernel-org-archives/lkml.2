Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab2INCAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:00:48 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63506 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2INCAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:00:46 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-18-50528fcbfbc9
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/4] perf tools: remove sscanf extension %as
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
	<1347574063-22521-2-git-send-email-irina.tirdea@intel.com>
Date: Fri, 14 Sep 2012 10:54:01 +0900
In-Reply-To: <1347574063-22521-2-git-send-email-irina.tirdea@intel.com> (Irina
	Tirdea's message of "Fri, 14 Sep 2012 01:07:40 +0300")
Message-ID: <87ligd8j46.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Irina,

(Adding Masami to Cc)

On Fri, 14 Sep 2012 01:07:40 +0300, Irina Tirdea wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
>
> perf uses sscanf extension %as to read and allocate a
> string in the same step. This is a non-standard extension
> only present in new versions of glibc.
>
> Replacing the use of sscanf and %as with strtok_r calls
> in order to parse a given string into its components.
> This is needed in Android since bionic does not support
> %as extension for sscanf.
>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/util/probe-event.c       |   25 ++++++++++++++++++-------
>  tools/perf/util/trace-event-parse.c |   18 ++++++++----------
>  2 files changed, 26 insertions(+), 17 deletions(-)
>
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 4ce04c2..685ddcf 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1100,6 +1100,7 @@ static int parse_probe_trace_command(const char *cmd,
>  	struct probe_trace_point *tp = &tev->point;
>  	char pr;
>  	char *p;
> +	char *argv0_str = NULL, *fmt, *fmt1_str, *fmt2_str, *fmt3_str;
>  	int ret, i, argc;
>  	char **argv;
>  
> @@ -1116,14 +1117,19 @@ static int parse_probe_trace_command(const char *cmd,
>  	}
>  
>  	/* Scan event and group name. */
> -	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
> -		     &pr, (float *)(void *)&tev->group,
> -		     (float *)(void *)&tev->event);
> -	if (ret != 3) {
> +	argv0_str = strdup(argv[0]);

It seems you need to check return value of strdup.


> +	fmt1_str = strtok_r(argv0_str, ":", &fmt);
> +	fmt2_str = strtok_r(NULL, "/", &fmt);
> +	fmt3_str = strtok_r(NULL, " \t", &fmt);
> +	if (fmt1_str == NULL || strlen(fmt1_str) != 1 || fmt2_str == NULL
> +	    || fmt3_str == NULL) {
>  		semantic_error("Failed to parse event name: %s\n", argv[0]);
>  		ret = -EINVAL;
>  		goto out;
>  	}
> +	pr = fmt1_str[0];
> +	tev->group = strdup(fmt2_str);
> +	tev->event = strdup(fmt3_str);
>  	pr_debug("Group:%s Event:%s probe:%c\n", tev->group, tev->event, pr);
>  
>  	tp->retprobe = (pr == 'r');
> @@ -1135,10 +1141,13 @@ static int parse_probe_trace_command(const char *cmd,
>  		p++;
>  	} else
>  		p = argv[1];
> -	ret = sscanf(p, "%a[^+]+%lu", (float *)(void *)&tp->symbol,
> -		     &tp->offset);
> -	if (ret == 1)
> +	fmt1_str = strtok_r(p, "+", &fmt);
> +	tp->symbol = strdup(fmt1_str);

Probably here too - although the original code didn't but I think it's
needed.


> +	fmt2_str = strtok_r(NULL, "", &fmt);
> +	if (fmt2_str == NULL)
>  		tp->offset = 0;
> +	else
> +		tp->offset = strtoul(fmt2_str, NULL, 10);
>  
>  	tev->nargs = argc - 2;
>  	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
> @@ -1162,6 +1171,8 @@ static int parse_probe_trace_command(const char *cmd,
>  	}
>  	ret = 0;
>  out:
> +	if (argv0_str)
> +		free(argv0_str);

The free() can handle a NULL pointer safely.


>  	argv_free(argv);
>  	return ret;
>  }
