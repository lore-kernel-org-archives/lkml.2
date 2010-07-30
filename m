Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab0G3SOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:14:09 -0400
Received: from kroah.org ([198.145.64.141]:59051 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672Ab0G3R5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:12 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:48 2010
Message-Id: <20100730175148.046181012@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Hocko <mhocko@suse.cz>, Darren Hart <dvhltc@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Nick Piggin <npiggin@suse.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [155/205] futex: futex_find_get_task remove credentails check
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 7a0ea09ad5352efce8fe79ed853150449903b9f5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -429,20 +429,11 @@ static void free_pi_state(struct futex_p
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
 
@@ -564,8 +555,8 @@ lookup_pi_state(u32 uval, struct futex_h
 	if (!pid)
 		return -ESRCH;
 	p = futex_find_get_task(pid);
-	if (IS_ERR(p))
-		return PTR_ERR(p);
+	if (!p)
+		return -ESRCH;
 
 	/*
 	 * We need to look at the task state flags to figure out,


