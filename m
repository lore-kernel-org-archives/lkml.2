Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1AQRdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:33:08 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:43701
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938Ab1AQRdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:33:04 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzz8275dhz2dh2a8h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Date: Mon, 17 Jan 2011 11:32:50 -0600
From: Scott Wood <scottwood@freescale.com>
To: Anton Blanchard <anton@samba.org>
CC: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: perf: Fix frequency calculation for
 overflowing counters
Message-ID: <20110117113250.48098aaa@udp111988uds.am.freescale.net>
In-Reply-To: <20110117161742.5feb3761@kryten>
References: <20110117161742.5feb3761@kryten>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011 16:17:42 +1100
Anton Blanchard <anton@samba.org> wrote:

> 
> When profiling a benchmark that is almost 100% userspace, I noticed some
> wildly inaccurate profiles that showed almost all time spent in the kernel.
> Closer examination shows we were programming a tiny number of cycles into
> the PMU after each overflow (about ~200 away from the next overflow). This
> gets us stuck in a loop which we eventually break out of by throttling the
> PMU (there are regular throttle/unthrottle events in the log).
> 
> It looks like we aren't setting event->hw.last_period to something same
> and the frequency to period calculations in perf are going haywire. With
> the following patch we find the correct period after a few interrupts and
> stay there. I also see no more throttle events.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
> index 5674807..ab6f6be 100644
> --- a/arch/powerpc/kernel/perf_event.c
> +++ b/arch/powerpc/kernel/perf_event.c
> @@ -1212,6 +1212,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
>  			if (left <= 0)
>  				left = period;
>  			record = 1;
> +			event->hw.last_period = event->hw.sample_period;
>  		}
>  		if (left < 0x80000000LL)
>  			val = 0x80000000LL - left;
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

Does perf_event_fsl_emb.c need this as well (it has almost the same
record_and_restart code)?

-Scott

