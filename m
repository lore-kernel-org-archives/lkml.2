Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2D3LW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:22:57 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:49331 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2D3LW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:22:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Bob Liu <lliubbo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.3-rc1] media updates
Date: Mon, 30 Apr 2012 13:23:17 +0200
Message-ID: <24289717.tQzdZ5Ax07@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.1; x86_64; ; )
In-Reply-To: <CAMuHMdV+ub7t_O5mu1vWrZFZOhZ7NYZfnoBWPyfK2bYQUT4yPw@mail.gmail.com>
References: <4F12D7A0.7030804@redhat.com> <CAMuHMdV+ub7t_O5mu1vWrZFZOhZ7NYZfnoBWPyfK2bYQUT4yPw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wednesday 25 April 2012 17:12:49 Geert Uytterhoeven wrote:
> On Sun, Jan 15, 2012 at 14:41, Mauro Carvalho Chehab wrote:
> > Laurent Pinchart (18):
> >      [media] uvcvideo: Move fields from uvc_buffer::buf to uvc_buffer
> >      [media] uvcvideo: Use videobuf2-vmalloc
> 
> It seems these change (3d95e932573c316ad56b8e2f283e26de0b9c891c
> resp. 6998b6fb4b1c8f320adeee938d399c4d8dcc90e2) broke the
> build for nommu a while ago, as uvc_queue_get_unmapped_area() was not
> or was incorrectly updated:
> 
> drivers/media/video/uvc/uvc_queue.c:254:23: error: 'struct
> uvc_video_queue' has no member named 'count'
> drivers/media/video/uvc/uvc_queue.c:255:18: error: 'struct
> uvc_video_queue' has no member named 'buffer'
> drivers/media/video/uvc/uvc_queue.c:256:19: error: 'struct vb2_buffer'
> has no member named 'm'
> drivers/media/video/uvc/uvc_queue.c:259:16: error: 'struct
> uvc_video_queue' has no member named 'count'
> drivers/media/video/uvc/uvc_queue.c:263:23: error: 'buf' undeclared
> (first use in this function)
> 
> Cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/6171077/

My bad, and thanks for the report. The following patch should fix this. Do you
have a NOMMU system to test it on ?

>From bbd5c24f340abeeecddd3e84c0da76408fc3f964 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Mon, 30 Apr 2012 13:19:10 +0200
Subject: [PATCH] uvcvideo: Use videobuf2 .get_unmapped_area() implementation

The get_unmapped_area() operation was forgotten during conversion to
videobuf2. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_queue.c |   43 ++++++++++------------------------
 1 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 8f54e24..9288fbd 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -207,6 +207,19 @@ int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 	return ret;
 }
 
+#ifndef CONFIG_MMU
+unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
+		unsigned long pgoff)
+{
+	unsigned long ret;
+
+	mutex_lock(&queue->mutex);
+	ret = vb2_get_unmapped_area(&queue->queue, 0, 0, pgoff, 0);
+	mutex_unlock(&queue->mutex);
+	return ret;
+}
+#endif
+
 unsigned int uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
 			    poll_table *wait)
 {
@@ -237,36 +250,6 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
 	return allocated;
 }
 
-#ifndef CONFIG_MMU
-/*
- * Get unmapped area.
- *
- * NO-MMU arch need this function to make mmap() work correctly.
- */
-unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
-		unsigned long pgoff)
-{
-	struct uvc_buffer *buffer;
-	unsigned int i;
-	unsigned long ret;
-
-	mutex_lock(&queue->mutex);
-	for (i = 0; i < queue->count; ++i) {
-		buffer = &queue->buffer[i];
-		if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
-			break;
-	}
-	if (i == queue->count) {
-		ret = -EINVAL;
-		goto done;
-	}
-	ret = (unsigned long)buf->mem;
-done:
-	mutex_unlock(&queue->mutex);
-	return ret;
-}
-#endif
-
 /*
  * Enable or disable the video buffers queue.
  *
-- 
Regards,

Laurent Pinchart

