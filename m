Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2HUHcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:32:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2HUHcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:32:05 -0400
Date: Tue, 21 Aug 2012 08:26:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] mempolicy: fix a memory corruption by refcount
 imbalance in alloc_pages_vma()
Message-ID: <20120821072611.GC1657@suse.de>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de>
 <1345480594-27032-6-git-send-email-mgorman@suse.de>
 <000001394596bd69-2c16d7fb-71b5-4009-95cc-7068103b2bfd-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <000001394596bd69-2c16d7fb-71b5-4009-95cc-7068103b2bfd-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 07:51:10PM +0000, Christoph Lameter wrote:
> On Mon, 20 Aug 2012, Mel Gorman wrote:
> 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 45f9825..82e872f 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1545,15 +1545,28 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
> >  		struct vm_area_struct *vma, unsigned long addr)
> >  {
> >  	struct mempolicy *pol = task->mempolicy;
> > +	int got_ref;
> 
> New variable. Need to set it to zero?
> 

Not needed at all, I was meant to get rid of it. Ben had pointed out this
exact problem with the initialisation.

> >
> >  	if (vma) {
> >  		if (vma->vm_ops && vma->vm_ops->get_policy) {
> >  			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
> >  									addr);
> > -			if (vpol)
> > +			if (vpol) {
> >  				pol = vpol;
> > -		} else if (vma->vm_policy)
> > +				got_ref = 1;
> 
> Set the new variable. But it was not initialzed before. So now its 1 or
> undefined?
> 

It's not even needed because the next block is the code that originally
cared about the value of got_ref.

> > +			}
> > +		} else if (vma->vm_policy) {
> >  			pol = vma->vm_policy;
> > +
> > +			/*
> > +			 * shmem_alloc_page() passes MPOL_F_SHARED policy with
> > +			 * a pseudo vma whose vma->vm_ops=NULL. Take a reference
> > +			 * count on these policies which will be dropped by
> > +			 * mpol_cond_put() later
> > +			 */
> > +			if (mpol_needs_cond_ref(pol))
> > +				mpol_get(pol);
> > +		}
> >  	}
> >  	if (!pol)
> >  		pol = &default_policy;
> >
> 
> I do not see any use of got_ref. Can we get rid of the variable?
> 

Yes, here is a correct version of the patch. Thanks Christoph.

---8<---
mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()

[cc9a6c87: cpuset: mm: reduce large amounts of memory barrier related damage
v3] introduced a potential memory corruption. shmem_alloc_page() uses a
pseudo vma and it has one significant unique combination, vma->vm_ops=NULL
and vma->policy->flags & MPOL_F_SHARED.

get_vma_policy() does NOT increase a policy ref when vma->vm_ops=NULL and
mpol_cond_put() DOES decrease a policy ref when a policy has MPOL_F_SHARED.
Therefore, when a cpuset update race occurs, alloc_pages_vma() falls in 'goto
retry_cpuset' path, decrements the reference count and frees the policy
prematurely.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mempolicy.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 45f9825..9842ef5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1552,8 +1552,18 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 									addr);
 			if (vpol)
 				pol = vpol;
-		} else if (vma->vm_policy)
+		} else if (vma->vm_policy) {
 			pol = vma->vm_policy;
+
+			/*
+			 * shmem_alloc_page() passes MPOL_F_SHARED policy with
+			 * a pseudo vma whose vma->vm_ops=NULL. Take a reference
+			 * count on these policies which will be dropped by
+			 * mpol_cond_put() later
+			 */
+			if (mpol_needs_cond_ref(pol))
+				mpol_get(pol);
+		}
 	}
 	if (!pol)
 		pol = &default_policy;
