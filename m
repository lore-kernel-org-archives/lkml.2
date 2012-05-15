Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab2EOCz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:55:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:49586 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042Ab2EOCRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 085/179] uvcvideo: Remove buffers from the queues when freeing
Date: Mon, 14 May 2012 22:13:01 -0400
Message-ID: <1337048075-6132-86-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8ca2c80b170c47eeb55f0c2a0f2b8edf85f35d49 upstream.

When freeing memory for the video buffers also remove them from the
irq & main queues.

This fixes an oops when doing the following:

open ("/dev/video", ..)
VIDIOC_REQBUFS
VIDIOC_QBUF
VIDIOC_REQBUFS
close ()

As the second VIDIOC_REQBUFS will cause the list entries of the buffers
to be cleared while they still hang around on the main and irc queues

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/video/uvc/uvc_queue.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 4a925a3..ad87703 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -165,6 +165,8 @@ int uvc_free_buffers(struct uvc_video_queue *queue)
 	}
 
 	if (queue->count) {
+		uvc_queue_cancel(queue, 0);
+		INIT_LIST_HEAD(&queue->mainqueue);
 		vfree(queue->mem);
 		queue->count = 0;
 	}
-- 
1.7.9.6

