Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0KIOvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:51:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab0KIOvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:51:37 -0500
Date: Tue, 9 Nov 2010 15:54:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Roland McGrath <roland@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] posix-cpu-timers: workaround to suppress the problems
 with mt exec
Message-ID: <20101109145419.GA26445@redhat.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com>
 <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6>
 <20101102160223.GC5964@swordfish.minsk.epam.com>
 <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6>
 <20101102183308.GA17720@redhat.com>
 <20101103105832.GA30053@swordfish.minsk.epam.com>
 <20101103124835.GA604@redhat.com>
 <20101103161059.GA13530@redhat.com>
 <20101105155342.GA13606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105155342.GA13606@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 04:53:42PM +0100, Oleg Nesterov wrote:
> posix-cpu-timers.c correctly assumes that the dying process does
> posix_cpu_timers_exit_group() and removes all !CPUCLOCK_PERTHREAD
> timers from signal->cpu_timers list.
> 
> But, it also assumes that timer->it.cpu.task is always the group
> leader, and thus the dead ->task means the dead thread group.
> 
> This is obviously not true after de_thread() changes the leader.
> After that almost every posix_cpu_timer_ method has problems.
> 
> It is not simple to fix this bug correctly. First of all, I think
> that timer->it.cpu should use struct pid instead of task_struct.
> Also, the locking should be reworked completely. In particular,
> tasklist_lock should not be used at all. This all needs a lot of
> nontrivial and hard-to-test changes.
> 
> Change __exit_signal() to do posix_cpu_timers_exit_group() when
> the old leader dies during exec. This is not the fix, just the
> temporary hack to hide the problem for 2.6.37 and stable. IOW,
> this is obviously wrong but this is what we currently have anyway:
> cpu timers do not work after mt exec.
> 
> In theory this change adds another race. The exiting leader can
> detach the timers which were attached to the new leader. However,
> the window between de_thread() and release_task() is small, we
> can pretend that sys_timer_create() was called before de_thread().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

