Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2C0OKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:10:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53834 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2C0OKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:10:51 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1332338318-5958-23-git-send-email-fweisbec@gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<1332338318-5958-23-git-send-email-fweisbec@gmail.com>
Date: Tue, 27 Mar 2012 16:10:49 +0200
Message-ID: <CAOtvUMegNxbb4OHRo6cB3EWT6R0F0rpzZAd8d=pxoHjehSCgKw@mail.gmail.com>
Subject: Re: [PATCH 21/32] nohz/cpuset: Flush cputime on threads in nohz
 cpusets when waiting leader
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 3:58 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> When we wait for a zombie task, flush the cputimes on nohz cpusets
> in case we are waiting for a group leader that has threads running
> in nohz CPUs. This way thread_group_times() doesn't report stale
> values.
>
> <doubts>
> If I understood well the code, by the time we call that thread_group_times(),
> we may have childs that are still running, so this is necessary.
> But I need to check deeper.
> </doubts>
>
...
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 4b4042f..c194662 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -52,6 +52,7 @@
>  #include <linux/hw_breakpoint.h>
>  #include <linux/oom.h>
>  #include <linux/writeback.h>
> +#include <linux/cpuset.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -1712,6 +1713,13 @@ repeat:
>           (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
>                goto notask;
>
> +       /*
> +        * For cputime in sub-threads before adding them.
> +        * Must be called outside tasklist_lock lock because write lock
> +        * can be acquired under irqs disabled.
> +        */
> +       cpuset_nohz_flush_cputimes();
> +
>        set_current_state(TASK_INTERRUPTIBLE);
>        read_lock(&tasklist_lock);
>        tsk = current;
> --
> 1.7.5.4
>

I believe this patch is not needed because after this point we call
do_wait_thread /ptrace_do_wait, which both call wait_consider_task,
which calls wait_task_stopped/zombie/continued, which all eventually
calls getrusage, which calls k_getrusage where you added a call to
cpuset_noz_flush_cputimes() in another patch :-)

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
