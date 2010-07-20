Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab0GTS6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:58:33 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:22891 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0GTS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:58:26 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5VE0X-02-35X-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/10] x86, xsave: check cpuid level for XSTATE_CPUID (0x0d)
Date: Tue, 20 Jul 2010 20:50:56 +0200
Message-ID: <1279651857-24639-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds a check that tests if XSTATE_CPUID exists.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/xsave.h |    2 ++
 arch/x86/kernel/xsave.c      |    8 +++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

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
index 2322f58..49540b7 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -423,9 +423,15 @@ static void __init setup_xstate_init(void)
  */
 static void __cpuinit xstate_enable_boot_cpu(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
 	unsigned int eax, ebx, ecx, edx;
 
-	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	if (c->cpuid_level < XSTATE_CPUID) {
+		WARN(1, KERN_ERR "XSTATE_CPUID missing\n");
+		return;
+	}
+
+	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
 	pcntxt_mask = eax + ((u64)edx << 32);
 
 	if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
-- 
1.7.1.1


