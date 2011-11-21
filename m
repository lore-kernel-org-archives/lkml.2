Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1KUOQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:16:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab1KUOQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:16:29 -0500
Date: Mon, 21 Nov 2011 15:16:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hugetlb: detect race if fail to COW
Message-ID: <20111121141625.GB16957@tiehlicka.suse.cz>
References: <CAJd=RBC+p8033bHNfP=WQ2SU1Y1zRpj+FEi9FdjuFKkjF_=_iA@mail.gmail.com>
 <20111118150742.GA23223@tiehlicka.suse.cz>
 <CAJd=RBCOK9tis-bF87Csn70miRDqLtCUiZmDH2hnc8i_9+KtNw@mail.gmail.com>
 <20111118161128.GC23223@tiehlicka.suse.cz>
 <20111121122303.GA13594@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121122303.GA13594@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-11-11 13:23:03, Michal Hocko wrote:
> On Fri 18-11-11 17:11:28, Michal Hocko wrote:
> > On Fri 18-11-11 23:23:12, Hillf Danton wrote:
> > > On Fri, Nov 18, 2011 at 11:07 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > > > On Fri 18-11-11 22:04:37, Hillf Danton wrote:
> > > >> In the error path that we fail to allocate new huge page, before try again, we
> > > >> have to check race since page_table_lock is re-acquired.
> > > >
> > > > I do not think we can race here because we are serialized by
> > > > hugetlb_instantiation_mutex AFAIU. Without this lock, however, we could
> > > > fall into avoidcopy and shortcut despite the fact that other thread has
> > > > already did the job.
> > > >
> > > > The mutex usage is not obvious in hugetlb_cow so maybe we want to be
> > > > explicit about it (either a comment or do the recheck).
> > > >
> > > 
> > > Then the following check is unnecessary, no?
> > 
> > Hmm, thinking about it some more, I guess we have to recheck because we
> > can still race with page migration. So we need you patch.
> 
> OK, so looked at it again and we cannot race with page migration because
> the page is locked (by unmap_and_move_*page) migration and we have the
> old page locked here as well (hugetlb_fault).
> 
> Or am I missing something?

And the updated patch:
--- 
>From 1388a321b2a04643c777b613512e709a3519d3cc Mon Sep 17 00:00:00 2001
From: Hillf Danton <dhillf@gmail.com>
Date: Fri, 18 Nov 2011 22:04:37 +0800
Subject: [PATCH] hugetlb: detect race if fail to COW

Currently we are not rechecking pte_same in hugetlb_cow after we take
ptl lock again in the page allocation failure code path and simply retry
again. This is not an issue at the moment because hugetlb fault path
is protected by hugetlb_instantiation_mutex so we cannot race.

The original page is locked and so we cannot race even with the page
migration.

Let's add the pte_same check anyway as we want to be consistent with the
other check later in this function and be safe if we ever remove the
mutex.

[Michal Hocko <mhocko@suse.cz>: Reworded the changelog]
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 mm/hugetlb.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bb28a5f..f76c7ea 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2407,7 +2407,14 @@ retry_avoidcopy:
 				BUG_ON(page_count(old_page) != 1);
 				BUG_ON(huge_pte_none(pte));
 				spin_lock(&mm->page_table_lock);
-				goto retry_avoidcopy;
+				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
+				if (likely(pte_same(huge_ptep_get(ptep), pte)))
+					goto retry_avoidcopy;
+				/*
+				 * race occurs while re-acquiring page_table_lock, and
+				 * our job is done.
+				 */
+				return 0;
 			}
 			WARN_ON_ONCE(1);
 		}
-- 
1.7.7.1


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
