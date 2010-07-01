Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab0GASXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:30 -0400
Received: from kroah.org ([198.145.64.141]:40460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab0GASXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:22 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:11 2010
Message-Id: <20100701173211.784521472@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
Subject: [patch 059/149] md: set mddev readonly flag on blkdev BLKROSET ioctl
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit e2218350465e7e0931676b4849b594c978437bce upstream.

When the user sets the block device to readwrite then the mddev should
follow suit.  Otherwise, the BUG_ON in md_write_start() will be set to
trigger.

The reverse direction, setting mddev->ro to match a set readonly
request, can be ignored because the blkdev level readonly flag precludes
the need to have mddev->ro set correctly.  Nevermind the fact that
setting mddev->ro to 1 may fail if the array is in use.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5334,6 +5334,7 @@ static int md_ioctl(struct block_device
 	int err = 0;
 	void __user *argp = (void __user *)arg;
 	mddev_t *mddev = NULL;
+	int ro;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -5469,6 +5470,34 @@ static int md_ioctl(struct block_device
 			err = do_md_stop(mddev, 1, 1);
 			goto done_unlock;
 
+		case BLKROSET:
+			if (get_user(ro, (int __user *)(arg))) {
+				err = -EFAULT;
+				goto done_unlock;
+			}
+			err = -EINVAL;
+
+			/* if the bdev is going readonly the value of mddev->ro
+			 * does not matter, no writes are coming
+			 */
+			if (ro)
+				goto done_unlock;
+
+			/* are we are already prepared for writes? */
+			if (mddev->ro != 1)
+				goto done_unlock;
+
+			/* transitioning to readauto need only happen for
+			 * arrays that call md_write_start
+			 */
+			if (mddev->pers) {
+				err = restart_array(mddev);
+				if (err == 0) {
+					mddev->ro = 2;
+					set_disk_ro(mddev->gendisk, 0);
+				}
+			}
+			goto done_unlock;
 	}
 
 	/*


