Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1GCCFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 22:05:55 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36473 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab1GCCFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 22:05:54 -0400
X-AuditID: b753bd60-a32aeba0000019f4-e2-4e0fce7ef1b6
X-AuditID: b753bd60-a32aeba0000019f4-e2-4e0fce7ef1b6
Message-ID: <4E0FCE7C.9060207@hitachi.com>
Date: Sun, 03 Jul 2011 11:05:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip ] [BUGFIX] x86: Remove preempt disabling from
 kprobes
References: <4E0DC859.6050405@hitachi.com>	 <20110701131408.30886.45766.stgit@localhost.localdomain>	 <1309527824.26417.149.camel@gandalf.stny.rr.com> <1309528411.26417.153.camel@gandalf.stny.rr.com>
In-Reply-To: <1309528411.26417.153.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/01 22:53), Steven Rostedt wrote:
> On Fri, 2011-07-01 at 09:43 -0400, Steven Rostedt wrote:
>
>> I applied it to v3.0-rc5. And not surprisingly it works. But the
>> question I have is, when we return from the trap, and NEED_RECHED is
>> set, will it schedule?

No, AFAIK, when breakpoint (a.k.a. int3 on x86) and single-step (a.k.a.
debug on x86) exception handlers are kicked in kernel space, it doesn't
schedule (if kicked from userspace, it does).
You can see that at paranoid_exit or ret_from_exception in entry_*.S.

>> My test placed the probe within the scheduler
>> where preemption is already disabled. Let me do this in places that has
>> preemption and interrupts enabled.
>>
>> I'll also try a kernel mod that adds a probe handler that does a
>> udelay() loop, forcing the timer interrupt to be set on return of the
>> trap, and see what happens there.
>
> I didn't need to do the above. Just adding a probe at the beginning of
> schedule() should do the trick. As I see from the latency-format option
> set, that NEED_RESCHED is enabled when we enter the path. If interrupts
> are enabled on single step, I would think that the code would go into an
> infinite loop if it had issues there.
>
> Thus I think we can say that removing preempt_disable() from kprobes in
> x86_64 (and probably 32) is safe. I'll go and test this on my PPC64 and
> mips (if I can get that compiled).

Thank you for checking that.

And here maybe another topic, but related.
I still have to tell you that kprobes can't probe add_preempt_count
when CONFIG_TRACE_PREEMPT/DEBUG_PREEMPT=y, even with this patch, because
another path disables preemption.
Here is a test log with removing __kprobes from add_preempt_count() and
add  "DEBUG_LOCKS_WARN_ON(kprobe_running());" on the entry of it.
(As you can see, this is on a kvm and lockdep is enabled)

 Kprobe smoke test started
 ------------[ cut here ]------------
 WARNING: at /home/mhiramat/ksrc/linux-2.6/kernel/sched.c:4094
add_preempt_count+0x11a/0x120()
 Hardware name: Bochs
 Modules linked in:
 Pid: 1, comm: swapper Not tainted 3.0.0-rc4-tip+ #16
 Call Trace:
 <#DB>  [<ffffffff8105b84f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8105b8aa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8105007a>] add_preempt_count+0x11a/0x120
 [<ffffffff81033b43>] kvm_clock_read+0x13/0x70
 [<ffffffff810128b9>] sched_clock+0x9/0x10
 [<ffffffff81087f05>] sched_clock_local+0x25/0x90
 [<ffffffff810880a8>] sched_clock_cpu+0xb8/0x130
 [<ffffffff81088152>] local_clock+0x32/0x80
 [<ffffffff810951bc>] lock_release_holdtime.part.3+0x1c/0x160
 [<ffffffff815799d0>] ? notifier_call_chain+0x70/0x70
 [<ffffffff81097d00>] lock_release+0x1b0/0x270
 [<ffffffff815799ad>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff81579a5b>] __atomic_notifier_call_chain+0x8b/0xb0
 [<ffffffff815799d0>] ? notifier_call_chain+0x70/0x70
 [<ffffffff81b50470>] ? audit_tree_init+0x58/0x58
 [<ffffffff81579a96>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff81579ace>] notify_die+0x2e/0x30
 [<ffffffff8157721f>] do_int3+0x5f/0xe0
 [<ffffffff815766fd>] int3+0x2d/0x40
 [<ffffffff81b50470>] ? audit_tree_init+0x58/0x58
 <<EOE>>  [<ffffffff810b79cd>] ? init_test_probes+0x6d/0x560
 [<ffffffff810a1d58>] ? register_module_notifier+0x18/0x20
 [<ffffffff81b505d7>] init_kprobes+0x167/0x189
 [<ffffffff812c5608>] ? __raw_spin_lock_init+0x38/0x70
 [<ffffffff81b50418>] ? audit_watch_init+0x3a/0x3a
 [<ffffffff811a48e9>] ? fsnotify_alloc_group+0xb9/0x100
 [<ffffffff81002042>] do_one_initcall+0x42/0x180
 [<ffffffff81b33d11>] kernel_init+0xda/0x154
 [<ffffffff8157e624>] kernel_thread_helper+0x4/0x10
 [<ffffffff81047565>] ? finish_task_switch+0x85/0x110
 [<ffffffff81576558>] ? retint_restore_args+0x13/0x13
 [<ffffffff81b33c37>] ? start_kernel+0x3f3/0x3f3
 [<ffffffff8157e620>] ? gs_change+0x13/0x13
 ---[ end trace fe4ebffb2b8ff187 ]---

So, even if some __kprobes functions really doesn't called from
kprobes itself, another path in do_int3/do_debug can call it and
causes an infinit loop.

Perhaps, we'd better not use this kind of "normal" notifier call
chain path, and call kprobe handler directly, as kgdb does, to
clarify what functions can be called on the path of kprobes.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
