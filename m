Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab0HKX7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:07 -0400
Received: from kroah.org ([198.145.64.141]:43494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009Ab0HKX6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:49 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.128562677@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [072/111] Btrfs: check return value of open_bdev_exclusive properly
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit 7f59203abeaf18bf3497b308891f95a4489810ad upstream.

Hit this problem while testing RAID1 failure stuff.  open_bdev_exclusive
returns ERR_PTR(), not NULL.  So change the return value properly.  This
is important if you accidently specify a device that doesn't exist when
trying to add a new device to an array, you will panic the box
dereferencing bdev.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1434,8 +1434,8 @@ int btrfs_init_new_device(struct btrfs_r
 		return -EINVAL;
 
 	bdev = open_bdev_exclusive(device_path, 0, root->fs_info->bdev_holder);
-	if (!bdev)
-		return -EIO;
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 
 	if (root->fs_info->fs_devices->seeding) {
 		seeding_dev = 1;


