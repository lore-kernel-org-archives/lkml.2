Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891Ab2INSp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:45:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42637 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2INSp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:45:56 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Oleszkiewicz <doleszki@adsyscontrols.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2] davinci: vpif: capture/display: fix race condition
Date: Sat, 15 Sep 2012 00:15:25 +0530
Message-Id: <1347648325-5114-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

channel_first_int[][] variable is used as a flag for the ISR,
This flag was being set after enabling the interrupts, There
where situations when the isr occurred even before the flag was set
due to which it was causing the application hang.
This patch sets channel_first_int[][] flag just before enabling the
interrupt.

Reported-by: David Oleszkiewicz <doleszki@adsyscontrols.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 Changes for v2:
 1: Fixed typo's in description.

 drivers/media/platform/davinci/vpif_capture.c |    2 +-
 drivers/media/platform/davinci/vpif_display.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 1b625b0..f64919b 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -339,6 +339,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 * Set interrupt for both the fields in VPIF Register enable channel in
 	 * VPIF register
 	 */
+	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
 	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id)) {
 		channel0_intr_assert();
 		channel0_intr_enable(1);
@@ -350,7 +351,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		channel1_intr_enable(1);
 		enable_channel1(1);
 	}
-	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
 
 	return 0;
 }
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 4a24848..523a840 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -302,6 +302,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	/* Set interrupt for both the fields in VPIF
 	    Register enable channel in VPIF register */
+	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
 	if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
 		channel2_intr_assert();
 		channel2_intr_enable(1);
@@ -318,7 +319,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		if (vpif_config_data->ch3_clip_en)
 			channel3_clipping_enable(1);
 	}
-	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
 
 	return 0;
 }
-- 
1.7.0.4

