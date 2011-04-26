Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1DZFuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:50:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50075 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1DZFuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:50:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] proc: fix pagemap_read() error case (was Re: [PATCH] proc: put check_mem_permission before __get_free_page in mem_read)
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hughd@google.com>,
        bookjovi@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <20110426141449.F37C.A69D9226@jp.fujitsu.com>
References: <alpine.LSU.2.00.1104252048190.6978@sister.anvils> <20110426141449.F37C.A69D9226@jp.fujitsu.com>
Message-Id: <20110426145226.F383.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 14:50:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi High,
> 
> > On Sun, 17 Apr 2011, bookjovi@gmail.com wrote:
> > > From: Jovi Zhang <bookjovi@gmail.com>
> > > 
> > > It should be better if put check_mem_permission before __get_free_page
> > > in mem_read, to be same as function mem_write.
> > > 
> > > Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> > 
> > Sorry to be contrary, but I disagree with this.  I'm all for consistency,
> > but is there a particular reason why you think the mem_write ordering is
> > right and mem_read wrong?
> > 
> > My reason for preferring the current mem_read ordering is this:
> > 
> > check_mem_permission gets a reference to the mm.  If we __get_free_page
> > after check_mem_permission, imagine what happens if the system is out
> > of memory, and the mm we're looking at is selected for killing by the
> > OOM killer: while we wait in __get_free_page for more memory, no memory
> > is freed from the selected mm because it cannot reach exit_mmap while
> > we hold that reference.
> 
> Right.
> 
> sorry for that. I missed this point.
> 
> 
> > (I may be overstating the case: a little memory may be freed from the
> > exiting task's stack, and kswapd should still be able to pick some pages
> > off the mm.  But nonetheless, we would do better to let this mm go.)
> > 
> > No doubt there are plenty of other places in /proc which try to
> > allocate memory after taking a reference on an mm; but I think
> > we should be working to eliminate those rather than add to them.
> 
> then, Should we change mem_write instead?

I've finished audit other /proc allocation callsite. If my understand
is correct, only pagemap_read() has the same issue.

fixed.


>From 5f83db14a7c62381c4f23994d559041c4c3320a8 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 14:26:52 +0900
Subject: [PATCH] proc: fix pagemap_read() error case

Currently, pagemap_read() has three error and/or corner case
handling mistake.
 (1) If ppos parameter is wrong, mm refcount will be leak.
 (2) If count parameter is 0, mm refcount will be leak too.
 (3) If the current task is sleeping in kmalloc() and the system
     is out of memory and oom-killer kill the proc associated task,
     mm_refcount prevent the task free its memory. then system may
     hang up.

<Quote Hugh's explain why we shold call kmalloc() before get_mm()>
  check_mem_permission gets a reference to the mm.  If we __get_free_page
  after check_mem_permission, imagine what happens if the system is out
  of memory, and the mm we're looking at is selected for killing by the
  OOM killer: while we wait in __get_free_page for more memory, no memory
  is freed from the selected mm because it cannot reach exit_mmap while
  we hold that reference.

This patch fixes the above three.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
---
 fs/proc/task_mmu.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 51b9d98..6fb07ce 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -769,18 +769,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!task)
 		goto out;
 
-	mm = mm_for_maps(task);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
-		goto out_task;
-
 	ret = -EINVAL;
 	/* file position must be aligned */
 	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
 		goto out_task;
 
 	ret = 0;
-
 	if (!count)
 		goto out_task;
 
@@ -788,7 +782,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
-		goto out_mm;
+		goto out_task;
+
+	mm = mm_for_maps(task);
+	ret = PTR_ERR(mm);
+	if (!mm || IS_ERR(mm))
+		goto out_free;
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
@@ -831,7 +830,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 		len = min(count, PM_ENTRY_BYTES * pm.pos);
 		if (copy_to_user(buf, pm.buffer, len)) {
 			ret = -EFAULT;
-			goto out_free;
+			goto out_mm;
 		}
 		copied += len;
 		buf += len;
@@ -841,10 +840,10 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!ret || ret == PM_END_OF_BUFFER)
 		ret = copied;
 
-out_free:
-	kfree(pm.buffer);
 out_mm:
 	mmput(mm);
+out_free:
+	kfree(pm.buffer);
 out_task:
 	put_task_struct(task);
 out:
-- 
1.7.3.1




