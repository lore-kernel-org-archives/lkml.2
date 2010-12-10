Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0LJNTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:19:36 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:24962 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069Ab0LJNTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:19:35 -0500
Subject: [RESEND][PATCH for stable 2.6.36 REGRESSION] cx25840: Prevent
 device probe failure due to volume control ERANGE error]
From: Andy Walls <awalls@md.metrocast.net>
To: stable@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: gregkh@suse.de, hverkuil@xs4all.nl, mchehab@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 08:19:57 -0500
Message-ID: <1291987197.2064.8.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-10_08:2010-12-10,2010-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=8
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012100032
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, since this didn't appear to make its way into in 2.6.36.2.
This patch fixes a regression that breaks analog video and audio on
boards supported by the ivtv, pvrusb2, cx231xx, and cx23885 drivers.
The regression also breaks IR on boards supported by the cx23885
driver.  

Regards,
Andy


The volume control scale in the cx25840 driver has an unusual mapping
from register values to v4l2 volume control values.  Enforce the mapping
limits, so that the default volume control setting does not fall out of
bounds to prevent the cx25840 module device probe from failing.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: stable@kernel.org
---
 drivers/media/video/cx25840/cx25840-core.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index f5a3e74..b9a2f18 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1991,8 +1991,23 @@ static int cx25840_probe(struct i2c_client *client,
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


