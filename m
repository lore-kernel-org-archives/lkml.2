Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab2EWUCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:02:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45272 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933873Ab2EWUCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:02:30 -0400
Date: Wed, 23 May 2012 15:02:26 -0500
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
Message-ID: <20120523200226.GA6936@sgi.com>
References: <20120521164959.GE16454@sgi.com>
 <alpine.LFD.2.02.1205212304580.3231@ionos>
 <20120521211917.GA25567@sgi.com>
 <alpine.LFD.2.02.1205212324260.3231@ionos>
 <20120523181636.GA2032@sgi.com>
 <20120523190414.GA5263@sgi.com>
 <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 12:24:46PM -0700, Suresh Siddha wrote:
> On Wed, 2012-05-23 at 14:04 -0500, Dimitri Sivanich wrote:
> > On Wed, May 23, 2012 at 01:16:36PM -0500, Dimitri Sivanich wrote:
> > > In create_irq_nr() there is a window where we have set vector_irq in
> > > __assign_irq_vector(), but not yet called irq_set_chip_data() to set the
> > > irq_cfg pointer.
> 
> Ha. Now I understand how it can happen during boot/module load time.
> Thanks.
> 
> > BTW - is there a reason why we're calling irq_set_chip_data() in create_irq_nr()
> > rather than in __assign_irq_vector() for the case where irq_cfg is NULL?
> 
> assign_irq_vector() is also for setting up vectors during irq migration.
> So may be we could have done the irq_set_chip_data() in create_irq_nr()
> itself before calling assign_irq_vector(). Anyways, this change can't
> help in case of destroy irq path which can also lead to the same issue
> of de-referencing null pointer.
> 
> Also, it will be nice if you can refer to this destroy irq path in your
> changelog.
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

OK.  Hopefully this covers it.



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
