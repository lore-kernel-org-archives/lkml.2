Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1BXSpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:45:19 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab1BXSou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:44:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76263928"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] msm: scm: Get cacheline size from CTR
Date: Thu, 24 Feb 2011 10:44:45 -0800
Message-Id: <1298573085-23217-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.55.gdca3d
In-Reply-To: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hardcoding the cacheline size as 32, get the cacheline
size from the CTR register.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/scm.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
index cfa808d..0528c71 100644
--- a/arch/arm/mach-msm/scm.c
+++ b/arch/arm/mach-msm/scm.c
@@ -26,9 +26,6 @@
 
 #include "scm.h"
 
-/* Cache line size for msm8x60 */
-#define CACHELINESIZE 32
-
 #define SCM_ENOMEM		-5
 #define SCM_EOPNOTSUPP		-4
 #define SCM_EINVAL_ADDR		-3
@@ -207,6 +204,14 @@ static int __scm_call(const struct scm_command *cmd)
 	return ret;
 }
 
+static inline u32 dcache_line_size(void)
+{
+	u32 ctr;
+
+	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	return 4 << ((ctr >> 16) & 0xf);
+}
+
 /**
  * scm_call() - Send an SCM command
  * @svc_id: service identifier
@@ -243,11 +248,13 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 	do {
 		u32 start = (u32)rsp;
 		u32 end = (u32)scm_get_response_buffer(rsp) + resp_len;
-		start &= ~(CACHELINESIZE - 1);
+		u32 cacheline_size = dcache_line_size();
+
+		start &= ~(cacheline_size - 1);
 		while (start < end) {
 			asm ("mcr p15, 0, %0, c7, c6, 1" : : "r" (start)
 			     : "memory");
-			start += CACHELINESIZE;
+			start += cacheline_size;
 		}
 	} while (!rsp->is_complete);
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

