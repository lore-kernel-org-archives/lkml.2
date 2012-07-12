Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162355Ab2GLWv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:51:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162283Ab2GLWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Ospite <ospite@studenti.unina.it>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 165/187] gspca-core: Fix buffers staying in queued state after a stream_off
Date: Thu, 12 Jul 2012 15:35:21 -0700
Message-Id: <20120712191538.630827881@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hans de Goede <hdegoede@redhat.com>

commit af05ef01e9cde84620c6855a8d8ab9c8a1db9009 upstream.

[Backport to linux-stable by Antonio Ospite <ospite@studenti.unina.it>]

This fixes a regression introduced by commit f7059ea and should be
backported to all supported stable kernels which have this commit.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/gspca/gspca.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1723,7 +1723,7 @@ static int vidioc_streamoff(struct file
 				enum v4l2_buf_type buf_type)
 {
 	struct gspca_dev *gspca_dev = priv;
-	int ret;
+	int i, ret;
 
 	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1754,6 +1754,8 @@ static int vidioc_streamoff(struct file
 	wake_up_interruptible(&gspca_dev->wq);
 
 	/* empty the transfer queues */
+	for (i = 0; i < gspca_dev->nframes; i++)
+		gspca_dev->frame[i].v4l2_buf.flags &= ~BUF_ALL_FLAGS;
 	atomic_set(&gspca_dev->fr_q, 0);
 	atomic_set(&gspca_dev->fr_i, 0);
 	gspca_dev->fr_o = 0;


