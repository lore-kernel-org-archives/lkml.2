Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2HNVQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:16:55 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58172 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab2HNVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120810015222.GA19286@localhost>
References: <20120726134748.GA20605@localhost>
	<CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com>
	<20120810015222.GA19286@localhost>
Date: Tue, 14 Aug 2012 14:16:52 -0700
X-Google-Sender-Auth: 0zbjPU8VhpOGV2N3qgFOq-GWH54
Message-ID: <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 6:52 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Thu, Aug 09, 2012 at 06:39:34PM -0700, Kees Cook wrote:
>> Hi,
>>
>> So, after taking a closer look at this, I cannot understand how it's
>> possible. Yama's task_lock call is against "current", not "child",
>> which is what ptrace_may_access() is locking. And the same code makes
>> sure that current != child. Yama would never get called if current ==
>> child.
>>
>> How did you reproduce this situation?
>
> This warning can be triggered with Dave Jones' trinity tool:
>
> git://git.codemonkey.org.uk/trinity
>
> That's a very dangerous tool, please only run it as normal user in a
> backed up and chrooted test box. I personally run it inside an initrd.
> If you are interested in reproducing this, I can send you the ready
> made initrd in private email.

Well, even with your initrd, I can't reproduce this. You're running
this against a stock kernel? I can't see how the path you've shown can
possible happen. It could only happen if "task" was "current", but
there is an explicit test for that in ptrace_may_access(). Based on
the traceback, this is from reading /proc/$pid/stack (or
/proc/$pid/task/$tid/stack), rather than a direct ptrace() call, but
the code path for task != current still stands.

I've tried both normal and "trinity -c read" and I haven't seen the
trace you found. :(

If you can isolate the case further, I'm happy to fix it, but
currently, I don't see a path where this can deadlock.

Thanks,

-Kees

>> On Thu, Jul 26, 2012 at 6:47 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> > Here is a recursive lock possibility:
>> >
>> >         ptrace_may_access()
>> > =>        task_lock(task);
>> >             yama_ptrace_access_check()
>> >               get_task_comm()
>> > =>              task_lock(task);
>> >
>> > [   60.230444] =============================================
>> > [   60.232078] [ INFO: possible recursive locking detected ]
>> > [   60.232078] 3.5.0+ #281 Not tainted
>> > [   60.232078] ---------------------------------------------
>> > [   60.232078] trinity-child0/17019 is trying to acquire lock:
>> > [   60.232078]  (&(&p->alloc_lock)->rlock){+.+...}, at: [<c1176ffa>] get_task_comm+0x4a/0xf0
>> > [   60.232078]
>> > [   60.232078] but task is already holding lock:
>> > [   60.232078]  (&(&p->alloc_lock)->rlock){+.+...}, at: [<c10653fa>] ptrace_may_access+0x4a/0xf0
>> > [   60.232078]
>> > [   60.232078] other info that might help us debug this:
>> > [   60.232078]  Possible unsafe locking scenario:
>> > [   60.232078]
>> > [   60.232078]        CPU0
>> > [   60.232078]        ----
>> > [   60.232078]   lock(&(&p->alloc_lock)->rlock);
>> > [   60.232078]   lock(&(&p->alloc_lock)->rlock);
>> > [   60.232078]
>> > [   60.232078]  *** DEADLOCK ***
>> > [   60.232078]
>> > [   60.232078]  May be due to missing lock nesting notation
>> > [   60.232078]
>> > [   60.232078] 3 locks held by trinity-child0/17019:
>> > [   60.232078]  #0:  (&p->lock){+.+.+.}, at: [<c11a9683>] seq_read+0x33/0x6b0
>> > [   60.232078]  #1:  (&sig->cred_guard_mutex){+.+.+.}, at: [<c11ff8ae>] lock_trace+0x2e/0xb0
>> > [   60.232078]  #2:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<c10653fa>] ptrace_may_access+0x4a/0xf0
>> > [   60.232078]
>> > [   60.232078] stack backtrace:
>> > [   60.232078] Pid: 17019, comm: trinity-child0 Not tainted 3.5.0+ #281
>> > [   60.232078] Call Trace:
>> > [   60.232078]  [<c10c6238>] __lock_acquire+0x1498/0x14f0
>> > [   60.232078]  [<c10be7e7>] ? trace_hardirqs_off+0x27/0x40
>> > [   60.232078]  [<c10c6360>] lock_acquire+0xd0/0x110
>> > [   60.232078]  [<c1176ffa>] ? get_task_comm+0x4a/0xf0
>> > [   60.232078]  [<c1422290>] _raw_spin_lock+0x60/0x110
>> > [   60.232078]  [<c1176ffa>] ? get_task_comm+0x4a/0xf0
>> > [   60.232078]  [<c1176ffa>] get_task_comm+0x4a/0xf0
>> > [   60.232078]  [<c1246798>] yama_ptrace_access_check+0x468/0x4a0
>> > [   60.232078]  [<c124648f>] ? yama_ptrace_access_check+0x15f/0x4a0
>> > [   60.232078]  [<c124209a>] security_ptrace_access_check+0x1a/0x30
>> > [   60.232078]  [<c1065229>] __ptrace_may_access+0x189/0x310
>> > [   60.232078]  [<c10650cc>] ? __ptrace_may_access+0x2c/0x310
>> > [   60.232078]  [<c106542d>] ptrace_may_access+0x7d/0xf0
>> > [   60.232078]  [<c11ff8ea>] lock_trace+0x6a/0xb0
>> > [   60.232078]  [<c11ffa46>] proc_pid_stack+0x76/0x170
>> > [   60.232078]  [<c1201064>] proc_single_show+0x74/0x100
>> > [   60.232078]  [<c11a97b3>] seq_read+0x163/0x6b0
>> > [   60.232078]  [<c105bf70>] ? do_setitimer+0x220/0x330
>> > [   60.232078]  [<c11a9650>] ? seq_lseek+0x1f0/0x1f0
>> > [   60.232078]  [<c116b55a>] vfs_read+0xca/0x280
>> > [   60.232078]  [<c11a9650>] ? seq_lseek+0x1f0/0x1f0
>> > [   60.232078]  [<c116b776>] sys_read+0x66/0xe0
>> > [   60.232078]  [<c1423d9d>] syscall_call+0x7/0xb
>> > [   60.232078]  [<c1420000>] ? __schedule+0x2a0/0xc80

-- 
Kees Cook
Chrome OS Security
