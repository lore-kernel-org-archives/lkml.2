Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1GOQzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:55:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52416 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1GOQzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:55:48 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] gma500: Fix DPU build
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:46:58 +0100
Message-ID: <20110715164650.2918.32196.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fix up the merge build

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_dsi_dbi.h     |    6 ++++++
 drivers/staging/gma500/mdfld_dsi_dbi_dpu.c |   10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.h b/drivers/staging/gma500/mdfld_dsi_dbi.h
index a2ec6fd..dc6242c 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.h
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.h
@@ -69,6 +69,12 @@ struct mdfld_dsi_dbi_output {
 	bool dbi_panel_on;
 	bool first_boot;
 	struct panel_funcs *p_funcs;
+
+	/* DPU */
+	u32 *dbi_cb_addr;
+	u32 dbi_cb_phy;
+	spinlock_t cb_lock;
+	u32 cb_write;
 };
 
 #define MDFLD_DSI_DBI_OUTPUT(dsi_encoder) \
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi_dpu.c b/drivers/staging/gma500/mdfld_dsi_dbi_dpu.c
index 98ec990..a4e2ff4 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi_dpu.c
+++ b/drivers/staging/gma500/mdfld_dsi_dbi_dpu.c
@@ -418,7 +418,7 @@ static int mdfld_dpu_update_pipe(struct mdfld_dsi_dbi_output *dbi_output,
 		 * added it so that text console could boot smoothly
 		 */
 		/* Clean pending flags on this pipe */
-		if (!ret && dev_priv->b_dsr_enable) {
+		if (!ret && dev_priv->dsr_enable) {
 			dpu_info->pending &= ~plane_mask;
 			/* Reset overlay pipe damage rect */
 			mdfld_dpu_init_damage(dpu_info, pipe);
@@ -527,7 +527,7 @@ static int __mdfld_dbi_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 	if (!dbi_output)
 		return 0;
 
-	/*if mode setting on-going, back off*/
+	/* If mode setting on-going, back off */
 	if ((dbi_output->mode_flags & MODE_SETTING_ON_GOING) ||
 		(psb_crtc && psb_crtc->mode_flags & MODE_SETTING_ON_GOING))
 		return -EAGAIN;
@@ -542,7 +542,7 @@ static int __mdfld_dbi_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 		reg_offset = MIPIC_REG_OFFSET;
 	}
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, true))
+	if (!gma_power_begin(dev, true))
 		return -EAGAIN;
 
 	/* Enable DPLL */
@@ -585,9 +585,9 @@ static int __mdfld_dbi_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 		udelay(500);
 	}
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 
-	/*clean IN_DSR flag*/
+	/* Clean IN_DSR flag */
 	dbi_output->mode_flags &= ~MODE_SETTING_IN_DSR;
 
 	return 0;

