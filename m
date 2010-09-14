Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0INXip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:38:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61967 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0INXio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=UhkD5etZ3ipRG7a+2wMovdXuF74FqYKBYk1xOuOJZ62GqjmhHIZTBzWzqjQoFeS6g8
         C62I6WBeo63P4JmkUHtybm7XFFCiHzOBW3W+jSBOGE+JyLm+3tT14RAYZbAz/za7K4Xk
         tgFtebct/qDG9T0+BZwgqM2OpjdJXR4MndWAU=
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
References: <1284284969.2928.18.camel@maxim-laptop>
	 <1284427621.4127.7.camel@maxim-laptop> <4C8F2699.3020509@kernel.org>
	 <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-Z9lFydlI+7zWY9UTcKdy"
Date: Wed, 15 Sep 2010 01:38:35 +0200
Message-ID: <1284507516.4963.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z9lFydlI+7zWY9UTcKdy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2010-09-14 at 10:07 +0200, Kay Sievers wrote: 
> On Tue, Sep 14, 2010 at 09:39, Tejun Heo <tj@kernel.org> wrote:
> > On 09/14/2010 03:27 AM, Maxim Levitsky wrote:
> >>> However 2.6.36 doesn't detect that removal.
> >>> According to udevadm monitor --property no uevents are send on removal.
> >> Correction, this is regression between 2.6.34 and 2.6.35. This shows how
> >> much I use cd these days...
> >>
> >> I bisected it down to this:
> >>
> >> 6b4517a7913a09d3259bb1d21c9cb300f12294bd is the first bad commit
> >> commit 6b4517a7913a09d3259bb1d21c9cb300f12294bd
> >> Author: Tejun Heo <tj@kernel.org>
> >> Date:   Wed Apr 7 18:53:59 2010 +0900
> >>
> >>     block: implement bd_claiming and claiming block
> >
> > Hmmm... weird.  This commit does change the open behavior but
> > shouldn't change the end result.  Can someone please enlighten me how
> > udevadm is interacting with the device at system call level?
> 
> Not at all. Udev does not really touch it.
> 
> The cdrom drive isn't unlocked on usual systems, udisks polls the
> cdrom drive periodically just like HAL did. The only difference is
> that with the polling, the sr driver detects a media change and sends
> a uevent to udev, instead of HAL looking at the result of the open().
> 
> Are we sure, that there is something that still polls the drive?
> Udisks is only auto-started, when the desktop calls into some D-Bus
> methods, unlike HAL where it was an init script.


Note that on current vanilla head, I applied the attached manual revert
patch, and problem disappears (and probably introduces the same bug that
patch supposed to fix).


Best regards,
Maxim Levitsky

--=-Z9lFydlI+7zWY9UTcKdy
Content-Disposition: attachment; filename="test.patch"
Content-Type: text/x-patch; name="test.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

commit 6256435b81d05c98be64fbeea57776520961a10c
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Tue Sep 14 23:47:14 2010 +0200

    block_dev: revert cdrom breakage

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 50e8c85..f1095f3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -839,14 +839,15 @@ static void bd_finish_claiming(struct block_device *bdev,
 int bd_claim(struct block_device *bdev, void *holder)
 {
 	struct block_device *whole = bdev->bd_contains;
-	int res;
+	int res = -EBUSY;
 
 	might_sleep();
 
 	spin_lock(&bdev_lock);
-	res = bd_prepare_to_claim(bdev, whole, holder);
-	if (res == 0)
+	if (bd_may_claim(bdev, whole, holder)) {
+		res = 0;
 		__bd_claim(bdev, whole, holder);
+	}
 	spin_unlock(&bdev_lock);
 
 	return res;
@@ -1462,7 +1463,6 @@ EXPORT_SYMBOL(blkdev_get);
 
 static int blkdev_open(struct inode * inode, struct file * filp)
 {
-	struct block_device *whole = NULL;
 	struct block_device *bdev;
 	int res;
 
@@ -1485,24 +1485,24 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	if (bdev == NULL)
 		return -ENOMEM;
 
+	filp->f_mapping = bdev->bd_inode->i_mapping;
+
+	res = blkdev_get(bdev, filp->f_mode);
+	if (res)
+	        return res;
+ 
 	if (filp->f_mode & FMODE_EXCL) {
-		whole = bd_start_claiming(bdev, filp);
-		if (IS_ERR(whole)) {
-			bdput(bdev);
-			return PTR_ERR(whole);
-		}
+	        res = bd_claim(bdev, filp);
+	        if (res)
+	                goto out_blkdev_put;
 	}
 
-	filp->f_mapping = bdev->bd_inode->i_mapping;
+	return 0;
 
-	res = blkdev_get(bdev, filp->f_mode);
+ out_blkdev_put:
+	blkdev_put(bdev, filp->f_mode);
+        return res;
 
-	if (whole) {
-		if (res == 0)
-			bd_finish_claiming(bdev, whole, filp);
-		else
-			bd_abort_claiming(whole, filp);
-	}
 
 	return res;
 }
@@ -1712,34 +1712,30 @@ EXPORT_SYMBOL(lookup_bdev);
  */
 struct block_device *open_bdev_exclusive(const char *path, fmode_t mode, void *holder)
 {
-	struct block_device *bdev, *whole;
-	int error;
+	struct block_device *bdev;
+	int error = 0;
 
 	bdev = lookup_bdev(path);
 	if (IS_ERR(bdev))
 		return bdev;
 
-	whole = bd_start_claiming(bdev, holder);
-	if (IS_ERR(whole)) {
-		bdput(bdev);
-		return whole;
-	}
-
 	error = blkdev_get(bdev, mode);
 	if (error)
-		goto out_abort_claiming;
+		return ERR_PTR(error);
 
 	error = -EACCES;
 	if ((mode & FMODE_WRITE) && bdev_read_only(bdev))
 		goto out_blkdev_put;
+	error = bd_claim(bdev, holder);
+	if (error)
+		goto blkdev_put;
+
 
 	bd_finish_claiming(bdev, whole, holder);
 	return bdev;
 
 out_blkdev_put:
 	blkdev_put(bdev, mode);
-out_abort_claiming:
-	bd_abort_claiming(whole, holder);
 	return ERR_PTR(error);
 }
 

--=-Z9lFydlI+7zWY9UTcKdy--

