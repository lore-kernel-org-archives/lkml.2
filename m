Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968Ab0J0LvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:51:21 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:45692 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab0J0LvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:51:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: hch@tuxera.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: [PATCH] FS: hfsplus, fix lock imbalance
Date: Wed, 27 Oct 2010 13:51:15 +0200
Message-Id: <1288180275-19941-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that there is mutex_lock in a fail path of
hfsplus_ioctl_setflags (i.e. double lock + leaving a function in
locked state). So fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Christoph Hellwig <hch@tuxera.com>
---
 fs/hfsplus/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index 5b4667e..40a85a3 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -92,7 +92,7 @@ static int hfsplus_ioctl_setflags(struct file *file, int __user *user_flags)
 	mark_inode_dirty(inode);
 
 out_unlock_inode:
-	mutex_lock(&inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out:
-- 
1.7.3.1


