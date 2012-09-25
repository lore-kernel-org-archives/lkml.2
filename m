Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2IYVjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:39:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab2IYVjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:39:33 -0400
Date: Tue, 25 Sep 2012 14:39:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Richard Davies <richard@arachsys.com>,
        Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] mm: compaction: Acquire the zone->lru_lock as late
 as possible
Message-Id: <20120925143931.f404ca22.akpm@linux-foundation.org>
In-Reply-To: <20120925081327.GA7759@bbox>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
	<1348224383-1499-6-git-send-email-mgorman@suse.de>
	<20120925070517.GK13234@bbox>
	<20120925075105.GC11266@suse.de>
	<20120925081327.GA7759@bbox>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 17:13:27 +0900
Minchan Kim <minchan@kernel.org> wrote:

> I see. To me, your saying is better than current comment.
> I hope comment could be more explicit.
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index df01b4e..f1d2cc7 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -542,8 +542,9 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>                  * splitting and collapsing (collapsing has already happened
>                  * if PageLRU is set) but the lock is not necessarily taken
>                  * here and it is wasteful to take it just to check transhuge.
> -                * Check transhuge without lock and skip if it's either a
> -                * transhuge or hugetlbfs page.
> +                * Check transhuge without lock and *skip* if it's either a
> +                * transhuge or hugetlbfs page because it's not safe to call
> +                * compound_order.
>                  */
>                 if (PageTransHuge(page)) {
>                         if (!locked)

Going a bit further:

--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix
+++ a/mm/compaction.c
@@ -415,7 +415,8 @@ isolate_migratepages_range(struct zone *
 		 * if PageLRU is set) but the lock is not necessarily taken
 		 * here and it is wasteful to take it just to check transhuge.
 		 * Check transhuge without lock and skip if it's either a
-		 * transhuge or hugetlbfs page.
+		 * transhuge or hugetlbfs page because calling compound_order()
+		 * requires lru_lock to exclude isolation and splitting.
 		 */
 		if (PageTransHuge(page)) {
 			if (!locked)
_


but...  the requirement to hold lru_lock for compound_order() is news
to me.  It doesn't seem to be written down or explained anywhere, and
one wonders why the cheerily undocumented compound_lock() doesn't have
this effect.  What's going on here??

