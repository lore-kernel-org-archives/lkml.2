Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab1LGRBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:01:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53199 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab1LGRBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:01:35 -0500
From: Tom Gundersen <teg@jklm.no>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>
Subject: [PATCH] x86: mark some messages as INFO/WARNING/ERROR
Date: Wed,  7 Dec 2011 18:01:26 +0100
Message-Id: <1323277286-3090-1-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the noise in

$ dmesg --kernel --level=err,warn

And classifise some error messages correctly.

Signed-off-by: Tom Gundersen <teg@jklm.no>
---
 arch/x86/kernel/acpi/boot.c |    8 ++++----
 arch/x86/kernel/smpboot.c   |    2 +-
 arch/x86/kernel/tsc.c       |   11 ++++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4558f0d..22bf8f0 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -418,12 +418,12 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 
 	if (intsrc->source_irq == 0 && intsrc->global_irq == 2) {
 		if (acpi_skip_timer_override) {
-			printk(PREFIX "BIOS IRQ0 pin2 override ignored.\n");
+			printk(KERN_WARNING PREFIX "BIOS IRQ0 pin2 override ignored.\n");
 			return 0;
 		}
 		if (acpi_fix_pin2_polarity && (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK)) {
 			intsrc->inti_flags &= ~ACPI_MADT_POLARITY_MASK;
-			printk(PREFIX "BIOS IRQ0 pin2 override: forcing polarity to high active.\n");
+			printk(KERN_WARNING PREFIX "BIOS IRQ0 pin2 override: forcing polarity to high active.\n");
 		}
 	}
 
@@ -499,7 +499,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 	if (old == new)
 		return;
 
-	printk(PREFIX "setting ELCR to %04x (from %04x)\n", new, old);
+	printk(KERN_INFO PREFIX "setting ELCR to %04x (from %04x)\n", new, old);
 	outb(new, 0x4d0);
 	outb(new >> 8, 0x4d1);
 }
@@ -652,7 +652,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	 */
 	cpumask_andnot(new_map, cpu_present_mask, tmp_map);
 	if (cpumask_empty(new_map)) {
-		printk ("Unable to map lapic to logical cpu number\n");
+		printk (KERN_ERR "Unable to map lapic to logical cpu number\n");
 		retval = -EINVAL;
 		goto free_new_map;
 	}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..f96716c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -701,7 +701,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	wait_for_completion(&c_idle.done);
 
 	if (IS_ERR(c_idle.idle)) {
-		printk("failed fork for CPU %d\n", cpu);
+		printk(KERN_ERR "failed fork for CPU %d\n", cpu);
 		destroy_work_on_stack(&c_idle.work);
 		return PTR_ERR(c_idle.idle);
 	}
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index db48336..2b2724c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL_GPL(check_tsc_unstable);
 int __init notsc_setup(char *str)
 {
 	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-			"cannot disable TSC completely.\n");
+	       "cannot disable TSC completely.\n");
 	tsc_disabled = 1;
 	return 1;
 }
@@ -372,7 +372,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	printk("Fast TSC calibration failed\n");
+	printk(KERN_WARNING "Fast TSC calibration failed\n");
 	return 0;
 
 success:
@@ -394,7 +394,7 @@ success:
 	delta += (long)(d2 - d1)/2;
 	delta *= PIT_TICK_RATE;
 	do_div(delta, i*256*1000);
-	printk("Fast TSC calibration using PIT\n");
+	printk(KERN_INFO "Fast TSC calibration using PIT\n");
 	return delta;
 }
 
@@ -517,7 +517,8 @@ unsigned long native_calibrate_tsc(void)
 
 		/* We don't have an alternative source, disable TSC */
 		if (!hpet && !ref1 && !ref2) {
-			printk("TSC: No reference (HPET/PMTIMER) available\n");
+			printk(KERN_WARNING "TSC: No reference (HPET/PMTIMER) "
+			       "available\n");
 			return 0;
 		}
 
@@ -961,7 +962,7 @@ void __init tsc_init(void)
 		return;
 	}
 
-	printk("Detected %lu.%03lu MHz processor.\n",
+	printk(KERN_INFO "Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
 			(unsigned long)cpu_khz % 1000);
 
-- 
1.7.8

