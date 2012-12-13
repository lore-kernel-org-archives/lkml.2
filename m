Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2LMOHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2LMOHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Betker <thomas.betker@rohde-schwarz.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 105/241] jffs2: Fix lock acquisition order bug in jffs2_write_begin
Date: Thu, 13 Dec 2012 11:57:50 -0200
Message-Id: <1355407206-17100-106-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Betker <thomas.betker@freenet.de>

commit 5ffd3412ae5536a4c57469cb8ea31887121dcb2e upstream.

jffs2_write_begin() first acquires the page lock, then f->sem. This
causes an AB-BA deadlock with jffs2_garbage_collect_live(), which first
acquires f->sem, then the page lock:

jffs2_garbage_collect_live
    mutex_lock(&f->sem)                         (A)
    jffs2_garbage_collect_dnode
        jffs2_gc_fetch_page
            read_cache_page_async
                do_read_cache_page
                    lock_page(page)             (B)

jffs2_write_begin
    grab_cache_page_write_begin
        find_lock_page
            lock_page(page)                     (B)
    mutex_lock(&f->sem)                         (A)

We fix this by restructuring jffs2_write_begin() to take f->sem before
the page lock. However, we make sure that f->sem is not held when
calling jffs2_reserve_space(), as this is not permitted by the locking
rules.

The deadlock above was observed multiple times on an SoC with a dual
ARMv7 (Cortex-A9), running the long-term 3.4.11 kernel; it occurred
when using scp to copy files from a host system to the ARM target
system. The fix was heavily tested on the same target system.

Signed-off-by: Thomas Betker <thomas.betker@rohde-schwarz.com>
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/jffs2/file.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index db3889b..8608f87 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -138,33 +138,39 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	struct page *pg;
 	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
+	struct jffs2_raw_inode ri;
+	uint32_t alloc_len = 0;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	uint32_t pageofs = index << PAGE_CACHE_SHIFT;
 	int ret = 0;
 
+	jffs2_dbg(1, "%s()\n", __func__);
+
+	if (pageofs > inode->i_size) {
+		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
+					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
+		if (ret)
+			return ret;
+	}
+
+	mutex_lock(&f->sem);
 	pg = grab_cache_page_write_begin(mapping, index, flags);
-	if (!pg)
+	if (!pg) {
+		if (alloc_len)
+			jffs2_complete_reservation(c);
+		mutex_unlock(&f->sem);
 		return -ENOMEM;
+	}
 	*pagep = pg;
 
-	jffs2_dbg(1, "%s()\n", __func__);
-
-	if (pageofs > inode->i_size) {
+	if (alloc_len) {
 		/* Make new hole frag from old EOF to new page */
-		struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
-		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
-		uint32_t alloc_len;
 
 		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
 			  (unsigned int)inode->i_size, pageofs);
 
-		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
-					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
-		if (ret)
-			goto out_page;
-
-		mutex_lock(&f->sem);
 		memset(&ri, 0, sizeof(ri));
 
 		ri.magic = cpu_to_je16(JFFS2_MAGIC_BITMASK);
@@ -191,7 +197,6 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		if (IS_ERR(fn)) {
 			ret = PTR_ERR(fn);
 			jffs2_complete_reservation(c);
-			mutex_unlock(&f->sem);
 			goto out_page;
 		}
 		ret = jffs2_add_full_dnode_to_inode(c, f, fn);
@@ -206,12 +211,10 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			jffs2_mark_node_obsolete(c, fn->raw);
 			jffs2_free_full_dnode(fn);
 			jffs2_complete_reservation(c);
-			mutex_unlock(&f->sem);
 			goto out_page;
 		}
 		jffs2_complete_reservation(c);
 		inode->i_size = pageofs;
-		mutex_unlock(&f->sem);
 	}
 
 	/*
@@ -220,18 +223,18 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	 * case of a short-copy.
 	 */
 	if (!PageUptodate(pg)) {
-		mutex_lock(&f->sem);
 		ret = jffs2_do_readpage_nolock(inode, pg);
-		mutex_unlock(&f->sem);
 		if (ret)
 			goto out_page;
 	}
+	mutex_unlock(&f->sem);
 	jffs2_dbg(1, "end write_begin(). pg->flags %lx\n", pg->flags);
 	return ret;
 
 out_page:
 	unlock_page(pg);
 	page_cache_release(pg);
+	mutex_unlock(&f->sem);
 	return ret;
 }
 
-- 
1.7.9.5

