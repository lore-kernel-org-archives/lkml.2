Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2IMAHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:07:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2ILXjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Jayakrishnan Memana <jayakrishnan.memana@maxim-ic.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 50/85] [media] uvcvideo: Reset the bytesused field when recycling an erroneous buffer
Date: Wed, 12 Sep 2012 16:36:33 -0700
Message-Id: <20120912233546.981440284@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayakrishnan Memana <jayakrishnan.memana@maxim-ic.com>

commit 8a3f0ede2b3f5477122060af1a816c6bbf09fcd2 upstream.

Buffers marked as erroneous are recycled immediately by the driver if
the nodrop module parameter isn't set. The buffer payload size is reset
to 0, but the buffer bytesused field isn't. This results in the buffer
being immediately considered as complete, leading to an infinite loop in
interrupt context.

Fix the problem by resetting the bytesused field when recycling the
buffer.

Signed-off-by: Jayakrishnan Memana <jayakrishnan.memana@maxim-ic.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/uvc/uvc_queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -355,6 +355,7 @@ struct uvc_buffer *uvc_queue_next_buffer
 	if ((queue->flags & UVC_QUEUE_DROP_CORRUPTED) && buf->error) {
 		buf->error = 0;
 		buf->state = UVC_BUF_STATE_QUEUED;
+		buf->bytesused = 0;
 		vb2_set_plane_payload(&buf->buf, 0, 0);
 		return buf;
 	}


