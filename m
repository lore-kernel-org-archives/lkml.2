Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0F2PZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:25:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:53935 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab0F2PY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:24:59 -0400
Date: Tue, 29 Jun 2010 17:24:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] futex: futex_find_get_task make credentials check
 conditional
Message-ID: <20100629152456.GH6215@tiehlicka.suse.cz>
References: <20100625082711.GA32765@tiehlicka.suse.cz>
 <4C24ED34.9040808@us.ibm.com>
 <4C253D32.6040304@us.ibm.com>
 <20100628144246.GA14201@tiehlicka.suse.cz>
 <20100628153214.GA24127@tiehlicka.suse.cz>
 <20100628155845.GC24127@tiehlicka.suse.cz>
 <20100628163952.GD24127@tiehlicka.suse.cz>
 <1277743748.3561.139.camel@laptop>
 <20100629084230.GE6215@tiehlicka.suse.cz>
 <4C2A0986.1000807@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2A0986.1000807@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-06-10 07:56:06, Darren Hart wrote:
> On 06/29/2010 01:42 AM, Michal Hocko wrote:
> >On Mon 28-06-10 18:49:08, Peter Zijlstra wrote:
> >>On Mon, 2010-06-28 at 18:39 +0200, Michal Hocko wrote:
> >>>Would something like the following be acceptable (just a compile
> >>>tested without comments). It simply makes caller of lookup_pi_state to
> >>>decide whether credentials should be checked.
> >>
> >>So it was Ingo, who in c87e2837be8 (pi-futex:
> >>futex_lock_pi/futex_unlock_pi support) introduced the euid checks:
> >>
> >>+futex_find_get_task():
> >>+       if ((current->euid != p->euid)&&  (current->euid != p->uid)) {
> >>+               p = NULL;
> >>+               goto out_unlock;
> >>+       }
> >>
> >>Ingo, do you remember the rationale behind that? It seems to be causing
> >>grief when two different users contend on the same (shared) futex.
> >>
> >>See the below proposed solution.
> >
> >Here is the patch with comments and rationale:
> >(reference to the original discussion: http://lkml.org/lkml/2010/6/23/52)
> >
> >--
> > From f477a6d989dfde11c5bb5f28d5ce21d0682f4e25 Mon Sep 17 00:00:00 2001
> >From: Michal Hocko<mhocko@suse.cz>
> >Date: Tue, 29 Jun 2010 10:02:58 +0200
> >Subject: [PATCH] futex: futex_find_get_task make credentials check conditional
> >
> >futex_find_get_task is currently used (through lookup_pi_state) from two
> >contexts, futex_requeue and futex_lock_pi_atomic. While credentials check
> >makes sense in the first code path, the second one is more problematic
> >because this check requires that the PI lock holder (pid parameter) has
> >the same uid and euid as the process's euid which is trying to lock the
> >same futex (current).
> >
> >This results in glibc assert failure or process hang (if glibc is
> >compiled without assert support) for shared robust pthread mutex with
> >priority inheritance if a process tries to lock already held lock owned
> >by a process with a different euid:
> >
> >pthread_mutex_lock.c:312: __pthread_mutex_lock_full: Assertion `(-(e)) != 3 || !robust' failed.
> >
> >The problem is that futex_lock_pi_atomic which is called when we try to
> >lock already held lock checks the current holder (tid is stored in the
> >futex value) to get the PI state. It uses lookup_pi_state which in turn
> >gets task struct from futex_find_get_task. ESRCH is returned either when
> >the task is not found or if credentials check fails.
> >futex_lock_pi_atomic simply returns if it gets ESRCH. glibc code,
> >however,  doesn't expect that robust lock returns with ESRCH because it
> >should get either success or owner died.
> >
> >Let's make credentials check conditional (as a new parameter) in
> >futex_find_get_task. Then we can prevent from check in the pi lock path
> >and still preserve it in the futex_requeue path.
> >
> 
> 
> Hi Michal,

Hey,

> 
> All the above is accurate, however I think it emphasizes glibc's
> expectations when the core of the issue is that shared PI futexes
> don't work across processes with different uid's.

I understand that but I failed to find any documentation which would
point that out. The issue is that this may be non-intuitive for users
who are trying to "improve" their application which uses robust mutexes
to use PI and that fails silently (even if glibc would fix the assert).

> 
> It seems like most users of shared futexes do so from the same uid,
> however I can think of situations where it would be useful to use
> them from different uid's. Since shared futexes key on their
> physical address, their shouldn't be any security issues with
> allowing different uids.

The original issue came from our customer (working on Firebird). I don't
know many details why they need different users but AFAIU they are
accessing some files and separate functionality into processes with
different users.

I don't see any security concerns for shared locks as well, but I am not
a security guy.

> 
> 
> >Signed-off-by: Michal Hocko<mhocko@suse.cz>
> >---
> >  kernel/futex.c |   24 +++++++++++++++---------
> >  1 files changed, 15 insertions(+), 9 deletions(-)
> >
> >diff --git a/kernel/futex.c b/kernel/futex.c
> >index e7a35f1..79b69e5 100644
> >--- a/kernel/futex.c
> >+++ b/kernel/futex.c
> >@@ -425,8 +425,9 @@ static void free_pi_state(struct futex_pi_state *pi_state)
> >  /*
> >   * Look up the task based on what TID userspace gave us.
> >   * We dont trust it.
> >+ * Check the credentials if required by check_cred
> 
> While we're changing comment blocks, please update it to a proper
> kerneldoc function descriptor:
> 
> /**
>  * futex_find_get_task() - Lookup task by TID
>  * @pid:	TID of the task_struct to find
>  * @check_cred:	check credentials (1) or not (0)
>  *
>  * Look up the task based on the TID userspace gave us. We don't trust
>  * it. Optionally check the credentials.
>  *
>  * Returns a valid task_struct pointer or an error code embedded in the
>  * pointer value.
>  */
> 
> The above should probably also include whatever motivation Ingo
> comes back with for having done the uid check in the first place -
> which I confess I am not seeing.

OK, no problem.

> 
> >   */
> >-static struct task_struct * futex_find_get_task(pid_t pid)
> >+static struct task_struct * futex_find_get_task(pid_t pid, bool check_cred)
> 
> bool is nice, not used elsewhere, but clearly defines purpose. I may
> need to update some of the other flags throughout the file in a
> follow-on patch.
> 
> >  {
> >  	struct task_struct *p;
> >  	const struct cred *cred = current_cred(), *pcred;
> >@@ -436,10 +437,12 @@ static struct task_struct * futex_find_get_task(pid_t pid)
> >  	if (!p) {
> >  		p = ERR_PTR(-ESRCH);
> >  	} else {
> >-		pcred = __task_cred(p);
> >-		if (cred->euid != pcred->euid&&
> >-		    cred->euid != pcred->uid)
> >-			p = ERR_PTR(-ESRCH);
> >+		if (check_cred) {
> >+			pcred = __task_cred(p);
> >+			if (cred->euid != pcred->euid&&
> >+			    cred->euid != pcred->uid)
> >+				p = ERR_PTR(-ESRCH);
> >+		}
> >  		else
> >  			get_task_struct(p);
> >  	}
> >@@ -504,9 +507,10 @@ void exit_pi_state_list(struct task_struct *curr)
> >  	raw_spin_unlock_irq(&curr->pi_lock);
> >  }
> >
> >+/* check_cred is just passed through to futex_find_get_task */
> >  static int
> >  lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
> >-		union futex_key *key, struct futex_pi_state **ps)
> >+		union futex_key *key, struct futex_pi_state **ps, bool check_cred)
> 
> Wrap at 80.

Sure

> 
> >  {
> >  	struct futex_pi_state *pi_state = NULL;
> >  	struct futex_q *this, *next;
> >@@ -563,7 +567,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
> >  	 */
> >  	if (!pid)
> >  		return -ESRCH;
> >-	p = futex_find_get_task(pid);
> >+	p = futex_find_get_task(pid, check_cred);
> >  	if (IS_ERR(p))
> >  		return PTR_ERR(p);
> >
> >@@ -704,8 +708,10 @@ retry:
> >  	/*
> >  	 * We dont have the lock. Look up the PI state (or create it if
> >  	 * we are the first waiter):
> >+	 * Do not ask for credentials check because we want to share the
> >+	 * lock between processes with different (e)uids
> 
> Please merge the new comments into the old. Keeping the original
> colon confuses the comment block. Try:
> 
>    	/*
>    	 * We dont have the lock. Look up the PI state (or create it if
>    	 * we are the first waiter). Don't ask for a credentials check
> 	 * as we need to allow shared locks between processes with
> 	 * different (e)uids.

Sure.

> 
> Thanks,

Thanks for comments!

> 
> -- 
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
