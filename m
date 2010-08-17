Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0HQC6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:58:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0HQC6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:58:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FYg428N8Hw1IoJMs/A5R20iLqEIjUVIHLCV+xYmK61Hh4KoTSU/HwC8ZnsD/tAFRr
	m2cezfQI+QmsSNwpvGZJw==
Date: Mon, 16 Aug 2010 19:58:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Altaparmakov <aia21@cantab.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [patch 5/6] ntfs: remove dependency on __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008161956500.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
caller.

Instead of maintaining a seperate _nofail() variant, it's possible to
remove it and use ntfs_malloc_nofs() instead.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/ntfs/malloc.h  |   17 -----------------
 fs/ntfs/runlist.c |    6 ++++--
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/fs/ntfs/malloc.h b/fs/ntfs/malloc.h
--- a/fs/ntfs/malloc.h
+++ b/fs/ntfs/malloc.h
@@ -66,23 +66,6 @@ static inline void *ntfs_malloc_nofs(unsigned long size)
 	return __ntfs_malloc(size, GFP_NOFS | __GFP_HIGHMEM);
 }
 
-/**
- * ntfs_malloc_nofs_nofail - allocate memory in multiples of pages
- * @size:	number of bytes to allocate
- *
- * Allocates @size bytes of memory, rounded up to multiples of PAGE_SIZE and
- * returns a pointer to the allocated memory.
- *
- * This function guarantees that the allocation will succeed.  It will sleep
- * for as long as it takes to complete the allocation.
- *
- * If there was insufficient memory to complete the request, return NULL.
- */
-static inline void *ntfs_malloc_nofs_nofail(unsigned long size)
-{
-	return __ntfs_malloc(size, GFP_NOFS | __GFP_HIGHMEM | __GFP_NOFAIL);
-}
-
 static inline void ntfs_free(void *addr)
 {
 	if (!is_vmalloc_addr(addr)) {
diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -127,8 +127,10 @@ static inline runlist_element *ntfs_rl_realloc_nofail(runlist_element *rl,
 	if (old_size == new_size)
 		return rl;
 
-	new_rl = ntfs_malloc_nofs_nofail(new_size);
-	BUG_ON(!new_rl);
+	do {
+		/* FIXME: this may potentially loop forever */
+		new_rl = ntfs_malloc_nofs(new_size);
+	} while (!new_rl);
 
 	if (likely(rl != NULL)) {
 		if (unlikely(old_size > new_size))
