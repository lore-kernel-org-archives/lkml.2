Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1CUSd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:33:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52133 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1CUSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:33:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6292"; a="81206609"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Saravana Kannan <skannan@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCHv2 4/4] msm: scm: Get cacheline size from CTR
Date: Mon, 21 Mar 2011 11:33:50 -0700
Message-Id: <1300732430-13189-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hardcoding the cacheline size as 32, get the cacheline
size from the CTR register. Use an early_initcall because
scm_call() is used to boot the secondary CPUs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v1:
 * Use an early_initcall to get cacheline size (tglx)
 * Pull the end assignment out of the for loop

 arch/arm/mach-msm/scm.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
index cfa808d..3103f3a 100644
--- a/arch/arm/mach-msm/scm.c
+++ b/arch/arm/mach-msm/scm.c
@@ -21,14 +21,12 @@
 #include <linux/mutex.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/init.h>
 
 #include <asm/cacheflush.h>
 
 #include "scm.h"
 
-/* Cache line size for msm8x60 */
-#define CACHELINESIZE 32
-
 #define SCM_ENOMEM		-5
 #define SCM_EOPNOTSUPP		-4
 #define SCM_EINVAL_ADDR		-3
@@ -207,6 +205,8 @@ static int __scm_call(const struct scm_command *cmd)
 	return ret;
 }
 
+static u32 cacheline_size;
+
 /**
  * scm_call() - Send an SCM command
  * @svc_id: service identifier
@@ -224,6 +224,7 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 	int ret;
 	struct scm_command *cmd;
 	struct scm_response *rsp;
+	u32 end;
 
 	cmd = alloc_scm_command(cmd_len, resp_len);
 	if (!cmd)
@@ -240,14 +241,16 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 		goto out;
 
 	rsp = scm_command_to_response(cmd);
+	end = (u32)scm_get_response_buffer(rsp) + resp_len;
+
 	do {
 		u32 start = (u32)rsp;
-		u32 end = (u32)scm_get_response_buffer(rsp) + resp_len;
-		start &= ~(CACHELINESIZE - 1);
+		start &= ~(cacheline_size - 1);
+
 		while (start < end) {
 			asm ("mcr p15, 0, %0, c7, c6, 1" : : "r" (start)
 			     : "memory");
-			start += CACHELINESIZE;
+			start += cacheline_size;
 		}
 	} while (!rsp->is_complete);
 
@@ -291,3 +294,14 @@ u32 scm_get_version(void)
 	return version;
 }
 EXPORT_SYMBOL(scm_get_version);
+
+static int __init scm_init(void)
+{
+	u32 ctr;
+
+	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	cacheline_size =  4 << ((ctr >> 16) & 0xf);
+
+	return 0;
+}
+early_initcall(scm_init);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

