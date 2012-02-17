Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab2BQHjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 02:39:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50884 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2BQHjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 02:39:11 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v2] block: avoid false positive warnings on ioctl to partition
Date: Fri, 17 Feb 2012 08:38:58 +0100
Message-Id: <1329464338-8351-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a month of reports, the warnings from non-whitelisted ioctls to
a partitions can be classified in three groups.

BLKFLSBUF and BLKROSET are always sent to devices.  Not having them in
the whitelist did not cause any visible harm, but anyway they can and
should be added to the whitelist.

Many unrecognized ioctls are sent to partitions as an attempt to probe for
CD-ROMs, floppies and other kinds of devices.  Like CDROM_GET_CAPABILITY,
they can be blocked safely.

Of the actual SCSI ioctls, only SG_IO was reported in the wild (twice).
udev's scsi_id can issue INQUIRY commands if passed a partition; this
only occurs with custom rules and is strictly speaking invalid, but we
need a transition period so that people can fix their configuration.
zfs-fuse also can issue SYNCHRONIZE CACHE commands, where it should
simply use fdatasync.

Therefore, this patch silently blocks all ioctls except SG_IO, since
all of them turned out to be false positives; in case some escaped, it
should be easily diagnosable or at least bisectable.  The warning text
is separated for root and non-root.  The warning for SG_IO is left in
because a) it will alert users to possible bugs, and b) we do want to
hear about more uses in the wild.  However, no deprecation period is
set for now.

Cc: stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Note: I will take care of the stable backport as soon as this
	patch or something similar hits Linus's tree.

 block/scsi_ioctl.c |   40 ++++++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 260fa80..fe86923 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -696,9 +696,6 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
 	if (bd && bd == bd->bd_contains)
 		return 0;
 
-	/* Actually none of these is particularly useful on a partition,
-	 * but they are safe.
-	 */
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN:
 	case SCSI_IOCTL_GET_BUS_NUMBER:
@@ -710,22 +707,39 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
+		/* Actually none of these is particularly useful on a partition,
+		 * but they are safe.
+		 */
 		return 0;
-	case CDROM_GET_CAPABILITY:
-		/* Keep this until we remove the printk below.  udev sends it
-		 * and we do not want to spam dmesg about it.   CD-ROMs do
-		 * not have partitions, so we get here only for disks.
-		 */
-		return -ENOIOCTLCMD;
+
+	case BLKROSET:
+	case BLKFLSBUF:
+		/* These are generic block layer ioctls that are nevertheless
+		 * passed down to devices.  They are certainly valid for
+		 * partitions!
+		 */
+		return 0;
+
+	case SG_IO:
+		/* Accept this for root users, at least for now.  */
+		break;
+
 	default:
-		break;
+		/* In particular, rule out resets and host-specific ioctls.  */
+		return -ENOIOCTLCMD;
 	}
 
-	/* In particular, rule out all resets and host-specific ioctls.  */
-	printk_ratelimited(KERN_WARNING
-			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
+	if (capable(CAP_SYS_RAWIO)) {
+		printk_ratelimited(KERN_WARNING
+				   "%s: SG_IO to a partition is likely a bug\n",
+				   current->comm);
+		return 0;
+	}
 
-	return capable(CAP_SYS_RAWIO) ? 0 : -ENOIOCTLCMD;
+	printk_ratelimited(KERN_WARNING
+			   "%s: rejecting SG_IO to a partition for non-root user\n",
+			   current->comm);
+	return -ENOIOCTLCMD;
 }
 EXPORT_SYMBOL(scsi_verify_blk_ioctl);
 
-- 
1.7.1

