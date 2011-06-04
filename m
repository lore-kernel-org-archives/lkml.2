Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab1FDPrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:47:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:48485 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582Ab1FDPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:45:47 -0400
Date: Sat, 4 Jun 2011 17:37:04 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        John Stultz <johnstul@us.ibm.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, trivial@kernel.org
Subject: [PATCH 8/8] arch/x86: use printk_ratelimited instead of
 printk_ratelimit
Message-ID: <fce87f1efab55e15e91b21f1b73f0e86016a27d9.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 arch/x86/kernel/hpet.c |    6 +++---
 arch/x86/kernel/irq.c  |    9 ++++-----
 arch/x86/kvm/i8259.c   |    7 +++----
 arch/x86/lguest/boot.c |    6 +++---
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 6781765..800d01b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -10,6 +10,7 @@
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
+#include <linux/ratelimit.h>
 
 #include <asm/fixmap.h>
 #include <asm/i8253.h>
@@ -1158,9 +1159,8 @@ static void hpet_rtc_timer_reinit(void)
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)
 			hpet_pie_count += lost_ints;
-		if (printk_ratelimit())
-			printk(KERN_WARNING "hpet1: lost %d rtc interrupts\n",
-				lost_ints);
+		printk_ratelimited("hpet1: lost %d rtc interrupts\n",
+				   lost_ints);
 	}
 }
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..435bf12 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -9,6 +9,7 @@
 #include <linux/smp.h>
 #include <linux/ftrace.h>
 #include <linux/delay.h>
+#include <linux/ratelimit.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
@@ -28,8 +29,7 @@ void (*x86_platform_ipi_callback)(void) = NULL;
  */
 void ack_bad_irq(unsigned int irq)
 {
-	if (printk_ratelimit())
-		pr_err("unexpected IRQ trap at vector %02x\n", irq);
+	pr_err_ratelimited("unexpected IRQ trap at vector %02x\n", irq);
 
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
@@ -188,9 +188,8 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	if (!handle_irq(irq, regs)) {
 		ack_APIC_irq();
 
-		if (printk_ratelimit())
-			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
-				__func__, smp_processor_id(), vector, irq);
+		pr_emerg_ratelimited("%s: %d.%d No irq handler for vector (irq %d)\n",
+				     __func__, smp_processor_id(), vector, irq);
 	}
 
 	irq_exit();
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 19fe855..8e26193 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
+#include <linux/ratelimit.h>
 #include "irq.h"
 
 #include <linux/kvm_host.h>
@@ -473,8 +474,7 @@ static int picdev_write(struct kvm_io_device *this,
 		return -EOPNOTSUPP;
 
 	if (len != 1) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "PIC: non byte write\n");
+		printk_ratelimited(KERN_ERR "PIC: non byte write\n");
 		return 0;
 	}
 	pic_lock(s);
@@ -503,8 +503,7 @@ static int picdev_read(struct kvm_io_device *this,
 		return -EOPNOTSUPP;
 
 	if (len != 1) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "PIC: non byte read\n");
+		printk_ratelimited(KERN_ERR "PIC: non byte read\n");
 		return 0;
 	}
 	pic_lock(s);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index db832fd..23a6eff 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -56,6 +56,7 @@
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
 #include <linux/pm.h>
+#include <linux/ratelimit.h>
 #include <asm/apic.h>
 #include <asm/lguest.h>
 #include <asm/paravirt.h>
@@ -927,9 +928,8 @@ static int lguest_clockevent_set_next_event(unsigned long delta,
 	/* FIXME: I don't think this can ever happen, but James tells me he had
 	 * to put this code in.  Maybe we should remove it now.  Anyone? */
 	if (delta < LG_CLOCK_MIN_DELTA) {
-		if (printk_ratelimit())
-			printk(KERN_DEBUG "%s: small delta %lu ns\n",
-			       __func__, delta);
+		printk_ratelimited(KERN_DEBUG "%s: small delta %lu ns\n",
+				   __func__, delta);
 		return -ETIME;
 	}
 
-- 
1.7.1

