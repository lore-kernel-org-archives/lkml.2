Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2EWXvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:51:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:53325 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2EWXu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:50:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147015370"
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 16:49:29 -0700
In-Reply-To: <20120523200226.GA6936@sgi.com>
References: <20120521164959.GE16454@sgi.com>
	 <alpine.LFD.2.02.1205212304580.3231@ionos> <20120521211917.GA25567@sgi.com>
	 <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>
	 <20120523190414.GA5263@sgi.com>
	 <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>
	 <20120523200226.GA6936@sgi.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 15:02 -0500, Dimitri Sivanich wrote:
> OK.  Hopefully this covers it.

Sorry No. Now you will understand why Thomas wanted detailed changelog.
I found one more issue with the help of your new modification to the
changelog.

> A NULL pointer dereference can occur in smp_irq_move_cleanup_interrupt() if
> we haven't yet setup the irq_cfg pointer in the irq_desc.irq_data.chip_data.
> 
> In create_irq_nr() there is a window where we have set vector_irq in
> __assign_irq_vector(), but not yet called irq_set_chip_data() to set the
> irq_cfg pointer.
> 
> Should an IRQ_MOVE_CLEANUP_VECTOR hit the cpu in question during this time,
> smp_irq_move_cleanup_interrupt() will attempt to process the aforementioned
> irq, but panic when accessing irq_cfg.
> 
> There is also a window in destroy_irq() where we've cleared the irq_cfg
> pointer in free_irq_cfg(), but have not yet called irq_free_desc().  Note
> that we have cleared vector_irq in __clear_irq_vector() prior to free_irq_cfg(),
> but smp_irq_move_cleanup_interrupt() might've already referenced the irq_desc.

So, what happens if the irq_desc gets freed by the destroy_irq() in the
sparse irq case? smp_irq_move_cleanup_interrupt() will refer to freed
irq desc memory! Right?

May we should really do something like the appended (untested patch)?
Can you please review and give this a try? Let me review a bit more to
see if this really fixes the issue.

Thanks.
---
 arch/x86/kernel/apic/io_apic.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ffdc152..81f4cab 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2295,6 +2295,8 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 	exit_idle();
 
 	me = smp_processor_id();
+
+	raw_spin_lock(&vector_lock);
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irq;
 		unsigned int irr;
@@ -2310,17 +2312,16 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			continue;
 
 		cfg = irq_cfg(irq);
-		raw_spin_lock(&desc->lock);
 
 		/*
 		 * Check if the irq migration is in progress. If so, we
 		 * haven't received the cleanup request yet for this irq.
 		 */
 		if (cfg->move_in_progress)
-			goto unlock;
+			continue;
 
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
-			goto unlock;
+			continue;
 
 		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
 		/*
@@ -2332,12 +2333,11 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		 */
 		if (irr  & (1 << (vector % 32))) {
 			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
-			goto unlock;
+			continue;
 		}
 		__this_cpu_write(vector_irq[vector], -1);
-unlock:
-		raw_spin_unlock(&desc->lock);
 	}
+	raw_spin_unlock(&vector_lock);
 
 	irq_exit();
 }
@@ -2986,17 +2986,16 @@ unsigned int create_irq_nr(unsigned int from, int node)
 		return 0;
 	}
 
+	irq_set_chip_data(irq, cfg);
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	if (!__assign_irq_vector(irq, cfg, apic->target_cpus()))
 		ret = irq;
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (ret) {
-		irq_set_chip_data(irq, cfg);
+	if (ret)
 		irq_clear_status_flags(irq, IRQ_NOREQUEST);
-	} else {
+	else
 		free_irq_at(irq, cfg);
-	}
 	return ret;
 }
 


