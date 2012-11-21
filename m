Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2KUTPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:15:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab2KUTPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:15:53 -0500
Date: Wed, 21 Nov 2012 19:15:47 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 36/46] mm: numa: Use a two-stage filter to restrict pages
 being migrated for unlikely task<->node relationships
Message-ID: <20121121191547.GM8218@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <1353493312-8069-37-git-send-email-mgorman@suse.de>
 <20121121182537.GB29893@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121121182537.GB29893@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 07:25:37PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > While it is desirable that all threads in a process run on its home
> > node, this is not always possible or necessary. There may be more
> > threads than exist within the node or the node might over-subscribed
> > with unrelated processes.
> > 
> > This can cause a situation whereby a page gets migrated off its home
> > node because the threads clearing pte_numa were running off-node. This
> > patch uses page->last_nid to build a two-stage filter before pages get
> > migrated to avoid problems with short or unlikely task<->node
> > relationships.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  mm/mempolicy.c |   30 +++++++++++++++++++++++++++++-
> >  1 file changed, 29 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 4c1c8d8..fd20e28 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2317,9 +2317,37 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
> >  	}
> >  
> >  	/* Migrate the page towards the node whose CPU is referencing it */
> > -	if (pol->flags & MPOL_F_MORON)
> > +	if (pol->flags & MPOL_F_MORON) {
> > +		int last_nid;
> > +
> >  		polnid = numa_node_id();
> >  
> > +		/*
> > +		 * Multi-stage node selection is used in conjunction
> > +		 * with a periodic migration fault to build a temporal
> > +		 * task<->page relation. By using a two-stage filter we
> > +		 * remove short/unlikely relations.
> > +		 *
> > +		 * Using P(p) ~ n_p / n_t as per frequentist
> > +		 * probability, we can equate a task's usage of a
> > +		 * particular page (n_p) per total usage of this
> > +		 * page (n_t) (in a given time-span) to a probability.
> > +		 *
> > +		 * Our periodic faults will sample this probability and
> > +		 * getting the same result twice in a row, given these
> > +		 * samples are fully independent, is then given by
> > +		 * P(n)^2, provided our sample period is sufficiently
> > +		 * short compared to the usage pattern.
> > +		 *
> > +		 * This quadric squishes small probabilities, making
> > +		 * it less likely we act on an unlikely task<->page
> > +		 * relation.
> > +		 */
> > +		last_nid = page_xchg_last_nid(page, polnid);
> > +		if (last_nid != polnid)
> > +			goto out;
> > +	}
> > +
> >  	if (curnid != polnid)
> >  		ret = polnid;
> >  out:
> 
> As mentioned in my other mail, this patch of yours looks very 
> similar to the numa/core commit attached below, mostly written 
> by Peter:
> 
>   30f93abc6cb3 sched, numa, mm: Add the scanning page fault machinery
> 

My patch is directly based on that particular patch and is a partial
extraction. I could not directly pull which is why the From is missing. I
think you'll also find that it's very similar to a partial extraction
from "autonuma: memory follows CPU algorithm and task/mm_autonuma stats
collection". The primary differences are exactly how the logic is applied
and when it happens.

I've added a note now to that effect now. For all the patches with notes
or any other ones, I'll be very happy to add the Signed-offs back on if
the original authors acknowledge they are ok with the end result. If you
recall, in the original V1 of this series I said;

	This series steals very heavily from both autonuma and schednuma
	with very little original code. In some cases I removed the
	signed-off-bys because the result was too different. I have noted
	in the changelog where this happened but the signed-offs can be
	restored if the original authors agree.

Just to compare, this is the wording in "autonuma: memory follows CPU
algorithm and task/mm_autonuma stats collection"

+/*
+ * In this function we build a temporal CPU_node<->page relation by
+ * using a two-stage autonuma_last_nid filter to remove short/unlikely
+ * relations.
+ *
+ * Using P(p) ~ n_p / n_t as per frequentest probability, we can
+ * equate a node's CPU usage of a particular page (n_p) per total
+ * usage of this page (n_t) (in a given time-span) to a probability.
+ *
+ * Our periodic faults will then sample this probability and getting
+ * the same result twice in a row, given these samples are fully
+ * independent, is then given by P(n)^2, provided our sample period
+ * is sufficiently short compared to the usage pattern.
+ *
+ * This quadric squishes small probabilities, making it less likely
+ * we act on an unlikely CPU_node<->page relation.
+ */

If this was the basis for the sched/numa patch then I'd point out that
I'm not the only person that failed to preserve history perfectly.

-- 
Mel Gorman
SUSE Labs
