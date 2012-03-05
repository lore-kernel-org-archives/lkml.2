Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2CEQBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:01:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab2CEQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:41 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 08/19] fs: Skip atime update on frozen filesystem
Date: Mon,  5 Mar 2012 17:01:06 +0100
Message-Id: <1330963277-26336-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unexpected to block reading of frozen filesystem because of atime update.
Also handling blocking on frozen filesystem because of atime update would make
locking more complex than it already is. So just skip atime update when
filesystem is frozen like we skip it when filesystem is remounted read-only.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 095828c..ff3b385 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1535,12 +1535,17 @@ void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
 	if (timespec_equal(&inode->i_atime, &now))
 		return;
 
-	if (mnt_want_write(mnt))
+	if (!sb_start_write_trylock(inode->i_sb))
 		return;
 
+	if (__mnt_want_write(mnt))
+		goto skip_update;
+
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
-	mnt_drop_write(mnt);
+	__mnt_drop_write(mnt);
+skip_update:
+	sb_end_write(inode->i_sb);
 }
 EXPORT_SYMBOL(touch_atime);
 
-- 
1.7.1

