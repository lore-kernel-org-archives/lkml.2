Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2LENk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:40:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab2LENkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:40:23 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] fs: Fix imbalance in freeze protection in mark_files_ro()
Date: Wed,  5 Dec 2012 14:40:14 +0100
Message-Id: <1354714814-7492-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File descriptors (even those for writing) do not hold freeze protection.
Thus mark_files_ro() must call __mnt_drop_write() to only drop protection
against remount read-only. Calling mnt_drop_write_file() as we do now
results in:

[ BUG: bad unlock balance detected! ]
3.7.0-rc6-00028-g88e75b6 #101 Not tainted
-------------------------------------
kworker/1:2/79 is trying to release lock (sb_writers) at:
[<ffffffff811b33b4>] mnt_drop_write+0x24/0x30
but there are no more locks to release!

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/file_table.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

  Umm, this got lost for some reason...

diff --git a/fs/file_table.c b/fs/file_table.c
index a72bf9d..de9e965 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -458,8 +458,8 @@ void mark_files_ro(struct super_block *sb)
 		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
+		__mnt_drop_write(f->f_path.mnt);
 		file_release_write(f);
-		mnt_drop_write_file(f);
 	} while_file_list_for_each_entry;
 	lg_global_unlock(&files_lglock);
 }
-- 
1.7.1

