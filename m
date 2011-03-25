Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1CYSIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:08:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53783 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1CYSIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=NjYxzeJ/jZujQ5+U63A+97K4An8f+e5CKPBKtavKvqAThY76vgETw6jfmWnfR/3C1W
         2YDjzOcefWg3O2e31JCMbokwmKESOYnKEsS2uBkzzzBn5XOHR6VeA6E9ZeIIFfeh8Bjz
         QGkDhSlEtY1+RgqFYg8LHTWbgMsp+qWBcRrKo=
Date: Fri, 25 Mar 2011 15:08:40 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Emit clearer message for sys_perf_event_open
 ENOENT return
Message-ID: <20110325180840.GE13180@ghostprotocols.net>
References: <1301076350-19593-1-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301076350-19593-1-git-send-email-daahern@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 25, 2011 at 12:05:50PM -0600, David Ahern escreveu:
> Resend of patch sent back in January 2011 in light of recent confusion around
> unsupported events for a given platform.
> 
> Improve sys_perf_event_open ENOENT return handling in top and record, just
> like 5a3446b does for stat.
> 
> Retry of Arnaldo's patch using error instead of die which allows the fallback
> from hardware cycles to software clock.

Please use ui__warning(""...) as it will work in the TUI too.
 
> Signed-off-by: David Ahern <daahern@cisco.com>
> ---
>  tools/perf/builtin-record.c |    6 ++++++
>  tools/perf/builtin-top.c    |    7 +++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 6febcc1..73fa8b7 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -282,6 +282,8 @@ try_again:
>  			else if (err ==  ENODEV && cpu_list) {
>  				die("No such device - did you specify"
>  					" an out-of-range profile CPU?\n");
> +			} else if (err ==  ENOENT) {
> +				error("%s event is not supported.", event_name(pos));
>  			} else if (err == EINVAL && sample_id_all_avail) {
>  				/*
>  				 * Old kernel, no attr->sample_id_type_all field
> @@ -307,6 +309,10 @@ try_again:
>  				attr->config = PERF_COUNT_SW_CPU_CLOCK;
>  				goto try_again;
>  			}
> +
> +			if (err == ENOENT)
> +				exit(1);
> +
>  			printf("\n");
>  			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
>  			      err, strerror(err));
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 80c9e06..ab27693 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -852,6 +852,9 @@ try_again:
>  				die("Permission error - are you root?\n"
>  					"\t Consider tweaking"
>  					" /proc/sys/kernel/perf_event_paranoid.\n");
> +			else if (err == ENOENT)
> +				error("%s event is not supported.", event_name(counter));
> +
>  			/*
>  			 * If it's cycles then fall back to hrtimer
>  			 * based cpu-clock-tick sw counter, which
> @@ -867,6 +870,10 @@ try_again:
>  				attr->config = PERF_COUNT_SW_CPU_CLOCK;
>  				goto try_again;
>  			}
> +
> +			if (err == ENOENT)
> +				exit(1);
> +
>  			printf("\n");
>  			error("sys_perf_event_open() syscall returned with %d "
>  			      "(%s).  /bin/dmesg may provide additional information.\n",
> -- 
> 1.7.4
