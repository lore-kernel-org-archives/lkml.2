Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0DTRo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:44:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48095 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab0DTRo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:44:28 -0400
Date: Tue, 20 Apr 2010 18:44:07 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] hugetlbfs: Kill applications that use MAP_NORESERVE with
	SIGBUS instead of OOM-killer
Message-ID: <20100420174407.GA30306@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ordinarily, application using hugetlbfs will create mappings with
reserves. For shared mappings, these pages are reserved before mmap()
returns success and for private mappings, the caller process is
guaranteed and a child process that cannot get the pages gets killed
with sigbus.

An application that uses MAP_NORESERVE gets no reservations and mmap()
will always succeed at the risk the page will not be available at fault
time. This might be used for example on very large sparse mappings where the
developer is confident the necessary huge pages exist to satisfy all faults
even though the whole mapping cannot be backed by huge pages.  Unfortunately,
if an allocation does fail, VM_FAULT_OOM is returned to the fault handler
which proceeds to trigger the OOM-killer. This is unhelpful.

This patch alters hugetlbfs to kill a process that uses MAP_NORESERVE
where huge pages were not available with SIGBUS instead of triggering
the OOM killer.

This patch if accepted should also be considered a -stable candidate.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/hugetlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6034dc9..af2d907 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1038,7 +1038,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page(h, vma, addr);
 		if (!page) {
 			hugetlb_put_quota(inode->i_mapping, chg);
-			return ERR_PTR(-VM_FAULT_OOM);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 		}
 	}
 
