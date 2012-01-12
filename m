Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2ALNjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 08:39:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64711 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2ALNja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 08:39:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1201111351080.1846@eggly.anvils>
References: <CAJd=RBAiAfyXBcn+9WO6AERthyx+C=cNP-romp9YJO3Hn7-U-g@mail.gmail.com>
	<alpine.LSU.2.00.1201111351080.1846@eggly.anvils>
Date: Thu, 12 Jan 2012 21:39:27 +0800
Message-ID: <CAJd=RBC6zXtN1uQMxJJxGGHrXH5xUAeDWGzoEazbVAdRXo9F0Q@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: deactivate isolated pages with lru lock released
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh

Thanks for your comment.

On Thu, Jan 12, 2012 at 6:33 AM, Hugh Dickins <hughd@google.com> wrote:
> On Wed, 11 Jan 2012, Hillf Danton wrote:
>
>> Spinners on other CPUs, if any, could take the lru lock and do their jobs while
>> isolated pages are deactivated on the current CPU if the lock is released
>> actively. And no risk of race raised as pages are already queued on locally
>> private list.
>
> You make a good point - except, I'm afraid as usual, I have difficulty
> in understanding your comment, in separating how it is before your change
> and how it is after your change.  Above you're describing how it is after
> your change; and it would help if you point out that you're taking the
> lock off clear_active_flags(), which goes all the way down the list of
> pages we isolated (to a locally private list, yes, important point).
>
> However... this patch is based on Linus's current, and will clash with a
> patch of mine presently in akpm's tree - which I'm expecting will go on
> to Linus soon, unless Andrew discards it in favour of yours (that might
> involve a little unravelling, I didn't look).  Among other rearrangements,
> I merged the code from clear_active_flags() into update_isolated_counts().
>
> And something that worries me is that you're now dropping the spinlock
> and reacquiring it shortly afterwards, just clear_active_flags in between.
> That may bounce the lock around more than before, and actually prove worse.
>

Yes, there is change introduced in locking behavior, and if it is already hot,
last acquiring it maybe a lucky accident due to that bounce(in your term).

The same lock is also encountered when isolating pages for migration, and I am
currently attempting to copy that lock mode to reclaim, based on the assumption
that bounce could be cured with bounce 8-) and preparing for incoming complains.

Though a hot lock, tiny window remains open for tiny tackle, for example the
attached diff.

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Thu Jan 12 20:48:42 2012
@@ -1032,6 +1032,12 @@ keep_lumpy:
 	return nr_reclaimed;
 }

+static bool is_all_lru_mode(isolate_mode_t mode)
+{
+	return (mode & (ISOLATE_ACTIVE|ISOLATE_INACTIVE)) ==
+			(ISOLATE_ACTIVE|ISOLATE_INACTIVE);
+}
+
 /*
  * Attempt to remove the specified page from its LRU.  Only take this page
  * if it is of the appropriate PageActive status.  Pages which are being
@@ -1051,8 +1057,7 @@ int __isolate_lru_page(struct page *page
 	if (!PageLRU(page))
 		return ret;

-	all_lru_mode = (mode & (ISOLATE_ACTIVE|ISOLATE_INACTIVE)) ==
-		(ISOLATE_ACTIVE|ISOLATE_INACTIVE);
+	all_lru_mode = is_all_lru_mode(mode);

 	/*
 	 * When checking the active state, we need to be sure we are
@@ -1155,6 +1160,13 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_lumpy_dirty = 0;
 	unsigned long nr_lumpy_failed = 0;
 	unsigned long scan;
+
+	/* Try to save a few cycles mainly due to lru_lock held and irq off,
+	 * no bother attempting pfn-based isolation if pages only on the given
+	 * src list could be taken.
+	 */
+	if (order && !is_all_lru_mode(mode))
+		order = 0;

 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		struct page *page;
--


> I suspect that your patch can be improved, to take away that worry.
> Why do we need to take the lock again?  Only to update reclaim_stat:
> for the other stats, interrupts disabled is certainly good enough,
> and more research might show that preemption disabled would be enough.
>
> get_scan_count() is called at the (re)start of shrink_mem_cgroup_zone(),
> before it goes down to do shrink_list()s: I think it would not be harmed
> at all if we delayed updating reclaim_stat->recent_scanned until the
> next time we take the lock, lower down.
>

Dunno how to handle the tons of __mod_zone_page_state() or similar without lock
protection 8-/ try to deffer updating reclaim_stat soon.

> Other things that strike me, looking here again: isn't it the case that
> update_isolated_counts() is actually called either for file or for anon,
> but never for both?

No, see the above diff please 8-)

> We might be able to make savings from that, perhaps
> enlist help from isolate_lru_pages() to avoid having to go down the list
> again to clear active flags.
>

Best regards
Hillf
