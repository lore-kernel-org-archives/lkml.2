Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2INNyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:54:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45446 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2INNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:54:07 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        David Oleszkiewicz <doleszki@adsyscontrols.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] davinci: vpif: capture/display: fix race condition
Date: Fri, 14 Sep 2012 19:23:56 +0530
Message-Id: <1347630836-7545-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

channel_first_int[][] variable is used as a flag for the ISR,
This flag was being set after enabling the interrupts, There
where suitaions when the isr ocuurend even before the flag was set
dues to which it was causing the applicaiotn hang.
This patch sets  channel_first_int[][] flag just before enabling the
interrupt.

Reported-by: David Oleszkiewicz <doleszki@adsyscontrols.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
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
1.7.4.1

