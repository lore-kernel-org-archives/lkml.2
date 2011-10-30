Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab1J3MuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:50:23 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:47678 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab1J3Mst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/27] m68k/irq: Remove obsolete IRQ_FLG_* users
Date: Sun, 30 Oct 2011 13:48:18 +0100
Message-Id: <1319978915-10933-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k core irq code stopped honoring these flags during the irq
restructuring in 2006.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/amiints.c       |   29 -----------------------------
 arch/m68k/hp300/time.c          |    2 +-
 arch/m68k/kernel/ints.c         |   19 -------------------
 arch/m68k/mac/iop.c             |   10 ++++------
 arch/m68k/mac/oss.c             |   13 +++++--------
 arch/m68k/mac/via.c             |   22 ++++++++--------------
 arch/m68k/mvme147/config.c      |    3 +--
 drivers/macintosh/via-macii.c   |    2 +-
 drivers/macintosh/via-maciisi.c |    4 ++--
 9 files changed, 22 insertions(+), 82 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index 0daa7fc..e5f3033 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -4,35 +4,6 @@
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
  * for more details.
- *
- * 11/07/96: rewritten interrupt handling, irq lists are exists now only for
- *           this sources where it makes sense (VERTB/PORTS/EXTER) and you must
- *           be careful that dev_id for this sources is unique since this the
- *           only possibility to distinguish between different handlers for
- *           free_irq. irq lists also have different irq flags:
- *           - IRQ_FLG_FAST: handler is inserted at top of list (after other
- *                           fast handlers)
- *           - IRQ_FLG_SLOW: handler is inserted at bottom of list and before
- *                           they're executed irq level is set to the previous
- *                           one, but handlers don't need to be reentrant, if
- *                           reentrance occurred, slow handlers will be just
- *                           called again.
- *           The whole interrupt handling for CIAs is moved to cia.c
- *           /Roman Zippel
- *
- * 07/08/99: rewamp of the interrupt handling - we now have two types of
- *           interrupts, normal and fast handlers, fast handlers being
- *           marked with IRQF_DISABLED and runs with all other interrupts
- *           disabled. Normal interrupts disable their own source but
- *           run with all other interrupt sources enabled.
- *           PORTS and EXTER interrupts are always shared even if the
- *           drivers do not explicitly mark this when calling
- *           request_irq which they really should do.
- *           This is similar to the way interrupts are handled on all
- *           other architectures and makes a ton of sense besides
- *           having the advantage of making it easier to share
- *           drivers.
- *           /Jes
  */
 
 #include <linux/init.h>
diff --git a/arch/m68k/hp300/time.c b/arch/m68k/hp300/time.c
index f6312c7..c87fe69 100644
--- a/arch/m68k/hp300/time.c
+++ b/arch/m68k/hp300/time.c
@@ -70,7 +70,7 @@ void __init hp300_sched_init(irq_handler_t vector)
 
   asm volatile(" movpw %0,%1@(5)" : : "d" (INTVAL), "a" (CLOCKBASE));
 
-  if (request_irq(IRQ_AUTO_6, hp300_tick, IRQ_FLG_STD, "timer tick", vector))
+  if (request_irq(IRQ_AUTO_6, hp300_tick, 0, "timer tick", vector))
     pr_err("Couldn't register timer interrupt\n");
 
   out_8(CLOCKBASE + CLKCR2, 0x1);		/* select CR1 */
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 15dbbe2..f6a4698 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -4,25 +4,6 @@
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
  * for more details.
