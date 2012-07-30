Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2G3PvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:51:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37320 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2G3PvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:51:10 -0400
Date: Mon, 30 Jul 2012 17:51:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
Message-ID: <20120730155059.GB17078@somewhere.redhat.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
 <1343660892.20897.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343660892.20897.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 05:08:12PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-07-27 at 17:40 +0200, Frederic Weisbecker wrote:
> > +++ b/kernel/user_hooks.c
> > @@ -0,0 +1,56 @@
> > +#include <linux/user_hooks.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/sched.h>
> > +#include <linux/percpu.h>
> > +
> > +struct user_hooks {
> > +       bool hooking;
> > +       bool in_user;
> > +};
> 
> I really detest using bool in structures.. but that's just me. Also this
> really wants a comment as to wtf 'hooking' means. in_user I can just
> about guess.

I really don't mind changing that to int. I just like them as bool because
they better describe the purpose of the field.

hooking means that the hooks are set (the TIF flag is set on the current task
and we also handle the exception hooks).

I can call that is_hooking instead? And/or add a comment to explain the
purpose of this.

> 
> > +DEFINE_PER_CPU(struct user_hooks, user_hooks) = {
> > +#ifdef CONFIG_USER_HOOKS_FORCE
> > +       .hooking = true,
> > +#endif
> > +};
> > +
> > +void user_enter(void)
> > +{
> > +       unsigned long flags;
> > +       struct user_hooks *uh;
> > +
> > +       WARN_ON_ONCE(!current->mm);
> > +       local_irq_save(flags);
> > +       uh = &__get_cpu_var(user_hooks);
> > +       if (uh->hooking && !uh->in_user) {
> > +               uh->in_user = true;
> > +               rcu_user_enter();
> > +       }
> 
> By not using __get_cpu_var() but __this_cpu_*() you generate much better
> code (esp. on x86).
> 
> IOW. something like:
> 
>   if (__this_cpu_read(uh.hooking) && !__this_cpu_read(uh.in_user)) {
> 	__this_cpu_write(uh.in_user, true);
> 	rcu_user_enter();
>   }

Ok, I'll replace.

> 
> > +       local_irq_restore(flags);
> > +}
> > +
> > +void user_exit(void)
> > +{
> > +       unsigned long flags;
> > +       struct user_hooks *uh;
> > +
> > +       local_irq_save(flags);
> > +       uh = &__get_cpu_var(user_hooks);
> > +       if (uh->in_user) {
> > +               uh->in_user = false;
> > +               rcu_user_exit();
> > +       }
> > +       local_irq_restore(flags);
> > +}
> > +
> > +void user_hooks_switch(struct task_struct *prev,
> > +                      struct task_struct *next)
> > +{
> > +       struct user_hooks *uh;
> > +
> > +       uh = &__get_cpu_var(user_hooks);
> > +       if (uh->hooking) {
> > +               clear_tsk_thread_flag(prev, TIF_NOHZ);
> > +               set_tsk_thread_flag(next, TIF_NOHZ);
> > +       }
> 
> This seems pointless to me.. why are we flipping that flag on context
> switch instead of keeping it enabled at all times? This are two atomic
> ops in the context switch path, why?

Because the hooks are per cpu. If we activate the hooks on CPU 1 but not
on CPU 2 and prev was running on CPU 1 and migrates on CPU 2, it's going
to keep the hook on that CPU 2 if we don't clear the flag.
