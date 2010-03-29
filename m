Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0C2Utd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:49:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0C2Utb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:49:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=P6OYFsptFHv0PF0zKBofTrTfg7XKsKTl6KuXlOWUYTuyzd1NrfSNXtqodtYyDBBtw
	wF4DhJTx8qFy/Y+sCtxQA==
Date: Mon, 29 Mar 2010 13:49:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
cc: anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch] oom: give current access to memory reserves if it has been
 killed
In-Reply-To: <20100329112111.GA16971@redhat.com>
Message-ID: <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com>
 <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, Oleg Nesterov wrote:

> Can't comment, I do not understand these subtleties.
> 
> But I'd like to note that fatal_signal_pending() can be true when the
> process wasn't killed, but another thread does exit_group/exec.
> 

I'm not sure there's a difference between whether a process was oom killed 
and received a SIGKILL that way or whether exit_group(2) was used, so I 
don't think we need to test for (p->signal->flags & SIGNAL_GROUP_EXIT) 
here.

We do need to guarantee that exiting tasks always can get memory, which is 
the responsibility of setting TIF_MEMDIE.  The only thing this patch does 
is defer calling the oom killer when a task has a pending SIGKILL and then 
fail the allocation when it would otherwise repeat.  Instead of the 
considerable risk involved with no failing GFP_KERNEL allocations that are 
under PAGE_ALLOC_COSTLY_ORDER that is typically never done, it may make 
more sense to retry the allocation with TIF_MEMDIE on the second 
iteration: in essence, automatically selecting current for oom kill 
regardless of other oom killed tasks if it already has a pending SIGKILL.



oom: give current access to memory reserves if it has been killed

It's possible to livelock the page allocator if a thread has mm->mmap_sem and 
fails to make forward progress because the oom killer selects another thread 
sharing the same ->mm to kill that cannot exit until the semaphore is dropped.

The oom killer will not kill multiple tasks at the same time; each oom killed 
task must exit before another task may be killed.  Thus, if one thread is 
holding mm->mmap_sem and cannot allocate memory, all threads sharing the same 
->mm are blocked from exiting as well.  In the oom kill case, that means the
thread holding mm->mmap_sem will never free additional memory since it cannot
get access to memory reserves and the thread that depends on it with access to
memory reserves cannot exit because it cannot acquire the semaphore.  Thus,
the page allocators livelocks.

When the oom killer is called and current happens to have a pending SIGKILL,
this patch automatically selects it for kill so that it has access to memory
reserves and the better timeslice.  Upon returning to the page allocator, its
allocation will hopefully succeed so it can quickly exit and free its memory.

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -681,6 +681,16 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	}
 
 	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		__oom_kill_task(current);
+		return;
+	}
+
+	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
