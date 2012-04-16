Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2DPQWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:22:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab2DPQOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:22 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 15/27] fs: Skip atime update on frozen filesystem
Date: Mon, 16 Apr 2012 18:13:53 +0200
Message-Id: <1334592845-22862-16-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unexpected to block reading of frozen filesystem because of atime update.
Also handling blocking on frozen filesystem because of atime update would make
locking more complex than it already is. So just skip atime update when
filesystem is frozen like we skip it when filesystem is remounted read-only.

BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 396a388..3ded74d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1515,12 +1515,17 @@ void touch_atime(struct path *path)
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

