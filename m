Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0LEWmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:42:03 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42023 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166Ab0LEWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:42:01 -0500
Subject: [PATCH for 2.6.37 REGRESSION] cx25840: Prevent device probe
 failure due to volume control ERANGE error
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Dec 2010 17:42:30 -0500
Message-ID: <1291588950.2046.51.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-05_07:2010-12-04,2010-12-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012050122
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was created and tested against linux-next
( git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git ),
tag next-20101203, and fixes a regression that crept into 2.6.36.

The volume control scale in the cx25840 driver has an unusual mapping
from register values to v4l2 volume control values.  Enforce the mapping
limits, so that the default volume control setting does not fall out of
bounds to prevent the cx25840 module device probe from failing.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/cx25840/cx25840-core.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index dfb198d..f164618 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1989,8 +1989,23 @@ static int cx25840_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&state->hdl, &cx25840_ctrl_ops,
 			V4L2_CID_HUE, -128, 127, 1, 0);
 	if (!is_cx2583x(state)) {
-		default_volume = 228 - cx25840_read(client, 0x8d4);
-		default_volume = ((default_volume / 2) + 23) << 9;
+		default_volume = cx25840_read(client, 0x8d4);
+		/*
+		 * Enforce the legacy PVR-350/MSP3400 to PVR-150/CX25843 volume
+		 * scale mapping limits to avoid -ERANGE errors when
+		 * initializing the volume control
+		 */
+		if (default_volume > 228) {
+			/* Bottom out at -96 dB, v4l2 vol range 0x2e00-0x2fff */
+			default_volume = 228;
+			cx25840_write(client, 0x8d4, 228);
+		}
+		else if (default_volume < 20) {
+			/* Top out at + 8 dB, v4l2 vol range 0xfe00-0xffff */
+			default_volume = 20;
+			cx25840_write(client, 0x8d4, 20);
+		}
+		default_volume = (((228 - default_volume) >> 1) + 23) << 9;
 
 		state->volume = v4l2_ctrl_new_std(&state->hdl,
 			&cx25840_audio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,
-- 
1.7.2.3



