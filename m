Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab0LHGBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 01:01:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:18033 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab0LHGBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 01:01:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,314,1288594800"; 
   d="scan'208";a="634239562"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        konrad.wilk@oracle.com, xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 1/2] apic: Move hypervisor detection of x2apic to hypervisor.h
Date: Wed,  8 Dec 2010 14:03:59 +0800
Message-Id: <1291788240-12130-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/hypervisor.h |    9 +++++++++
 arch/x86/kernel/apic/apic.c       |    5 +++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index ff2546c..0c6f7af 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -20,6 +20,8 @@
 #ifndef _ASM_X86_HYPERVISOR_H
 #define _ASM_X86_HYPERVISOR_H
 
+#include <asm/kvm_para.h>
+
 extern void init_hypervisor(struct cpuinfo_x86 *c);
 extern void init_hypervisor_platform(void);
 
@@ -47,4 +49,11 @@ extern const struct hypervisor_x86 x86_hyper_vmware;
 extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
 
+static inline bool hypervisor_x2apic_available(void)
+{
+	if (kvm_para_available())
+		return true;
+	return false;
+}
+
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..8408f2d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -50,8 +50,8 @@
 #include <asm/mtrr.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
-#include <asm/kvm_para.h>
 #include <asm/tsc.h>
+#include <asm/hypervisor.h>
 
 unsigned int num_processors;
 
@@ -1476,7 +1476,8 @@ void __init enable_IR_x2apic(void)
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
-		if (max_physical_apicid > 255 || !kvm_para_available())
+		if (max_physical_apicid > 255 ||
+		    !hypervisor_x2apic_available())
 			goto nox2apic;
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
-- 
1.7.0.1

