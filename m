Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2AWXpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:45:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2AWXpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:45:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:42:03 2012
Message-Id: <20120123234202.949515136@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:41:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [15/27] [media] V4L/DVB: v4l2-ioctl: integer overflow in video_usercopy()
In-Reply-To: <20120123234224.GA19510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6c06108be53ca5e94d8b0e93883d534dd9079646 upstream.

If ctrls->count is too high the multiplication could overflow and
array_size would be lower than expected.  Mauro and Hans Verkuil
suggested that we cap it at 1024.  That comes from the maximum
number of controls with lots of room for expantion.

$ grep V4L2_CID include/linux/videodev2.h | wc -l
211

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/v4l2-ioctl.c |    6 ++++++
 include/linux/videodev2.h        |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -414,6 +414,9 @@ video_usercopy(struct file *file, unsign
 		p->error_idx = p->count;
 		user_ptr = (void __user *)p->controls;
 		if (p->count) {
+			err = -EINVAL;
+			if (p->count > V4L2_CID_MAX_CTRLS)
+				goto out_ext_ctrl;
 			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
 			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
 			mbuf = kmalloc(ctrls_size, GFP_KERNEL);
@@ -1912,6 +1915,9 @@ long video_ioctl2(struct file *file,
 		p->error_idx = p->count;
 		user_ptr = (void __user *)p->controls;
 		if (p->count) {
+			err = -EINVAL;
+			if (p->count > V4L2_CID_MAX_CTRLS)
+				goto out_ext_ctrl;
 			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
 			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
 			mbuf = kmalloc(ctrls_size, GFP_KERNEL);
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -858,6 +858,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
 
 /*  User-class control IDs defined by V4L2 */
+#define V4L2_CID_MAX_CTRLS		1024
 #define V4L2_CID_BASE			(V4L2_CTRL_CLASS_USER | 0x900)
 #define V4L2_CID_USER_BASE 		V4L2_CID_BASE
 /*  IDs reserved for driver specific controls */


