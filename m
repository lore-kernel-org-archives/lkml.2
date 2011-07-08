Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1GHFDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab1GHFDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.793120352@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [062/107] [media] uvcvideo: Remove buffers from the queues when freeing
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -104,6 +104,8 @@ static int __uvc_free_buffers(struct uvc
 	}
 
 	if (queue->count) {
+		uvc_queue_cancel(queue, 0);
+		INIT_LIST_HEAD(&queue->mainqueue);
 		vfree(queue->mem);
 		queue->count = 0;
 	}


