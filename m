Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab0JEHyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:54:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab0JEHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XORvb6gkFWWIBTOMF1UVPBeMJDNmxuotiUDqmCHfsbSn3P1adrk/ZLJaU8RGeEgsmy
         UMMjDLdbtUy0A9OCLhiA==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] filemap_fault: unique path for locking page
Date: Tue,  5 Oct 2010 00:53:33 -0700
Message-Id: <1286265215-9025-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286265215-9025-1-git-send-email-walken@google.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change introduces a single location where filemap_fault() locks
the desired page. There used to be two such places, depending if the
initial find_get_page() was successful or not.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/filemap.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3d4df44..8ed709a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1539,25 +1539,27 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		 * waiting for the lock.
 		 */
 		do_async_mmap_readahead(vma, ra, file, page, offset);
-		lock_page(page);
-
-		/* Did it get truncated? */
-		if (unlikely(page->mapping != mapping)) {
-			unlock_page(page);
-			put_page(page);
-			goto no_cached_page;
-		}
 	} else {
 		/* No page in the page cache at all */
 		do_sync_mmap_readahead(vma, ra, file, offset);
 		count_vm_event(PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
 retry_find:
-		page = find_lock_page(mapping, offset);
+		page = find_get_page(mapping, offset);
 		if (!page)
 			goto no_cached_page;
 	}
 
+	lock_page(page);
+
+	/* Did it get truncated? */
+	if (unlikely(page->mapping != mapping)) {
+		unlock_page(page);
+		put_page(page);
+		goto retry_find;
+	}
+	VM_BUG_ON(page->index != offset);
+
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
-- 
1.7.1
