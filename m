Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab0EXXbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:31:50 -0400
Received: from kroah.org ([198.145.64.141]:59316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab0EXXX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:27 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:13 2010
Message-Id: <20100524231813.566722586@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: [04/39] hugetlbfs: kill applications that use MAP_NORESERVE with SIGBUS instead of OOM-killer
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mel Gorman <mel@csn.ul.ie>

commit 4a6018f7f4f1075c1a5403b5ec0ee7262187b86c upstream.

Ordinarily, application using hugetlbfs will create mappings with
reserves.  For shared mappings, these pages are reserved before mmap()
returns success and for private mappings, the caller process is guaranteed
and a child process that cannot get the pages gets killed with sigbus.

An application that uses MAP_NORESERVE gets no reservations and mmap()
will always succeed at the risk the page will not be available at fault
time.  This might be used for example on very large sparse mappings where
the developer is confident the necessary huge pages exist to satisfy all
faults even though the whole mapping cannot be backed by huge pages.
Unfortunately, if an allocation does fail, VM_FAULT_OOM is returned to the
fault handler which proceeds to trigger the OOM-killer.  This is
unhelpful.

Even without hugetlbfs mounted, a user using mmap() can trivially trigger
the OOM-killer because VM_FAULT_OOM is returned (will provide example
program if desired - it's a whopping 24 lines long).  It could be
considered a DOS available to an unprivileged user.

This patch alters hugetlbfs to kill a process that uses MAP_NORESERVE
where huge pages were not available with SIGBUS instead of triggering the
OOM killer.

This change affects hugetlb_cow() as well.  I feel there is a failure case
in there, but I didn't create one.  It would need a fairly specific target
in terms of the faulting application and the hugepage pool size.  The
hugetlb_no_page() path is much easier to hit but both might as well be
closed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1039,7 +1039,7 @@ static struct page *alloc_huge_page(stru
 		page = alloc_buddy_huge_page(h, vma, addr);
 		if (!page) {
 			hugetlb_put_quota(inode->i_mapping, chg);
-			return ERR_PTR(-VM_FAULT_OOM);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 		}
 	}
 


