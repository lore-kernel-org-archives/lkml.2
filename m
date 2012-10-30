Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab2J3QFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:05:14 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:8947 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab2J3QFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:05:11 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr3c7sfw==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] xen PVonHVM: require at least Xen 3.4 as dom0
Date: Tue, 30 Oct 2012 17:05:05 +0100
Message-Id: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XenPVHVM extensions have not been tested much on very old
hypervisors. At least Xen 3.4 gets some testing with the pvops kernel.

Require at least Xen 3.4 for the PVonHVM extensions. If an older
hypervisor is detected the extensions will be disabled and the guest
will only see emulated hardware.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 arch/x86/xen/enlighten.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0cc41f8..8566fa8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1543,17 +1543,10 @@ static void __init xen_hvm_init_shared_info(void)
 
 static void __init init_hvm_pv_info(void)
 {
-	int major, minor;
 	uint32_t eax, ebx, ecx, edx, pages, msr, base;
 	u64 pfn;
 
 	base = xen_cpuid_base();
-	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
-
-	major = eax >> 16;
-	minor = eax & 0xffff;
-	printk(KERN_INFO "Xen version %d.%d.\n", major, minor);
-
 	cpuid(base + 2, &pages, &msr, &ecx, &edx);
 
 	pfn = __pa(hypercall_page);
@@ -1604,13 +1597,29 @@ static void __init xen_hvm_guest_init(void)
 
 static bool __init xen_hvm_platform(void)
 {
+	int major, minor, old = 0;
+	uint32_t eax, ebx, ecx, edx, base;
+	bool usable = true;
+
 	if (xen_pv_domain())
 		return false;
 
-	if (!xen_cpuid_base())
+	base = xen_cpuid_base();
+	if (!base)
 		return false;
 
-	return true;
+	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
+
+	major = eax >> 16;
+	minor = eax & 0xffff;
+
+	/* Require at least Xen 3.4 */
+	if (major < 3 || (major == 3 && minor < 4))
+		usable = false;
+	printk(KERN_INFO "Xen version %d.%d.%s\n",
+		major, minor, usable ? "" : " (too old)");
+
+	return usable;
 }
 
 bool xen_hvm_need_lapic(void)
-- 
1.8.0

