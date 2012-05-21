Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab2EUVJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:09:05 -0400
Received: from relay3.sgi.com ([192.48.152.1]:60386 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758302Ab2EUVJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:09:04 -0400
Date: Mon, 21 May 2012 16:09:01 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
Message-ID: <20120521210901.GA25326@sgi.com>
References: <20120521164959.GE16454@sgi.com>
 <1337634353.1997.144.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337634353.1997.144.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 02:05:53PM -0700, Suresh Siddha wrote:
> On Mon, 2012-05-21 at 11:49 -0500, Dimitri Sivanich wrote:
> > The smp_irq_move_cleanup_interrupt routine should be checking for a valid
> > irq_cfg pointer prior to accessing it.  It also seems that this should be
> > done after taking the desc lock.
> 
> I think these changes are correct. Did you see any crashes during module
> unload etc?

Yes, we have seen these on occasion during boot.

> 
> Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> > 
> > Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> > ---
> >  arch/x86/kernel/apic/io_apic.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > Index: linux/arch/x86/kernel/apic/io_apic.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/apic/io_apic.c
> > +++ linux/arch/x86/kernel/apic/io_apic.c
> > @@ -2478,9 +2478,12 @@ asmlinkage void smp_irq_move_cleanup_int
> >  		if (!desc)
> >  			continue;
> >  
> > -		cfg = irq_cfg(irq);
> >  		raw_spin_lock(&desc->lock);
> >  
> > +		cfg = irq_cfg(irq);
> > +		if (!cfg)
> > +			goto unlock;
> > +
> >  		/*
> >  		 * Check if the irq migration is in progress. If so, we
> >  		 * haven't received the cleanup request yet for this irq.
> 
