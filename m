Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2F1LBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:01:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39204 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab2F1LB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:01:29 -0400
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH 3/7] Make TestSetPageDirty and dirty page accounting in one func
Date: Thu, 28 Jun 2012 19:01:15 +0800
Message-Id: <1340881275-5651-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

Commit a8e7d49a(Fix race in create_empty_buffers() vs __set_page_dirty_buffers())
extracts TestSetPageDirty from __set_page_dirty and is far away from
account_page_dirtied.But it's better to make the two operations in one single
function to keep modular.So in order to avoid the potential race mentioned in
commit a8e7d49a, we can hold private_lock until __set_page_dirty completes.
I guess there's no deadlock between ->private_lock and ->tree_lock by quick look.

It's a prepare patch for following memcg dirty page accounting patches.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 fs/buffer.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 838a9cf..e8d96b8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -610,9 +610,15 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  * If warn is true, then emit a warning if the page is not uptodate and has
  * not been truncated.
  */
-static void __set_page_dirty(struct page *page,
+static int __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
+	if (unlikely(!mapping))
+		return !TestSetPageDirty(page);
+
+	if (TestSetPageDirty(page))
+		return 0;
+
 	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
@@ -622,6 +628,8 @@ static void __set_page_dirty(struct page *page,
 	}
 	spin_unlock_irq(&mapping->tree_lock);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+
+	return 1;
 }
 
 /*
@@ -667,11 +675,9 @@ int __set_page_dirty_buffers(struct page *page)
 			bh = bh->b_this_page;
 		} while (bh != head);
 	}
-	newly_dirty = !TestSetPageDirty(page);
+	newly_dirty = __set_page_dirty(page, mapping, 1);
 	spin_unlock(&mapping->private_lock);
 
-	if (newly_dirty)
-		__set_page_dirty(page, mapping, 1);
 	return newly_dirty;
 }
 EXPORT_SYMBOL(__set_page_dirty_buffers);
@@ -1115,14 +1121,9 @@ void mark_buffer_dirty(struct buffer_head *bh)
 			return;
 	}
 
-	if (!test_set_buffer_dirty(bh)) {
-		struct page *page = bh->b_page;
-		if (!TestSetPageDirty(page)) {
-			struct address_space *mapping = page_mapping(page);
-			if (mapping)
-				__set_page_dirty(page, mapping, 0);
-		}
-	}
+	if (!test_set_buffer_dirty(bh))
+		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
+
 }
 EXPORT_SYMBOL(mark_buffer_dirty);
 
-- 
1.7.1

