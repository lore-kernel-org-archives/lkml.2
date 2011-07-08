Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1GIGA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:00:57 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52964 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527Ab1GIGAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:00:51 -0400
X-Sasl-enc: PP1HXjSdqbCHQQxNQ6p1Ecdn1+VNOzNHSAthv7MV5and 1310191250
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:10 2011
Message-Id: <20110708230110.615647636@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [11/35] [media] uvcvideo: Remove buffers from the queues when freeing
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_queue.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -165,6 +165,8 @@ int uvc_free_buffers(struct uvc_video_qu
 	}
 
 	if (queue->count) {
+		uvc_queue_cancel(queue, 0);
+		INIT_LIST_HEAD(&queue->mainqueue);
 		vfree(queue->mem);
 		queue->count = 0;
 	}


