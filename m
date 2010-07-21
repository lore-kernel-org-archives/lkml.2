Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab0GUWho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:37:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:42848 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab0GUWhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:37:40 -0400
Date: Wed, 21 Jul 2010 22:37:22 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1279731838-1522-4-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Check cpuid level for XSTATE_CPUID (0x0d)
Message-ID: <tip-ee813d53a8e980a3a28318efb8935d45723f5211@git.kernel.org>
Git-Commit-ID: ee813d53a8e980a3a28318efb8935d45723f5211
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 22:37:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee813d53a8e980a3a28318efb8935d45723f5211
Gitweb:     http://git.kernel.org/tip/ee813d53a8e980a3a28318efb8935d45723f5211
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 21 Jul 2010 19:03:54 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 Jul 2010 14:06:04 -0700

x86, xsave: Check cpuid level for XSTATE_CPUID (0x0d)

The patch introduces the XSTATE_CPUID macro and adds a check that
tests if XSTATE_CPUID exists.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279731838-1522-4-git-send-email-robert.richter@amd.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h |    2 ++
 arch/x86/kernel/xsave.c      |   11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 4d3b5d1..d1b5f3a 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 #include <asm/processor.h>
 
+#define XSTATE_CPUID		0x0000000d
+
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
 #define XSTATE_YMM	0x4
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2322f58..5adb7fb 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -379,7 +379,7 @@ static void setup_xstate_features(void)
 	xstate_sizes = alloc_bootmem(xstate_features * sizeof(int));
 
 	do {
-		cpuid_count(0xd, leaf, &eax, &ebx, &ecx, &edx);
+		cpuid_count(XSTATE_CPUID, leaf, &eax, &ebx, &ecx, &edx);
 
 		if (eax == 0)
 			break;
@@ -425,7 +425,12 @@ static void __cpuinit xstate_enable_boot_cpu(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
-	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	if (boot_cpu_data.cpuid_level < XSTATE_CPUID) {
+		WARN(1, KERN_ERR "XSTATE_CPUID missing\n");
+		return;
+	}
+
+	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
 	pcntxt_mask = eax + ((u64)edx << 32);
 
 	if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
@@ -444,7 +449,7 @@ static void __cpuinit xstate_enable_boot_cpu(void)
 	/*
 	 * Recompute the context size for enabled features
 	 */
-	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
 	xstate_size = ebx;
 
 	update_regset_xstate_info(xstate_size, pcntxt_mask);
