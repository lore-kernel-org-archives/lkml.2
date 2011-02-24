Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1BXSpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:45:23 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab1BXSot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:44:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76263927"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] msm: scm: Check for interruption immediately
Date: Thu, 24 Feb 2011 10:44:44 -0800
Message-Id: <1298573085-23217-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.55.gdca3d
In-Reply-To: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we're interrupted on the secure side, we should just issue
another smc instruction again instead of replaying the arguments
to smc. Fix it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/scm.c |   51 ++++++++++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
index 5eddf54..cfa808d 100644
--- a/arch/arm/mach-msm/scm.c
+++ b/arch/arm/mach-msm/scm.c
@@ -174,15 +174,18 @@ static u32 smc(u32 cmd_addr)
 	register u32 r0 asm("r0") = 1;
 	register u32 r1 asm("r1") = (u32)&context_id;
 	register u32 r2 asm("r2") = cmd_addr;
-	asm volatile(
-		__asmeq("%0", "r0")
-		__asmeq("%1", "r0")
-		__asmeq("%2", "r1")
-		__asmeq("%3", "r2")
-		"smc	#0	@ switch to secure world\n"
-		: "=r" (r0)
-		: "r" (r0), "r" (r1), "r" (r2)
-		: "r3");
+	do {
+		asm volatile(
+			__asmeq("%0", "r0")
+			__asmeq("%1", "r0")
+			__asmeq("%2", "r1")
+			__asmeq("%3", "r2")
+			"smc	#0	@ switch to secure world\n"
+			: "=r" (r0)
+			: "r" (r0), "r" (r1), "r" (r2)
+			: "r3");
+	} while (r0 == SCM_INTERRUPTED);
+
 	return r0;
 }
 
@@ -197,13 +200,9 @@ static int __scm_call(const struct scm_command *cmd)
 	 * side in the buffer.
 	 */
 	flush_cache_all();
-	do {
-		ret = smc(cmd_addr);
-		if (ret < 0) {
-			ret = scm_remap_error(ret);
-			break;
-		}
-	} while (ret == SCM_INTERRUPTED);
+	ret = smc(cmd_addr);
+	if (ret < 0)
+		ret = scm_remap_error(ret);
 
 	return ret;
 }
@@ -274,14 +273,18 @@ u32 scm_get_version(void)
 
 	r0 = 0x1 << 8;
 	r1 = (u32)&context_id;
-	asm volatile(
-		__asmeq("%0", "r1")
-		__asmeq("%1", "r0")
-		__asmeq("%2", "r1")
-		"smc	#0	@ switch to secure world\n"
-		: "=r" (r1)
-		: "r" (r0), "r" (r1)
-		: "r2", "r3");
+	do {
+		asm volatile(
+			__asmeq("%0", "r0")
+			__asmeq("%1", "r1")
+			__asmeq("%2", "r0")
+			__asmeq("%3", "r1")
+			"smc	#0	@ switch to secure world\n"
+			: "=r" (r0), "=r" (r1)
+			: "r" (r0), "r" (r1)
+			: "r2", "r3");
+	} while (r0 == SCM_INTERRUPTED);
+
 	version = r1;
 	mutex_unlock(&scm_lock);
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

