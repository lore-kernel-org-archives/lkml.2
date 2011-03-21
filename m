Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1CULgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:36:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47593 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1CULgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:36:23 -0400
From: manjunatha_halli@ti.com
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [PATCH 2/2] [media] radio: wl128x: Update registration process with ST.
Date: Mon, 21 Mar 2011 08:03:14 -0400
Message-Id: <1300708994-18058-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

As underlying ST driver registration API's have changed this
patch will update the FM driver accordingly.

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 96a95c5..b09b283 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1494,12 +1494,17 @@ u32 fmc_prepare(struct fmdev *fmdev)
 	}
 
 	memset(&fm_st_proto, 0, sizeof(fm_st_proto));
-	fm_st_proto.type = ST_FM;
 	fm_st_proto.recv = fm_st_receive;
 	fm_st_proto.match_packet = NULL;
 	fm_st_proto.reg_complete_cb = fm_st_reg_comp_cb;
 	fm_st_proto.write = NULL; /* TI ST driver will fill write pointer */
 	fm_st_proto.priv_data = fmdev;
+	fm_st_proto.chnl_id = 0x08;
+	fm_st_proto.max_frame_size = 0xff;
+	fm_st_proto.hdr_len = 1;
+	fm_st_proto.offset_len_in_hdr = 0;
+	fm_st_proto.len_size = 1;
+	fm_st_proto.reserve = 1;
 
 	ret = st_register(&fm_st_proto);
 	if (ret == -EINPROGRESS) {
@@ -1532,7 +1537,7 @@ u32 fmc_prepare(struct fmdev *fmdev)
 		g_st_write = fm_st_proto.write;
 	} else {
 		fmerr("Failed to get ST write func pointer\n");
-		ret = st_unregister(ST_FM);
+		ret = st_unregister(&fm_st_proto);
 		if (ret < 0)
 			fmerr("st_unregister failed %d\n", ret);
 		return -EAGAIN;
@@ -1586,6 +1591,7 @@ u32 fmc_prepare(struct fmdev *fmdev)
  */
 u32 fmc_release(struct fmdev *fmdev)
 {
+	static struct st_proto_s fm_st_proto;
 	u32 ret;
 
 	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
@@ -1604,7 +1610,11 @@ u32 fmc_release(struct fmdev *fmdev)
 	fmdev->resp_comp = NULL;
 	fmdev->rx.freq = 0;
 
-	ret = st_unregister(ST_FM);
+	memset(&fm_st_proto, 0, sizeof(fm_st_proto));
+	fm_st_proto.chnl_id = 0x08;
+
+	ret = st_unregister(&fm_st_proto);
+
 	if (ret < 0)
 		fmerr("Failed to de-register FM from ST %d\n", ret);
 	else
-- 
1.7.0.4

