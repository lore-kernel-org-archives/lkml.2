Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1BMK71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 05:59:27 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:59524 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752640Ab1BMK7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 05:59:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:X-Identified-User;
	b=Jy8s6G8gAzFTnfng1bioXCWSvSwX1vZPWgEEna65KHUsySv0t7HdcuO3p/fszd9Y4o7RJ6jhTEmInTE/OYyNofHcwcXlCaCFK8+3C19BzyG+3va1RA7dG5LoVYHxXSBv;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] loop: clear read-only flag in loop_clr_fd.
Date: Sun, 13 Feb 2011 18:58:55 +0800
Message-Id: <1297594735-5593-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4D573BBB.6090200@redhat.com>
References: <4D573BBB.6090200@redhat.com>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.4.246 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 75f1dc0, we check bdev_read_only() from blkdev_get().
But the loop_clr_fd doesn't clear the read only flag.
What cause a error if we changing a loop device from
read only to writable.

A simple test to reproduce the error reported by Milan[1]:
touch /x1.img
losetup -r /dev/loop0 /x1.img
losetup -d /dev/loop0
losetup /dev/loop0 /x1.img
/dev/loop0: Permission denied

1: http://marc.info/?l=linux-kernel&m=129756258222642&w=2

Reported-by: Milan Broz <mbroz@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 drivers/block/loop.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 44e18c0..0d24579 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1036,8 +1036,10 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
-	if (bdev)
+	if (bdev) {
+		set_device_ro(bdev, 0);
 		invalidate_bdev(bdev);
+	}
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
 	if (bdev) {
-- 
1.6.3.GIT

