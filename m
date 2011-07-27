Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1G0V5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:57:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:48866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab1G0VtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258384"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: sjoerd.simons@collabora.co.uk, laurent.pinchart@ideasonboard.com,
        mchehab@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [74/99] uvcvideo: Remove buffers from the queues when freeing
Message-Id: <20110727214913.9EA3D2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/uvc/uvc_queue.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/media/video/uvc/uvc_queue.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/uvc/uvc_queue.c
+++ linux-2.6.35.y/drivers/media/video/uvc/uvc_queue.c
@@ -165,6 +165,8 @@ int uvc_free_buffers(struct uvc_video_qu
 	}
 
 	if (queue->count) {
+		uvc_queue_cancel(queue, 0);
+		INIT_LIST_HEAD(&queue->mainqueue);
 		vfree(queue->mem);
 		queue->count = 0;
 	}
