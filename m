Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0F2Imh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:42:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:40656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0F2Imf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:42:35 -0400
Date: Tue, 29 Jun 2010 10:42:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] futex: futex_find_get_task make credentials check
 conditional
Message-ID: <20100629084230.GE6215@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
 <4C2417AA.4030306@us.ibm.com>
 <20100625082711.GA32765@tiehlicka.suse.cz>
 <4C24ED34.9040808@us.ibm.com>
 <4C253D32.6040304@us.ibm.com>
 <20100628144246.GA14201@tiehlicka.suse.cz>
 <20100628153214.GA24127@tiehlicka.suse.cz>
 <20100628155845.GC24127@tiehlicka.suse.cz>
 <20100628163952.GD24127@tiehlicka.suse.cz>
 <1277743748.3561.139.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277743748.3561.139.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-06-10 18:49:08, Peter Zijlstra wrote:
> On Mon, 2010-06-28 at 18:39 +0200, Michal Hocko wrote:
> > Would something like the following be acceptable (just a compile
> > tested without comments). It simply makes caller of lookup_pi_state to
> > decide whether credentials should be checked.
> 
> So it was Ingo, who in c87e2837be8 (pi-futex:
> futex_lock_pi/futex_unlock_pi support) introduced the euid checks:
> 
> +futex_find_get_task():
> +       if ((current->euid != p->euid) && (current->euid != p->uid)) {
> +               p = NULL;
> +               goto out_unlock;
> +       }
> 
> Ingo, do you remember the rationale behind that? It seems to be causing
> grief when two different users contend on the same (shared) futex.
> 
> See the below proposed solution.

Here is the patch with comments and rationale:
(reference to the original discussion: http://lkml.org/lkml/2010/6/23/52)

--
>From f477a6d989dfde11c5bb5f28d5ce21d0682f4e25 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 29 Jun 2010 10:02:58 +0200
Subject: [PATCH] futex: futex_find_get_task make credentials check conditional

futex_find_get_task is currently used (through lookup_pi_state) from two
contexts, futex_requeue and futex_lock_pi_atomic. While credentials check
makes sense in the first code path, the second one is more problematic
because this check requires that the PI lock holder (pid parameter) has
the same uid and euid as the process's euid which is trying to lock the
same futex (current).

This results in glibc assert failure or process hang (if glibc is
compiled without assert support) for shared robust pthread mutex with
priority inheritance if a process tries to lock already held lock owned
by a process with a different euid:

pthread_mutex_lock.c:312: __pthread_mutex_lock_full: Assertion `(-(e)) != 3 || !robust' failed.

The problem is that futex_lock_pi_atomic which is called when we try to
lock already held lock checks the current holder (tid is stored in the
futex value) to get the PI state. It uses lookup_pi_state which in turn
gets task struct from futex_find_get_task. ESRCH is returned either when
the task is not found or if credentials check fails.
futex_lock_pi_atomic simply returns if it gets ESRCH. glibc code,
however,  doesn't expect that robust lock returns with ESRCH because it
should get either success or owner died.

Let's make credentials check conditional (as a new parameter) in
futex_find_get_task. Then we can prevent from check in the pi lock path
and still preserve it in the futex_requeue path.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/futex.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e7a35f1..79b69e5 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -425,8 +425,9 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 /*
  * Look up the task based on what TID userspace gave us.
  * We dont trust it.
+ * Check the credentials if required by check_cred
  */
-static struct task_struct * futex_find_get_task(pid_t pid)
+static struct task_struct * futex_find_get_task(pid_t pid, bool check_cred)
 {
 	struct task_struct *p;
 	const struct cred *cred = current_cred(), *pcred;
@@ -436,10 +437,12 @@ static struct task_struct * futex_find_get_task(pid_t pid)
 	if (!p) {
 		p = ERR_PTR(-ESRCH);
 	} else {
-		pcred = __task_cred(p);
-		if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid)
-			p = ERR_PTR(-ESRCH);
+		if (check_cred) {
+			pcred = __task_cred(p);
+			if (cred->euid != pcred->euid &&
+			    cred->euid != pcred->uid)
+				p = ERR_PTR(-ESRCH);
+		}
 		else
 			get_task_struct(p);
 	}
@@ -504,9 +507,10 @@ void exit_pi_state_list(struct task_struct *curr)
 	raw_spin_unlock_irq(&curr->pi_lock);
 }
 
+/* check_cred is just passed through to futex_find_get_task */
 static int
 lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
-		union futex_key *key, struct futex_pi_state **ps)
+		union futex_key *key, struct futex_pi_state **ps, bool check_cred)
 {
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_q *this, *next;
@@ -563,7 +567,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	 */
 	if (!pid)
 		return -ESRCH;
-	p = futex_find_get_task(pid);
+	p = futex_find_get_task(pid, check_cred);
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
@@ -704,8 +708,10 @@ retry:
 	/*
 	 * We dont have the lock. Look up the PI state (or create it if
 	 * we are the first waiter):
+	 * Do not ask for credentials check because we want to share the
+	 * lock between processes with different (e)uids
 	 */
-	ret = lookup_pi_state(uval, hb, key, ps);
+	ret = lookup_pi_state(uval, hb, key, ps, false);
 
 	if (unlikely(ret)) {
 		switch (ret) {
@@ -1258,7 +1264,7 @@ retry_private:
 			ret = get_futex_value_locked(&curval2, uaddr2);
 			if (!ret)
 				ret = lookup_pi_state(curval2, hb2, &key2,
-						      &pi_state);
+						      &pi_state, true);
 		}
 
 		switch (ret) {
-- 
1.7.1


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
