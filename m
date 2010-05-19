Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0ESRUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:20:37 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:6355 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0ESRUg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ksrinivasan@novell.com:4:1>);
	Wed, 19 May 2010 13:20:36 -0400
Message-Id: <4BF3C97F020000300008560D@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 19 May 2010 11:20:31 -0600
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: <hpa@zytor.com>
Cc: <greg@kroah.com>, <hjanssen@microsoft.com>, <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Hyperv detection - code cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K. Y. Srinivasan <ksrinivasan@novell.com>
Subject: Code cleanup - get rid of the "ms" prefix in hyperv related files.  


Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>

Index: linux.trees.git/arch/x86/include/asm/hyperv.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/hyperv.h	2010-05-18 13:04:25.000000000 -0600
+++ linux.trees.git/arch/x86/include/asm/hyperv.h	2010-05-18 13:46:18.000000000 -0600
@@ -190,11 +190,11 @@
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 
-struct ms_hyperv_info {
+struct hyperv_info {
 	u32 features;
 	u32 hints;
 };
 
-extern struct ms_hyperv_info ms_hyperv;
+extern struct hyperv_info hyperv_info;
 
 #endif
Index: linux.trees.git/arch/x86/include/asm/hypervisor.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/hypervisor.h	2010-05-18 10:14:02.000000000 -0600
+++ linux.trees.git/arch/x86/include/asm/hypervisor.h	2010-05-18 13:52:10.000000000 -0600
@@ -44,6 +44,6 @@ extern const struct hypervisor_x86 *x86_
 
 /* Recognized hypervisors */
 extern const struct hypervisor_x86 x86_hyper_vmware;
-extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
+extern const struct hypervisor_x86 x86_hyper_hyperv;
 
 #endif
Index: linux.trees.git/arch/x86/kernel/cpu/Makefile
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/cpu/Makefile	2010-05-18 10:14:02.000000000 -0600
+++ linux.trees.git/arch/x86/kernel/cpu/Makefile	2010-05-18 13:55:30.000000000 -0600
@@ -14,7 +14,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
+obj-y			+= vmware.o hypervisor.o sched.o hyperv.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
Index: linux.trees.git/arch/x86/kernel/cpu/hyperv.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/x86/kernel/cpu/hyperv.c	2010-05-18 14:11:07.000000000 -0600
@@ -0,0 +1,55 @@
+/*
+ * HyperV  Detection code.
+ *
+ * Copyright (C) 2010, Novell, Inc.
+ * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <asm/processor.h>
+#include <asm/hypervisor.h>
+#include <asm/hyperv.h>
+
+struct hyperv_info hyperv_info;
+EXPORT_SYMBOL(hyperv_info);
+
+static bool __init hyperv_platform(void)
+{
+	u32 eax;
+	u32 hyp_signature[3];
+
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return false;
+
+	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
+	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
+
+	return eax >= HYPERV_CPUID_MIN &&
+		eax <= HYPERV_CPUID_MAX &&
+		!memcmp("Microsoft Hv", hyp_signature, 12);
+}
+
+static void __init hyperv_init_platform(void)
+{
+	/*
+	 * Extract the features and hints
+	 */
+	hyperv_info.features = cpuid_eax(HYPERV_CPUID_FEATURES);
+	hyperv_info.hints    = cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
+
+	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
+	       hyperv_info.features, hyperv_info.hints);
+}
+
+const __refconst struct hypervisor_x86 x86_hyper_hyperv = {
+	.name			= "Microsoft HyperV",
+	.detect			= hyperv_platform,
+	.init_platform		= hyperv_init_platform,
+};
+EXPORT_SYMBOL(x86_hyper_hyperv);
Index: linux.trees.git/arch/x86/kernel/cpu/mshyperv.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 13:05:43.000000000 -0600
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,55 +0,0 @@
-/*
- * HyperV  Detection code.
- *
- * Copyright (C) 2010, Novell, Inc.
- * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- */
-
-#include <linux/types.h>
-#include <linux/module.h>
-#include <asm/processor.h>
-#include <asm/hypervisor.h>
-#include <asm/hyperv.h>
-
-struct ms_hyperv_info ms_hyperv;
-EXPORT_SYMBOL(ms_hyperv);
-
-static bool __init ms_hyperv_platform(void)
-{
-	u32 eax;
-	u32 hyp_signature[3];
-
-	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
-		return false;
-
-	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
-	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
-
-	return eax >= HYPERV_CPUID_MIN &&
-		eax <= HYPERV_CPUID_MAX &&
-		!memcmp("Microsoft Hv", hyp_signature, 12);
-}
-
-static void __init ms_hyperv_init_platform(void)
-{
-	/*
-	 * Extract the features and hints
-	 */
-	ms_hyperv.features = cpuid_eax(HYPERV_CPUID_FEATURES);
-	ms_hyperv.hints    = cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
-
-	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
-	       ms_hyperv.features, ms_hyperv.hints);
-}
-
-const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
-	.name			= "Microsoft HyperV",
-	.detect			= ms_hyperv_platform,
-	.init_platform		= ms_hyperv_init_platform,
-};
-EXPORT_SYMBOL(x86_hyper_ms_hyperv);
Index: linux.trees.git/arch/x86/kernel/cpu/hypervisor.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/cpu/hypervisor.c	2010-05-18 10:14:02.000000000 -0600
+++ linux.trees.git/arch/x86/kernel/cpu/hypervisor.c	2010-05-18 14:06:07.000000000 -0600
@@ -33,7 +33,7 @@
 static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
 	&x86_hyper_vmware,
-	&x86_hyper_ms_hyperv,
+	&x86_hyper_hyperv,
 };
 
 const struct hypervisor_x86 *x86_hyper;


