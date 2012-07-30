Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2G3PIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:08:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:35255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3PIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:08:36 -0400
Message-ID: <1343660892.20897.3.camel@twins>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Date: Mon, 30 Jul 2012 17:08:12 +0200
In-Reply-To: <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
	 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 17:40 +0200, Frederic Weisbecker wrote:
> +++ b/kernel/user_hooks.c
> @@ -0,0 +1,56 @@
> +#include <linux/user_hooks.h>
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
> +#include <linux/percpu.h>
> +
> +struct user_hooks {
> +       bool hooking;
> +       bool in_user;
> +};

I really detest using bool in structures.. but that's just me. Also this
really wants a comment as to wtf 'hooking' means. in_user I can just
about guess.

> +DEFINE_PER_CPU(struct user_hooks, user_hooks) = {
> +#ifdef CONFIG_USER_HOOKS_FORCE
> +       .hooking = true,
> +#endif
> +};
> +
> +void user_enter(void)
> +{
> +       unsigned long flags;
> +       struct user_hooks *uh;
> +
> +       WARN_ON_ONCE(!current->mm);
> +       local_irq_save(flags);
> +       uh = &__get_cpu_var(user_hooks);
> +       if (uh->hooking && !uh->in_user) {
> +               uh->in_user = true;
> +               rcu_user_enter();
> +       }

By not using __get_cpu_var() but __this_cpu_*() you generate much better
code (esp. on x86).

IOW. something like:

  if (__this_cpu_read(uh.hooking) && !__this_cpu_read(uh.in_user)) {
	__this_cpu_write(uh.in_user, true);
	rcu_user_enter();
  }

> +       local_irq_restore(flags);
> +}
> +
> +void user_exit(void)
> +{
> +       unsigned long flags;
> +       struct user_hooks *uh;
> +
> +       local_irq_save(flags);
> +       uh = &__get_cpu_var(user_hooks);
> +       if (uh->in_user) {
> +               uh->in_user = false;
> +               rcu_user_exit();
> +       }
> +       local_irq_restore(flags);
> +}
> +
> +void user_hooks_switch(struct task_struct *prev,
> +                      struct task_struct *next)
> +{
> +       struct user_hooks *uh;
> +
> +       uh = &__get_cpu_var(user_hooks);
> +       if (uh->hooking) {
> +               clear_tsk_thread_flag(prev, TIF_NOHZ);
> +               set_tsk_thread_flag(next, TIF_NOHZ);
> +       }

This seems pointless to me.. why are we flipping that flag on context
switch instead of keeping it enabled at all times? This are two atomic
ops in the context switch path, why?

> +} 
