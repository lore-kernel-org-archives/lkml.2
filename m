Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873Ab0CSEHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 00:07:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58270 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0CSEHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 00:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:cc:in-reply-to;
        b=wAdkH92QkNUJECjhPleuYx61066zaUT7uN+/eTEj+hbtcIQr4Eyysv3e2mvDAOWJNj
         Uzn6CtJZ2h2hc1JaSYWasnITElWrP611vCdz/iTfnRA8JXYywtdLcme61+gaxbQ2NwEk
         ZW2okQRkM92GZTqOM6FvqPZRIY4YDPiqrGjlI=
Message-ID: <4ba2f862.4902be0a.0815.0d09@mx.google.com>
Date: Thu, 18 Mar 2010 21:06:58 -0700 (PDT)
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Clemens Ladisch <clemens@ladisch.de>
Cc: "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>,
       "Vojtech Pavlik" <vojtech@suse.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100318121151.cedeb849.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Please always retain and maintain the changelog with each version of a patch.
>
> Please resend this patch with a complete changelog.

OK, here's my description from the original posting:
<<
The current implementation of the /dev/hpet driver couples opening the
device with allocating one of the (scarce) timers (aka comparators).
This is a limitation in that the main counter may be valuable to
applications seeking a high-resolution timer who have no use for the
interrupt generating functionality of the comparators.

This patch alters the open semantics so that when the device is
opened, no timer is allocated. Operations that depend on a timer being
in context implicitly attempt allocating a timer, to maintain backward
compatibility. There is also an IOCTL (HPET_ALLOC_TIMER _IO) added so
that the allocation may be done explicitly. (I prefer the explicit
open then allocate pattern but don't know how practical it would be to
require all existing code to be changed.)
>>

The difference between the first and second version of my patch is that
the first altered the semantics of the HPET_INFO IOCTL so that it didn't
force allocation of a timer, which would not be strictly backwards compatible;
the second version keeps it so a device open followed by HPET_INFO call will
have allocated a timer (or attempted to and given an error).

Signed-off-by: Magnus Lynch <maglyx@gmail.com>

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e481c59..97f8d5b 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -244,16 +244,40 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 
 static int hpet_open(struct inode *inode, struct file *file)
 {
-	struct hpet_dev *devp;
 	struct hpets *hpetp;
-	int i;
 
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
+	hpetp = hpets;
+	/* starting with timer-neutral instance */
+	file->private_data = &hpetp->hp_dev[hpetp->hp_ntimer];
+
+	return 0;
+}
+
+static int hpet_alloc_timer(struct file *file)
+{
+	struct hpet_dev *devp;
+	struct hpets *hpetp;
+	int i;
+
+	/* once acquired, will remain */
+	devp = file->private_data;
+	if (devp->hd_timer)
+		return 0;
+
 	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
+	/* check for race acquiring */
+	devp = file->private_data;
+	if (devp->hd_timer) {
+		spin_unlock_irq(&hpet_lock);
+		unlock_kernel();
+		return 0;
+	}
+
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
 			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
@@ -384,6 +408,10 @@ static int hpet_fasync(int fd, struct file *file, int on)
 {
 	struct hpet_dev *devp;
 
+	int r = hpet_alloc_timer(file);
+	if (r < 0)
+		return r;
+
 	devp = file->private_data;
 
 	if (fasync_helper(fd, file, on, &devp->hd_async_queue) >= 0)
@@ -401,6 +429,9 @@ static int hpet_release(struct inode *inode, struct file *file)
 	devp = file->private_data;
 	timer = devp->hd_timer;
 
+	if (!timer)
+		goto out;
+
 	spin_lock_irq(&hpet_lock);
 
 	writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
@@ -425,7 +456,7 @@ static int hpet_release(struct inode *inode, struct file *file)
 
 	if (irq)
 		free_irq(irq, devp);
-
+out:
 	file->private_data = NULL;
 	return 0;
 }
@@ -438,6 +469,10 @@ hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 {
 	struct hpet_dev *devp;
 
+	int r = hpet_alloc_timer(file);
+	if (r < 0)
+		return r;
+
 	devp = file->private_data;
 	return hpet_ioctl_common(devp, cmd, arg, 0);
 }
@@ -570,6 +605,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 		break;
 	case HPET_IE_ON:
 		return hpet_ioctl_ieon(devp);
+	case HPET_ALLOC_TIMER:
+		/* nothing to do */
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -794,7 +832,11 @@ int hpet_alloc(struct hpet_data *hdp)
 		return 0;
 	}
 
-	siz = sizeof(struct hpets) + ((hdp->hd_nirqs - 1) *
+	/*
+	 * last hpet_dev will have null timer pointer, gives timer-neutral
+	 * representation of block
+	 */
+	siz = sizeof(struct hpets) + ((hdp->hd_nirqs) *
 				      sizeof(struct hpet_dev));
 
 	hpetp = kzalloc(siz, GFP_KERNEL);
@@ -860,13 +902,16 @@ int hpet_alloc(struct hpet_data *hdp)
 		writeq(mcfg, &hpet->hpet_config);
 	}
 
-	for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer; i++, devp++) {
+	for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer + 1;
+	     i++, devp++) {
 		struct hpet_timer __iomem *timer;
 
-		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
-
 		devp->hd_hpets = hpetp;
 		devp->hd_hpet = hpet;
+		if (i == hpetp->hp_ntimer)
+			continue;
+
+		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
 		devp->hd_timer = timer;
 
 		/*
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 219ca4f..d690c0f 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -125,6 +125,7 @@ struct hpet_info {
 #define	HPET_EPI	_IO('h', 0x04)	/* enable periodic */
 #define	HPET_DPI	_IO('h', 0x05)	/* disable periodic */
 #define	HPET_IRQFREQ	_IOW('h', 0x6, unsigned long)	/* IRQFREQ usec */
+#define	HPET_ALLOC_TIMER _IO('h', 0x7)
 
 #define MAX_HPET_TBS	8		/* maximum hpet timer blocks */
 
