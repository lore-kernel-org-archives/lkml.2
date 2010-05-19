Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0ESAeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:34:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab0ESAeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:34:00 -0400
Message-ID: <4BF331E4.4010906@redhat.com>
Date: Tue, 18 May 2010 20:33:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/5] perf probe: Don't call die()
References: <1274228881-8035-1-git-send-email-acme@infradead.org> <1274228881-8035-5-git-send-email-acme@infradead.org>
In-Reply-To: <1274228881-8035-5-git-send-email-acme@infradead.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Functions that were calling xzalloc also returned -1 when, for other
> reasons, it could fail, and the calleds are coping with failures, so
> stop using die() and xzalloc().
> 

OK, but could you return -ENOMEM if failed to call zalloc()?

> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-probe.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 61c6d70..99b1728 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -65,8 +65,10 @@ static int parse_probe_event(const char *str)
>  	int ret;
>  
>  	pr_debug("probe-definition(%d): %s\n", params.nevents, str);
> -	if (++params.nevents == MAX_PROBES)
> -		die("Too many probes (> %d) are specified.", MAX_PROBES);
> +	if (++params.nevents == MAX_PROBES) {
> +		pr_err("Too many probes (> %d) were specified.", MAX_PROBES);
> +		return -1;
> +	}
>  
>  	/* Parse a perf-probe command into event */
>  	ret = parse_perf_probe_command(str, pev);
> @@ -84,7 +86,9 @@ static int parse_probe_event_argv(int argc, const char **argv)
>  	len = 0;
>  	for (i = 0; i < argc; i++)
>  		len += strlen(argv[i]) + 1;
> -	buf = xzalloc(len + 1);
> +	buf = zalloc(len + 1);
> +	if (buf == NULL)
> +		return -1;
>  	len = 0;
>  	for (i = 0; i < argc; i++)
>  		len += sprintf(&buf[len], "%s ", argv[i]);

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
