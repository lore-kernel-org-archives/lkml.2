Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab1FVMcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:32:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab1FVMcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:32:07 -0400
Date: Wed, 22 Jun 2011 14:32:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH V2] mm: Do not keep page locked during page fault while
 charging it for memcg
Message-ID: <20110622123204.GC14343@tiehlicka.suse.cz>
References: <20110622120635.GB14343@tiehlicka.suse.cz>
 <20110622121516.GA28359@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622121516.GA28359@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-06-11 08:15:16, Christoph Hellwig wrote:
> > +
> > +			/* We have to drop the page lock here because memcg
> > +			 * charging might block for unbound time if memcg oom
> > +			 * killer is disabled.
> > +			 */
> > +			unlock_page(vmf.page);
> > +			ret = mem_cgroup_newpage_charge(page, mm, GFP_KERNEL);
> > +			lock_page(vmf.page);
> 
> This introduces a completely poinless unlock/lock cycle for non-memcg
> pagefaults.  Please make sure it only happens when actually needed.

Fair point. Thanks!
What about the following?
I realize that pushing more memcg logic into mm/memory.c is not nice but
I found it better than pushing the old page into mem_cgroup_newpage_charge.
We could also check whether the old page is in the root cgroup because
memcg oom killer is not active there but that would add more code into
this hot path so I guess it is not worth it.

Changes since v1
- do not unlock page when memory controller is disabled.

8<------
>From 82d2b5ce6c38ad3d6df7ccf7010084c2d6658634 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 22 Jun 2011 13:56:54 +0200
Subject: [PATCH] mm: Do not keep page locked during page fault while charging
 it for memcg

Currently we are keeping faulted page locked throughout whole __do_fault
call (except for page_mkwrite code path). If we do early COW we allocate a
new page which has to be charged for a memcg (mem_cgroup_newpage_charge).
This function, however, might block for unbounded amount of time if memcg
oom killer is disabled because the only way out of the OOM situation is
either an external event (kill a process from the group or resize the group
hard limit) or internal event (that would get us under the limit). Many
times the external event is the only chance to move forward, though.
In the end we are keeping the faulted page locked and blocking other
processes from faulting it in which is not good at all because we are
basically punishing potentially an unrelated process for OOM condition
in a different group (I have seen stuck system because of ld-2.11.1.so being
locked).

Let's unlock the faulted page while we are charging a new page and then
recheck whether it wasn't truncated in the mean time. We should retry the
fault in that case.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memory.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 87d9353..627eb6a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3177,7 +3177,26 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
-			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
+
+			/* We have to drop the page lock here because memcg
+			 * charging might block for unbound time if memcg oom
+			 * killer is disabled.
+			 */
+			if (!mem_cgroup_disabled())
+				unlock_page(vmf.page);
+			ret = mem_cgroup_newpage_charge(page, mm, GFP_KERNEL);
+			if (!mem_cgroup_disabled()) {
+				lock_page(vmf.page);
+
+				if (!vmf.page->mapping) {
+					if (!ret)
+						mem_cgroup_uncharge_page(page);
+					page_cache_release(page);
+					ret = 0; /* retry the fault */
+					goto out;
+				}
+			}
+			if (ret) {
 				ret = VM_FAULT_OOM;
 				page_cache_release(page);
 				goto out;
-- 
1.7.5.4


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
