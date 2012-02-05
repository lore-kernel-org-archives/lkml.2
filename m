Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2BEWnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:43:41 -0500
Received: from 1wt.eu ([62.212.114.60]:61898 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2BEW0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:23 -0500
Message-Id: <20120205220950.600107885@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 27/91] uvcvideo: Remove buffers from the queues when freeing
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/media/video/uvc/uvc_queue.c
===================================================================
--- longterm-2.6.27.orig/drivers/media/video/uvc/uvc_queue.c	2012-02-05 22:34:34.215915503 +0100
+++ longterm-2.6.27/drivers/media/video/uvc/uvc_queue.c	2012-02-05 22:34:38.711914474 +0100
@@ -165,6 +165,8 @@
 	}
 
 	if (queue->count) {
+		uvc_queue_cancel(queue, 0);
+		INIT_LIST_HEAD(&queue->mainqueue);
 		vfree(queue->mem);
 		queue->count = 0;
 	}


