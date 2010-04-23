Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0DWNk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:40:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36593 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0DWNkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MXaAfqvFml1VxFeKTFeuTiar9YBGsFLq869ls8CGVkXAXItBRywQzTyKeb//H7dG7E
         gfTz9D0MCRL7ubQ7J7lA8UlQZNufCQxU/U1aiy4S+ijfpzLcD/SCVZ7fONBwztsaxtvY
         x+FMjrzKnZOMBcU5AqeXPcKWdSWVCqTtk3/eE=
Date: Fri, 23 Apr 2010 21:40:44 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Yong Zhang <yong.zhang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] lockdep: reduce stack_trace usage
Message-ID: <20100423134044.GA2777@zhy-desktop>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <alpine.LFD.2.00.1004230907050.4151@localhost>
 <1272009915.1646.25.camel@laptop>
 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 10:31:16AM +0200, John Kacur wrote:
> > Non of these numbers look strange..
> >
> 
> As I told Peter privately the laptop that triggered the
> MAX_STACK_TRACE_ENTRIES every time, has met an
> unfortunate early demise. However, I think it was the config - not the
> hardware. On this machine where the above
> numbers come from, I believe I have less debug options configured -
> but it is running the exact same kernel as
> the laptop was. (2.6.33.2-rt13)

Hi John,

(checking mail at home).
I find some place which can be hacked. Below is the patch.
But I don't even compile it. Can you test it to see if it can smooth
your problem.

---cut here ---
>From 6b9d513b7c417c0805ef0acc1cb3227bddba0889 Mon Sep 17 00:00:00 2001
From: Yong Zhang <yong.zhang0@gmail.com>
Date: Fri, 23 Apr 2010 21:13:54 +0800
Subject: [PATCH] lockdep: reduce stack_trace usage

When calling check_prevs_add(), if all validations passed
add_lock_to_list() will add new lock to dependency tree and
alloc stack_trace for each list_entry. But at this time,
we are always on the same stack, so stack_trace for each
list_entry has the same value. This is redundant and eats up
lots of memory which could lead to warning on low
MAX_STACK_TRACE_ENTRIES.
Using one copy of stack_trace instead.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
---
 kernel/lockdep.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..097d5fb 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -818,7 +818,8 @@ static struct lock_list *alloc_list_entry(void)
  * Add a new dependency to the head of the list:
  */
 static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+			    struct list_head *head, unsigned long ip,
+			    int distance, struct stack_trace *trace)
 {
 	struct lock_list *entry;
 	/*
@@ -829,11 +830,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!entry)
 		return 0;
 
-	if (!save_trace(&entry->trace))
-		return 0;
-
 	entry->class = this;
 	entry->distance = distance;
+	entry->trace = *trace;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -1635,7 +1634,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
  */
 static int
 check_prev_add(struct task_struct *curr, struct held_lock *prev,
-	       struct held_lock *next, int distance)
+	       struct held_lock *next, int distance, struct stack_trace *trace)
 {
 	struct lock_list *entry;
 	int ret;
@@ -1694,14 +1693,14 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 */
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
 			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, trace);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
 			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, trace);
 	if (!ret)
 		return 0;
 
@@ -1732,6 +1731,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 {
 	int depth = curr->lockdep_depth;
 	struct held_lock *hlock;
+	struct stack_trace trace;
 
 	/*
 	 * Debugging checks.
@@ -1748,6 +1748,9 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 			curr->held_locks[depth-1].irq_context)
 		goto out_bug;
 
+	if (!save_trace(&trace))
+		return 0;
+
 	for (;;) {
 		int distance = curr->lockdep_depth - depth + 1;
 		hlock = curr->held_locks + depth-1;
@@ -1756,7 +1759,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * added:
 		 */
 		if (hlock->read != 2) {
-			if (!check_prev_add(curr, hlock, next, distance))
+			if (!check_prev_add(curr, hlock, next,
+						distance, &trace))
 				return 0;
 			/*
 			 * Stop after the first non-trylock entry,
-- 
1.6.3.3
