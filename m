Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2EBKLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:11:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab2EBKLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:11:00 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed,  2 May 2012 12:10:52 +0200
Message-Id: <1335953452-10460-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, warnings about ioctls to partition happen often enough that they
form majority of the warnings in the kernel log and users complain. In some
cases warnings are about ioctls such as SG_IO so it's not good to get rid of
the warnings completely as they can ease debugging of userspace problems
when ioctl is refused.

Since I have seen warnings from lots of commands, including some proprietary
userspace applications, I don't think disallowing the ioctls for processes
with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: James Bottomley <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/scsi_ioctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 260fa80..9a87daa 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -721,11 +721,14 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
 		break;
 	}
 
+	if (capable(CAP_SYS_RAWIO))
+		return 0;
+
 	/* In particular, rule out all resets and host-specific ioctls.  */
 	printk_ratelimited(KERN_WARNING
 			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
 
-	return capable(CAP_SYS_RAWIO) ? 0 : -ENOIOCTLCMD;
+	return -ENOIOCTLCMD;
 }
 EXPORT_SYMBOL(scsi_verify_blk_ioctl);
 
-- 
1.7.1

