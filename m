Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab1CWUq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:46:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38471 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933268Ab1CWUqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:46:55 -0400
Date: Wed, 23 Mar 2011 15:46:47 -0500
From: Jack Steiner <steiner@sgi.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110323204647.GA30938@sgi.com>
References: <20110321175110.GL1239@redhat.com> <20110321182235.GA14562@sgi.com> <20110321193740.GN1239@redhat.com> <20110322171118.GA6294@sgi.com> <20110322184450.GU1239@redhat.com> <20110322212519.GA12076@sgi.com> <20110322220505.GB13453@redhat.com> <20110323163255.GA17178@sgi.com> <20110323175320.GB9413@redhat.com> <20110323200008.GZ1239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323200008.GZ1239@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 04:00:08PM -0400, Don Zickus wrote:
> On Wed, Mar 23, 2011 at 01:53:20PM -0400, Don Zickus wrote:
> > Let me know if the patch fixes that problem.  Then it will be one less
> > thing to worry about. :-)
> 
> Ok, I was an idiot and made the patch against RHEL-6.  Here is the one
> against 2.6.38.  Sorry about that.

No problem.

I applied the patch below. However, I still see the "dazed" messages with
about the same frequency.

> 
> Cheers,
> Don
> 
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 87eab4a..62ec8e9 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1375,7 +1375,7 @@ perf_event_nmi_handler(struct notifier_block *self,
>  	if ((handled > 1) ||
>  		/* the next nmi could be a back-to-back nmi */
>  	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
> -	     (__this_cpu_read(pmu_nmi.handled) > 1))) {
> +	     (__this_cpu_read(pmu_nmi.handled) > 0) && handled && this_nmi)) {
>  		/*
>  		 * We could have two subsequent back-to-back nmis: The
>  		 * first handles more than one counter, the 2nd
> @@ -1386,6 +1386,8 @@ perf_event_nmi_handler(struct notifier_block *self,
>  		 * handling more than one counter. We will mark the
>  		 * next (3rd) and then drop it if unhandled.
>  		 */
> +		//if ((__this_cpu_read(pmu_nmi.handled) == 1) && (handled == 1))
> +		//	trace_printk("!! fixed?\n");
>  		__this_cpu_write(pmu_nmi.marked, this_nmi + 1);
>  		__this_cpu_write(pmu_nmi.handled, handled);
>  	}
