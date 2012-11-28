Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2K1Qxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:53:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2K1QoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:03 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 03/25] gadget: remove only user of aio retry
Date: Wed, 28 Nov 2012 08:43:27 -0800
Message-Id: <1354121029-1376-4-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@redhat.com>

This removes the only in-tree user of aio retry.  This will let us
remove the retry code from the aio core.

Removing retry is relatively easy as the USB gadget wasn't using it to
retry IOs at all.  It always fully submitted the IO in the context of
the initial io_submit() call.  It only used the AIO retry facility to
get the submitter's mm context for copying the result of a read back to
user space.  This is easy to implement with use_mm() and a work struct,
much like kvm does with async_pf_execute() for get_user_pages().

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/usb/gadget/inode.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 76494ca..2a3f001 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
+#include <linux/mmu_context.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
@@ -514,6 +515,9 @@ static long ep_ioctl(struct file *fd, unsigned code, unsigned long value)
 struct kiocb_priv {
 	struct usb_request	*req;
 	struct ep_data		*epdata;
+	struct kiocb 		*iocb;
+	struct mm_struct 	*mm;
+	struct work_struct	work;
 	void			*buf;
 	const struct iovec	*iv;
 	unsigned long		nr_segs;
@@ -541,15 +545,12 @@ static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
 	return value;
 }
 
-static ssize_t ep_aio_read_retry(struct kiocb *iocb)
+static ssize_t ep_copy_to_user(struct kiocb_priv *priv)
 {
-	struct kiocb_priv	*priv = iocb->private;
 	ssize_t			len, total;
 	void			*to_copy;
 	int			i;
 
-	/* we "retry" to get the right mm context for this: */
-
 	/* copy stuff into user buffers */
 	total = priv->actual;
 	len = 0;
@@ -569,9 +570,26 @@ static ssize_t ep_aio_read_retry(struct kiocb *iocb)
 		if (total == 0)
 			break;
 	}
+
+	return len;
+}
+
+static void ep_user_copy_worker(struct work_struct *work)
+{
+	struct kiocb_priv *priv = container_of(work, struct kiocb_priv, work);
+	struct mm_struct *mm = priv->mm;
+	struct kiocb *iocb = priv->iocb;
+	size_t ret;
+
+	use_mm(mm);
+	ret = ep_copy_to_user(priv);
+	unuse_mm(mm);
+
+	/* completing the iocb can drop the ctx and mm, don't touch mm after */
+	aio_complete(iocb, ret, ret);
+
 	kfree(priv->buf);
 	kfree(priv);
-	return len;
 }
 
 static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
@@ -597,14 +615,14 @@ static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
 		aio_complete(iocb, req->actual ? req->actual : req->status,
 				req->status);
 	} else {
-		/* retry() won't report both; so we hide some faults */
+		/* ep_copy_to_user() won't report both; we hide some faults */
 		if (unlikely(0 != req->status))
 			DBG(epdata->dev, "%s fault %d len %d\n",
 				ep->name, req->status, req->actual);
 
 		priv->buf = req->buf;
 		priv->actual = req->actual;
-		kick_iocb(iocb);
+		schedule_work(&priv->work);
 	}
 	spin_unlock(&epdata->dev->lock);
 
@@ -634,8 +652,10 @@ fail:
 		return value;
 	}
 	iocb->private = priv;
+	priv->iocb = iocb;
 	priv->iv = iv;
 	priv->nr_segs = nr_segs;
+	INIT_WORK(&priv->work, ep_user_copy_worker);
 
 	value = get_ready_ep(iocb->ki_filp->f_flags, epdata);
 	if (unlikely(value < 0)) {
@@ -647,6 +667,7 @@ fail:
 	get_ep(epdata);
 	priv->epdata = epdata;
 	priv->actual = 0;
+	priv->mm = current->mm; /* mm teardown waits for iocbs in exit_aio() */
 
 	/* each kiocb is coupled to one usb_request, but we can't
 	 * allocate or submit those if the host disconnected.
@@ -675,7 +696,7 @@ fail:
 		kfree(priv);
 		put_ep(epdata);
 	} else
-		value = (iv ? -EIOCBRETRY : -EIOCBQUEUED);
+		value = -EIOCBQUEUED;
 	return value;
 }
 
@@ -693,7 +714,6 @@ ep_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	iocb->ki_retry = ep_aio_read_retry;
 	return ep_aio_rwtail(iocb, buf, iocb->ki_left, epdata, iov, nr_segs);
 }
 
-- 
1.7.12

