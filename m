Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2ENU2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:28:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42193 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab2ENU12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:27:28 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V6 2/5] New control class and features for FM RX
Date: Mon, 14 May 2012 15:27:21 -0500
Message-ID: <1337027244-2595-3-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
References: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

This patch creates new ctrl class for FM RX and adds new CID's for
below FM features,
      1) De-Emphasis filter mode
      2) RDS Alternate Frequency switch

Also this patch adds a field for band selection in struct v4l2_hw_freq_seek
and adds new capability flags for all below FM bands
	1) V4L2_TUNER_CAP_BAND_TYPE_DEFAULT -> Default Band
	2) V4L2_TUNER_CAP_BAND_TYPE_EUROPE_US -> Europe/US Band
	3) V4L2_TUNER_CAP_BAND_TYPE_JAPAN   -> Japan Band
	4) V4L2_TUNER_CAP_BAND_TYPE_RUSSIAN -> Russian Band
	5) V4L2_TUNER_CAP_BAND_TYPE_WEATHER -> Weather Band

Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/video/v4l2-ctrls.c |   17 ++++++++++++++---
 include/linux/videodev2.h        |   24 +++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 18015c0..9d7608e 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -243,8 +243,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Vivid",
 		NULL
 	};
-	static const char * const tune_preemphasis[] = {
-		"No Preemphasis",
+	static const char * const tune_emphasis[] = {
+		"None",
 		"50 Microseconds",
 		"75 Microseconds",
 		NULL,
@@ -413,7 +413,9 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_COLORFX:
 		return colorfx;
 	case V4L2_CID_TUNE_PREEMPHASIS:
-		return tune_preemphasis;
+		return tune_emphasis;
+	case V4L2_CID_TUNE_DEEMPHASIS:
+		return tune_emphasis;
 	case V4L2_CID_FLASH_LED_MODE:
 		return flash_led_mode;
 	case V4L2_CID_FLASH_STROBE_SOURCE:
@@ -644,6 +646,12 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
 	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
 
+	/* FM Radio Receiver control */
+	/* Keep the order of the 'case's the same as in videodev2.h! */
+	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
+	case V4L2_CID_RDS_AF_SWITCH:		return "RDS Alternate Frequency Switch";
+	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
+
 	default:
 		return NULL;
 	}
@@ -688,6 +696,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
+	case V4L2_CID_RDS_AF_SWITCH:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -733,6 +742,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
+	case V4L2_CID_TUNE_DEEMPHASIS:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
@@ -745,6 +755,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FM_TX_CLASS:
 	case V4L2_CID_FLASH_CLASS:
 	case V4L2_CID_JPEG_CLASS:
+	case V4L2_CID_FM_RX_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c9c9a46..91bc47b 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1137,6 +1137,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
 #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
 #define V4L2_CTRL_CLASS_JPEG 0x009d0000		/* JPEG-compression controls */
+#define V4L2_CTRL_CLASS_FM_RX 0x009e0000	/* FM Receiver control class */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1782,6 +1783,13 @@ enum v4l2_jpeg_chroma_subsampling {
 #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
 #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
 
+/* FM Receiver class control IDs */
+#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
+#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
+
+#define V4L2_CID_RDS_AF_SWITCH			(V4L2_CID_FM_RX_CLASS_BASE + 1)
+#define V4L2_CID_TUNE_DEEMPHASIS		(V4L2_CID_FM_RX_CLASS_BASE + 2)
+
 /*
  *	T U N I N G
  */
@@ -1819,6 +1827,12 @@ struct v4l2_modulator {
 #define V4L2_TUNER_CAP_RDS		0x0080
 #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
 #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
+#define V4L2_TUNER_CAP_BAND_TYPE_DEFAULT	0x00000000	/* Default band */
+#define V4L2_TUNER_CAP_BAND_TYPE_EUROPE_US	0x00010000	/* Europe/US band */
+#define V4L2_TUNER_CAP_BAND_TYPE_JAPAN		0x00020000	/* Japan band */
+#define V4L2_TUNER_CAP_BAND_TYPE_RUSSIAN	0x00030000	/* Russian band */
+#define V4L2_TUNER_CAP_BAND_TYPE_WEATHER	0x00040000	/* Weather band */
+
 
 /*  Flags for the 'rxsubchans' field */
 #define V4L2_TUNER_SUB_MONO		0x0001
@@ -1843,13 +1857,21 @@ struct v4l2_frequency {
 	__u32		      reserved[8];
 };
 
+
+#define V4L2_FM_BAND__DEFAULT	0
+#define V4L2_FM_BAND_EUROPE_US	1	/* 87.5 Mhz - 108 MHz */
+#define V4L2_FM_BAND_JAPAN	2	/* 76 MHz - 90 MHz */
+#define V4L2_FM_BAND_RUSSIAN	3	/* 65.8 MHz - 74 MHz */
+#define V4L2_FM_BAND_WEATHER	4	/* 162.4 MHz - 162.55 MHz */
+
 struct v4l2_hw_freq_seek {
 	__u32		      tuner;
 	enum v4l2_tuner_type  type;
 	__u32		      seek_upward;
 	__u32		      wrap_around;
 	__u32		      spacing;
-	__u32		      reserved[7];
+	__u32		      band;
+	__u32		      reserved[6];
 };
 
 /*
-- 
1.7.4.1

