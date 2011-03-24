Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab1CXPVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:21:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47401 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070Ab1CXPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:21:34 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, vapier@gentoo.org, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCHv2 3/4] drivers/otp: allow an ioctl to be specified
Date: Thu, 24 Mar 2011 15:21:10 +0000
Message-Id: <1300980071-24645-4-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers may need an ioctl method to provide device specific control
such as blackfin for providing locking.  Regions can specify an ioctl to
be used but this field method is optional.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/otp/otp.c   |   30 ++++++++++++++++++++++++------
 include/linux/otp.h |    3 +++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/otp/otp.c b/drivers/otp/otp.c
index dd47cf1..d362d09 100644
--- a/drivers/otp/otp.c
+++ b/drivers/otp/otp.c
@@ -30,14 +30,16 @@ static ssize_t otp_write(struct file *filp, const char __user *buf,
 static ssize_t otp_read(struct file *filp, char __user *buf, size_t len,
 			loff_t *offs);
 static loff_t otp_llseek(struct file *filp, loff_t offs, int origin);
+static long otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg);
 
 static const struct file_operations otp_fops = {
-	.owner	    = THIS_MODULE,
-	.open	    = otp_open,
-	.release    = otp_release,
-	.write	    = otp_write,
-	.read	    = otp_read,
-	.llseek	    = otp_llseek,
+	.owner		= THIS_MODULE,
+	.open		= otp_open,
+	.release	= otp_release,
+	.write		= otp_write,
+	.read		= otp_read,
+	.llseek		= otp_llseek,
+	.unlocked_ioctl	= otp_ioctl,
 };
 
 static DEFINE_SEMAPHORE(otp_sem);
@@ -691,6 +693,22 @@ out:
 	return ret ?: written;
 }
 
+static long otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
+{
+	struct otp_region *region = filp->private_data;
+	long ret = -ENOTTY;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	if (region->ops->ioctl)
+		ret = region->ops->ioctl(region, cmd, arg);
+
+	up(&otp_sem);
+
+	return ret;
+}
+
 /*
  * Read an OTP region. This switches the OTP into the appropriate redundancy
  * format so we can simply read from the beginning of the region and copy it
diff --git a/include/linux/otp.h b/include/linux/otp.h
index 93ccf8b..ce77f05 100644
--- a/include/linux/otp.h
+++ b/include/linux/otp.h
@@ -100,6 +100,7 @@ struct otp_device {
  * @get_size:		Get the effective storage size of the region.
  *			Depending on the number of regions in the device and
  *			the redundancy format of the region, this may vary.
+ * @ioctl:		Optional region ioctl.
  */
 struct otp_region_ops {
 	int			(*set_fmt)(struct otp_region *region,
@@ -112,6 +113,8 @@ struct otp_region_ops {
 					     unsigned long word_addr,
 					     u64 *value);
 	ssize_t			(*get_size)(struct otp_region *region);
+	long			(*ioctl)(struct otp_region *dev,
+					 unsigned cmd, unsigned long arg);
 };
 
 /**
-- 
1.7.4

