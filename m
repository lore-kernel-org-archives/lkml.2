Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab2BJKDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:03:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657Ab2BJKDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:03:10 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, mpatocka@redhat.com,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] quota: Fix deadlock with suspend and quotas
Date: Fri, 10 Feb 2012 11:03:01 +0100
Message-Id: <1328868181-16979-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328868181-16979-1-git-send-email-jack@suse.cz>
References: <1328868181-16979-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script causes a kernel deadlock:
set -e
DEVICE=/dev/vg1/linear
lvchange -ay $DEVICE
mkfs.ext3 $DEVICE
mount -t ext3 -o usrquota,grpquota $DEVICE /mnt/test
quotacheck -gu /mnt/test
umount /mnt/test
mount -t ext3 -o usrquota,grpquota $DEVICE /mnt/test
quotaon /mnt/test
dmsetup suspend $DEVICE
setquota -u root 1 2 3 4 /mnt/test &
sleep 1
dmsetup resume $DEVICE

setquota acquired semaphore s_umount for read and then tried to perform a
transaction (and waits because the device is suspended).  dmsetup resume tries
to acquire s_umount for write before resuming the device (and waits for
setquota).

Fix the deadlock by grabbing a thawed superblock for quota commands which need
it.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 7898cd6..fc2c438 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -292,11 +292,26 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	}
 }
 
+/* Return 1 if 'cmd' will block on frozen filesystem */
+static int quotactl_cmd_write(int cmd)
+{
+	switch (cmd) {
+	case Q_GETFMT:
+	case Q_GETINFO:
+	case Q_SYNC:
+	case Q_XGETQSTAT:
+	case Q_XGETQUOTA:
+	case Q_XQUOTASYNC:
+		return 0;
+	}
+	return 1;
+}
+
 /*
  * look up a superblock on which quota ops will be performed
  * - use the name of a block device to find the superblock thereon
  */
-static struct super_block *quotactl_block(const char __user *special)
+static struct super_block *quotactl_block(const char __user *special, int cmd)
 {
 #ifdef CONFIG_BLOCK
 	struct block_device *bdev;
@@ -309,7 +324,10 @@ static struct super_block *quotactl_block(const char __user *special)
 	putname(tmp);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
-	sb = get_super(bdev);
+	if (quotactl_cmd_write(cmd))
+		sb = get_super_thawed(bdev);
+	else
+		sb = get_super(bdev);
 	bdput(bdev);
 	if (!sb)
 		return ERR_PTR(-ENODEV);
@@ -361,7 +379,7 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
 			pathp = &path;
 	}
 
-	sb = quotactl_block(special);
+	sb = quotactl_block(special, cmds);
 	if (IS_ERR(sb)) {
 		ret = PTR_ERR(sb);
 		goto out;
-- 
1.7.1

