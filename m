Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1I2HpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:45:07 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4599 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab1I2HpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:45:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 2/6] ivtv: only start streaming in poll() if polling for input.
Date: Thu, 29 Sep 2011 09:44:08 +0200
Message-Id: <32566dbc40ed36da1ef324afd8a09813c1bc080c.1317281827.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
References: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-fileops.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 38f0522..a931ecf 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -744,8 +744,9 @@ unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
 	return res;
 }
 
-unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
+unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct ivtv_open_id *id = fh2id(filp->private_data);
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[id->type];
@@ -753,7 +754,8 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 	unsigned res = 0;
 
 	/* Start a capture if there is none */
-	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
+	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags) &&
+			(req_events & (POLLIN | POLLRDNORM))) {
 		int rc;
 
 		mutex_lock(&itv->serialize_lock);
-- 
1.7.5.4

