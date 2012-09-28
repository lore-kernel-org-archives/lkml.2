Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2I1GPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:15:18 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:32989 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484Ab2I1GPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:15:12 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 02:15:11 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowIAEc+ZVB5LPfb/2dsb2JhbABFi1+yLYEJgiABLS8jGBhqAzSIBLhZjh+DIAOmFIJ5
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH] loop: Make explicit loop device destruction lazy
Date: Fri, 28 Sep 2012 16:09:53 +1000
Message-Id: <1348812593-21344-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfstests has always had random failures of tests due to loop devices
failing to be torn down and hence leaving filesytems that cannot be
unmounted. This causes test runs to immediately stop.

Over the past 6 or 7 years we've added hacks like explicit unmount
-d commands for loop mounts, losetup -d after unmount -d fails, etc,
but still the problems persist.  Recently, the frequency of loop
related failures increased again to the point that xfstests 259 will
reliably fail with a stray loop device that was not torn down.

That is despite the fact the test is above as simple as it gets -
loop 5 or 6 times running mkfs.xfs with different paramters:

        lofile=$(losetup -f)
        losetup $lofile "$testfile"
        "$MKFS_XFS_PROG" -b size=512 $lofile >/dev/null || echo "mkfs failed!"
        sync
        losetup -d $lofile

And losteup -d $lofile is failing with EBUSY on 1-3 of these loops
every time the test is run.

Turns out that blkid is running simultaneously with losetup -d, and
so it sees an elevated reference count and returns EBUSY.  But why
is blkid running? It's obvious, isn't it? udev has decided to try
and find out what is on the block device as a result of a creation
notification. And it is racing with mkfs, so might still be scanning
the device when mkfs finishes and we try to tear it down.

So, make losetup -d force autoremove behaviour. That is, when the
last reference goes away, tear down the device. xfstests wants it
*gone*, not causing random teardown failures when we know that all
the operations the tests have specifically run on the device have
completed and are no longer referencing the loop device.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 drivers/block/loop.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3bba655..187b573 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -976,8 +976,21 @@ static int loop_clr_fd(struct loop_device *lo)
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
-	if (lo->lo_refcnt > 1)	/* we needed one fd for the ioctl */
-		return -EBUSY;
+	/*
+	 * If we've explicitly asked to tear down the loop device,
+	 * and it has an elevated reference count, set it for auto-teardown when
+	 * the last reference goes away. This stops $!~#$@ udev from
+	 * preventing teardown because it decided that it needs to run blkid on
+	 * the loopback device whenever they appear. xfstests is notorious for
+	 * failing tests because blkid via udev races with a losetup
+	 * <dev>/do something like mkfs/losetup -d <dev> causing the losetup -d
+	 * command to fail with EBUSY.
+	 */
+	if (lo->lo_refcnt > 1) {
+		lo->lo_flags |= LO_FLAGS_AUTOCLEAR;
+		mutex_unlock(&lo->lo_ctl_mutex);
+		return 0;
+	}
 
 	if (filp == NULL)
 		return -EINVAL;
-- 
1.7.10

