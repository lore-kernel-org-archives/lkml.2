Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0KZMN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:13:28 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:54529 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KZMN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:13:27 -0500
Date: Fri, 26 Nov 2010 13:13:25 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>
Subject: Re: [patch 1/3] printk: fix wake_up_klogd() vs cpu hotplug
Message-ID: <20101126121325.GA7023@osiris.boeblingen.de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
 <20101126120235.091835714@de.ibm.com>
 <1290773408.2145.138.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290773408.2145.138.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 01:10:08PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-26 at 13:00 +0100, Heiko Carstens wrote:
> > plain text document attachment (001_printk_preempt.diff)
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > wake_up_klogd() may get called from preemtible context but uses
> > __raw_get_cpu_var() to write to a per cpu variable. If it gets preempted between
> > getting the address and writing to it, the cpu in question could be offline if
> > the process gets scheduled back and hence writes to the per cpu data of an offline
> > cpu.
> > 
> > No idea why that behaviour was introduced with fa33507a "printk: robustify
> > printk, fix #2" which was supposed to fix a "using smp_processor_id() in
> > preemptible" warning.
> > 
> > Let's use get_cpu_var() instead which disables preemption and makes sure that
> > the outlined scenario cannot happen.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > ---
> >  kernel/printk.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -1087,8 +1087,10 @@ int printk_needs_cpu(int cpu)
> >  
> >  void wake_up_klogd(void)
> >  {
> > -	if (waitqueue_active(&log_wait))
> > -		__raw_get_cpu_var(printk_pending) = 1;
> > +	if (waitqueue_active(&log_wait)) {
> > +		get_cpu_var(printk_pending) = 1;
> > +		put_cpu_var(printk_pending);
> > +	}
> >  }
> >  
> >  /**
> > 
> 
> But but but, the cpu can still be offlined between writing this state
> and the next tick happening, right?

Yes, that's what the second patch would fix as a side effect.
