Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0DLRpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:45:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0DLRpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:45:35 -0400
Date: Mon, 12 Apr 2010 14:45:08 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip v3 04/10] perf probe: Query basic types from
	debuginfo
Message-ID: <20100412174508.GC6750@ghostprotocols.net>
References: <20100412171646.3790.64715.stgit@localhost6.localdomain6> <20100412171715.3790.23730.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412171715.3790.23730.stgit@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 12, 2010 at 01:17:15PM -0400, Masami Hiramatsu escreveu:
> Query the basic type information (byte-size and signed-flag) from
> debuginfo and pass that to kprobe-tracer. This is especially useful
> for tracing the members of data structure, because each member has
> different byte-size on the memory.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> 
>  tools/perf/util/probe-event.c  |    9 +++++
>  tools/perf/util/probe-event.h  |    1 +
>  tools/perf/util/probe-finder.c |   78 ++++++++++++++++++++++++++++++++++++----
>  3 files changed, 80 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 19de8b7..05ca4a9 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -740,6 +740,13 @@ static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
>  		buf += ret;
>  		buflen -= ret;
>  	}
> +	/* Print argument type */
> +	if (arg->type) {
> +		ret = e_snprintf(buf, buflen, ":%s", arg->type);
> +		if (ret <= 0)
> +			return ret;
> +		buf += ret;
> +	}
>  
>  	return buf - tmp;
>  }
> @@ -848,6 +855,8 @@ void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
>  			free(tev->args[i].name);
>  		if (tev->args[i].value)
>  			free(tev->args[i].value);
> +		if (tev->args[i].type)
> +			free(tev->args[i].type);

It follows the existing style but as kfree, free() also can cope with
NULL pointers, so unconditionally calling free is a shorter form, but
this can be fixed later, possibily in a big cleanup in all of
tools/perf.

- Arnaldo
