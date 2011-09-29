Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1I2Ho7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:44:59 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3947 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab1I2Hoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:44:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 3/6] videobuf2: only start streaming in poll() if so requested by the poll mask.
Date: Thu, 29 Sep 2011 09:44:09 +0200
Message-Id: <47dc03d0de07b08b43188d0ef3a53f431aa6b955.1317281827.git.hans.verkuil@cisco.com>
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
 drivers/media/video/videobuf2-core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6687ac3..a921638 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1368,6 +1368,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	unsigned long flags;
 	unsigned int ret;
 	struct vb2_buffer *vb = NULL;
@@ -1376,12 +1377,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+				(req_events & (POLLIN | POLLRDNORM))) {
 			ret = __vb2_init_fileio(q, 1);
 			if (ret)
 				return POLLERR;
 		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+				(req_events & (POLLOUT | POLLWRNORM))) {
 			ret = __vb2_init_fileio(q, 0);
 			if (ret)
 				return POLLERR;
-- 
1.7.5.4

