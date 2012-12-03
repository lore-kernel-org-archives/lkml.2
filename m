Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2LCOgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43853 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312Ab2LCOgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:46 -0500
Message-Id: <20121203143154.623890415@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Betker <thomas.betker@freenet.de>,
        Thomas Betker <thomas.betker@rohde-schwarz.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 51/89] jffs2: Fix lock acquisition order bug in jffs2_write_begin
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Use D1(printk(KERN_DEBUG ...)) instead of jffs2_dbg(1, ...)]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jffs2/file.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -135,33 +135,39 @@ static int jffs2_write_begin(struct file
 	struct page *pg;
 	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
+	struct jffs2_raw_inode ri;
+	uint32_t alloc_len = 0;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	uint32_t pageofs = index << PAGE_CACHE_SHIFT;
 	int ret = 0;
 
+	D1(printk(KERN_DEBUG "%s()\n", __func__));
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
 
-	D1(printk(KERN_DEBUG "jffs2_write_begin()\n"));
-
-	if (pageofs > inode->i_size) {
+	if (alloc_len) {
 		/* Make new hole frag from old EOF to new page */
-		struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
-		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
-		uint32_t alloc_len;
 
 		D1(printk(KERN_DEBUG "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
 			  (unsigned int)inode->i_size, pageofs));
 
-		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
-					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
-		if (ret)
-			goto out_page;
-
-		mutex_lock(&f->sem);
 		memset(&ri, 0, sizeof(ri));
 
 		ri.magic = cpu_to_je16(JFFS2_MAGIC_BITMASK);
@@ -188,7 +194,6 @@ static int jffs2_write_begin(struct file
 		if (IS_ERR(fn)) {
 			ret = PTR_ERR(fn);
 			jffs2_complete_reservation(c);
-			mutex_unlock(&f->sem);
 			goto out_page;
 		}
 		ret = jffs2_add_full_dnode_to_inode(c, f, fn);
@@ -202,12 +207,10 @@ static int jffs2_write_begin(struct file
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
@@ -216,18 +219,18 @@ static int jffs2_write_begin(struct file
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
 	D1(printk(KERN_DEBUG "end write_begin(). pg->flags %lx\n", pg->flags));
 	return ret;
 
 out_page:
 	unlock_page(pg);
 	page_cache_release(pg);
+	mutex_unlock(&f->sem);
 	return ret;
 }
 


