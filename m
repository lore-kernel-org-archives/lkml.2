Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2HVJq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:46:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33411 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab2HVJqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:46:54 -0400
Date: Wed, 22 Aug 2012 12:46:48 +0300
From: Ido Yariv <ido@wizery.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/vsmp: Use hypervisor layer for
 initialization
Message-ID: <20120822094648.GA14941@WorkStation.localnet>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
 <tip-c00679af441c5be76e195deed2c76fef65a5d102@git.kernel.org>
 <20120822091141.GC23336@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822091141.GC23336@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, Aug 22, 2012 at 11:11:41AM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Ido Yariv <ido@wizery.com> wrote:
> 
> > Commit-ID:  c00679af441c5be76e195deed2c76fef65a5d102
> > Gitweb:     http://git.kernel.org/tip/c00679af441c5be76e195deed2c76fef65a5d102
> > Author:     Ido Yariv <ido@wizery.com>
> > AuthorDate: Wed, 8 Aug 2012 20:01:38 +0300
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 22 Aug 2012 10:48:05 +0200
> > 
> > x86/vsmp: Use hypervisor layer for initialization
> > 
> > vSMP detection and initialization could be done by
> > the hypervisor layer, so set it up that way.
> > 
> > This cleans up vSMP initialization.
> > 
> > Signed-off-by: Ido Yariv <ido@wizery.com>
> > Acked-by: Shai Fultheim <shai@scalemp.com>
> > Link: http://lkml.kernel.org/r/1344445299-22142-1-git-send-email-ido@wizery.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > ---
> >  arch/x86/include/asm/hypervisor.h |    1 +
> >  arch/x86/include/asm/setup.h      |    7 -------
> >  arch/x86/kernel/cpu/hypervisor.c  |    1 +
> >  arch/x86/kernel/setup.c           |    2 --
> >  arch/x86/kernel/vsmp_64.c         |   27 +++++++++++++++++----------
> >  5 files changed, 19 insertions(+), 19 deletions(-)
> 
> I had to zap this commit because it breaks the build:
> 
> (.init.rodata+0x4c8): undefined reference to `x86_hyper_vsmp'

I failed to notice that vsmp_64.c is only built on 64bit, so this will
break on 32bit builds.

How about the patch below?

Thanks,
Ido.

>From 806d8966d9284d5351e9ebed43f6f801e62e946d Mon Sep 17 00:00:00 2001
From: Ido Yariv <ido@wizery.com>
Date: Mon, 11 Jun 2012 14:41:08 +0300
Subject: [PATCH v2] x86/vsmp: Use hypervisor layer for initialization

vSMP Foundation detection and initialization could be done by the
hypervisor layer, so set it up that way.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/include/asm/hypervisor.h |    1 +
 arch/x86/include/asm/setup.h      |    7 -------
 arch/x86/kernel/cpu/hypervisor.c  |    3 +++
 arch/x86/kernel/setup.c           |    2 --
 arch/x86/kernel/vsmp_64.c         |   27 +++++++++++++++++----------
 5 files changed, 21 insertions(+), 19 deletions(-)

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
index a8f8fa9..f250d6a 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -40,6 +40,9 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 #ifdef CONFIG_KVM_GUEST
 	&x86_hyper_kvm,
 #endif
+#ifdef CONFIG_X86_64
+	&x86_hyper_vsmp,
+#endif
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
-- 
1.7.7.6

