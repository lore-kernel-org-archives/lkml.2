Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab2HVJFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:05:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab2HVJEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:04:45 -0400
Date: Wed, 22 Aug 2012 02:04:19 -0700
From: tip-bot for Ido Yariv <ido@wizery.com>
Message-ID: <tip-c00679af441c5be76e195deed2c76fef65a5d102@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shai@scalemp.com, ido@wizery.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, tglx@linutronix.de, ido@wizery.com
In-Reply-To: <1344445299-22142-1-git-send-email-ido@wizery.com>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/vsmp:
  Use hypervisor layer for initialization
Git-Commit-ID: c00679af441c5be76e195deed2c76fef65a5d102
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 02:04:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c00679af441c5be76e195deed2c76fef65a5d102
Gitweb:     http://git.kernel.org/tip/c00679af441c5be76e195deed2c76fef65a5d102
Author:     Ido Yariv <ido@wizery.com>
AuthorDate: Wed, 8 Aug 2012 20:01:38 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 22 Aug 2012 10:48:05 +0200

x86/vsmp: Use hypervisor layer for initialization

vSMP detection and initialization could be done by
the hypervisor layer, so set it up that way.

This cleans up vSMP initialization.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Link: http://lkml.kernel.org/r/1344445299-22142-1-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/hypervisor.h |    1 +
 arch/x86/include/asm/setup.h      |    7 -------
 arch/x86/kernel/cpu/hypervisor.c  |    1 +
 arch/x86/kernel/setup.c           |    2 --
 arch/x86/kernel/vsmp_64.c         |   27 +++++++++++++++++----------
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index b518c75..eb617ae 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -50,6 +50,7 @@ extern const struct hypervisor_x86 x86_hyper_vmware;
 extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
 extern const struct hypervisor_x86 x86_hyper_kvm;
+extern const struct hypervisor_x86 x86_hyper_vsmp;
 
 static inline bool hypervisor_x2apic_available(void)
 {
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index d0f19f9..a4c5b14 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -26,13 +26,6 @@
 #include <asm/bootparam.h>
 #include <asm/x86_init.h>
 
-/* Interrupt control for vSMPowered x86_64 systems */
-#ifdef CONFIG_X86_64
-void vsmp_init(void);
-#else
-static inline void vsmp_init(void) { }
-#endif
-
 void setup_bios_corruption_check(void);
 
 #ifdef CONFIG_X86_VISWS
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index a8f8fa9..bcac2ff6 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -40,6 +40,7 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 #ifdef CONFIG_KVM_GUEST
 	&x86_hyper_kvm,
 #endif
+	&x86_hyper_vsmp,
 };
 
 const struct hypervisor_x86 *x86_hyper;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..f9706d1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -943,8 +943,6 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_crashkernel();
 
-	vsmp_init();
-
 	io_delay_init();
 
 	/*
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 992f890..f655f2c 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -17,12 +17,14 @@
 #include <linux/pci_regs.h>
 #include <linux/smp.h>
 #include <linux/irq.h>
+#include <linux/module.h>
 
 #include <asm/apic.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 #include <asm/paravirt.h>
 #include <asm/setup.h>
+#include <asm/hypervisor.h>
 
 #define TOPOLOGY_REGISTER_OFFSET 0x10
 
@@ -132,17 +134,20 @@ static void __init set_vsmp_pv_ops(void)
 #ifdef CONFIG_PCI
 static int is_vsmp = -1;
 
-static void __init detect_vsmp_box(void)
+static bool __init detect_vsmp_box(void)
 {
 	is_vsmp = 0;
 
 	if (!early_pci_allowed())
-		return;
+		goto out;
 
 	/* Check if we are running on a ScaleMP vSMPowered box */
 	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
 	     (PCI_VENDOR_ID_SCALEMP | (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
 		is_vsmp = 1;
+
+out:
+	return is_vsmp == 1;
 }
 
 int is_vsmp_box(void)
@@ -156,8 +161,9 @@ int is_vsmp_box(void)
 }
 
 #else
-static void __init detect_vsmp_box(void)
+static bool __init detect_vsmp_box(void)
 {
+	return false;
 }
 int is_vsmp_box(void)
 {
@@ -221,16 +227,17 @@ static void vsmp_apic_post_init(void)
 	apic->vector_allocation_domain = fill_vector_allocation_domain;
 }
 
-void __init vsmp_init(void)
+static void __init vsmp_platform_setup(void)
 {
-	detect_vsmp_box();
-	if (!is_vsmp_box())
-		return;
-
 	x86_platform.apic_post_init = vsmp_apic_post_init;
 
 	vsmp_cap_cpus();
-
 	set_vsmp_pv_ops();
-	return;
 }
+
+const __refconst struct hypervisor_x86 x86_hyper_vsmp = {
+	.name			= "ScaleMP vSMP Foundation",
+	.detect			= detect_vsmp_box,
+	.init_platform		= vsmp_platform_setup,
+};
+EXPORT_SYMBOL(x86_hyper_vsmp);
