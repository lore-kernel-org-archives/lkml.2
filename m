Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2I0SYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:24:04 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47488 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab2I0SWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:22:21 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:22:16 EDT
From: Daniel Kiper <daniel.kiper@oracle.com>
To: konrad.wilk@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 09/11] x86/xen/enlighten: Add init and crash kexec/kdump hooks
Date: Thu, 27 Sep 2012 20:06:36 +0200
Message-Id: <1348769198-29580-10-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1348769198-29580-9-git-send-email-daniel.kiper@oracle.com>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-8-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-9-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.000281
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add init and crash kexec/kdump hooks.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/enlighten.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1fbe75a..5043d77 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/kexec.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -66,6 +67,7 @@
 #include <asm/hypervisor.h>
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
+#include <asm/xen/kexec.h>
 
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
@@ -1237,6 +1239,12 @@ static void xen_machine_power_off(void)
 
 static void xen_crash_shutdown(struct pt_regs *regs)
 {
+#ifdef CONFIG_KEXEC
+	if (kexec_crash_image) {
+		crash_save_cpu(regs, safe_smp_processor_id());
+		return;
+	}
+#endif
 	xen_reboot(SHUTDOWN_crash);
 }
 
@@ -1315,6 +1323,10 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_init_mmu_ops();
 
+#ifdef CONFIG_KEXEC
+	xen_init_kexec_ops();
+#endif
+
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
 #if 0
-- 
1.5.6.5

