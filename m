Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2ISHBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:01:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26031 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2ISHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:00:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6839"; a="238452247"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/5] ARM: msm: Move dma.h #defines that are private to dma.c
Date: Wed, 19 Sep 2012 00:00:40 -0700
Message-Id: <1348038044-1790-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.403.gce5cf6f
In-Reply-To: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These #defines are only used by the dma.c file within mach-msm.
Don't put them into a global mach include that any driver can use
to muck with registers within the dma controller. This also
prevents random people from getting access to msm_iomap.h
(a file that will soon be private to mach-msm).

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/dma.c              | 26 ++++++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/dma.h | 26 --------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 354b91d..b279fd8 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -19,9 +19,35 @@
 #include <linux/interrupt.h>
 #include <linux/completion.h>
 #include <mach/dma.h>
+#include <mach/msm_iomap.h>
 
 #define MSM_DMOV_CHANNEL_COUNT 16
 
+#define DMOV_SD0(off, ch) (MSM_DMOV_BASE + 0x0000 + (off) + ((ch) << 2))
+#define DMOV_SD1(off, ch) (MSM_DMOV_BASE + 0x0400 + (off) + ((ch) << 2))
+#define DMOV_SD2(off, ch) (MSM_DMOV_BASE + 0x0800 + (off) + ((ch) << 2))
+#define DMOV_SD3(off, ch) (MSM_DMOV_BASE + 0x0C00 + (off) + ((ch) << 2))
+
+#if defined(CONFIG_ARCH_MSM7X30)
+#define DMOV_SD_AARM DMOV_SD2
+#else
+#define DMOV_SD_AARM DMOV_SD3
+#endif
+
+#define DMOV_CMD_PTR(ch)      DMOV_SD_AARM(0x000, ch)
+#define DMOV_RSLT(ch)         DMOV_SD_AARM(0x040, ch)
+#define DMOV_FLUSH0(ch)       DMOV_SD_AARM(0x080, ch)
+#define DMOV_FLUSH1(ch)       DMOV_SD_AARM(0x0C0, ch)
+#define DMOV_FLUSH2(ch)       DMOV_SD_AARM(0x100, ch)
+#define DMOV_FLUSH3(ch)       DMOV_SD_AARM(0x140, ch)
+#define DMOV_FLUSH4(ch)       DMOV_SD_AARM(0x180, ch)
+#define DMOV_FLUSH5(ch)       DMOV_SD_AARM(0x1C0, ch)
+
+#define DMOV_STATUS(ch)       DMOV_SD_AARM(0x200, ch)
+#define DMOV_ISR              DMOV_SD_AARM(0x380, 0)
+
+#define DMOV_CONFIG(ch)       DMOV_SD_AARM(0x300, ch)
+
 enum {
 	MSM_DMOV_PRINT_ERRORS = 1,
 	MSM_DMOV_PRINT_IO = 2,
diff --git a/arch/arm/mach-msm/include/mach/dma.h b/arch/arm/mach-msm/include/mach/dma.h
index 05583f5..a72d48d 100644
--- a/arch/arm/mach-msm/include/mach/dma.h
+++ b/arch/arm/mach-msm/include/mach/dma.h
@@ -16,7 +16,6 @@
 #ifndef __ASM_ARCH_MSM_DMA_H
 
 #include <linux/list.h>
-#include <mach/msm_iomap.h>
 
 struct msm_dmov_errdata {
 	uint32_t flush[6];
@@ -45,48 +44,23 @@ static inline
 int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr) { return -EIO; }
 #endif
 
-
-#define DMOV_SD0(off, ch) (MSM_DMOV_BASE + 0x0000 + (off) + ((ch) << 2))
-#define DMOV_SD1(off, ch) (MSM_DMOV_BASE + 0x0400 + (off) + ((ch) << 2))
-#define DMOV_SD2(off, ch) (MSM_DMOV_BASE + 0x0800 + (off) + ((ch) << 2))
-#define DMOV_SD3(off, ch) (MSM_DMOV_BASE + 0x0C00 + (off) + ((ch) << 2))
-
-#if defined(CONFIG_ARCH_MSM7X30)
-#define DMOV_SD_AARM DMOV_SD2
-#else
-#define DMOV_SD_AARM DMOV_SD3
-#endif
-
-#define DMOV_CMD_PTR(ch)      DMOV_SD_AARM(0x000, ch)
 #define DMOV_CMD_LIST         (0 << 29) /* does not work */
 #define DMOV_CMD_PTR_LIST     (1 << 29) /* works */
 #define DMOV_CMD_INPUT_CFG    (2 << 29) /* untested */
 #define DMOV_CMD_OUTPUT_CFG   (3 << 29) /* untested */
 #define DMOV_CMD_ADDR(addr)   ((addr) >> 3)
 
-#define DMOV_RSLT(ch)         DMOV_SD_AARM(0x040, ch)
 #define DMOV_RSLT_VALID       (1 << 31) /* 0 == host has empties result fifo */
 #define DMOV_RSLT_ERROR       (1 << 3)
 #define DMOV_RSLT_FLUSH       (1 << 2)
 #define DMOV_RSLT_DONE        (1 << 1)  /* top pointer done */
 #define DMOV_RSLT_USER        (1 << 0)  /* command with FR force result */
 
-#define DMOV_FLUSH0(ch)       DMOV_SD_AARM(0x080, ch)
-#define DMOV_FLUSH1(ch)       DMOV_SD_AARM(0x0C0, ch)
-#define DMOV_FLUSH2(ch)       DMOV_SD_AARM(0x100, ch)
-#define DMOV_FLUSH3(ch)       DMOV_SD_AARM(0x140, ch)
-#define DMOV_FLUSH4(ch)       DMOV_SD_AARM(0x180, ch)
-#define DMOV_FLUSH5(ch)       DMOV_SD_AARM(0x1C0, ch)
-
-#define DMOV_STATUS(ch)       DMOV_SD_AARM(0x200, ch)
 #define DMOV_STATUS_RSLT_COUNT(n)    (((n) >> 29))
 #define DMOV_STATUS_CMD_COUNT(n)     (((n) >> 27) & 3)
 #define DMOV_STATUS_RSLT_VALID       (1 << 1)
 #define DMOV_STATUS_CMD_PTR_RDY      (1 << 0)
 
-#define DMOV_ISR              DMOV_SD_AARM(0x380, 0)
-  
-#define DMOV_CONFIG(ch)       DMOV_SD_AARM(0x300, ch)
 #define DMOV_CONFIG_FORCE_TOP_PTR_RSLT (1 << 2)
 #define DMOV_CONFIG_FORCE_FLUSH_RSLT   (1 << 1)
 #define DMOV_CONFIG_IRQ_EN             (1 << 0)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

