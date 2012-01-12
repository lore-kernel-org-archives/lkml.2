Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2ALUin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:38:43 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:50152 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2ALUif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:38:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nitin Gupta <ngupta@vflare.org>,
        Matthew Wilcox <matthew@wil.cx>, Chris Mason <chris.mason@oracle.com>,
        Rik Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] mm: cleancache: s/flush/invalidate/
Date: Thu, 12 Jan 2012 15:36:17 -0500
Message-Id: <1326400580-16853-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
References: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F0F44BC.001C,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>

Per akpm suggestions alter the use of the term flush to be
invalidate. The next patch will do this across all MM.

This change is completely cosmetic.

[v9: akpm@linux-foundation.org: change "flush" to "invalidate", part 3]

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Rik Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
[v10: Fixed  fs: move code out of buffer.c conflict change]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/vm/cleancache.txt |   37 +++++++++++++++++++------------------
 fs/block_dev.c                  |    2 +-
 fs/super.c                      |    2 +-
 include/linux/cleancache.h      |   23 ++++++++++++++---------
 mm/cleancache.c                 |   19 ++++++++++---------
 mm/filemap.c                    |    2 +-
 mm/truncate.c                   |   10 +++++-----
 7 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/Documentation/vm/cleancache.txt b/Documentation/vm/cleancache.txt
index 36c367c..e0a5356 100644
--- a/Documentation/vm/cleancache.txt
+++ b/Documentation/vm/cleancache.txt
@@ -46,10 +46,11 @@ a negative return value indicates failure.  A "put_page" will copy a
 the pool id, a file key, and a page index into the file.  (The combination
 of a pool id, a file key, and an index is sometimes called a "handle".)
 A "get_page" will copy the page, if found, from cleancache into kernel memory.
-A "flush_page" will ensure the page no longer is present in cleancache;
-a "flush_inode" will flush all pages associated with the specified file;
-and, when a filesystem is unmounted, a "flush_fs" will flush all pages in
-all files specified by the given pool id and also surrender the pool id.
+An "invalidate_page" will ensure the page no longer is present in cleancache;
+an "invalidate_inode" will invalidate all pages associated with the specified
+file; and, when a filesystem is unmounted, an "invalidate_fs" will invalidate
+all pages in all files specified by the given pool id and also surrender
+the pool id.
 
 An "init_shared_fs", like init_fs, obtains a pool id but tells cleancache
 to treat the pool as shared using a 128-bit UUID as a key.  On systems
@@ -62,12 +63,12 @@ of the kernel (e.g. by "tools" that control cleancache).  Or a
 cleancache implementation can simply disable shared_init by always
 returning a negative value.
 
-If a get_page is successful on a non-shared pool, the page is flushed (thus
-making cleancache an "exclusive" cache).  On a shared pool, the page
-is NOT flushed on a successful get_page so that it remains accessible to
+If a get_page is successful on a non-shared pool, the page is invalidated
+(thus making cleancache an "exclusive" cache).  On a shared pool, the page
+is NOT invalidated on a successful get_page so that it remains accessible to
 other sharers.  The kernel is responsible for ensuring coherency between
 cleancache (shared or not), the page cache, and the filesystem, using
-cleancache flush operations as required.
+cleancache invalidate operations as required.
 
 Note that cleancache must enforce put-put-get coherency and get-get
 coherency.  For the former, if two puts are made to the same handle but
@@ -77,7 +78,7 @@ if a get for a given handle fails, subsequent gets for that handle will
 never succeed unless preceded by a successful put with that handle.
 
 Last, cleancache provides no SMP serialization guarantees; if two
-different Linux threads are simultaneously putting and flushing a page
+different Linux threads are simultaneously putting and invalidating a page
 with the same handle, the results are indeterminate.  Callers must
 lock the page to ensure serial behavior.
 
@@ -90,7 +91,7 @@ can be measured (across all filesystems) with:
 succ_gets	- number of gets that were successful
 failed_gets	- number of gets that failed
 puts		- number of puts attempted (all "succeed")
-flushes		- number of flushes attempted
+invalidates	- number of invalidates attempted
 
 A backend implementatation may provide additional metrics.
 
@@ -143,7 +144,7 @@ systems.
 
 The core hooks for cleancache in VFS are in most cases a single line
 and the minimum set are placed precisely where needed to maintain
-coherency (via cleancache_flush operations) between cleancache,
+coherency (via cleancache_invalidate operations) between cleancache,
 the page cache, and disk.  All hooks compile into nothingness if
 cleancache is config'ed off and turn into a function-pointer-
 compare-to-NULL if config'ed on but no backend claims the ops
@@ -184,15 +185,15 @@ or for real kernel-addressable RAM, it makes perfect sense for
 transcendent memory.
 
 4) Why is non-shared cleancache "exclusive"?  And where is the
-   page "flushed" after a "get"? (Minchan Kim)
+   page "invalidated" after a "get"? (Minchan Kim)
 
 The main reason is to free up space in transcendent memory and
-to avoid unnecessary cleancache_flush calls.  If you want inclusive,
+to avoid unnecessary cleancache_invalidate calls.  If you want inclusive,
 the page can be "put" immediately following the "get".  If
 put-after-get for inclusive becomes common, the interface could
