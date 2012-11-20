Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2KTPSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:18:00 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:60204 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2KTPRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:17:20 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 10:17:12 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 09/11] x86/xen/enlighten: Add init and crash kexec/kdump hooks
Date: Tue, 20 Nov 2012 16:04:51 +0100
Message-Id: <1353423893-23125-10-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1353423893-23125-9-git-send-email-daniel.kiper@oracle.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-4-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-5-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-6-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-7-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-8-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-9-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.251242
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add init and crash kexec/kdump hooks.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/enlighten.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 586d838..e5b4d0d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/kexec.h>
 
 #include <xen/xen.h>
 #include <xen/events.h>
@@ -67,6 +68,7 @@
 #include <asm/hypervisor.h>
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
+#include <asm/xen/kexec.h>
 
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
@@ -1254,6 +1256,12 @@ static void xen_machine_power_off(void)
 
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
 
@@ -1331,6 +1339,10 @@ asmlinkage void __init xen_start_kernel(void)
 
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

