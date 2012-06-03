Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2FCWNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 18:13:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab2FCWNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 18:13:43 -0400
Date: Sun, 3 Jun 2012 18:13:26 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
Message-ID: <20120603221326.GA7707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20120601161205.GA1918@redhat.com>
 <20120601171606.GA3794@redhat.com>
 <alpine.LSU.2.00.1206011511560.12839@eggly.anvils>
 <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com>
 <alpine.LSU.2.00.1206012108430.11308@eggly.anvils>
 <20120603181548.GA306@redhat.com>
 <CA+55aFwZ5PsBLqM7K8vDQdbS3sf+vi3yeoWx6XKV=nF8k2r7DQ@mail.gmail.com>
 <20120603183139.GA1061@redhat.com>
 <20120603205332.GA5412@redhat.com>
 <CA+55aFzjuPTBNGkMohmy+AzvvB9S_aEUOpG2nD-WjS9YGdQV0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzjuPTBNGkMohmy+AzvvB9S_aEUOpG2nD-WjS9YGdQV0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 02:59:22PM -0700, Linus Torvalds wrote:
 > On Sun, Jun 3, 2012 at 1:53 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > running just over two hours with that commit reverted with no obvious ill effects so far.
 > 
 > And how quickly have you usually seen the problems? Would you have
 > considered two ours "good" in your bisection thing?

Yeah, usually see something go awry in an hour or less.

 > Also, just to check: Hugh sent out a patch called "mm: fix warning in
 > __set_page_dirty_nobuffers". Is that applied in your tree too, or did
 > the __set_page_dirty_nobuffers() warning go away with just the revert?

That is applied. Otherwise I see the warning he refers to.

 > I'm just trying to figure out exactly what you are testing. When you
 > said "test with that (and Hugh's last patch) backed out", the "and
 > Hugh's last patch" part was a bit ambiguous. Do you mean the trial
 > patch in this thread (backed out) or do you mean "*with* Hugh's patch
 > for the __set_page_dirty_nobuffers() warning".

The former.  (This).

--- 3.4.0+/mm/compaction.c      2012-05-30 08:17:19.396008280 -0700
+++ linux/mm/compaction.c       2012-06-01 20:59:56.840204915 -0700
@@ -369,6 +369,8 @@ static bool rescue_unmovable_pageblock(s
 {
  	unsigned long pfn, start_pfn, end_pfn;
       	struct page *start_page, *end_page;
+       struct zone *zone;
+       unsigned long flags;

        pfn = page_to_pfn(page);
        start_pfn = pfn & ~(pageblock_nr_pages - 1);
@@ -378,7 +380,8 @@ static bool rescue_unmovable_pageblock(s
        end_page = pfn_to_page(end_pfn);

        /* Do not deal with pageblocks that overlap zones */
-       if (page_zone(start_page) != page_zone(end_page))
+       zone = page_zone(start_page);
+       if (zone != page_zone(end_page))
                return false;

        for (page = start_page, pfn = start_pfn; page < end_page; pfn++,
@@ -399,8 +402,10 @@ static bool rescue_unmovable_pageblock(s
                return false;
        }

+       spin_lock_irqsave(&zone->lock, flags);
        set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-       move_freepages_block(page_zone(page), page, MIGRATE_MOVABLE);
+       move_freepages_block(zone, page, MIGRATE_MOVABLE);
+       spin_unlock_irqrestore(&zone->lock, flags);
        return true;



I do see something else weird going on, but it seems like an unrelated problem.
I have a lot of processes hanging after calling sys_renameat.

I'll dig some more on that, and post a follow-up.

	Dave


