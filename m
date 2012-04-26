Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab2DZX7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 19:59:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2DZX7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 19:59:15 -0400
Date: Thu, 26 Apr 2012 16:59:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linaro-kernel@lists.linaro.org, patches@linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] cpu: Introduce clear_tasks_mm_cpumask() helper
Message-Id: <20120426165911.00cebd31.akpm@linux-foundation.org>
In-Reply-To: <20120423070736.GA30752@lizard>
References: <20120423070641.GA27702@lizard>
	<20120423070736.GA30752@lizard>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 00:07:36 -0700
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> Many architectures clear tasks' mm_cpumask like this:
> 
> 	read_lock(&tasklist_lock);
> 	for_each_process(p) {
> 		if (p->mm)
> 			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
> 	}
> 	read_unlock(&tasklist_lock);
> 
> Depending on the context, the code above may have several problems,
> such as:
> 
> 1. Working with task->mm w/o getting mm or grabing the task lock is
>    dangerous as ->mm might disappear (exit_mm() assigns NULL under
>    task_lock(), so tasklist lock is not enough).
> 
> 2. Checking for process->mm is not enough because process' main
>    thread may exit or detach its mm via use_mm(), but other threads
>    may still have a valid mm.
> 
> This patch implements a small helper function that does things
> correctly, i.e.:
> 
> 1. We take the task's lock while whe handle its mm (we can't use
>    get_task_mm()/mmput() pair as mmput() might sleep);
> 
> 2. To catch exited main thread case, we use find_lock_task_mm(),
>    which walks up all threads and returns an appropriate task
>    (with task lock held).
> 
> Also, Per Peter Zijlstra's idea, now we don't grab tasklist_lock in
> the new helper, instead we take the rcu read lock. We can do this
> because the function is called after the cpu is taken down and marked
> offline, so no new tasks will get this cpu set in their mm mask.
> 

Seems reasonable.

> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -179,6 +179,7 @@ extern void put_online_cpus(void);
>  #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
>  #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
>  #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
> +void clear_tasks_mm_cpumask(int cpu);
>  int cpu_down(unsigned int cpu);
>  
>  #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 2060c6e..ecdf499 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -10,6 +10,8 @@
>  #include <linux/sched.h>
>  #include <linux/unistd.h>
>  #include <linux/cpu.h>
> +#include <linux/oom.h>
> +#include <linux/rcupdate.h>
>  #include <linux/export.h>
>  #include <linux/kthread.h>
>  #include <linux/stop_machine.h>
> @@ -171,6 +173,30 @@ void __ref unregister_cpu_notifier(struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_cpu_notifier);
>  
> +void clear_tasks_mm_cpumask(int cpu)

The operation of this function was presumably obvious to you at the
time you wrote it, but that isn't true of other people at later times.

Please document it?


> +{
> +	struct task_struct *p;
> +
> +	/*
> +	 * This function is called after the cpu is taken down and marked
> +	 * offline,

hm, well.  Who said that this function will only ever be called
after that CPU was taken down?  There is nothing in the function name
nor in the (absent) documentation which enforces this precondition.

If someone tries to use this function for a different purpose, or
copies-and-modifies it for a different purpose, we just shot them in
the foot.

They'd be pretty dumb to do that without reading the local comment,
but still...

> 	 so its not like new tasks will ever get this cpu set in
> +	 * their mm mask. -- Peter Zijlstra
> +	 * Thus, we may use rcu_read_lock() here, instead of grabbing
> +	 * full-fledged tasklist_lock.
> +	 */
> +	rcu_read_lock();
> +	for_each_process(p) {
> +		struct task_struct *t;
> +
> +		t = find_lock_task_mm(p);
> +		if (!t)
> +			continue;
> +		cpumask_clear_cpu(cpu, mm_cpumask(t->mm));
> +		task_unlock(t);
> +	}
> +	rcu_read_unlock();
> +}

It is good that this code exists under CONFIG_HOTPLUG_CPU.  Did you
check that everything works correctly with CONFIG_HOTPLUG_CPU=n?

