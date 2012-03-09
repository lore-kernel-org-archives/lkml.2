Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2CIJCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:02:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab2CIJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:02:37 -0500
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] fs: Remove bogus wait in write_inode_now()
Date: Fri,  9 Mar 2012 10:02:25 +0100
Message-Id: <1331283748-12959-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1331283748-12959-1-git-send-email-jack@suse.cz>
References: <1331283748-12959-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode_sync_wait() in write_inode_now() is just bogus. That function waits for
I_SYNC bit to be cleared but writeback_single_inode() clears the bit on return
so the wait is effectivelly a nop unless someone else submits the inode for
writeback again. All the waiting write_inode_now() needs is achieved by using
WB_SYNC_ALL writeback mode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5b4a936..f60297b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1364,8 +1364,6 @@ int write_inode_now(struct inode *inode, int sync)
 	ret = writeback_single_inode(inode, wb, &wbc);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
-	if (sync)
-		inode_sync_wait(inode);
 	return ret;
 }
 EXPORT_SYMBOL(write_inode_now);
-- 
1.7.1

