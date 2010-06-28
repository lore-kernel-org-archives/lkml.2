Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0F1Qtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:49:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0F1Qtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:49:39 -0400
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100628163952.GD24127@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
	 <4C2417AA.4030306@us.ibm.com> <20100625082711.GA32765@tiehlicka.suse.cz>
	 <4C24ED34.9040808@us.ibm.com> <4C253D32.6040304@us.ibm.com>
	 <20100628144246.GA14201@tiehlicka.suse.cz>
	 <20100628153214.GA24127@tiehlicka.suse.cz>
	 <20100628155845.GC24127@tiehlicka.suse.cz>
	 <20100628163952.GD24127@tiehlicka.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 18:49:08 +0200
Message-ID: <1277743748.3561.139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 18:39 +0200, Michal Hocko wrote:
> Would something like the following be acceptable (just a compile
> tested without comments). It simply makes caller of lookup_pi_state to
> decide whether credentials should be checked.

So it was Ingo, who in c87e2837be8 (pi-futex:
futex_lock_pi/futex_unlock_pi support) introduced the euid checks:

+futex_find_get_task():
+       if ((current->euid != p->euid) && (current->euid != p->uid)) {
+               p = NULL;
+               goto out_unlock;
+       }

Ingo, do you remember the rationale behind that? It seems to be causing
grief when two different users contend on the same (shared) futex.

See the below proposed solution.

> diff --git a/kernel/futex.c b/kernel/futex.c
> index e7a35f1..dfe4b11 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -426,7 +426,7 @@ static void free_pi_state(struct futex_pi_state *pi_state)
>   * Look up the task based on what TID userspace gave us.
>   * We dont trust it.
>   */
> -static struct task_struct * futex_find_get_task(pid_t pid)
> +static struct task_struct * futex_find_get_task(pid_t pid, bool check_cred)
>  {
>         struct task_struct *p;
>         const struct cred *cred = current_cred(), *pcred;
> @@ -436,10 +436,12 @@ static struct task_struct * futex_find_get_task(pid_t pid)
>         if (!p) {
>                 p = ERR_PTR(-ESRCH);
>         } else {
> -               pcred = __task_cred(p);
> -               if (cred->euid != pcred->euid &&
> -                   cred->euid != pcred->uid)
> -                       p = ERR_PTR(-ESRCH);
> +               if (check_cred) {
> +                       pcred = __task_cred(p);
> +                       if (cred->euid != pcred->euid &&
> +                           cred->euid != pcred->uid)
> +                               p = ERR_PTR(-ESRCH);
> +               }
>                 else
>                         get_task_struct(p);
>         }
> @@ -506,7 +508,7 @@ void exit_pi_state_list(struct task_struct *curr)
>  
>  static int
>  lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
> -               union futex_key *key, struct futex_pi_state **ps)
> +               union futex_key *key, struct futex_pi_state **ps, bool check_cred)
>  {
>         struct futex_pi_state *pi_state = NULL;
>         struct futex_q *this, *next;
> @@ -563,7 +565,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
>          */
>         if (!pid)
>                 return -ESRCH;
> -       p = futex_find_get_task(pid);
> +       p = futex_find_get_task(pid, check_cred);
>         if (IS_ERR(p))
>                 return PTR_ERR(p);
>  
> @@ -705,7 +707,7 @@ retry:
>          * We dont have the lock. Look up the PI state (or create it if
>          * we are the first waiter):
>          */
> -       ret = lookup_pi_state(uval, hb, key, ps);
> +       ret = lookup_pi_state(uval, hb, key, ps, false);
>  
>         if (unlikely(ret)) {
>                 switch (ret) {
> @@ -1258,7 +1260,7 @@ retry_private:
>                         ret = get_futex_value_locked(&curval2, uaddr2);
>                         if (!ret)
>                                 ret = lookup_pi_state(curval2, hb2, &key2,
> -                                                     &pi_state);
> +                                                     &pi_state, true);
>                 }
>  
>                 switch (ret) { 
