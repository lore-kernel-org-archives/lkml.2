Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2JCVKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:10:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43577 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2JCVKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:10:44 -0400
Date: Wed, 3 Oct 2012 14:10:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch -mm] mm, thp: fix mlock statistics fix
In-Reply-To: <20121003131012.f88b0d66.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1210031403270.4352@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1209191818490.7879@chino.kir.corp.google.com> <alpine.LSU.2.00.1209192021270.28543@eggly.anvils> <alpine.DEB.2.00.1209261821380.7745@chino.kir.corp.google.com> <alpine.DEB.2.00.1209261929270.8567@chino.kir.corp.google.com>
 <alpine.LSU.2.00.1209271814340.2107@eggly.anvils> <20121003131012.f88b0d66.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Andrew Morton wrote:

> The free_page_mlock() hunk gets dropped because free_page_mlock() is
> removed.  And clear_page_mlock() doesn't need this treatment.  But
> please check my handiwork.
> 

I reviewed what was merged into -mm and clear_page_mlock() does need this 
fix as well.  It's an easy fix, there's no need to pass "anon" into 
clear_page_mlock() since PageHuge() is already checked in its only caller.


mm, thp: fix mlock statistics fix

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mlock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -56,7 +56,8 @@ void clear_page_mlock(struct page *page)
 	if (!TestClearPageMlocked(page))
 		return;
 
-	dec_zone_page_state(page, NR_MLOCK);
+	mod_zone_page_state(page_zone(page), NR_MLOCK,
+			    -hpage_nr_pages(page));
 	count_vm_event(UNEVICTABLE_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
