Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1KPJRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:17:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39229 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1KPJRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:17:16 -0500
Message-ID: <1321434843.16575.1.camel@phoenix>
Subject: [PATCH] [media] media/radio/tef6862: fix checking return value of
 i2c_master_send
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>,
        Mauro Carvalho Chehab Mauro Carvalho Chehab 
	<mchehab@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-media@vger.kernel.org
Date: Wed, 16 Nov 2011 17:14:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_master_send returns negative errno, or else the number of bytes written.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/media/radio/tef6862.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 0991e19..3408685 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -118,9 +118,11 @@ static int tef6862_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	i2cmsg[2] = pll & 0xff;
 
 	err = i2c_master_send(client, i2cmsg, sizeof(i2cmsg));
-	if (!err)
-		state->freq = f->frequency;
-	return err;
+	if (err != sizeof(i2cmsg))
+		return err < 0 ? err : -EIO;
+
+	state->freq = f->frequency;
+	return 0;
 }
 
 static int tef6862_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
-- 
1.7.5.4