-be easily extended to add a "get_no_flush" call.
+be easily extended to add a "get_no_invalidate" call.
 
-The flush is done by the cleancache backend implementation.
+The invalidate is done by the cleancache backend implementation.
 
 5) What's the performance impact?
 
@@ -222,7 +223,7 @@ Some points for a filesystem to consider:
   as tmpfs should not enable cleancache)
 - To ensure coherency/correctness, the FS must ensure that all
   file removal or truncation operations either go through VFS or
-  add hooks to do the equivalent cleancache "flush" operations
+  add hooks to do the equivalent cleancache "invalidate" operations
 - To ensure coherency/correctness, either inode numbers must
   be unique across the lifetime of the on-disk file OR the
   FS must provide an "encode_fh" function.
@@ -243,11 +244,11 @@ If cleancache would use the inode virtual address instead of
 inode/filehandle, the pool id could be eliminated.  But, this
 won't work because cleancache retains pagecache data pages
 persistently even when the inode has been pruned from the
-inode unused list, and only flushes the data page if the file
+inode unused list, and only invalidates the data page if the file
 gets removed/truncated.  So if cleancache used the inode kva,
 there would be potential coherency issues if/when the inode
 kva is reused for a different file.  Alternately, if cleancache
-flushed the pages when the inode kva was freed, much of the value
+invalidated the pages when the inode kva was freed, much of the value
 of cleancache would be lost because the cache of pages in cleanache
 is potentially much larger than the kernel pagecache and is most
 useful if the pages survive inode cache removal.
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 69a5b6f..d6d5f29 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -110,7 +110,7 @@ void invalidate_bdev(struct block_device *bdev)
 	/* 99% of the time, we don't need to flush the cleancache on the bdev.
 	 * But, for the strange corners, lets be cautious
 	 */
-	cleancache_flush_inode(mapping);
+	cleancache_invalidate_inode(mapping);
 }
 EXPORT_SYMBOL(invalidate_bdev);
 
diff --git a/fs/super.c b/fs/super.c
index de41e1e..e5d9765 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -250,7 +250,7 @@ void deactivate_locked_super(struct super_block *s)
 {
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
-		cleancache_flush_fs(s);
+		cleancache_invalidate_fs(s);
 		fs->kill_sb(s);
 
 		/* caches are now gone, we can safely kill the shrinker now */
diff --git a/include/linux/cleancache.h b/include/linux/cleancache.h
index 04ffb2e..66fb63b 100644
--- a/include/linux/cleancache.h
+++ b/include/linux/cleancache.h
@@ -28,6 +28,11 @@ struct cleancache_ops {
 			pgoff_t, struct page *);
 	void (*put_page)(int, struct cleancache_filekey,
 			pgoff_t, struct page *);
+	/*
+	 * NOTE: per akpm, flush_page, flush_inode and flush_fs will be
+	 * renamed to invalidate_* in a later commit in which all
+	 * dependencies (i.e Xen, zcache) will be renamed simultaneously
+	 */
 	void (*flush_page)(int, struct cleancache_filekey, pgoff_t);
 	void (*flush_inode)(int, struct cleancache_filekey);
 	void (*flush_fs)(int);
@@ -39,9 +44,9 @@ extern void __cleancache_init_fs(struct super_block *);
 extern void __cleancache_init_shared_fs(char *, struct super_block *);
 extern int  __cleancache_get_page(struct page *);
 extern void __cleancache_put_page(struct page *);
-extern void __cleancache_flush_page(struct address_space *, struct page *);
-extern void __cleancache_flush_inode(struct address_space *);
-extern void __cleancache_flush_fs(struct super_block *);
+extern void __cleancache_invalidate_page(struct address_space *, struct page *);
+extern void __cleancache_invalidate_inode(struct address_space *);
+extern void __cleancache_invalidate_fs(struct super_block *);
 extern int cleancache_enabled;
 
 #ifdef CONFIG_CLEANCACHE
@@ -99,24 +104,24 @@ static inline void cleancache_put_page(struct page *page)
 		__cleancache_put_page(page);
 }
 
