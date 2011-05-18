Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab1ERJgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:36:23 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:45583 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab1ERJgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:36:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH V4] irq: uninline generic_handle_irq, export handle_simple_irq, irq_modify_status, generic_handle_irq, irq_alloc_descs and irq_free_descs
Date: Wed, 18 May 2011 10:39:04 +0100
Message-Id: <1305711544-505-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V4: EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL for generic_handle_irq.

V3: stop exporting irq_to_desc and instead take generic_handle_irq out of the header.
As suggested by Thomas Gleixner.

Patch was previously:
irq: export handle_simple_irq, irq_modify_status, irq_to_desc, irq_alloc_descs and irq_free_descs

V2: add irq_alloc_descs and irq_free_descs for dynamic pool allocation.

This is to allow their use in IIO. We have complete control of
both the irq_chip creation and requesting of irqs so would like
to be able to build as a module. That requires these exports.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

Same as before except for EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL.
Sorry about that all; more coffee needed I think.


Hi Thomas,

Looking a bit more at possible locations it is clear that CONFIG_GENERIC_HARDIRQS
only exists as an ifdef in irqdesc.c so I guess that is the least intrusive place
to move this to.

Lots stacked behind this, so thought I'd keep the ball rolling rather than
waiting for your reply to my question of where best to put generic_handle_irq.

Thanks,

Jonathan

 include/linux/irqdesc.h |    5 +----
 kernel/irq/chip.c       |    2 ++
 kernel/irq/irqdesc.c    |    8 ++++++++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index a082905..27b971d 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -109,10 +109,7 @@ static inline void generic_handle_irq_desc(unsigned int irq, struct irq_desc *de
 	desc->handle_irq(irq, desc);
 }
 
-static inline void generic_handle_irq(unsigned int irq)
-{
-	generic_handle_irq_desc(irq, irq_to_desc(irq));
-}
+void generic_handle_irq(unsigned int irq);
 
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 4af1e2b..ad409d3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -310,6 +310,7 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL_GPL(handle_simple_irq);
 
 /**
  *	handle_level_irq - Level type irq handler
@@ -612,6 +613,7 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 
 	irq_put_desc_unlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(irq_modify_status);
 
 /**
  *	irq_cpu_online - Invoke all irq_cpu_online functions.
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 2c039c9..a6fdd10 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -311,6 +311,7 @@ void irq_free_descs(unsigned int from, unsigned int cnt)
 	bitmap_clear(allocated_irqs, from, cnt);
 	mutex_unlock(&sparse_irq_lock);
 }
+EXPORT_SYMBOL_GPL(irq_free_descs);
 
 /**
  * irq_alloc_descs - allocate and initialize a range of irq descriptors
@@ -351,6 +352,7 @@ err:
 	mutex_unlock(&sparse_irq_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(irq_alloc_descs);
 
 /**
  * irq_reserve_irqs - mark irqs allocated
@@ -443,4 +445,10 @@ unsigned int kstat_irqs(unsigned int irq)
 		sum += *per_cpu_ptr(desc->kstat_irqs, cpu);
 	return sum;
 }
+
+void generic_handle_irq(unsigned int irq)
+{
+	generic_handle_irq_desc(irq, irq_to_desc(irq));
+}
+EXPORT_SYMBOL_GPL(generic_handle_irq);
 #endif /* CONFIG_GENERIC_HARDIRQS */
-- 
1.7.3.4

