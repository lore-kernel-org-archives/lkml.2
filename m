Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1G3PZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1G3PZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:25:22 -0400
Date: Sat, 30 Jul 2011 17:22:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, Ying Han <yinghan@google.com>
Subject: mm->oom_disable_count is broken
Message-ID: <20110730152238.GA17424@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110727163610.GJ23793@redhat.com> <20110727175624.GA3950@redhat.com> <20110728154324.GA22864@redhat.com> <alpine.DEB.2.00.1107281341060.16093@chino.kir.corp.google.com> <20110729141431.GA3501@redhat.com> <20110730143426.GA6061@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730143426.GA6061@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Oleg Nesterov wrote:
>
> So I'd suggest this hack^Wpatch as a quick fix. I still think this
> code is not right, but the patch tries to keep the current logic.

And this reminds me. mm->oom_disable_count looks absolutely broken.
IIRC, I already complained but nobody replied.

What does this counter mean?

	/* How many tasks sharing this mm are OOM_DISABLE */
	atomic_t oom_disable_count;

tasks? processes or threads?

Lets look at oom_adjust_write(),

		if (task->signal->oom_adj == OOM_DISABLE)
			atomic_inc(&task->mm->oom_disable_count);

OK, so it is per-process. No matter how many threads this process
has, mm->oom_disable_count becomes 1 (ignoring CLONE_VM).


However, exit_mm() does:

	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
		atomic_dec(&mm->oom_disable_count);

but this is per-thread! it becomes zero and then negative after
pthread_exit().


copy_process()->copy_mm() seems to think it is per-thread too. But,
bad_fork_cleanup_mm:

	if (p->mm) {
		task_lock(p);
		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
			atomic_dec(&p->mm->oom_disable_count);
		task_unlock(p);
		mmput(p->mm);
	}

Why do we take task_lock() ? OK, oom_score_adj_write() does task_lock()
too, but this can't help in the multithreaded case? Why copy_mm() checks
->oom_score_adj lockless?

Oleg.

