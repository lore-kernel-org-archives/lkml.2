Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1HZKYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:24:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49239 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1HZKYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:24:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/9] gma500: kill bogus code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:19:17 +0100
Message-ID: <20110826101908.16760.70316.stgit@localhost.localdomain>
In-Reply-To: <20110826101734.16760.64364.stgit@localhost.localdomain>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

During the power split ups and work a chunk of code escaped into the
Poulsbo code path which it isn't for. On some devices such as the Dell
mini-10 this causes problems.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_device.c |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index 4659132..b97aa78 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -213,7 +213,6 @@ static int psb_restore_display_registers(struct drm_device *dev)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct drm_crtc *crtc;
 	struct drm_connector *connector;
-	int pp_stat;
 
 	/* Display arbitration + watermarks */
 	PSB_WVDC32(dev_priv->saveDSPARB, DSPARB);
@@ -237,37 +236,6 @@ static int psb_restore_display_registers(struct drm_device *dev)
 		connector->funcs->restore(connector);
 
 	mutex_unlock(&dev->mode_config.mutex);
-
-	if (dev_priv->iLVDS_enable) {
-		/*shutdown the panel*/
-		PSB_WVDC32(0, PP_CONTROL);
-		do {
-			pp_stat = PSB_RVDC32(PP_STATUS);
-		} while (pp_stat & 0x80000000);
-
-		/* Turn off the plane */
-		PSB_WVDC32(0x58000000, DSPACNTR);
-		PSB_WVDC32(0, DSPASURF);/*trigger the plane disable*/
-		/* Wait ~4 ticks */
-		msleep(4);
-		/* Turn off pipe */
-		PSB_WVDC32(0x0, PIPEACONF);
-		/* Wait ~8 ticks */
-		msleep(8);
-
-		/* Turn off PLLs */
-		PSB_WVDC32(0, MRST_DPLL_A);
-	} else {
-		PSB_WVDC32(DPI_SHUT_DOWN, DPI_CONTROL_REG);
-		PSB_WVDC32(0x0, PIPEACONF);
-		PSB_WVDC32(0x2faf0000, BLC_PWM_CTL);
-		while (REG_READ(0x70008) & 0x40000000)
-			cpu_relax();
-		while ((PSB_RVDC32(GEN_FIFO_STAT_REG) & DPI_FIFO_EMPTY)
-			!= DPI_FIFO_EMPTY)
-			cpu_relax();
-		PSB_WVDC32(0, DEVICE_READY_REG);
-	}
 	return 0;
 }
 

