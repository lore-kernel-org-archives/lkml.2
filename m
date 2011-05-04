Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1EDSWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:22:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36849 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1EDSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RfrPnwhr6V7Ljc6PmD5utXDzLMjlilR7sDE9SH0xU0EhauJ8arN0vPL2xXzLB/a9u6
         Vvuft3Q2tIOjZM7ZjecV5KSfSCu22fPW+Pb5j4Vo/QJ4CJP+e748+8EWuxSocKd2L7yo
         +tW8ZtM1Prlla0+2ScI2zijPhL0iXoNyYSHdI=
Date: Wed, 4 May 2011 20:22:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, "v2.6.33.." <stable@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task
 breakpoints
Message-ID: <20110504182158.GC1804@nowhere>
References: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
 <1304429124-2376-2-git-send-email-fweisbec@gmail.com>
 <20110504063106.GA20140@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504063106.GA20140@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 08:31:06AM +0200, Ingo Molnar wrote:
> 
> (Linus and Andrew Cc:-ed as well)
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > When a task is traced and is in a stopped state, the tracer
> > may execute a ptrace request to examine the tracee state and
> > get its task struct. Right after, the tracee can be killed
> > and thus its breakpoints released.
> > This can happen concurrently when the tracer is in the middle
> > of reading or modifying these breakpoints, leading to dereferencing
> > a freed pointer.
> > 
> > Hence, to prepare the fix, create a generic breakpoint reference
> > holding API. When a reference on the breakpoints of a task is
> > held, the breakpoints won't be released until the last reference
> > is dropped. After that, no more ptrace request on the task's
> > breakpoints can be serviced for the tracer.
> > 
> > Reported-by: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Ok, this series looks a bit scary - and this ptrace.h change does not have 
> Oleg's Acked-by. (the arch bits all have maintaner Acked-by's)
> 
> The changes look a bit ugly as well: beyond the ugly ifdeffery, we have 
> ptrace.h::ptrace_init_task(), which is only used in 
> tracehook.h::tracehook_finish_clone() which is only used in 
> kernel/fork.c::copy_process().
> 
> That's two levels of obfuscation to do something rather simple - i think we 
> should get rid of the tracehook.h redirections, it did not work out in the end 
> as a method of capturing events - ftrace TRACE_EVENT() seems better structured 
> and more maintainable.
> 
> But i guess we could live with this fix for v2.6.39, if neither Oleg nor Linus 
> and Andrew are hating this further complication of the ptrace mess enough to 
> NAK it. Thoughts?
> 
> Plus, i'd really love it if you did some stress-testing of this change of a 
> mixed ptrace breakpoints and perf breakpoints workload, on some sufficiently 
> SMP box. gdb's hbreak is a very low freq way of testing thus such regressions 
> take ages to be reported.

But the perf breakpoints (those created using perf syscall) are not touched
at all by this patch. Only the ptrace ones.

What I can stress test is trying some ptrace breakpoint request and at the
same time SIGKILL the child, which is the only way to reproduce the bug
supposed to be fixed. And run that in a loop for one night. I'll try that.
