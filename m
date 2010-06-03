Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0FCNLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:11:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52461 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0FCNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:18 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908923"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>
Subject: [PATCH 02/12] early PV on HVM
Date: Thu,  3 Jun 2010 14:10:35 +0100
Message-Id: <1275570645-27189-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:17.0444 (UTC) FILETIME=[4064C840:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Initialize basic pv on hvm features in xen_guest_init.

The hook in arch/x86/kernel/setup.c can easily be removed using the new
generic hypervisor independent initialization infrastructure present in
the linux-2.6-tip tree.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
---
 arch/x86/kernel/setup.c           |    2 +
 arch/x86/xen/enlighten.c          |   86 +++++++++++++++++++++++++++++++++++++
 drivers/input/xen-kbdfront.c      |    2 +-
 drivers/video/xen-fbfront.c       |    2 +-
 drivers/xen/xenbus/xenbus_probe.c |   21 ++++++++-
 include/xen/xen.h                 |    2 +
 6 files changed, 110 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4851ef..ae9b6cb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -69,6 +69,7 @@
 #include <linux/tboot.h>
 
 #include <video/edid.h>
+#include <xen/xen.h>
 
 #include <asm/mtrr.h>
 #include <asm/apic.h>
@@ -1032,6 +1033,7 @@ void __init setup_arch(char **cmdline_p)
 	probe_nr_irqs_gsi();
 
 	kvm_guest_init();
+	xen_guest_init();
 
 	e820_reserve_resources();
 	e820_mark_nosave_regions(max_low_pfn);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 65d8d79..c1f6545 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -35,6 +35,7 @@
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/memory.h>
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/hvc-console.h>
@@ -56,6 +57,7 @@
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
 #include <asm/stackprotector.h>
+#include <asm/hypervisor.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1206,3 +1208,87 @@ asmlinkage void __init xen_start_kernel(void)
 	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
 #endif
 }
+
+static uint32_t xen_cpuid_base(void)
+{
+	uint32_t base, eax, ebx, ecx, edx;
+	char signature[13];
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+		cpuid(base, &eax, &ebx, &ecx, &edx);
+		*(uint32_t*)(signature + 0) = ebx;
+		*(uint32_t*)(signature + 4) = ecx;
+		*(uint32_t*)(signature + 8) = edx;
+		signature[12] = 0;
+
+		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
+			return base;
+	}
+
+	return 0;
+}
+
+static int init_hvm_pv_info(int *major, int *minor)
+{
+	uint32_t eax, ebx, ecx, edx, pages, msr, base;
+	u64 pfn;
+
+	base = xen_cpuid_base();
+	if (!base)
+		return -EINVAL;
+
+	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
+
+	*major = eax >> 16;
+	*minor = eax & 0xffff;
+	printk(KERN_INFO "Xen version %d.%d.\n", *major, *minor);
+
+	cpuid(base + 2, &pages, &msr, &ecx, &edx);
+
+	pfn = __pa(hypercall_page);
+	wrmsr_safe(msr, (u32)pfn, (u32)(pfn >> 32));
+
+	xen_setup_features();
+
+	pv_info = xen_info;
+	pv_info.kernel_rpl = 0;
+
+	xen_domain_type = XEN_HVM_DOMAIN;
+
+	return 0;
+}
+
+static void __init init_shared_info(void)
+{
+	struct xen_add_to_physmap xatp;
+	struct shared_info *shared_info_page;
+
+	shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
+	xatp.domid = DOMID_SELF;
+	xatp.idx = 0;
+	xatp.space = XENMAPSPACE_shared_info;
+	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
+	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+		BUG();
+
+	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
+
+	/* Don't do the full vcpu_info placement stuff until we have a
+	   possible map and a non-dummy shared_info. */
+	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+}
+
+void __init xen_guest_init(void)
+{
+	int r;
+	int major, minor;
+
+	if (xen_pv_domain())
+		return;
+
+	r = init_hvm_pv_info(&major, &minor);
+	if (r < 0)
+		return;
+
+	init_shared_info();
+}
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index e140816..7451d78 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -339,7 +339,7 @@ static struct xenbus_driver xenkbd_driver = {
 
 static int __init xenkbd_init(void)
 {
-	if (!xen_domain())
+	if (!xen_domain() || xen_hvm_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index fa97d3e..a105a19 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -684,7 +684,7 @@ static struct xenbus_driver xenfb_driver = {
 
 static int __init xenfb_init(void)
 {
-	if (!xen_domain())
+	if (!xen_domain() || xen_hvm_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 3479332..0b05b62 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -56,6 +56,8 @@
 #include <xen/events.h>
 #include <xen/page.h>
 
+#include <xen/hvm.h>
+
 #include "xenbus_comms.h"
 #include "xenbus_probe.h"
 
@@ -806,10 +808,23 @@ static int __init xenbus_probe_init(void)
 		/* dom0 not yet supported */
 	} else {
 		xenstored_ready = 1;
-		xen_store_evtchn = xen_start_info->store_evtchn;
-		xen_store_mfn = xen_start_info->store_mfn;
+		if (xen_hvm_domain()) {
+			uint64_t v = 0;
+			err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
+			if (err)
+				goto out_error;
+			xen_store_evtchn = (int)v;
+			err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
+			if (err)
+				goto out_error;
+			xen_store_mfn = (unsigned long)v;
+			xen_store_interface = ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
+		} else {
+			xen_store_evtchn = xen_start_info->store_evtchn;
+			xen_store_mfn = xen_start_info->store_mfn;
+			xen_store_interface = mfn_to_virt(xen_store_mfn);
+		}
 	}
-	xen_store_interface = mfn_to_virt(xen_store_mfn);
 
 	/* Initialize the interface to xenstore. */
 	err = xs_init();
diff --git a/include/xen/xen.h b/include/xen/xen.h
index a164024..cb8c48b 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -9,8 +9,10 @@ enum xen_domain_type {
 
 #ifdef CONFIG_XEN
 extern enum xen_domain_type xen_domain_type;
+extern void xen_guest_init(void);
 #else
 #define xen_domain_type		XEN_NATIVE
+#define xen_guest_init() do { } while (0)
 #endif
 
 #define xen_domain()		(xen_domain_type != XEN_NATIVE)
-- 
1.7.0.4

