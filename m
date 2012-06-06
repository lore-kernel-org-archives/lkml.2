Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2FFP5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:57:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:47640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab2FFPzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161755309"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/7] affs: stop using lock_super
Date: Wed,  6 Jun 2012 18:56:55 +0300
Message-Id: <1338998217-5010-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The VFS's 'lock_super()' and 'unlock_super()' calls are deprecated and unwanted
and just wait for a brave knight who'd kill them. This patch makes AFFS stop
using them and use the buffer-head's own lock instead.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/super.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 4ceec56..da7498d 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -31,13 +31,14 @@ affs_commit_super(struct super_block *sb, int wait)
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
-	lock_super(sb);
+	lock_buffer(bh);
 	secs_to_datestamp(get_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
+	unlock_buffer(bh);
+
 	mark_buffer_dirty(bh);
 	if (wait)
 		sync_dirty_buffer(bh);
-	unlock_super(sb);
 }
 
 static void
-- 
1.7.7.6

