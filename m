Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0GHMvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:51:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:47464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0GHMvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:51:06 -0400
Date: Thu, 8 Jul 2010 14:51:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: stable@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] futex: futex_find_get_task remove credentails check
Message-ID: <20100708125104.GD4925@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi stable team,
could you consider including the following patch (Linus tree commit:
7a0ea09ad5352efce8fe79ed853150449903b9f5).

The original discussion which led to this commit can be found at
http://lkml.org/lkml/2010/6/23/52.

In short:
The original pi locking implementation (since it got to the kernel)
contains a credential check (in futex_find_get_task) if we want to
create a PI state for already held lock. This test fails if the lock
owner has a different (e)uid than the process for which we want to
create the state.
The lock operation then fails with ESRCH which is the error code 
which is returned if the process holding a lock doesn't exist. 
The userspace (glibc) doesn't expect this behavior for shared robust PI
futexes and fails with an assert or hang the task in the end-less loop.

The test case is attached in the referenced thread.

The credential test, which is removed by this patch, doesn't look
correct and it limits the functionality without any good reason. There
are no security consequences as well because the only thing that should
matter in the shared futex-es is accessibility to the shared memory.

The patch applies as is on top of Vanilla 2.6.32, but let me know if you
want to base it on top of the any of the stable trees.


---
>From 7a0ea09ad5352efce8fe79ed853150449903b9f5 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 30 Jun 2010 09:51:19 +0200
Subject: [PATCH] futex: futex_find_get_task remove credentails check

futex_find_get_task is currently used (through lookup_pi_state) from two
contexts, futex_requeue and futex_lock_pi_atomic.  None of the paths
looks it needs the credentials check, though.  Different (e)uids
shouldn't matter at all because the only thing that is important for
shared futex is the accessibility of the shared memory.

The credentail check results in glibc assert failure or process hang (if
glibc is compiled without assert support) for shared robust pthread
mutex with priority inheritance if a process tries to lock already held
lock owned by a process with a different euid:

pthread_mutex_lock.c:312: __pthread_mutex_lock_full: Assertion `(-(e)) != 3 || !robust' failed.

The problem is that futex_lock_pi_atomic which is called when we try to
lock already held lock checks the current holder (tid is stored in the
futex value) to get the PI state.  It uses lookup_pi_state which in turn
gets task struct from futex_find_get_task.  ESRCH is returned either
when the task is not found or if credentials check fails.

futex_lock_pi_atomic simply returns if it gets ESRCH.  glibc code,
however, doesn't expect that robust lock returns with ESRCH because it
should get either success or owner died.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/futex.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e7a35f1..6a3a5fa 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -429,20 +429,11 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 static struct task_struct * futex_find_get_task(pid_t pid)
 {
 	struct task_struct *p;
-	const struct cred *cred = current_cred(), *pcred;
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
-	if (!p) {
-		p = ERR_PTR(-ESRCH);
-	} else {
-		pcred = __task_cred(p);
-		if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid)
-			p = ERR_PTR(-ESRCH);
-		else
-			get_task_struct(p);
-	}
+	if (p)
+		get_task_struct(p);
 
 	rcu_read_unlock();
 
@@ -564,8 +555,8 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	if (!pid)
 		return -ESRCH;
 	p = futex_find_get_task(pid);
-	if (IS_ERR(p))
-		return PTR_ERR(p);
+	if (!p)
+		return -ESRCH;
 
 	/*
 	 * We need to look at the task state flags to figure out,
-- 
1.7.1

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
