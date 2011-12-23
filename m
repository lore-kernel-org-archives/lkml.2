Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab1LWUMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:12:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53359 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab1LWUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:12:28 -0500
Date: Fri, 23 Dec 2011 12:12:15 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-fb209bd891645bb87b9618b724f0b4928e0df3de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        flyboy@gmail.com, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, flyboy@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20111222014632.600418637@sbsiddha-desk.sc.intel.com>
References: <20111222014632.600418637@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, x2apic: Fallback to xapic when BIOS doesn'
 t setup interrupt-remapping
Git-Commit-ID: fb209bd891645bb87b9618b724f0b4928e0df3de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 12:12:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb209bd891645bb87b9618b724f0b4928e0df3de
Gitweb:     http://git.kernel.org/tip/fb209bd891645bb87b9618b724f0b4928e0df3de
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 21 Dec 2011 17:45:17 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 23 Dec 2011 11:01:01 -0800

x86, x2apic: Fallback to xapic when BIOS doesn't setup interrupt-remapping

On some of the recent Intel SNB platforms, by default bios is pre-enabling
x2apic mode in the cpu with out setting up interrupt-remapping.
This case was resulting in the kernel to panic as the cpu is already in
x2apic mode but the OS was not able to enable interrupt-remapping (which
is a pre-req for using x2apic capability).

On these platforms all the apic-ids are < 255 and the kernel can fallback to
xapic mode if the bios has not enabled interrupt-remapping (which is
mostly the case if the bios has not exported interrupt-remapping tables to the
OS).

Reported-by: Berck E. Nash <flyboy@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20111222014632.600418637@sbsiddha-desk.sc.intel.com
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/apic.h    |    4 ++
 arch/x86/include/asm/apicdef.h |    1 +
 arch/x86/kernel/apic/apic.c    |   73 ++++++++++++++++++++++++++++++----------
 arch/x86/kernel/apic/io_apic.c |    4 ++
 4 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a0f541a..a12d571 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -176,6 +176,7 @@ static inline u64 native_x2apic_icr_read(void)
 }
 
 extern int x2apic_phys;
+extern int x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -198,6 +199,9 @@ static inline void x2apic_force_phys(void)
 	x2apic_phys = 1;
 }
 #else
+static inline void disable_x2apic(void)
+{
+}
 static inline void check_x2apic(void)
 {
 }
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 3925d80..134bba0 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -144,6 +144,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0783236..2c07aeb 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -146,7 +146,8 @@ __setup("apicpmtimer", setup_apicpmtimer);
 int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
-static int x2apic_preenabled;
+int x2apic_preenabled;
+static int x2apic_disabled;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -1432,6 +1433,40 @@ void __init bsp_end_local_APIC_setup(void)
 }
 
 #ifdef CONFIG_X86_X2APIC
+/*
+ * Need to disable xapic and x2apic at the same time and then enable xapic mode
+ */
+static inline void __disable_x2apic(u64 msr)
+{
+	wrmsrl(MSR_IA32_APICBASE,
+	       msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
+	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
+}
+
+static void disable_x2apic(void)
+{
+	u64 msr;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (msr & X2APIC_ENABLE) {
+		u32 x2apic_id = read_apic_id();
+
+		if (x2apic_id >= 255)
+			panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
+
+		pr_info("Disabling x2apic\n");
+		__disable_x2apic(msr);
+
+		x2apic_disabled = 1;
+		x2apic_mode = 0;
+
+		register_lapic_address(mp_lapic_addr);
+	}
+}
+
 void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
@@ -1442,15 +1477,20 @@ void check_x2apic(void)
 
 void enable_x2apic(void)
 {
-	int msr, msr2;
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (x2apic_disabled) {
+		__disable_x2apic(msr);
+		return;
+	}
 
 	if (!x2apic_mode)
 		return;
 
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
+		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
 #endif /* CONFIG_X86_X2APIC */
@@ -1487,7 +1527,7 @@ void __init enable_IR_x2apic(void)
 	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto out;
+		return;
 	}
 
 	local_irq_save(flags);
@@ -1499,13 +1539,19 @@ void __init enable_IR_x2apic(void)
 	else
 		ret = enable_IR();
 
+	if (!x2apic_supported())
+		goto nox2apic;
+
 	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available())
+		    !hypervisor_x2apic_available()) {
+			if (x2apic_preenabled)
+				disable_x2apic();
 			goto nox2apic;
+		}
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
@@ -1513,8 +1559,10 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	if (ret == IRQ_REMAP_XAPIC_MODE)
+	if (ret == IRQ_REMAP_XAPIC_MODE) {
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
 		goto nox2apic;
+	}
 
 	x2apic_enabled = 1;
 
@@ -1529,17 +1577,6 @@ nox2apic:
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
-
-out:
-	if (x2apic_enabled || !x2apic_supported())
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (ret == IRQ_REMAP_XAPIC_MODE)
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-	else if (ret < 0)
-		pr_info("x2apic not enabled, IRQ remapping init failed\n");
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d939d7..45b461f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2948,6 +2948,10 @@ static inline void __init check_timer(void)
 	}
 	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
+	if (x2apic_preenabled)
+		apic_printk(APIC_QUIET, KERN_INFO
+			    "Perhaps problem with the pre-enabled x2apic mode\n"
+			    "Try booting with x2apic and interrupt-remapping disabled in the bios.\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option.\n");
 out:
