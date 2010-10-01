Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0JAFFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:05:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17105 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0JAFFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AE3R2kLN6V0ARIcNpK9Ma9DBlsAd9ldUeXjmMlmgOa9o3qKdGUxvLqB+p+IYF+leZu
         56mq9dVefNHKplqMlRoA==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 1/2] Unique path for locking page in filemap_fault()
Date: Thu, 30 Sep 2010 22:04:43 -0700
Message-Id: <1285909484-30958-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285909484-30958-1-git-send-email-walken@google.com>
References: <1285909484-30958-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that if the file got truncated before we locked the page, we retry
at find_get_page(). This is similar to what find_lock_page() would do.
Linus's commit ef00e08e introduced a goto no_cached_page in that simuation,
which seems correct as well but possibly less efficient ?

----------------------- >8 ------------------------

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