- *
- * 07/03/96: Timer initialization, and thus mach_sched_init(),
- *           removed from request_irq() and moved to init_time().
- *           We should therefore consider renaming our add_isr() and
- *           remove_isr() to request_irq() and free_irq()
- *           respectively, so they are compliant with the other
- *           architectures.                                     /Jes
- * 11/07/96: Changed all add_/remove_isr() to request_/free_irq() calls.
- *           Removed irq list support, if any machine needs an irq server
- *           it must implement this itself (as it's already done), instead
- *           only default handler are used with mach_default_handler.
- *           request_irq got some flags different from other architectures:
- *           - IRQ_FLG_REPLACE : Replace an existing handler (the default one
- *                               can be replaced without this flag)
- *           - IRQ_FLG_LOCK : handler can't be replaced
- *           There are other machine depending flags, see there
- *           If you want to replace a default handler you should know what
- *           you're doing, since it might handle different other irq sources
- *           which must be served                               /Roman Zippel
  */
 
 #include <linux/module.h>
diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 1ad4e9d..a5462cc 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -305,15 +305,13 @@ void __init iop_register_interrupts(void)
 {
 	if (iop_ism_present) {
 		if (oss_present) {
-			if (request_irq(OSS_IRQLEV_IOPISM, iop_ism_irq,
-					IRQ_FLG_LOCK, "ISM IOP",
-					(void *) IOP_NUM_ISM))
+			if (request_irq(OSS_IRQLEV_IOPISM, iop_ism_irq, 0,
+					"ISM IOP", (void *)IOP_NUM_ISM))
 				pr_err("Couldn't register ISM IOP interrupt\n");
 			oss_irq_enable(IRQ_MAC_ADB);
 		} else {
-			if (request_irq(IRQ_VIA2_0, iop_ism_irq,
-					IRQ_FLG_LOCK|IRQ_FLG_FAST, "ISM IOP",
-					(void *) IOP_NUM_ISM))
+			if (request_irq(IRQ_VIA2_0, iop_ism_irq, 0, "ISM IOP",
+					(void *)IOP_NUM_ISM))
 				pr_err("Couldn't register ISM IOP interrupt\n");
 		}
 		if (!iop_alive(iop_base[IOP_NUM_ISM])) {
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index ad51241..1eb60f0 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -65,17 +65,14 @@ void __init oss_init(void)
 
 void __init oss_register_interrupts(void)
 {
-	if (request_irq(OSS_IRQLEV_SCSI, oss_irq, IRQ_FLG_LOCK,
-			"scsi", (void *) oss))
+	if (request_irq(OSS_IRQLEV_SCSI, oss_irq, 0, "scsi", (void *)oss))
 		pr_err("Couldn't register %s interrupt\n", "scsi");
-	if (request_irq(OSS_IRQLEV_NUBUS, oss_nubus_irq, IRQ_FLG_LOCK,
-			"nubus", (void *) oss))
+	if (request_irq(OSS_IRQLEV_NUBUS, oss_nubus_irq, 0, "nubus",
+			(void *)oss))
 		pr_err("Couldn't register %s interrupt\n", "nubus");
-	if (request_irq(OSS_IRQLEV_SOUND, oss_irq, IRQ_FLG_LOCK,
-			"sound", (void *) oss))
+	if (request_irq(OSS_IRQLEV_SOUND, oss_irq, 0, "sound", (void *)oss))
 		pr_err("Couldn't register %s interrupt\n", "sound");
-	if (request_irq(OSS_IRQLEV_VIA1, via1_irq, IRQ_FLG_LOCK,
-			"via1", (void *) via1))
+	if (request_irq(OSS_IRQLEV_VIA1, via1_irq, 0, "via1", (void *)via1))
 		pr_err("Couldn't register %s interrupt\n", "via1");
 }
 
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 0678570..af9ed33 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -281,7 +281,7 @@ void __init via_init_clock(irq_handler_t func)
 	via1[vT1CL] = MAC_CLOCK_LOW;
 	via1[vT1CH] = MAC_CLOCK_HIGH;
 
-	if (request_irq(IRQ_MAC_TIMER_1, func, IRQ_FLG_LOCK, "timer", func))
+	if (request_irq(IRQ_MAC_TIMER_1, func, 0, "timer", func))
 		pr_err("Couldn't register %s interrupt\n", "timer");
 }
 
@@ -292,25 +292,19 @@ void __init via_init_clock(irq_handler_t func)
 void __init via_register_interrupts(void)
 {
 	if (via_alt_mapping) {
-		if (request_irq(IRQ_AUTO_1, via1_irq,
-				IRQ_FLG_LOCK|IRQ_FLG_FAST, "software",
-				(void *) via1))
+		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "software",
+				(void *)via1))
 			pr_err("Couldn't register %s interrupt\n", "software");
-		if (request_irq(IRQ_AUTO_6, via1_irq,
-				IRQ_FLG_LOCK|IRQ_FLG_FAST, "via1",
-				(void *) via1))
+		if (request_irq(IRQ_AUTO_6, via1_irq, 0, "via1", (void *)via1))
 			pr_err("Couldn't register %s interrupt\n", "via1");
 	} else {
-		if (request_irq(IRQ_AUTO_1, via1_irq,
-				IRQ_FLG_LOCK|IRQ_FLG_FAST, "via1",
-				(void *) via1))
+		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "via1", (void *)via1))
 			pr_err("Couldn't register %s interrupt\n", "via1");
 	}
