Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0DOBE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:04:59 -0400
Received: from [69.28.251.93] ([69.28.251.93]:38089 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab0DOBE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:04:57 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 14 Apr 2010 17:56:10 -0700
Subject: [PATCH] LogFS: Fix oops on failed mount
Message-Id: <621ed5fa50005b6ea02cff222037d3702a4d59b0@localhost.localdomain>
To: <joern@logfs.org>
Cc: <logfs@logfs.org>, <linux-kernel@vger.kernel.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logfs_kill_sb() calls mempool_destroy() on super->s_alias_pool .  But if
logfs_kill_sb() is being called because the mount failed (e.g.
__logfs_read_sb() returned -EIO) this pointer will still be NULL,
resulting in a kernel oops.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 fs/logfs/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/logfs/super.c b/fs/logfs/super.c
index b60bfac..f817713 100644
--- a/fs/logfs/super.c
+++ b/fs/logfs/super.c
@@ -517,7 +517,8 @@ static void logfs_kill_sb(struct super_block *sb)
 		__free_page(super->s_erase_page);
 	super->s_devops->put_device(sb);
 	mempool_destroy(super->s_btree_pool);
-	mempool_destroy(super->s_alias_pool);
+	if (super->s_alias_pool)
+		mempool_destroy(super->s_alias_pool);
 	kfree(super);
 	log_super("LogFS: Finished unmounting\n");
 }
-- 
1.6.3.1

