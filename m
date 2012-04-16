Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2DPCWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 22:22:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49301 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2DPCVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 22:21:41 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 2/2] Enter 2nd kernel with BSP
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, vgoyal@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp
Date: Mon, 16 Apr 2012 11:21:39 +0900
Message-ID: <20120416022139.9303.56284.stgit@localhost6.localdomain6>
In-Reply-To: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split logic into BSP's and AP's: BSP waits for AP halting.

Don't remove variable crashing_cpu for debugging use; useful for
determining one what CPU crash happens.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 arch/x86/kernel/crash.c  |   15 ++++++++++++++-
 arch/x86/kernel/reboot.c |   16 ++++++----------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 13ad899..c5c19fa 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -83,9 +83,14 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	 * In practice this means shooting down the other cpus in
 	 * an SMP system.
 	 */
+
+	int cpu;
+
 	/* The kernel is broken so disable interrupts */
 	local_irq_disable();
 
+	crash_ipi_init();
+
 	kdump_nmi_shootdown_cpus();
 
 	/* Booting kdump kernel with VMX or SVM enabled won't work,
@@ -102,5 +107,13 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
-	crash_save_cpu(regs, safe_smp_processor_id());
+	cpu = safe_smp_processor_id();
+	crash_save_cpu(regs, cpu);
+
+	if (cpu_physical_id(cpu) == boot_cpu_physical_apicid) {
+		crash_ipi_wait_for_APs();
+		return;
+	}
+
+	crash_ipi_dec_and_halt();
 }
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 6dd77a8..90354f9 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/tboot.h>
 #include <linux/delay.h>
+#include <linux/kexec.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -800,16 +801,15 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 
 	cpu = raw_smp_processor_id();
 
-	/* Don't do anything if this handler is invoked on crashing cpu.
-	 * Otherwise, system will completely hang. Crashing cpu can get
-	 * an NMI if system was initially booted with nmi_watchdog parameter.
-	 */
-	if (cpu == crashing_cpu)
-		return NMI_HANDLED;
 	local_irq_disable();
 
 	shootdown_callback(cpu, regs);
 
+	if (cpu_physical_id(cpu) == boot_cpu_physical_apicid) {
+		crash_ipi_wait_for_APs();
+		machine_kexec(kexec_crash_image);
+	}
+
 	crash_ipi_dec_and_halt();
 
 	return NMI_HANDLED;
@@ -835,8 +835,6 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	shootdown_callback = callback;
 
-	crash_ipi_init();
-
 	/* Would it be better to replace the trap vector here? */
 	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
 				 NMI_FLAG_FIRST, "crash"))
@@ -848,8 +846,6 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	smp_send_nmi_allbutself();
 
-	crash_ipi_wait_for_APs();
-
 	/* Leave the nmi callback set */
 }
 #else /* !CONFIG_SMP */

