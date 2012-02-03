Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2BCJ3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:29:50 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3592 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2BCJ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:29:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/6] ivtv: only start streaming in poll() if polling for input.
Date: Fri,  3 Feb 2012 10:28:41 +0100
Message-Id: <1850ba798baf5d9af1a329ad6bd87de0662bea59.1328260650.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
References: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
References: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/ivtv/ivtv-fileops.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 2cd6c89..956a75a 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -746,8 +746,9 @@ unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
 	return res;
 }
 
-unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
+unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct ivtv_open_id *id = fh2id(filp->private_data);
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[id->type];
@@ -755,7 +756,8 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 	unsigned res = 0;
 
 	/* Start a capture if there is none */
-	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
+	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags) &&
+			(req_events & (POLLIN | POLLRDNORM))) {
 		int rc;
 
 		rc = ivtv_start_capture(id);
-- 
1.7.8.3