-static inline void cleancache_flush_page(struct address_space *mapping,
+static inline void cleancache_invalidate_page(struct address_space *mapping,
 					struct page *page)
 {
 	/* careful... page->mapping is NULL sometimes when this is called */
 	if (cleancache_enabled && cleancache_fs_enabled_mapping(mapping))
-		__cleancache_flush_page(mapping, page);
+		__cleancache_invalidate_page(mapping, page);
 }
 
-static inline void cleancache_flush_inode(struct address_space *mapping)
+static inline void cleancache_invalidate_inode(struct address_space *mapping)
 {
 	if (cleancache_enabled && cleancache_fs_enabled_mapping(mapping))
-		__cleancache_flush_inode(mapping);
+		__cleancache_invalidate_inode(mapping);
 }
 
-static inline void cleancache_flush_fs(struct super_block *sb)
+static inline void cleancache_invalidate_fs(struct super_block *sb)
 {
 	if (cleancache_enabled)
-		__cleancache_flush_fs(sb);
+		__cleancache_invalidate_fs(sb);
 }
 
 #endif /* _LINUX_CLEANCACHE_H */
diff --git a/mm/cleancache.c b/mm/cleancache.c
index bcaae4c..237c6e0 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -19,7 +19,7 @@
 
 /*
  * This global enablement flag may be read thousands of times per second
- * by cleancache_get/put/flush even on systems where cleancache_ops
+ * by cleancache_get/put/invalidate even on systems where cleancache_ops
  * is not claimed (e.g. cleancache is config'ed on but remains
  * disabled), so is preferred to the slower alternative: a function
  * call that checks a non-global.
@@ -148,10 +148,11 @@ void __cleancache_put_page(struct page *page)
 EXPORT_SYMBOL(__cleancache_put_page);
 
 /*
- * Flush any data from cleancache associated with the poolid and the
+ * Invalidate any data from cleancache associated with the poolid and the
  * page's inode and page index so that a subsequent "get" will fail.
  */
-void __cleancache_flush_page(struct address_space *mapping, struct page *page)
+void __cleancache_invalidate_page(struct address_space *mapping,
+					struct page *page)
 {
 	/* careful... page->mapping is NULL sometimes when this is called */
 	int pool_id = mapping->host->i_sb->cleancache_poolid;
@@ -165,14 +166,14 @@ void __cleancache_flush_page(struct address_space *mapping, struct page *page)
 		}
 	}
 }
-EXPORT_SYMBOL(__cleancache_flush_page);
+EXPORT_SYMBOL(__cleancache_invalidate_page);
 
 /*
- * Flush all data from cleancache associated with the poolid and the
+ * Invalidate all data from cleancache associated with the poolid and the
  * mappings's inode so that all subsequent gets to this poolid/inode
  * will fail.
  */
-void __cleancache_flush_inode(struct address_space *mapping)
+void __cleancache_invalidate_inode(struct address_space *mapping)
 {
 	int pool_id = mapping->host->i_sb->cleancache_poolid;
 	struct cleancache_filekey key = { .u.key = { 0 } };
@@ -180,14 +181,14 @@ void __cleancache_flush_inode(struct address_space *mapping)
 	if (pool_id >= 0 && cleancache_get_key(mapping->host, &key) >= 0)
 		(*cleancache_ops.flush_inode)(pool_id, key);
 }
-EXPORT_SYMBOL(__cleancache_flush_inode);
+EXPORT_SYMBOL(__cleancache_invalidate_inode);
 
 /*
  * Called by any cleancache-enabled filesystem at time of unmount;
  * note that pool_id is surrendered and may be reutrned by a subsequent
  * cleancache_init_fs or cleancache_init_shared_fs
  */
-void __cleancache_flush_fs(struct super_block *sb)
+void __cleancache_invalidate_fs(struct super_block *sb)
 {
 	if (sb->cleancache_poolid >= 0) {
 		int old_poolid = sb->cleancache_poolid;
@@ -195,7 +196,7 @@ void __cleancache_flush_fs(struct super_block *sb)
 		(*cleancache_ops.flush_fs)(old_poolid);
 	}
 }
-EXPORT_SYMBOL(__cleancache_flush_fs);
+EXPORT_SYMBOL(__cleancache_invalidate_fs);
 
 #ifdef CONFIG_SYSFS
 
diff --git a/mm/filemap.c b/mm/filemap.c
index a0701e6..0aa3faa 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -123,7 +123,7 @@ void __delete_from_page_cache(struct page *page)
 	if (PageUptodate(page) && PageMappedToDisk(page))
 		cleancache_put_page(page);
 	else
-		cleancache_flush_page(mapping, page);
+		cleancache_invalidate_page(mapping, page);
 
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
diff --git a/mm/truncate.c b/mm/truncate.c
index 632b15e..b4d575c 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -52,7 +52,7 @@ void do_invalidatepage(struct page *page, unsigned long offset)
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
 	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
-	cleancache_flush_page(page->mapping, page);
+	cleancache_invalidate_page(page->mapping, page);
 	if (page_has_private(page))
 		do_invalidatepage(page, partial);
 }
@@ -213,7 +213,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	pgoff_t end;
 	int i;
 
-	cleancache_flush_inode(mapping);
+	cleancache_invalidate_inode(mapping);
 	if (mapping->nrpages == 0)
 		return;
 
@@ -292,7 +292,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		mem_cgroup_uncharge_end();
 		index++;
 	}
-	cleancache_flush_inode(mapping);
+	cleancache_invalidate_inode(mapping);
 }
 EXPORT_SYMBOL(truncate_inode_pages_range);
 
@@ -444,7 +444,7 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 	int ret2 = 0;
 	int did_range_unmap = 0;
 
-	cleancache_flush_inode(mapping);
+	cleancache_invalidate_inode(mapping);
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index <= end && pagevec_lookup(&pvec, mapping, index,
@@ -500,7 +500,7 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		cond_resched();
 		index++;
 	}
-	cleancache_flush_inode(mapping);
+	cleancache_invalidate_inode(mapping);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
-- 
1.7.7.4

