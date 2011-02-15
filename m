Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1BONRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:17:05 -0500
Received: from www.tglx.de ([62.245.132.106]:39734 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1BONRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:17:02 -0500
Date: Tue, 15 Feb 2011 14:16:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kenneth Albanowski (Palm GBU)" <Kenneth.Albanowski@palm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: Question about clearing of tsk->robust_list in clone
In-Reply-To: <23C1F4DA0B73684F85AD25A73E4BB50315252BD7@ushqwmb09>
Message-ID: <alpine.LFD.2.00.1102151233330.26192@localhost6.localdomain6>
References: <23C1F4DA0B73684F85AD25A73E4BB50315252BD7@ushqwmb09>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Kenneth Albanowski (Palm GBU) wrote:

Cc'ed a few folks.

> I've been tracking down a bug I ran into with a robust pthreads mutex
> shared between a parent and a child that it forked. This finally came
> down to a bad interaction between glibc and the kernel (and looks to
> be present in the current Linux trees as well as glibc 2.13): 
> copy_process() explicitly clears the robust_list pointer in the cloned
> child. However, there is currently no logic in nptl to re-establish
> the robust list pointer after a fork.
> 
> There was some conversation about this in the Fedora bugtracker:
> 
>   https://bugzilla.redhat.com/show_bug.cgi?id=628608
> 
> Those folks appear to have reached the same conclusion as I: this
> could either be solved with some potentially complex glibc code, or by
> simply not having the kernel NULL out robust_list in the child.

That conclusion is just wrong.

> Can anyone say what problem was being fixed by initializing the robust
> list(s) to NULL? I've stared at the implementation, and I cannot see any
> harm (potentially a slight bit more work in exec, but no harm) in not
> clearing them.

copy_process() is used for a lot more than fork(). The most obvious
example is pthread_create() where we _MUST_ clear it in copy_process()
otherwise an exiting thread would run through the parents
robust_list.

You cannot preserve the pointer for fork either. The simple reason is
that it points to the parents list, which is copied during fork. So:

   mutex_1 = mmap(region1);
   mutex_2 = mmap(region2);  

   pthread_mutex_lock(mutex_1);

   pid = fork();

   if (!pid) {

        pthread_mutex_lock(mutex_2);

	-> mutex_2 is on robust_list after mutex_1

      	do_something();

	exit();

---> Kernel looks at the copied robust list, which says that it holds
     mutex_1 and mutex_2.

     The sanity checks in exit_robust_list will catch that mutex_1
     owner is not matching, but that makes it not more correct.

     Worse, the child might have unmapped region1 because it does not
     use it at all. That will fault in handling the robust list
     mutex_1 entry and then abort the list walk. So mutex_2 remains
     locked. Not brilliant either.

So the robust_list = NULL stays no matter what.

And I do not buy the argument about "complex glibc code" at all. glibc
already handles it for pthread_create() so why the hell can't it
handle it for fork() ?

Thanks,

	tglx
