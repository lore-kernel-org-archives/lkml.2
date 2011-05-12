Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab1ELWP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:15:27 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:40824 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1ELWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:15:26 -0400
Date: Fri, 13 May 2011 00:15:06 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Message-ID: <20110512221506.GM16531@cmpxchg.org>
References: <1305127773-10570-4-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1105120942050.24560@router.home>
 <1305213359.2575.46.camel@mulgrave.site>
 <alpine.DEB.2.00.1105121024350.26013@router.home>
 <1305214993.2575.50.camel@mulgrave.site>
 <1305215742.27848.40.camel@jaguar>
 <1305225467.2575.66.camel@mulgrave.site>
 <1305229447.2575.71.camel@mulgrave.site>
 <1305230652.2575.72.camel@mulgrave.site>
 <1305237882.2575.100.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305237882.2575.100.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 05:04:41PM -0500, James Bottomley wrote:
> On Thu, 2011-05-12 at 15:04 -0500, James Bottomley wrote:
> > Confirmed, I'm afraid ... I can trigger the problem with all three
> > patches under PREEMPT.  It's not a hang this time, it's just kswapd
> > taking 100% system time on 1 CPU and it won't calm down after I unload
> > the system.
> 
> Just on a "if you don't know what's wrong poke about and see" basis, I
> sliced out all the complex logic in sleeping_prematurely() and, as far
> as I can tell, it cures the problem behaviour.  I've loaded up the
> system, and taken the tar load generator through three runs without
> producing a spinning kswapd (this is PREEMPT).  I'll try with a
> non-PREEMPT kernel shortly.
> 
> What this seems to say is that there's a problem with the complex logic
> in sleeping_prematurely().  I'm pretty sure hacking up
> sleeping_prematurely() just to dump all the calculations is the wrong
> thing to do, but perhaps someone can see what the right thing is ...

I think I see the problem: the boolean logic of sleeping_prematurely()
is odd.  If it returns true, kswapd will keep running.  So if
pgdat_balanced() returns true, kswapd should go to sleep.

This?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2b701e0..092d773 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2261,7 +2261,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
 	 * must be balanced
 	 */
 	if (order)
-		return pgdat_balanced(pgdat, balanced, classzone_idx);
+		return !pgdat_balanced(pgdat, balanced, classzone_idx);
 	else
 		return !all_zones_ok;
 }
