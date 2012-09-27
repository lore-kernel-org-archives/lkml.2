Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2I0Fd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:33:57 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51943 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2I0Fd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:33:56 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] media: davinci: vpif: add check for NULL handler
Date: Thu, 27 Sep 2012 11:03:12 +0530
Message-Id: <1348723992-3199-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

for da850/omap-l138, there is no need to setup_input_channel_mode()
and set_clock(), to avoid adding dummy code in board file just returning
zero add a check in the driver itself to call the handler only if its
not NULL.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 Changes for v2:
 1: Added patch description, pointed by Mauro.

 drivers/media/platform/davinci/vpif_capture.c |   13 +++++++------
 drivers/media/platform/davinci/vpif_display.c |   13 +++++++------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 13aa46d..7b5e09a 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -311,12 +311,13 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	/* configure 1 or 2 channel mode */
-	ret = vpif_config_data->setup_input_channel_mode
-					(vpif->std_info.ycmux_mode);
-
-	if (ret < 0) {
-		vpif_dbg(1, debug, "can't set vpif channel mode\n");
-		return ret;
+	if (vpif_config_data->setup_input_channel_mode) {
+		ret = vpif_config_data->
+			setup_input_channel_mode(vpif->std_info.ycmux_mode);
+		if (ret < 0) {
+			vpif_dbg(1, debug, "can't set vpif channel mode\n");
+			return ret;
+		}
 	}
 
 	/* Call vpif_set_params function to set the parameters and addresses */
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index e401aea..e8a0286 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -280,12 +280,13 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	/* clock settings */
-	ret =
-	    vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
-					ch->vpifparams.std_info.hd_sd);
-	if (ret < 0) {
-		vpif_err("can't set clock\n");
-		return ret;
+	if (vpif_config_data->set_clock) {
+		ret = vpif_config_data->set_clock(ch->vpifparams.std_info.
+		ycmux_mode, ch->vpifparams.std_info.hd_sd);
+		if (ret < 0) {
+			vpif_err("can't set clock\n");
+			return ret;
+		}
 	}
 
 	/* set the parameters and addresses */
-- 
1.7.4.1

