Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0IYPC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 11:02:57 -0400
Received: from kroah.org ([198.145.64.141]:51779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0IYPC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 11:02:56 -0400
Date: Sat, 25 Sep 2010 08:02:01 -0700
From: Greg KH <greg@kroah.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [00/80] 2.6.35.6 stable review
Message-ID: <20100925150201.GA3964@kroah.com>
References: <20100924162706.GA7381@kroah.com> <201009241649.57150.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <201009241649.57150.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 24, 2010 at 04:49:57PM -0400, Gene Heskett wrote:
> On Friday, September 24, 2010, Greg KH wrote:
> >This is the start of the stable review cycle for the 2.6.35.6 release.
> >There are 80 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let us know.  If anyone is a maintainer of the proper subsystem, and
> >wants to add a Signed-off-by: line to the patch, please respond with it.
> >
> >Responses should be made by Sunday September 26, 17:00:00 UTC
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.6-rc1.gz
> 
> Hi Greg;  I just pulled this about an hour ago, built it from a make 
> oldconfig based on a flawlessly running 2.6.35.4.

Please cc: me on messages, I don't read lkml as well as I should these
days due to travel.

> 3 things I call regressions.
> 
> 1. On rebooting to it, and launching kmail, cpu went to 100% of whatever 
> core it skipped to on a 4 core amd phenom box with 4G of ram.  Normally, 
> kmail on a restart will check and rebuild its indices, taking maybe 4 or 5 
> minutes to do this up till now, during that time keyboard/mouse 
> interactivity lags a split second.  This time it was 44 minutes before I 
> got my machine back.  At times the keyboard went dead for minutes at a 
> time.  I even went to the kitchen and got fresh batteries for it, only to 
> have everything I had typed blind 2 minutes before, show up on screen while 
> there was no batteries in it.

Odd, can you try reverting the patch below to see if it makes things
better?  I need to drop it as Jens said it might cause problems.  Let me
know if that solves the problem or not please.

> 2. That I think is separate from the login screen, there I had no keyboard 
> or mouse for a minute, but something finally registered and I was able to 
> log in then.
> 
> 3. My usb tree is not fully populated, this has been a frequent problem for 
> the last year or so, udev often does not wait for responses long enough to 
> trace a several hubs tall tree to the last branch so I have to crawl under 
> and unplug the missing stuff later, which is then properly recognized when I 
> plug it back into the same socket on the same hub.  One of my often missing 
> printers is 4 hubs away in the basement.

These both sound like the same issue, you might want to work to resolve
them.

Oh, and 4 hubs distance, that's pushing the limits of USB, one flaky
cable and you are not going to have a working printer...

thanks,

greg k-h

--vtzGhvizbBRQ85DL
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="bdi-fix-warnings-in-__mark_inode_dirty-for-dev-zero-and-friends.patch"

>From 692ebd17c2905313fff3c504c249c6a0faad16ec Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 21 Sep 2010 11:51:01 +0200
Subject: bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends

From: Jan Kara <jack@suse.cz>

commit 692ebd17c2905313fff3c504c249c6a0faad16ec upstream.

Inodes of devices such as /dev/zero can get dirty for example via
utime(2) syscall or due to atime update. Backing device of such inodes
(zero_bdi, etc.) is however unable to handle dirty inodes and thus
__mark_inode_dirty complains.  In fact, inode should be rather dirtied
against backing device of the filesystem holding it. This is generally a
good rule except for filesystems such as 'bdev' or 'mtd_inodefs'. Inodes
in these pseudofilesystems are referenced from ordinary filesystem
inodes and carry mapping with real data of the device. Thus for these
inodes we have to use inode->i_mapping->backing_dev_info as we did so
far. We distinguish these filesystems by checking whether sb->s_bdi
points to a non-trivial backing device or not.

Example: Assume we have an ext3 filesystem on /dev/sda1 mounted on /.
There's a device inode A described by a path "/dev/sdb" on this
filesystem. This inode will be dirtied against backing device "8:0"
after this patch. bdev filesystem contains block device inode B coupled
with our inode A. When someone modifies a page of /dev/sdb, it's B that
gets dirtied and the dirtying happens against the backing device "8:16".
Thus both inodes get filed to a correct bdi list.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -28,8 +28,6 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
-#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
-
 /*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
@@ -62,6 +60,27 @@ int writeback_in_progress(struct backing
 	return !list_empty(&bdi->work_list);
 }
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+
+	/*
+	 * For inodes on standard filesystems, we use superblock's bdi. For
+	 * inodes on virtual filesystems, we want to use inode mapping's bdi
+	 * because they can possibly point to something useful (think about
+	 * block_dev filesystem).
+	 */
+	if (sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) {
+		/* Some device inodes could play dirty tricks. Catch them... */
+		WARN(bdi != sb->s_bdi && bdi_cap_writeback_dirty(bdi),
+			"Dirtiable inode bdi %s != sb bdi %s\n",
+			bdi->name, sb->s_bdi->name);
+		return sb->s_bdi;
+	}
+	return bdi;
+}
+
 static void bdi_queue_work(struct backing_dev_info *bdi,
 		struct wb_writeback_work *work)
 {

--vtzGhvizbBRQ85DL--
