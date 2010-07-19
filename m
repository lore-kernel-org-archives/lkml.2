Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967195Ab0GSXIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:08:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:30386 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967099Ab0GSXIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,229,1278313200"; 
   d="scan'208";a="301951489"
Message-Id: <20100719230205.262987929@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:05:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/5] x86: track the offset, size of features state in the xsave layout
References: <20100719225747.372816924@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=xstate_feature_offset_size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subleaves of the cpuid vector 0xd provides the offset and size of different
feature state that are managed by the xsave/xrstor. Track this for the upcoming
usage during signal handling.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/xsave.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: tip-linux-2.6/arch/x86/kernel/xsave.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/xsave.c
+++ tip-linux-2.6/arch/x86/kernel/xsave.c
@@ -21,6 +21,8 @@ struct _fpx_sw_bytes fx_sw_reserved;
 struct _fpx_sw_bytes fx_sw_reserved_ia32;
 #endif
 
+static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
+
 /*
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
@@ -294,12 +296,39 @@ void __cpuinit xsave_init(void)
 }
 
 /*
+ * Record the offsets and sizes of different state managed by the xsave
+ * memory layout.
+ */
+static void setup_xstate_features(void)
+{
+	int eax, ebx, ecx, edx, leaf = 0x2;
+
+	xstate_features = fls64(pcntxt_mask);
+	xstate_offsets = alloc_bootmem(xstate_features * sizeof(int));
+	xstate_sizes = alloc_bootmem(xstate_features * sizeof(int));
+
+	do {
+		cpuid_count(0xd, leaf, &eax, &ebx, &ecx, &edx);
+
+		if (eax == 0)
+			break;
+
+		xstate_offsets[leaf] = ebx;
+		xstate_sizes[leaf] = eax;
+
+		leaf++;
+	} while (1);
+}
+
+/*
  * setup the xstate image representing the init state
  */
 static void __init setup_xstate_init(void)
 {
 	init_xstate_buf = alloc_bootmem(xstate_size);
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
+
+	setup_xstate_features();
 }
 
 /*


