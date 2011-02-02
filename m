Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1BBMOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:14:49 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58553 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1BBMOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:14:48 -0500
X-AuditID: b753bd60-a64bdba000004916-13-4d494ab56263
X-AuditID: b753bd60-a64bdba000004916-13-4d494ab56263
Message-ID: <4D494AB1.1040508@hitachi.com>
Date: Wed, 02 Feb 2011 21:14:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, agl@google.com, fweisbec@gmail.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: Using ftrace/perf as a basis for generic seccomp
References: <1294867725.3237.230.camel@localhost.localdomain> <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
In-Reply-To: <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

(2011/02/01 23:58), Eric Paris wrote:
> On Wed, Jan 12, 2011 at 4:28 PM, Eric Paris <eparis@redhat.com> wrote:
>> Some time ago Adam posted a patch to allow for a generic seccomp
>> implementation (unlike the current seccomp where your choice is all
>> syscalls or only read, write, sigreturn, and exit) which got little
>> traction and it was suggested he instead do the same thing somehow using
>> the tracing code:
>> http://thread.gmane.org/gmane.linux.kernel/833556

Hm, interesting idea :)
But why would you like to use tracing code? just for hooking?

>> The actual method that this could be achieved was apparently left as an
>> exercise for the reader.  Since I'd like to do something similar (and
>> actually basically reimplemented Adam's code before I found this thread)
>> I guess that makes me the reader.  I've never touched
>> perf/ftrace/whatever so I'm not even knowledgeably enough to ask good
>> questions so please, try to talk to me like a 2 year old.

OK, I'll try to explain;

Ftrace/perf syscall event tracing is based on syscall tracepoints
(sys_enter and sys_exit) which are implemented as a special hook
requiring TIF_SYSCALL_TRACEPOINT.

--<arch/x86/kernel/ptrace.c>--
asmregparm long syscall_trace_enter(struct pt_regs *regs)
{
        long ret = 0;
[...]
        /* do the secure computing check first */
        secure_computing(regs->orig_ax);		<-- secomp!

        if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
                ret = -1L;

        if ((ret || test_thread_flag(TIF_SYSCALL_TRACE)) &&
            tracehook_report_syscall_entry(regs))
                ret = -1L;

        if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
                trace_sys_enter(regs, regs->orig_ax);	<--here!
----

All syscalls issued by threads which has TIF_SYSCALL_TRACEPOINT
kick trace_sys_enter() tracepoint, and then the tracepoint calls
ftrace handler or perf handler.

And this tracepoint is not only for ftrace/perf, but also you
can use it directly via register_trace_sys_enter() (the tracepoint
can be shared among several handlers). If you just want to hook
the syscall entry, I recommend that instead of modifying ftrace/perf.
See kernel/trace/trace_syscalls.c, Documentation/trace/tracepoints.txt
and samples/tracepoints/ for details.

However, I think here is an ordering problem. As you can see, secomp
hook is done before these hooks, that might cause a problem because
tracehook_report_syscall_entry(), which is also done before tracepoint,
is used by ptrace().
This means that someone can hook into an unsafe syscall via debugger.

So, finally, I think you'd better expand secure_computing() hook, or
introduce more generic hook-point.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
