Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967476Ab0GTBwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 21:52:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:44386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967380Ab0GTBwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 21:52:04 -0400
Date: Tue, 20 Jul 2010 01:51:45 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100719230205.262987929@sbs-t61.sc.intel.com>
References: <20100719230205.262987929@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Track the offset, size of state in the xsave layout
Message-ID: <tip-a1488f8bf4d72ad724700f6e982469a1240e4264@git.kernel.org>
Git-Commit-ID: a1488f8bf4d72ad724700f6e982469a1240e4264
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 01:51:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1488f8bf4d72ad724700f6e982469a1240e4264
Gitweb:     http://git.kernel.org/tip/a1488f8bf4d72ad724700f6e982469a1240e4264
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 19 Jul 2010 16:05:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Jul 2010 17:51:17 -0700

x86, xsave: Track the offset, size of state in the xsave layout

Subleaves of the cpuid vector 0xd provides the offset and size of different
feature state that are managed by the xsave/xrstor. Track this for the upcoming
usage during signal handling.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100719230205.262987929@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9801498..4993caa 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -21,6 +21,8 @@ struct _fpx_sw_bytes fx_sw_reserved;
 struct _fpx_sw_bytes fx_sw_reserved_ia32;
 #endif
 
+static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
+
 /*
  * Check for the presence of extended state information in the
  * user fpstate pointer in the sigcontext.
@@ -302,12 +304,39 @@ void __cpuinit xsave_init(void)
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
