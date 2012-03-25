Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2CYRvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 13:51:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab2CYRve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 13:51:34 -0400
Date: Sun, 25 Mar 2012 19:42:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: Re: [PATCH v2.1 01/10] cpu: Introduce clear_tasks_mm_cpumask()
	helper
Message-ID: <20120325174210.GA23605@redhat.com>
References: <20120324102609.GA28356@lizard> <20120324102751.GA29067@lizard> <1332593021.16159.27.camel@twins> <20120324164316.GB3640@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120324164316.GB3640@lizard>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Anton Vorontsov wrote:
>
> Many architctures clear tasks' mm_cpumask like this:
>
> 	read_lock(&tasklist_lock);
> 	for_each_process(p) {
> 		if (p->mm)
> 			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
> 	}
> 	read_unlock(&tasklist_lock);

Namely arm, powerpc, and sh.

> The code above has several problems, such as:
>
> 1. Working with task->mm w/o getting mm or grabing the task lock is
>    dangerous as ->mm might disappear (exit_mm() assigns NULL under
>    task_lock(), so tasklist lock is not enough).

This is not actually true for arm and sh, afaics. They do not even
need tasklist or rcu lock for for_each_process().

__cpu_disable() is called by __stop_machine(), we know that nobody
can preempt us and other CPUs can do nothing.

> 2. Checking for process->mm is not enough because process' main
>    thread may exit or detach its mm via use_mm(), but other threads
>    may still have a valid mm.

Yes,

> Also, Per Peter Zijlstra's idea, now we don't grab tasklist_lock in
> the new helper, instead we take the rcu read lock. We can do this
> because the function is called after the cpu is taken down and marked
> offline, so no new tasks will get this cpu set in their mm mask.

And only powerpc needs rcu_read_lock() and task_lock().

OTOH, I do not understand why powepc does this on CPU_DEAD...
And probably CPU_UP_CANCELED doesn't need to clear mm_cpumask().

That said, personally I think these patches are fine, the common
helper makes sense.

Oleg.

