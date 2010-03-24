Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0CXFS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:18:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:35608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0CXFSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:18:24 -0400
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 24 Mar 2010 16:12:23 +1100
Subject: [PATCH 1/2] VFS: use __put_super_and_need_restart in get_active_super.
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Message-ID: <20100324051223.10015.75309.stgit@notabene.brown>
In-Reply-To: <20100324051140.10015.32854.stgit@notabene.brown>
References: <20100324051140.10015.32854.stgit@notabene.brown>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently-added get_active_super() walks the super_blocks
list but unlike all other code that walks this list it does
not use __put_super_and_need_restart().
I believe this is an omission that should be fixed.

cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index f35ac60..34c8391 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -482,6 +482,7 @@ struct super_block *get_active_super(struct block_device *bdev)
 		return NULL;
 
 	spin_lock(&sb_lock);
+restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (sb->s_bdev != bdev)
 			continue;
@@ -500,9 +501,10 @@ struct super_block *get_active_super(struct block_device *bdev)
 			spin_unlock(&sb_lock);
 		}
 		up_write(&sb->s_umount);
-		put_super(sb);
 		yield();
 		spin_lock(&sb_lock);
+		if (__put_super_and_need_restart(sb))
+			goto restart;
 	}
 	spin_unlock(&sb_lock);
 	return NULL;


