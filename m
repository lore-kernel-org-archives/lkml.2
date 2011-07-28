Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1G1Xso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:48:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:25230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1G1Xok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="35732467"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: hans.verkuil@cisco.com, isely@pobox.com, mchehab@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [35/50] pvrusb2: fix g/s_tuner support
Message-Id: <20110728234439.E57A22403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hans Verkuil <hans.verkuil@cisco.com>

[ upstream commit 50e9efd60b213ce43ad6979bfc18e25eec2d8413 ]

The tuner-core subdev requires that the type field of v4l2_tuner is
filled in correctly. This is done in v4l2-ioctl.c, but pvrusb2 doesn't
use that yet, so we have to do it manually based on whether the current
input is radio or not.

Tested with my pvrusb2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Mike Isely <isely@pobox.com>
Cc: stable@kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/media/video/pvrusb2/pvrusb2-hdw.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ linux-2.6.35.y/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -3039,6 +3039,8 @@ static void pvr2_subdev_update(struct pv
 	if (hdw->input_dirty || hdw->audiomode_dirty || hdw->force_dirty) {
 		struct v4l2_tuner vt;
 		memset(&vt, 0, sizeof(vt));
+		vt.type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		vt.audmode = hdw->audiomode_val;
 		v4l2_device_call_all(&hdw->v4l2_dev, 0, tuner, s_tuner, &vt);
 	}
@@ -5163,6 +5165,8 @@ void pvr2_hdw_status_poll(struct pvr2_hd
 {
 	struct v4l2_tuner *vtp = &hdw->tuner_signal_info;
 	memset(vtp, 0, sizeof(*vtp));
+	vtp->type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
+		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	hdw->tuner_signal_stale = 0;
 	/* Note: There apparently is no replacement for VIDIOC_CROPCAP
 	   using v4l2-subdev - therefore we can't support that AT ALL right
