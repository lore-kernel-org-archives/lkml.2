Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab2BCJ37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:29:59 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3227 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab2BCJ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:29:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] videobuf2: only start streaming in poll() if so requested by the poll mask.
Date: Fri,  3 Feb 2012 10:28:42 +0100
Message-Id: <743b77f12f9a3e29fd5cbcc821bb864cb8c1fab6.1328260650.git.hans.verkuil@cisco.com>
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
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 2e8f1df..0b1c771 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1647,6 +1647,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	unsigned long flags;
 	unsigned int ret;
 	struct vb2_buffer *vb = NULL;
@@ -1655,12 +1656,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
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
1.7.8.3

