Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1JSAFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:05:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1JSAFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:05:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=v3sche3hkICG2LJkLJHm0ycE4FWP3GWjuFunsjUM0L+BMeU5aFlBUmvwcZyqxkmTV
	rQ/eZzXNhf3iEgp08uP/w==
Date: Tue, 18 Oct 2011 17:02:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: munlock use mapcount to avoid terrible overhead
Message-ID: <alpine.LSU.2.00.1110181700400.3361@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A process spent 30 minutes exiting, just munlocking the pages of a large
anonymous area that had been alternately mprotected into page-sized vmas:
for every single page there's an anon_vma walk through all the other
little vmas to find the right one.

A general fix to that would be a lot more complicated (use prio_tree on
anon_vma?), but there's one very simple thing we can do to speed up the
common case: if a page to be munlocked is mapped only once, then it is
our vma that it is mapped into, and there's no need whatever to walk
through all the others.

Okay, there is a very remote race in munlock_vma_pages_range(), if
between its follow_page() and lock_page(), another process were to
munlock the same page, then page reclaim remove it from our vma, then
another process mlock it again.  We would find it with page_mapcount
1, yet it's still mlocked in another process.  But never mind, that's
much less likely than the down_read_trylock() failure which munlocking
already tolerates (in try_to_unmap_one()): in due course page reclaim
will discover and move the page to unevictable instead.
    
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 3.1-rc10/mm/mlock.c	2011-07-21 19:17:23.000000000 -0700
+++ linux/mm/mlock.c	2011-10-06 12:47:54.670436979 -0700
@@ -110,7 +110,10 @@ void munlock_vma_page(struct page *page)
 	if (TestClearPageMlocked(page)) {
 		dec_zone_page_state(page, NR_MLOCK);
 		if (!isolate_lru_page(page)) {
-			int ret = try_to_munlock(page);
+			int ret = SWAP_AGAIN;
+
+			if (page_mapcount(page) > 1)
+				ret = try_to_munlock(page);
 			/*
 			 * did try_to_unlock() succeed or punt?
 			 */
