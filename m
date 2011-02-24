Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1BXI4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:56:39 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40547 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1BXI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=d5JRP7m6TDPYDDb+7BzH+1IZvLjMHVY92V+bx/x1s1wy71GT2CThyXqXUKPEQmP6ks
         LW/YUtO2505JSeyRcpNJxKeOavBcXs6En/ne0kg97o54TMz+vziQ3uC/xFEBwdJfYgll
         wts2e/ASLBgVo6ugXqhm2g8Z06lRxX3KU1UnY=
Date: Thu, 24 Feb 2011 09:56:32 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        "Hawrylewicz Czarnowski, Przemyslaw" 
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2.6.38-rc6] block: bd_link_disk_holder() should hold on to
 holder_dir
Message-ID: <20110224085632.GC7840@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new implementation of bd_link_disk_holder() added by 49731baa41d
(block: restore multiple bd_link_disk_holder() support) didn't get an
extra reference for the holder_dir kobject of the slave bdev; however,
bdev kills holder_dir on removal, not release, so if the slave bdev is
removed while there are holder links, the holder_dir will be destroyed
while there still are holder links, which leads to oops later when
bd_unlink_disk_order() tries to remove those links.

Make bd_link_disk_holder() grab an extra reference for the slave's
holder_dir and put it in bd_unlink_disk_holder().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Tested-by: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
Jens, Linus, it's pretty late in the release cycle and I'm not sure
Jens is back yet so I'm writing to you both.  It's an isolated and
relatively safe fix.  I think how it gets routed doesn't matter too
much.

Thank you.

 fs/block_dev.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4fb8a34..94d41db 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -873,6 +873,11 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	ret = add_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
 	if (ret)
 		goto out_del;
+	/*
+	 * bdev could be deleted beneath us which would implicitly destroy
+	 * the holder directory.  Hold on to it.
+	 */
+	kobject_get(bdev->bd_part->holder_dir);
 
 	list_add(&holder->list, &bdev->bd_holder_disks);
 	goto out_unlock;
@@ -909,6 +914,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 		del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
 		del_symlink(bdev->bd_part->holder_dir,
 			    &disk_to_dev(disk)->kobj);
+		kobject_put(bdev->bd_part->holder_dir);
 		list_del_init(&holder->list);
 		kfree(holder);
 	}
