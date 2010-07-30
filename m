Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0G3LHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:07:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56143 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab0G3LHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rcgUaBUEN8hvvvd8CSFmyeKnX/xzBpPnFTko+SRN5pspgD0XoMmKysWvHLgquSdqDb
         CpO/5MOA53nShQZNdNQNXAv10iAWBT15WCGxY45vAABE11vzAeUmWA2CRgVBQTBOjSnD
         j3UWd75mKdSUrP9rNJ8nV6Bih0cN32t5ZgcXA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Simon Horman <horms@verge.net.au>, Joe Eloff <kagen101@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] staging: dt3155: check put_user() return value
Date: Fri, 30 Jul 2010 15:07:09 +0400
Message-Id: <1280488030-20697-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() may fail, if so return -EFAULT.
Also compare count with copied data size, not size of struct with these
fields.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |  121 ++++++++++++++++------------------
 1 files changed, 57 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index fed7e62..cfe4fae 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -737,77 +737,70 @@ static int dt3155_close(struct inode *inode, struct file *filep)
 static ssize_t dt3155_read(struct file *filep, char __user *buf,
 			   size_t count, loff_t *ppos)
 {
-  /* which device are we reading from? */
-  int		minor = MINOR(filep->f_dentry->d_inode->i_rdev);
-  u32		offset;
-  int		frame_index;
-  struct dt3155_status *dts = &dt3155_status[minor];
-  struct dt3155_fbuffer *fb = &dts->fbuffer;
-  struct frame_info	*frame_info;
-
-  /* TODO: this should check the error flag and */
-  /*   return an error on hardware failures */
-  if (count != sizeof(struct dt3155_read))
-    {
-      printk("DT3155 ERROR (NJC): count is not right\n");
-      return -EINVAL;
-    }
-
-
-  /* Hack here -- I'm going to allow reading even when idle.
-   * this is so that the frames can be read after STOP has
-   * been called.  Leaving it here, commented out, as a reminder
-   * for a short while to make sure there are no problems.
-   * Note that if the driver is not opened in non_blocking mode,
-   * and the device is idle, then it could sit here forever! */
+	/* which device are we reading from? */
+	int minor = MINOR(filep->f_dentry->d_inode->i_rdev);
+	u32 offset;
+	int frame_index;
+	struct dt3155_status *dts = &dt3155_status[minor];
+	struct dt3155_fbuffer *fb = &dts->fbuffer;
+	struct frame_info *frame_info;
+	u32 *buffer = (u32 *)buf;
+
+	/* TODO: this should check the error flag and */
+	/*   return an error on hardware failures */
+	if (count != 4*3 + sizeof(struct frame_info)) {
+		pr_err("DT3155 ERROR (NJC): count is not right\n");
+		return -EINVAL;
+	}
 
-  /*  if (dts->state == DT3155_STATE_IDLE)*/
-  /*    return -EBUSY;*/
 
-  /* non-blocking reads should return if no data */
-  if (filep->f_flags & O_NDELAY)
-    {
-      if ((frame_index = dt3155_get_ready_buffer(minor)) < 0) {
-	/*printk("dt3155:  no buffers available (?)\n");*/
-	/* 		printques(minor); */
-	return -EAGAIN;
-      }
-    }
-  else
-    {
-      /*
-       * sleep till data arrives , or we get interrupted.
-       * Note that wait_event_interruptible() does not actually
-       * sleep/wait if it's condition evaluates to true upon entry.
-       */
-      wait_event_interruptible(dt3155_read_wait_queue[minor],
-			       (frame_index = dt3155_get_ready_buffer(minor))
-			       >= 0);
-
-      if (frame_index < 0)
-	{
-	  printk ("DT3155: read: interrupted\n");
-	  quick_stop (minor);
-	  printques(minor);
-	  return -EINTR;
+	/* Hack here -- I'm going to allow reading even when idle.
+	* this is so that the frames can be read after STOP has
+	* been called.  Leaving it here, commented out, as a reminder
+	* for a short while to make sure there are no problems.
+	* Note that if the driver is not opened in non_blocking mode,
+	* and the device is idle, then it could sit here forever! */
+
+	/*  if (dts->state == DT3155_STATE_IDLE)*/
+	/*    return -EBUSY;*/
+
+	/* non-blocking reads should return if no data */
+	if (filep->f_flags & O_NDELAY) {
+		frame_index = dt3155_get_ready_buffer(minor);
+		if (frame_index < 0)
+			/*printk("dt3155:  no buffers available (?)\n");*/
+			/* printques(minor); */
+			return -EAGAIN;
+	} else {
+		/*
+		* sleep till data arrives , or we get interrupted.
+		* Note that wait_event_interruptible() does not actually
+		* sleep/wait if it's condition evaluates to true upon entry.
+		*/
+		wait_event_interruptible(dt3155_read_wait_queue[minor],
+				  (frame_index = dt3155_get_ready_buffer(minor))
+				  >= 0);
+
+		if (frame_index < 0) {
+			pr_info("DT3155: read: interrupted\n");
+			quick_stop(minor);
+			printques(minor);
+			return -EINTR;
+		}
 	}
-    }
 
-  frame_info = &fb->frame_info[frame_index];
+	frame_info = &fb->frame_info[frame_index];
 
-  /* make this an offset */
-  offset = frame_info->addr - dts->mem_addr;
+	/* make this an offset */
+	offset = frame_info->addr - dts->mem_addr;
 
-  put_user(offset, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(fb->frame_count, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(dts->state, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
-      return -EFAULT;
+	if (put_user(offset, buffer) ||
+	    put_user(fb->frame_count, buffer + 1) ||
+	    put_user(dts->state, buffer + 2) ||
+	    copy_to_user(buffer + 3, frame_info, sizeof(*frame_info)))
+		return -EFAULT;
 
-  return sizeof(struct dt3155_read);
+	return count;
 }
 
 static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
-- 
1.7.0.4

