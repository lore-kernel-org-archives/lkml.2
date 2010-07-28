Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0G1Ogj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:36:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57496 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab0G1Ogf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:36:35 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 4/5] staging:ti dspbridge: remove unnecessary volatile variables
Date: Wed, 28 Jul 2010 09:40:51 -0500
Message-Id: <1280328052-31292-5-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328052-31292-4-git-send-email-ernesto@ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
 <1280328052-31292-2-git-send-email-ernesto@ti.com>
 <1280328052-31292-3-git-send-email-ernesto@ti.com>
 <1280328052-31292-4-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary volatile variables; use accessor
functions __raw_readl/__raw_writel instead when applicable.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c |    8 ++++----
 drivers/staging/tidspbridge/dynload/tramp.c   |    4 ++--
 drivers/staging/tidspbridge/pmgr/cmm.c        |    7 ++++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 08a2f5f..ae1f394 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -404,7 +404,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		pr_err("%s: Illegal SM base\n", __func__);
 		status = -EPERM;
 	} else
-		*((volatile u32 *)dw_sync_addr) = 0xffffffff;
+		__raw_writel(0xffffffff, dw_sync_addr);
 
 	if (DSP_SUCCEEDED(status)) {
 		resources = dev_context->resources;
@@ -584,7 +584,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		dev_dbg(bridge, "Waiting for Sync @ 0x%x\n", dw_sync_addr);
 		dev_dbg(bridge, "DSP c_int00 Address =  0x%x\n", dsp_addr);
 		if (dsp_debug)
-			while (*((volatile u16 *)dw_sync_addr))
+			while (__raw_readw(dw_sync_addr))
 				;;
 
 		/* Wait for DSP to clear word in shared memory */
@@ -602,7 +602,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			/* Write the synchronization bit to indicate the
 			 * completion of OPP table update to DSP
 			 */
-			*((volatile u32 *)dw_sync_addr) = 0XCAFECAFE;
+			__raw_writel(0XCAFECAFE, dw_sync_addr);
 
 			/* update board state */
 			dev_context->dw_brd_state = BRD_RUNNING;
@@ -1852,7 +1852,7 @@ bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr)
 	u16 timeout = TIHELEN_ACKTIMEOUT;
 
 	/*  Wait for response from board */
-	while (*((volatile u16 *)dw_sync_addr) && --timeout)
+	while (__raw_readw(dw_sync_addr) && --timeout)
 		udelay(10);
 
 	/*  If timed out: return false */
diff --git a/drivers/staging/tidspbridge/dynload/tramp.c b/drivers/staging/tidspbridge/dynload/tramp.c
index 81314d2..60d22ea 100644
--- a/drivers/staging/tidspbridge/dynload/tramp.c
+++ b/drivers/staging/tidspbridge/dynload/tramp.c
@@ -86,8 +86,8 @@ static u8 priv_h2a(u8 value)
 static void priv_tramp_sym_gen_name(u32 value, char *dst)
 {
 	u32 i;
-	volatile char *prefix = TRAMP_SYM_PREFIX;
-	volatile char *dst_local = dst;
+	char *prefix = TRAMP_SYM_PREFIX;
+	char *dst_local = dst;
 	u8 tmp;
 
 	/*  Clear out the destination, including the ending NULL */
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 874ed64..b7cba1b 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -1008,6 +1008,7 @@ void *cmm_xlator_alloc_buf(struct cmm_xlatorobject *xlator, void *va_buf,
 {
 	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
 	void *pbuf = NULL;
+	void *tmp_va_buff;
 	struct cmm_attrs attrs;
 
 	DBC_REQUIRE(refs > 0);
@@ -1019,16 +1020,16 @@ void *cmm_xlator_alloc_buf(struct cmm_xlatorobject *xlator, void *va_buf,
 
 	if (xlator_obj) {
 		attrs.ul_seg_id = xlator_obj->ul_seg_id;
-		*(volatile u32 *)va_buf = 0;
+		__raw_writel(0, va_buf);
 		/* Alloc SM */
 		pbuf =
 		    cmm_calloc_buf(xlator_obj->hcmm_mgr, pa_size, &attrs, NULL);
 		if (pbuf) {
 			/* convert to translator(node/strm) process Virtual
 			 * address */
-			*(volatile u32 **)va_buf =
-			    (u32 *) cmm_xlator_translate(xlator,
+			 tmp_va_buff = cmm_xlator_translate(xlator,
 							 pbuf, CMM_PA2VA);
+			__raw_writel((u32)tmp_va_buff, va_buf);
 		}
 	}
 	return pbuf;
-- 
1.5.4.5

