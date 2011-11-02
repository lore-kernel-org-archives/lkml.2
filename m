Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1KBKxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:53:52 -0400
Received: from gold.linx.net ([195.66.232.40]:40034 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab1KBKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:53:49 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 06:53:48 EDT
From: Tony Vroon <tony@linx.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, LKML <linux-kernel@vger.kernel.org>,
        John Brooks <john.brooks@dereferenced.net>
Subject: [PATCH] solo6x10: Correct motion threshold writes
Message-Id: <20111102104617.46BE6100C3@gold.linx.net>
Date: Wed,  2 Nov 2011 10:46:17 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Motion thresholds were never written as solo_p2m_dma fails on 4-byte writes. Some code 
assumed the table was 32x32, but it is 64x64. These errors were not reported upwards 
and could result in improper or complete absence of memory initialisation.

Extracted from an upstream commit by John Brooks and then modified slightly:
https://github.com/bluecherrydvr/solo6x10/commit/7811dfa10972d3ed7f0a86eba2fd277651779c16

Signed-off-by: Tony Vroon <tony@linx.net>

diff --git a/drivers/staging/solo6x10/disp.c b/drivers/staging/solo6x10/disp.c
index 884c0eb..4e88612 100644
--- a/drivers/staging/solo6x10/disp.c
+++ b/drivers/staging/solo6x10/disp.c
@@ -30,8 +30,8 @@
 #define SOLO_MOT_THRESH_H		64
 #define SOLO_MOT_THRESH_SIZE		8192
 #define SOLO_MOT_THRESH_REAL		(SOLO_MOT_THRESH_W * SOLO_MOT_THRESH_H)
-#define SOLO_MOT_FLAG_SIZE		512
-#define SOLO_MOT_FLAG_AREA		(SOLO_MOT_FLAG_SIZE * 32)
+#define SOLO_MOT_FLAG_SIZE		1024
+#define SOLO_MOT_FLAG_AREA		(SOLO_MOT_FLAG_SIZE * 16)
 
 static unsigned video_type;
 module_param(video_type, uint, 0644);
@@ -163,19 +163,19 @@ static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
 	return ret;
 }
 
-void solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
+int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
 {
 	if (ch > solo_dev->nr_chans)
-		return;
+		return -EINVAL;
 
-	solo_dma_vin_region(solo_dev, SOLO_MOT_FLAG_AREA +
+	return solo_dma_vin_region(solo_dev, SOLO_MOT_FLAG_AREA +
 			    (ch * SOLO_MOT_THRESH_SIZE * 2),
-			    val, SOLO_MOT_THRESH_REAL);
+			    val, SOLO_MOT_THRESH_SIZE);
 }
 
 /* First 8k is motion flag (512 bytes * 16). Following that is an 8k+8k
  * threshold and working table for each channel. Atleast that's what the
- * spec says. However, this code (take from rdk) has some mystery 8k
+ * spec says. However, this code (taken from rdk) has some mystery 8k
  * block right after the flag area, before the first thresh table. */
 static void solo_motion_config(struct solo_dev *solo_dev)
 {
@@ -188,9 +188,9 @@ static void solo_motion_config(struct solo_dev *solo_dev)
 
 		/* Clear working cache table */
 		solo_dma_vin_region(solo_dev, SOLO_MOT_FLAG_AREA +
-				    SOLO_MOT_THRESH_SIZE +
-				    (i * SOLO_MOT_THRESH_SIZE * 2),
-				    0x0000, SOLO_MOT_THRESH_REAL);
+				    (i * SOLO_MOT_THRESH_SIZE * 2) +
+				    SOLO_MOT_THRESH_SIZE, 0x0000,
+				    SOLO_MOT_THRESH_SIZE);
 
 		/* Set default threshold table */
 		solo_set_motion_threshold(solo_dev, i, SOLO_DEF_MOT_THRESH);
diff --git a/drivers/staging/solo6x10/solo6x10.h b/drivers/staging/solo6x10/solo6x10.h
index abee721..abc1575 100644
--- a/drivers/staging/solo6x10/solo6x10.h
+++ b/drivers/staging/solo6x10/solo6x10.h
@@ -327,7 +327,7 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev, u8 id,
 		      struct p2m_desc *desc, int desc_count);
 
 /* Set the threshold for motion detection */
-void solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
+int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
 #define SOLO_DEF_MOT_THRESH		0x0300
 
 /* Write text on OSD */
diff --git a/drivers/staging/solo6x10/v4l2-enc.c b/drivers/staging/solo6x10/v4l2-enc.c
index bee7280..1ef43a4 100644
--- a/drivers/staging/solo6x10/v4l2-enc.c
+++ b/drivers/staging/solo6x10/v4l2-enc.c
@@ -1585,8 +1585,7 @@ static int solo_s_ctrl(struct file *file, void *priv,
 		if (ctrl->value < 0 || ctrl->value > 0xffff)
 			return -ERANGE;
 		solo_enc->motion_thresh = ctrl->value;
-		solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->value);
-		break;
+		return solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->value);
 	case V4L2_CID_MOTION_ENABLE:
 		solo_motion_toggle(solo_enc, ctrl->value);
 		break;
