Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2AXLAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:00:22 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40412 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2AXLAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:00:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120123170354.82b9f127.akpm@linux-foundation.org>
References: <CAJd=RBDVxT5Pc2HZjz15LUb7xhFbztpFmXqLXVB3nCoQLKHiHg@mail.gmail.com>
	<20120123170354.82b9f127.akpm@linux-foundation.org>
Date: Tue, 24 Jan 2012 19:00:19 +0800
Message-ID: <CAJd=RBByNhLSiBtyaYOHeMRQpXmAO=hEKTOanPTzrb2gRZTOSg@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: fix malused nr_reclaimed in shrinking zone
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 9:03 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Well, let's step back and look at it.
>
> - The multiple-definitions-of-a-local-per-line thing is generally a
>  bad idea, partly because it prevents people from adding comments to
>  the definition.  It would be better like this:
>
>        unsigned long reclaimed = 0;    /* total for this function */
>        unsigned long nr_reclaimed = 0; /* on each pass through the loop */
>
> - The names of these things are terrible!  Why not
>  reclaimed_this_pass and reclaimed_total or similar?
>
> - It would be cleaner to do the "reclaimed += nr_reclaimed" at the
>  end of the loop, if we've decided to goto restart.  (But better
>  to do it within the loop!)
>
> - Only need to update sc->nr_reclaimed at the end of the function
>  (assumes that callees of this function aren't interested in
>  sc->nr_reclaimed, which seems a future-safe assumption to me).
>
> - Should be able to avoid the temporary addition of nr_reclaimed to
>  reclaimed inside the loop by updating `reclaimed' at an appropriate
>  place.
>
>
> Or whatever.  That code's handling of `reclaimed' and `nr_reclaimed' is
> a twisty mess.  Please clean it up!  If it is done correctly,
> `nr_reclaimed' can (and should) be local to the internal loop.

Hi Andrew

The mess is cleaned up, please review again.

Thanks
Hillf


===cut here===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: vmscan: fix malused nr_reclaimed in shrinking zone

The value of nr_reclaimed is the amount of pages reclaimed in the current
round of loop, whereas nr_to_reclaim should be compared with pages reclaimed
in all rounds.

In each round of loop, reclaimed pages are cut off from the reclaim goal,
and loop stops once goal achieved.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Mon Jan 23 00:23:10 2012
+++ b/mm/vmscan.c	Tue Jan 24 17:10:34 2012
@@ -2113,7 +2113,12 @@ restart:
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
+		if (nr_reclaimed >= nr_to_reclaim)
+			nr_to_reclaim = 0;
+		else
+			nr_to_reclaim -= nr_reclaimed;
+
+		if (!nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
 	blk_finish_plug(&plug);
