Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1LVSDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:03:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48609 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab1LVSCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:02:35 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com, torvalds@linux-foundation.org
Subject: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
Date: Thu, 22 Dec 2011 19:02:18 +0100
Message-Id: <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1324576939-23619-1-git-send-email-pbonzini@redhat.com>
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux allows executing the SG_IO ioctl on a partition or even on an
LVM volume, and will pass the command to the underlying block device.
This is well-known, but it is also a large security problem when (via
Unix permissions, ACLs, SELinux or a combination thereof) a program or
user needs to be granted access to a particular partition or logical
volume but not to the full device.

This patch limits the ioctls that are forwarded to non-SCSI devices to
a few ones that are harmless.  This restriction includes programs
running with the CAP_SYS_RAWIO.  If for example I let a program access
/dev/sda2 and /dev/sdb, it still should not be able to read/write outside
the boundaries of /dev/sda2 independent of the capabilities.

This patch does not affect the non-libata IDE driver.  That driver however
already tests for bd != bd->bd_contains before issuing some ioctl; so,
programs that do not require CAP_SYS_ADMIN or CAP_SYS_RAWIO are safe.
Whenever possible a workaround is just to use libata, of course.

Encryption on the host is a mitigating factor, but it does not provide
a full solution.  In particular it doesn't protect against DoS (write
random data), replay attacks (reinstate old ciphertext sectors), or
writes to unencrypted areas including the MBR, the partition table, or
/boot.

Thanks to Daniel Berrange, Milan Broz, Mike Christie, Alasdair Kergon,
Petr Matousek, Jeff Moyer, Mike Snitzer and others for help discussing
this issue.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c     |   34 ++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c      |   11 +++++++++--
 include/linux/blkdev.h |    1 +
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 48dfbe7..6411f8c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -675,9 +675,43 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
 }
 EXPORT_SYMBOL(scsi_cmd_ioctl);
 
+int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
+{
+	if (bd && bd == bd->bd_contains)
+		return 0;
+
+	/* Actually none of this is particularly useful on a partition
+	 * device, but let's play it safe.
+	 */
+	switch (cmd) {
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+	case SCSI_IOCTL_GET_PCI:
+	case SCSI_IOCTL_PROBE_HOST:
+	case SG_GET_VERSION_NUM:
+	case SG_SET_TIMEOUT:
+	case SG_GET_TIMEOUT:
+	case SG_GET_RESERVED_SIZE:
+	case SG_SET_RESERVED_SIZE:
+	case SG_EMULATED_HOST:
+		return 0;
+	default:
+		break;
+	}
+	/* In particular, rule out all resets and host-specific ioctls.  */
+	return -ENOTTY;
+}
+EXPORT_SYMBOL(scsi_verify_blk_ioctl);
+
 int scsi_cmd_blk_ioctl(struct block_device *bd, fmode_t mode,
 		       unsigned int cmd, void __user *arg)
 {
+	int ret;
+
+	ret = scsi_verify_blk_ioctl(bd, cmd);
+	if (ret < 0)
+		return ret;
+
 	return scsi_cmd_ioctl(bd->bd_disk->queue, bd->bd_disk, mode, cmd, arg);
 }
 EXPORT_SYMBOL(scsi_cmd_blk_ioctl);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c6c449a..0c5954c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1058,6 +1058,10 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=%s, "
 				    "cmd=0x%x\n", disk->disk_name, cmd));
 
+	error = scsi_verify_blk_ioctl(bdev, cmd);
+	if (error < 0)
+		return error;
+
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
 	 * else try and use this device.  Also, if error recovery fails, it
@@ -1228,6 +1232,11 @@ static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct scsi_device *sdev = scsi_disk(bdev->bd_disk)->device;
+	int ret;
+
+	ret = scsi_verify_blk_ioctl(bdev, cmd);
+	if (ret < 0)
+		return ret == -ENOTTY ? -ENOIOCTLCMD : ret;
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
@@ -1239,8 +1248,6 @@ static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 		return -ENODEV;
 	       
 	if (sdev->host->hostt->compat_ioctl) {
-		int ret;
-
 		ret = sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
 
 		return ret;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 03a00a6..11cf6ca 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -761,6 +761,7 @@ extern void blk_plug_device(struct request_queue *);
 				     struct request *rq);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
+extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
 			      unsigned int, void __user *);
 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
-- 
1.7.7.1


