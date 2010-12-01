Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0LAXVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:21:35 -0500
Received: from mx2.netapp.com ([216.240.18.37]:48914 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab0LAXVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:21:34 -0500
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="489748026"
Subject: Re: [PATCH v2 3/3] NFS: Fix a memory leak in nfs_readdir
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1291243633.6609.59.camel@heimdal.trondhjem.org>
References: <1291217804-11257-1-git-send-email-Trond.Myklebust@netapp.com>
	 <1291217804-11257-2-git-send-email-Trond.Myklebust@netapp.com>
	 <20101201150428.GA2879@elliptictech.com>
	 <1291217804-11257-3-git-send-email-Trond.Myklebust@netapp.com>
	 <1291217804-11257-4-git-send-email-Trond.Myklebust@netapp.com>
	 <AANLkTi=C8UtWwctEgBY2584d8fDV3OHpf+mGNnQO8ZJt@mail.gmail.com>
	 <1291229669.6609.24.camel@heimdal.trondhjem.org>
	 <AANLkTinsEeKK9LykVAVq60Lsb3caLDJasnKH8kcgSFVp@mail.gmail.com>
	 <1291234251.6609.39.camel@heimdal.trondhjem.org>
	 <20101201123341.d12ef362.akpm@linux-foundation.org>
	 <alpine.LSU.2.00.1012011258220.18662@tigran.mtv.corp.google.com>
	 <alpine.LSU.2.00.1012011311590.18920@tigran.mtv.corp.google.com>
	 <20101201133831.ea6ba10a.akpm@linux-foundation.org>
	 <1291240272.6609.50.camel@heimdal.trondhjem.org>
	 <20101201141351.8609140b.akpm@linux-foundation.org>
	 <AANLkTimgZPET+T16Qpj_KnpCu==97g-8+_y5dtjNOrxG@mail.gmail.com>
	 <20101201143856.51f4f9d9.akpm@linux-foundation.org>
	 <1291243633.6609.59.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Wed, 01 Dec 2010 18:21:16 -0500
Message-ID: <1291245676.6609.62.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 01 Dec 2010 23:21:17.0355 (UTC) FILETIME=[7468BFB0:01CB91AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 17:47 -0500, Trond Myklebust wrote:
> However, Linus' explanation appears to answer one of Hugh's objections:
> we can apparently use a preempt-disable() in order to ensure that the
> module containing the mapping->a_ops is not unloaded until after the
> ->freepage() call is complete.
> 
> That would imply that ->freepage() cannot sleep, but I don't think that
> is too nasty a restriction.

Revised patch would be as follows...

----------------------------------------------------------------------------------------
>From 1cd6bf106ef40dec415e375eb3632b9a84a72d5f Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Dec 2010 13:35:19 -0500
Subject: [PATCH] Call the filesystem back whenever a page is removed from the page cache

NFS needs to be able to release objects that are stored in the page
cache once the page itself is no longer visible from the page cache.

This patch adds a callback to the address space operations that allows
filesystems to perform page cleanups once the page has been removed
from the page cache.

Original patch by: Linus Torvalds <torvalds@linux-foundation.org>
[trondmy: cover the cases of invalidate_inode_pages2() and
          truncate_inode_pages()]
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 Documentation/filesystems/Locking |    7 ++++++-
 Documentation/filesystems/vfs.txt |    7 +++++++
 include/linux/fs.h                |    1 +
 mm/truncate.c                     |    8 ++++++++
 mm/vmscan.c                       |   11 +++++++++++
 5 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index a91f308..b6426f1 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -173,12 +173,13 @@ prototypes:
 	sector_t (*bmap)(struct address_space *, sector_t);
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
+	void (*freepage)(struct page *);
 	int (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs);
 	int (*launder_page) (struct page *);
 
 locking rules:
-	All except set_page_dirty may block
+	All except set_page_dirty and freepage may block
 
 			BKL	PageLocked(page)	i_mutex
 writepage:		no	yes, unlocks (see below)
@@ -193,6 +194,7 @@ perform_write:		no	n/a			yes
 bmap:			no
 invalidatepage:		no	yes
 releasepage:		no	yes
+freepage:		no	yes
 direct_IO:		no
 launder_page:		no	yes
 
@@ -288,6 +290,9 @@ buffers from the page in preparation for freeing it.  It returns zero to
 indicate that the buffers are (or may be) freeable.  If ->releasepage is zero,
 the kernel assumes that the fs has no private interest in the buffers.
 
+	->freepage() is called when the kernel is done dropping the page
+from the page cache.
+
 	->launder_page() may be called prior to releasing a page if
 it is still found to be dirty. It returns zero if the page was successfully
 cleaned, or an error value if not. Note that in order to prevent the page
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index ed7e5ef..3b14a55 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -534,6 +534,7 @@ struct address_space_operations {
 	sector_t (*bmap)(struct address_space *, sector_t);
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
+	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs);
 	struct page* (*get_xip_page)(struct address_space *, sector_t,
@@ -679,6 +680,12 @@ struct address_space_operations {
         need to ensure this.  Possibly it can clear the PageUptodate
         bit if it cannot free private data yet.
 
+  freepage: freepage is called once the page is no longer visible in
+        the page cache in order to allow the cleanup of any private
+	data. Since it may be called by the memory reclaimer, it
+	should not assume that the original address_space mapping still
+	exists, and it should not block.
+
   direct_IO: called by the generic read/write routines to perform
         direct_IO - that is IO requests which bypass the page cache
         and transfer data directly between the storage and the
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c9e06cc..090f0ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -602,6 +602,7 @@ struct address_space_operations {
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, gfp_t);
+	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
diff --git a/mm/truncate.c b/mm/truncate.c
index ba887bf..76ab2a8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -108,6 +108,10 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	clear_page_mlock(page);
 	remove_from_page_cache(page);
 	ClearPageMappedToDisk(page);
+
+	if (mapping->a_ops->freepage)
+		mapping->a_ops->freepage(page);
+
 	page_cache_release(page);	/* pagecache ref */
 	return 0;
 }
@@ -390,6 +394,10 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
+
+	if (mapping->a_ops->freepage)
+		mapping->a_ops->freepage(page);
+
 	page_cache_release(page);	/* pagecache ref */
 	return 1;
 failed:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d31d7ce..9e218e7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -454,6 +454,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
+	preempt_disable();
 	spin_lock_irq(&mapping->tree_lock);
 	/*
 	 * The non racy check for a busy page.
@@ -492,10 +493,19 @@ static int __remove_mapping(struct address_space *mapping, struct page *page)
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
+		preempt_enable();
 		swapcache_free(swap, page);
 	} else {
+		void (*freepage)(struct page *);
+
+		freepage = mapping->a_ops->freepage;
+
 		__remove_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
+		if (freepage != NULL)
+			freepage(page);
+		preempt_enable();
+
 		mem_cgroup_uncharge_cache_page(page);
 	}
 
@@ -503,6 +513,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page)
 
 cannot_free:
 	spin_unlock_irq(&mapping->tree_lock);
+	preempt_enable();
 	return 0;
 }
 
-- 
1.7.3.2



-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

