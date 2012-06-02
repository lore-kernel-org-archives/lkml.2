Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966419Ab2FBH2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:28:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34037 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966396Ab2FBH2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:28:07 -0400
Date: Sat, 2 Jun 2012 00:27:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dave Jones <davej@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: fix warning in __set_page_dirty_nobuffers
In-Reply-To: <alpine.LSU.2.00.1206020021280.1376@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1206020023340.1376@eggly.anvils>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com> <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com>
 <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com> <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <20120602071730.GB329@x4> <alpine.LSU.2.00.1206020021280.1376@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New tmpfs use of !PageUptodate pages for fallocate() is triggering the
WARNING: at mm/page-writeback.c:1990 when __set_page_dirty_nobuffers()
is called from migrate_page_copy() for compaction.

It is anomalous that migration should use __set_page_dirty_nobuffers()
on an address_space that does not participate in dirty and writeback
accounting; and this has also been observed to insert surprising dirty
tags into a tmpfs radix_tree, despite tmpfs not using tags at all.

We should probably give migrate_page_copy() a better way to preserve
the tag and migrate accounting info, when mapping_cap_account_dirty().
But that needs some more work: so in the interim, avoid the warning
by using a simple SetPageDirty on PageSwapBacked pages.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 3.4.0+/mm/migrate.c	2012-05-27 10:01:43.104049010 -0700
+++ linux/mm/migrate.c	2012-06-01 00:10:58.080098749 -0700
@@ -436,7 +436,10 @@ void migrate_page_copy(struct page *newp
 		 * is actually a signal that all of the page has become dirty.
 		 * Whereas only part of our page may be dirty.
 		 */
-		__set_page_dirty_nobuffers(newpage);
+		if (PageSwapBacked(page))
+			SetPageDirty(newpage);
+		else
+			__set_page_dirty_nobuffers(newpage);
  	}
 
 	mlock_migrate_page(newpage, page);
