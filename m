Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0GURWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:22:15 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34660
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753305Ab0GURWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:22:01 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5X434-01-7EV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] x86, xsave: check cpuid level for XSTATE_CPUID (0x0d)
Date: Wed, 21 Jul 2010 19:03:54 +0200
Message-ID: <1279731838-1522-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introduces the XSTATE_CPUID macro and adds a check that
tests if XSTATE_CPUID exists.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.7.1.1


