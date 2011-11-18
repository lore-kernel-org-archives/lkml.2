Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab1KRTjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:39:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1KRTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:39:48 -0500
Date: Fri, 18 Nov 2011 11:39:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hugetlb: detect race if fail to COW
Message-Id: <20111118113946.6563fd08.akpm@linux-foundation.org>
In-Reply-To: <20111118161128.GC23223@tiehlicka.suse.cz>
References: <CAJd=RBC+p8033bHNfP=WQ2SU1Y1zRpj+FEi9FdjuFKkjF_=_iA@mail.gmail.com>
	<20111118150742.GA23223@tiehlicka.suse.cz>
	<CAJd=RBCOK9tis-bF87Csn70miRDqLtCUiZmDH2hnc8i_9+KtNw@mail.gmail.com>
	<20111118161128.GC23223@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 17:11:28 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Fri 18-11-11 23:23:12, Hillf Danton wrote:
> > On Fri, Nov 18, 2011 at 11:07 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > > On Fri 18-11-11 22:04:37, Hillf Danton wrote:
> > >> In the error path that we fail to allocate new huge page, before try again, we
> > >> have to check race since page_table_lock is re-acquired.
> > >
> > > I do not think we can race here because we are serialized by
> > > hugetlb_instantiation_mutex AFAIU. Without this lock, however, we could
> > > fall into avoidcopy and shortcut despite the fact that other thread has
> > > already did the job.
> > >
> > > The mutex usage is not obvious in hugetlb_cow so maybe we want to be
> > > explicit about it (either a comment or do the recheck).
> > >
> > 
> > Then the following check is unnecessary, no?
> 
> Hmm, thinking about it some more, I guess we have to recheck because we
> can still race with page migration. So we need you patch.
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

So we need a new changelog.  How does this look?


From: Hillf Danton <dhillf@gmail.com>
Subject: hugetlb: detect race upon page allocation failure during COW

In the error path where we failed to allocate a new huge page, we should
check whether a racing thread has added this page for us while this thread
waited for the page_table_lock.

We are serialized by hugetlb_instantiation_mutex on the pagefault patch
but this race can occur when another thread is performing page migration.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-detect-race-upon-page-allocation-failure-during-cow mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-detect-race-upon-page-allocation-failure-during-cow
+++ a/mm/hugetlb.c
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
_

