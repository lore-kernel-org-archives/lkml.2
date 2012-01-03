Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2ACWEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:04:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab2ACWEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:04:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:02:42 2012
Message-Id: <20120103220241.801850293@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:01:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [4/7] vfs: __read_cache_page should use gfp argument rather than GFP_KERNEL
In-Reply-To: <20120103220302.GA28338@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit e6f67b8c05f5e129e126f4409ddac6f25f58ffcb upstream.

lockdep reports a deadlock in jfs because a special inode's rw semaphore
is taken recursively.  The mapping's gfp mask is GFP_NOFS, but is not
used when __read_cache_page() calls add_to_page_cache_lru().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1675,7 +1675,7 @@ repeat:
 		page = __page_cache_alloc(gfp | __GFP_COLD);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
-		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		err = add_to_page_cache_lru(page, mapping, index, gfp);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			if (err == -EEXIST)
@@ -1772,10 +1772,7 @@ static struct page *wait_on_page_read(st
  * @gfp:	the page allocator flags to use if allocating
  *
  * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags. Note
- * that the Radix tree operations will still use GFP_KERNEL, so you can't
- * expect to do this atomically or anything like that - but you can pass in
- * other page requirements.
+ * any new page allocations done using the specified allocation flags.
  *
  * If the page does not get brought uptodate, return -EIO.
  */


