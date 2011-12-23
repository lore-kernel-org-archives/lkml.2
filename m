Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab1LWUNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:13:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab1LWUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:13:14 -0500
Date: Fri, 23 Dec 2011 12:13:01 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-a31bc32760992a2c68f3d6bf7da9f760c0fd7c41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <CAE9FiQUeB-3uxJAMiHsz=uPWoFv5Hg1pVepz7aU6YtqOxMC-=Q@mail.gmail.com>
References: <CAE9FiQUeB-3uxJAMiHsz=uPWoFv5Hg1pVepz7aU6YtqOxMC-=Q@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, x2apic: Allow "nox2apic"
  to disable x2apic mode setup by BIOS
Git-Commit-ID: a31bc32760992a2c68f3d6bf7da9f760c0fd7c41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 12:13:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a31bc32760992a2c68f3d6bf7da9f760c0fd7c41
Gitweb:     http://git.kernel.org/tip/a31bc32760992a2c68f3d6bf7da9f760c0fd7c41
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 23 Dec 2011 11:01:43 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 23 Dec 2011 11:01:43 -0800

x86, x2apic: Allow "nox2apic" to disable x2apic mode setup by BIOS

Currently "nox2apic" boot parameter was not enabling x2apic mode if the cpu,
kernel are all capable of enabling x2apic mode and the OS handover
happened in xapic mode.

However If the bios enabled x2apic prior to OS handover, using "nox2apic"
boot parameter had no effect.

If the boot cpu's apicid is < 255, enable "nox2apic" boot parameter to
disable the x2apic mode setup by the bios. This will enable the kernel to
fallback to xapic mode and bringup only the cpu's which has apic-id < 255.

-v2: fix patch error and two compiling warning
	make disable_x2apic to be __init

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/CAE9FiQUeB-3uxJAMiHsz=uPWoFv5Hg1pVepz7aU6YtqOxMC-=Q@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/apic/apic.c |   37 +++++++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a12d571..3ab9bdd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -216,6 +216,7 @@ static inline void x2apic_force_phys(void)
 {
 }
 
+#define	nox2apic	0
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2c07aeb..ff69d5d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -148,15 +148,24 @@ int x2apic_mode;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 static int x2apic_disabled;
+static int nox2apic;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
-		pr_warning("Bios already enabled x2apic, "
-			   "can't enforce nox2apic");
-		return 0;
-	}
+		int apicid = native_apic_msr_read(APIC_ID);
+
+		if (apicid >= 255) {
+			pr_warning("Apicid: %08x, cannot enforce nox2apic\n",
+				   apicid);
+			return 0;
+		}
+
+		pr_warning("x2apic already enabled. will disable it\n");
+	} else
+		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+
+	nox2apic = 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1443,7 +1452,7 @@ static inline void __disable_x2apic(u64 msr)
 	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
 }
 
-static void disable_x2apic(void)
+static __init void disable_x2apic(void)
 {
 	u64 msr;
 
@@ -1460,6 +1469,11 @@ static void disable_x2apic(void)
 		pr_info("Disabling x2apic\n");
 		__disable_x2apic(msr);
 
+		if (nox2apic) {
+			clear_cpu_cap(&cpu_data(0), X86_FEATURE_X2APIC);
+			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+		}
+
 		x2apic_disabled = 1;
 		x2apic_mode = 0;
 
@@ -1534,13 +1548,16 @@ void __init enable_IR_x2apic(void)
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
+	if (x2apic_preenabled && nox2apic)
+		disable_x2apic();
+
 	if (dmar_table_init_ret)
 		ret = -1;
 	else
 		ret = enable_IR();
 
 	if (!x2apic_supported())
-		goto nox2apic;
+		goto skip_x2apic;
 
 	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
@@ -1550,7 +1567,7 @@ void __init enable_IR_x2apic(void)
 		    !hypervisor_x2apic_available()) {
 			if (x2apic_preenabled)
 				disable_x2apic();
-			goto nox2apic;
+			goto skip_x2apic;
 		}
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
@@ -1561,7 +1578,7 @@ void __init enable_IR_x2apic(void)
 
 	if (ret == IRQ_REMAP_XAPIC_MODE) {
 		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-		goto nox2apic;
+		goto skip_x2apic;
 	}
 
 	x2apic_enabled = 1;
@@ -1572,7 +1589,7 @@ void __init enable_IR_x2apic(void)
 		pr_info("Enabled x2apic\n");
 	}
 
-nox2apic:
+skip_x2apic:
 	if (ret < 0) /* IR enabling failed */
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
