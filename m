Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1AVOXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:23:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1AVOXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:23:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LbX0a6bKEYH5bfQkbrdto6nZlFqEtwSHuSvMP4s5nHWz88kgrOHxZh1oOO4i2EdABU
         FAsOJ9Jq+q78rZI2I1+JsZ7fCBMyscQtg5Z9bs4PcrbVZZCXu0jq6B7dampsoGCHHGQT
         05cEuumEi8U6jw34wJrMWJhBn2/iNbiwltlU4=
Date: Sat, 22 Jan 2011 15:23:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/2] block: clear ro on fd detach fd is bound
Message-ID: <20110122142303.GD6160@htj.dyndns.org>
References: <23846.1295615979@jrobl>
 <20110122142234.GC6160@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110122142234.GC6160@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75f1dc0d (block: check bdev_read_only() from blkdev_get())
enforced bdev_read_only() check during blkdev_get().  This had an
unfortunate side effect on loop because loop didn't clear ro flag on
fd detach, so once a loop device was used ro, it can't be used for rw
at all.

Fix it by clearing ro flag on fd detach.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "J. R. Okajima" <hooanon05@yahoo.co.jp>
---
 drivers/block/loop.c |    1 +
 1 file changed, 1 insertion(+)

Index: work/drivers/block/loop.c
===================================================================
--- work.orig/drivers/block/loop.c
+++ work/drivers/block/loop.c
@@ -1041,6 +1041,7 @@ static int loop_clr_fd(struct loop_devic
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
 	bd_set_size(bdev, 0);
+	set_device_ro(bdev, 0);
 	/* let user-space know about this change */
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
