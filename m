Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2DPUsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:48:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2DPUs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:48:29 -0400
Date: Mon, 16 Apr 2012 22:47:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] i387: ptrace breaks the lazy-fpu-restore logic
Message-ID: <20120416204756.GA24884@redhat.com>
References: <20120414235238.GA11131@redhat.com> <CA+55aFxJykAy4=9WVOnUOy1PUBYLmPy9mJmydoYZpQEbSkfvJQ@mail.gmail.com> <20120415223808.GA26214@redhat.com> <CA+55aFwpts0X=V67+wUchJN9Bgjh17eZJqOo0Y0oc2Mzbfa7QA@mail.gmail.com> <CA+55aFzeLqBMJ_tGyKh7EJhqWwPkD7DfggZ=NDmxwi3gYNjkdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzeLqBMJ_tGyKh7EJhqWwPkD7DfggZ=NDmxwi3gYNjkdA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Linus Torvalds wrote:
>
> Put another way: I do think it would be a good idea to do the "reset
> last_cpu" in copy_thread() too. It doesn't really cost us anything,
> and it's cleaner to always just make sure that last_cpu is "valid"
> (even if the fpu_owner_task is *also* used to invalidate it, and even
> if we never use the lazy restore if fpu_counter is zero and thus
> fpu.preload isn't set).

Yes, this was my thinking too, and initially I was going to include
this change into this patch. But lets do it separately.

I feel we need some cleanups. For example, it seems that flush_thread()
can do this too, although in this case we can rely on __thread_fpu_end()
which clears fpu_owner_task.

So I am just sending your one-liner, and according to my testing it
fixes the problem.

And A couple of off-topic questions...


Why unlazy_fpu() clears ->fpu_counter? Afaics, this doesn't make
sense and unneeded.


And it is not clear to me why init_fpu() does unlazy_fpu(), afaics
tsk_used_math() "tsk == current" is only possible if this task dumps
the core.


arch_dup_task_struct() checks fpu_allocated(), this doesn't look
exactly right to me. Suppose that a task without PF_USED_MATH uses
FPU only once in the signal handler. If it forks after that, we
allocate and copy fpu->state for no reason. IOW, we probably should
check tsk_used_math() instead, but do memzero(&dst->thread.fpu)
unconditionally. And perhaps this memzero() deserves a helper
which can set .last_cpu = -1, and this is what copy_thread()
should call.


OTOH, this reminds me, a long ago I noticed by accident that all
threads on the testing machine have PF_USED_MATH set. IIRC, This
is because /sbin/init does memset or memcpy and glibc uses xmm
for this. Not that I really suggest this, but perhaps
prctl(PR_DROP_FPU) makes some sense.

Oleg.

