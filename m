Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2K2N3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:29:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2K2N27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:28:59 -0500
Date: Thu, 29 Nov 2012 14:28:54 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] memcg: do not check for mm in mem_cgroup_count_vm_event
 disabled
Message-ID: <20121129132854.GB27887@dhcp22.suse.cz>
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
 <20121120134932.055bc192.akpm@linux-foundation.org>
 <20121121083505.GA8761@dhcp22.suse.cz>
 <alpine.LNX.2.00.1211281509560.15410@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211281509560.15410@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28-11-12 15:29:30, Hugh Dickins wrote:
> On Wed, 21 Nov 2012, Michal Hocko wrote:
> > On Tue 20-11-12 13:49:32, Andrew Morton wrote:
> > > On Mon, 19 Nov 2012 17:44:34 -0800 (PST)
> > > David Rientjes <rientjes@google.com> wrote:
[...]
> > > > -void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> > > > +void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> > > > +static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
> > > > +					     enum vm_event_item idx)
> > > > +{
> > > > +	if (mem_cgroup_disabled() || !mm)
> > > > +		return;
> > > > +	__mem_cgroup_count_vm_event(mm, idx);
> > > > +}
> > > 
> > > Does the !mm case occur frequently enough to justify inlining it, or
> > > should that test remain out-of-line?
> > 
> > Now that you've asked about it I started looking around and I cannot see
> > how mm can ever be NULL. The condition is there since the very beginning
> > (456f998e memcg: add the pagefault count into memcg stats) but all the
> > callers are page fault handlers and those shouldn't have mm==NULL.
> > Or is there anything obvious I am missing?
> > 
> > Ying, the whole thread starts https://lkml.org/lkml/2012/11/19/545 but
> > the primary question is why we need !mm test for mem_cgroup_count_vm_event
> > at all.
> 
> Here's a guess: as Ying's 456f998e patch started out in akpm's tree,
> shmem.c was calling mem_cgroup_count_vm_event(current->mm, PGMAJFAULT).
> 
> Then I insisted that was inconsistent with how we usually account when
> one task touches another's address space, and rearranged it to work on
> vma->vm_mm instead.

Thanks Hugh!
 
> Done the original way, if the touching task were a kernel daemon (KSM's
> ksmd comes to my mind), then the current->mm could well have been NULL.
> 
> I agree with you that it looks redundant now.

Andrew could you please pick this up?
---
>From 619b1ab26c3e96944f6c60256cf7920671bafa5b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 29 Nov 2012 14:20:58 +0100
Subject: [PATCH] memcg: do not check for mm in mem_cgroup_count_vm_event

mm given to mem_cgroup_count_vm_event cannot be NULL because the
function is either called from the page fault path or vma->vm_mm is
used. So the check can be dropped.

The check has been introduced by 456f998e (memcg: add the pagefault
count into memcg stats) because the originally proposed patch used
current->mm for shmem but this has been changed to vma->vm_mm later on
without the check being removed (thanks to Hugh for this recollection).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 095d2b4..0108a56 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -188,7 +188,7 @@ void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
 					     enum vm_event_item idx)
 {
-	if (mem_cgroup_disabled() || !mm)
+	if (mem_cgroup_disabled())
 		return;
 	__mem_cgroup_count_vm_event(mm, idx);
 }
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