-	if (request_irq(IRQ_AUTO_2, via2_irq, IRQ_FLG_LOCK|IRQ_FLG_FAST,
-			"via2", (void *) via2))
+	if (request_irq(IRQ_AUTO_2, via2_irq, 0, "via2", (void *)via2))
 		pr_err("Couldn't register %s interrupt\n", "via2");
-	if (request_irq(IRQ_MAC_NUBUS, via_nubus_irq,
-			IRQ_FLG_LOCK|IRQ_FLG_FAST, "nubus", (void *) via2))
+	if (request_irq(IRQ_MAC_NUBUS, via_nubus_irq, 0, "nubus",
+			(void *)via2))
 		pr_err("Couldn't register %s interrupt\n", "nubus");
 }
 
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 6cb9c3a..01f2adf 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -114,8 +114,7 @@ static irqreturn_t mvme147_timer_int (int irq, void *dev_id)
 void mvme147_sched_init (irq_handler_t timer_routine)
 {
 	tick_handler = timer_routine;
-	if (request_irq(PCC_IRQ_TIMER1, mvme147_timer_int, IRQ_FLG_REPLACE,
-			"timer 1", NULL))
+	if (request_irq(PCC_IRQ_TIMER1, mvme147_timer_int, 0, "timer 1", NULL))
 		pr_err("Couldn't register timer interrupt\n");
 
 	/* Init the clock with a value */
diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index 817f37a..c9570fc 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -159,7 +159,7 @@ int macii_init(void)
 	err = macii_init_via();
 	if (err) goto out;
 
-	err = request_irq(IRQ_MAC_ADB, macii_interrupt, IRQ_FLG_LOCK, "ADB",
+	err = request_irq(IRQ_MAC_ADB, macii_interrupt, 0, "ADB",
 			  macii_interrupt);
 	if (err) goto out;
 
diff --git a/drivers/macintosh/via-maciisi.c b/drivers/macintosh/via-maciisi.c
index 9ab5b0c..34d02a9 100644
--- a/drivers/macintosh/via-maciisi.c
+++ b/drivers/macintosh/via-maciisi.c
@@ -122,8 +122,8 @@ maciisi_init(void)
 		return err;
 	}
 
-	if (request_irq(IRQ_MAC_ADB, maciisi_interrupt, IRQ_FLG_LOCK | IRQ_FLG_FAST, 
-			"ADB", maciisi_interrupt)) {
+	if (request_irq(IRQ_MAC_ADB, maciisi_interrupt, 0, "ADB",
+			maciisi_interrupt)) {
 		printk(KERN_ERR "maciisi_init: can't get irq %d\n", IRQ_MAC_ADB);
 		return -EAGAIN;
 	}
-- 
1.7.0.4

