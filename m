Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2IXHNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:13:44 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48317 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2IXHNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:13:43 -0400
X-AuditID: b753bd60-97c52ba000002f78-fe-506008242d2b
X-AuditID: b753bd60-97c52ba000002f78-fe-506008242d2b
Message-ID: <5060081C.3060903@hitachi.com>
Date: Mon, 24 Sep 2012 16:13:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: irina.tirdea@gmail.com
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v2 1/1] perf tools: remove sscanf extension %as
References: <1347574063-22521-2-git-send-email-irina.tirdea@intel.com> <1348173470-4936-1-git-send-email-irina.tirdea@gmail.com>
In-Reply-To: <1348173470-4936-1-git-send-email-irina.tirdea@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/21 5:37), irina.tirdea@gmail.com wrote:
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

OK, I've reviewed and tested, looks good! :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/util/probe-event.c       |   36 ++++++++++++++++++++++++++++-------
>  tools/perf/util/trace-event-parse.c |   18 ++++++++----------
>  2 files changed, 37 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 4ce04c2..49a256e 100644
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
> @@ -1116,14 +1117,27 @@ static int parse_probe_trace_command(const char *cmd,
>  	}
>  
>  	/* Scan event and group name. */
> -	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
> -		     &pr, (float *)(void *)&tev->group,
> -		     (float *)(void *)&tev->event);
> -	if (ret != 3) {
> +	argv0_str = strdup(argv[0]);
> +	if (argv0_str == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
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
> +	if (tev->group == NULL || tev->event == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  	pr_debug("Group:%s Event:%s probe:%c\n", tev->group, tev->event, pr);
>  
>  	tp->retprobe = (pr == 'r');
> @@ -1135,10 +1149,17 @@ static int parse_probe_trace_command(const char *cmd,
>  		p++;
>  	} else
>  		p = argv[1];
> -	ret = sscanf(p, "%a[^+]+%lu", (float *)(void *)&tp->symbol,
> -		     &tp->offset);
> -	if (ret == 1)
> +	fmt1_str = strtok_r(p, "+", &fmt);
> +	tp->symbol = strdup(fmt1_str);
> +	if (tp->symbol == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	fmt2_str = strtok_r(NULL, "", &fmt);
> +	if (fmt2_str == NULL)
>  		tp->offset = 0;
> +	else
> +		tp->offset = strtoul(fmt2_str, NULL, 10);
>  
>  	tev->nargs = argc - 2;
>  	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
> @@ -1162,6 +1183,7 @@ static int parse_probe_trace_command(const char *cmd,
>  	}
>  	ret = 0;
>  out:
> +	free(argv0_str);
>  	argv_free(argv);
>  	return ret;
>  }
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index aa4c860..3aabcd6 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -229,24 +229,22 @@ void parse_proc_kallsyms(struct pevent *pevent,
>  	char *next = NULL;
>  	char *addr_str;
>  	char *mod;
> -	char ch;
> +	char *fmt;
>  
>  	line = strtok_r(file, "\n", &next);
>  	while (line) {
>  		mod = NULL;
> -		sscanf(line, "%as %c %as\t[%as",
> -		       (float *)(void *)&addr_str, /* workaround gcc warning */
> -		       &ch, (float *)(void *)&func, (float *)(void *)&mod);
> +		addr_str = strtok_r(line, " ", &fmt);
>  		addr = strtoull(addr_str, NULL, 16);
> -		free(addr_str);
> -
> -		/* truncate the extra ']' */
> +		/* skip character */
> +		strtok_r(NULL, " ", &fmt);
> +		func = strtok_r(NULL, "\t", &fmt);
> +		mod = strtok_r(NULL, "]", &fmt);
> +		/* truncate the extra '[' */
>  		if (mod)
> -			mod[strlen(mod) - 1] = 0;
> +			mod = mod + 1;
>  
>  		pevent_register_function(pevent, func, addr, mod);
> -		free(func);
> -		free(mod);
>  
>  		line = strtok_r(NULL, "\n", &next);
>  	}
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


