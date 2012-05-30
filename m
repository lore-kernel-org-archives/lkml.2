Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2E3Nu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:50:29 -0400
Received: from [192.48.179.30] ([192.48.179.30]:38899 "EHLO relay.sgi.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754500Ab2E3Nu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:50:28 -0400
Date: Wed, 30 May 2012 08:46:03 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        gregkh@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
Message-ID: <20120530134603.GA32097@sgi.com>
References: <20120523181636.GA2032@sgi.com>
 <20120523190414.GA5263@sgi.com>
 <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>
 <20120523200226.GA6936@sgi.com>
 <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>
 <20120524143711.GA24711@sgi.com>
 <1337883560.7938.9.camel@sbsiddha-desk.sc.intel.com>
 <alpine.LFD.2.02.1205242113400.3231@ionos>
 <1337991809.7938.36.camel@sbsiddha-desk.sc.intel.com>
 <alpine.LFD.2.02.1205261216160.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205261216160.3231@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:18:21PM +0200, Thomas Gleixner wrote:
> On Fri, 25 May 2012, Suresh Siddha wrote:
> > On Thu, 2012-05-24 at 21:16 +0200, Thomas Gleixner wrote:
> > There are other (not-so common) irq desc references, like in the
> > show_interrupts() (cat /proc/interrupts path) etc, that does things like
> > this in the process context:
> > 
> >         desc = irq_to_desc(i);
> >         if (!desc)
> >                 return 0;
> > 
> >         raw_spin_lock_irqsave(&desc->lock, flags);
> > 
> > May be we should introduce something like
> > get_irq_desc_locked()/put_irq_desc_locked() that can safely access the
> > irq desc with pre-emption/irq's disabled and lock it etc. And the
> > synchronize_sched() will enable the destroy_irq()/free_desc() to free it
> > safely etc.
> 
> I want to avoid that and instead use proper refcounting. The reason is
> that we want to move the irq descriptor when the affinity changes
> nodes, and for that we need refcounting anyway.
>

While this proposal sounds good, in the meantime would there be any harm in
putting the NULL cfg check into smp_irq_move_cleanup_interrupt()?

It's a minimal change, and eliminates the panics that I've encountered thus far.

Reposting the patch.



A NULL pointer dereference can occur in smp_irq_move_cleanup_interrupt() if
we haven't yet setup the irq_cfg pointer in the irq_desc.irq_data.chip_data.

In create_irq_nr() there is a window where we have set vector_irq in
__assign_irq_vector(), but not yet called irq_set_chip_data() to set the
irq_cfg pointer.

Should an IRQ_MOVE_CLEANUP_VECTOR hit the cpu in question during this time,
smp_irq_move_cleanup_interrupt() will attempt to process the aforementioned
irq, but panic when accessing irq_cfg.

There is also a window in destroy_irq() where we've cleared the irq_cfg
pointer in free_irq_cfg(), but have not yet called irq_free_desc().  Note
that we have cleared vector_irq in __clear_irq_vector() prior to free_irq_cfg(),
but smp_irq_move_cleanup_interrupt() might've already referenced the irq_desc.

Only continue processing the irq if irq_cfg is non-NULL.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/kernel/apic/io_apic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c
+++ linux/arch/x86/kernel/apic/io_apic.c
@@ -2478,9 +2478,12 @@ asmlinkage void smp_irq_move_cleanup_int
 		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
 		raw_spin_lock(&desc->lock);
 
+		cfg = irq_cfg(irq);
+		if (!cfg)
+			goto unlock;
+
 		/*
 		 * Check if the irq migration is in progress. If so, we
 		 * haven't received the cleanup request yet for this irq.
