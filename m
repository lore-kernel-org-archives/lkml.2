Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2HODBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 23:01:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:5318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2HODBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 23:01:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,770,1336374000"; 
   d="scan'208";a="201207981"
Date: Wed, 15 Aug 2012 11:01:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
Message-ID: <20120815030110.GA24836@localhost>
References: <20120726134748.GA20605@localhost>
 <CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com>
 <20120810015222.GA19286@localhost>
 <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:16:52PM -0700, Kees Cook wrote:
> On Thu, Aug 9, 2012 at 6:52 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > On Thu, Aug 09, 2012 at 06:39:34PM -0700, Kees Cook wrote:
> >> Hi,
> >>
> >> So, after taking a closer look at this, I cannot understand how it's
> >> possible. Yama's task_lock call is against "current", not "child",
> >> which is what ptrace_may_access() is locking. And the same code makes
> >> sure that current != child. Yama would never get called if current ==
> >> child.
> >>
> >> How did you reproduce this situation?
> >
> > This warning can be triggered with Dave Jones' trinity tool:
> >
> > git://git.codemonkey.org.uk/trinity
> >
> > That's a very dangerous tool, please only run it as normal user in a
> > backed up and chrooted test box. I personally run it inside an initrd.
> > If you are interested in reproducing this, I can send you the ready
> > made initrd in private email.
> 
> Well, even with your initrd, I can't reproduce this. You're running
> this against a stock kernel? I can't see how the path you've shown can

Yes, it happens on 3.6-rc1.

> possible happen. It could only happen if "task" was "current", but
> there is an explicit test for that in ptrace_may_access(). Based on
> the traceback, this is from reading /proc/$pid/stack (or
> /proc/$pid/task/$tid/stack), rather than a direct ptrace() call, but
> the code path for task != current still stands.
> 
> I've tried both normal and "trinity -c read" and I haven't seen the
> trace you found. :(
> 
> If you can isolate the case further, I'm happy to fix it, but
> currently, I don't see a path where this can deadlock.

Even if it's proved to be a false warning, it's still very worthwhile
to apply Oleg's fix to quiet the warning. Such warnings will mislead
my bisect script. The sooner it's fixed, the better. And I like Oleg's
fix because it makes things more simple and a little bit faster.

btw, I see some different warnings when digging through the boot logs:

(x86_64-randconfig-b050)
[  128.725667]
[  128.728649] =============================================
[  128.733989] [ INFO: possible recursive locking detected ]
[  128.733989] 3.6.0-rc1 #1 Not tainted
[  128.733989] ---------------------------------------------
[  128.733989] trinity-child0/523 is trying to acquire lock:
[  128.733989]  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff810e0481>] get_task_comm+0x20/0x47
[  128.733989]
[  128.733989] but task is already holding lock:
[  128.733989]  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff810572ab>] sys_ptrace+0x158/0x313
[  128.733989]
[  128.733989] other info that might help us debug this:
[  128.733989]  Possible unsafe locking scenario:
[  128.733989]
[  128.733989]        CPU0
[  128.733989]        ----
[  128.733989]   lock(&(&p->alloc_lock)->rlock);
[  128.733989]   lock(&(&p->alloc_lock)->rlock);
[  128.733989]
[  128.733989]  *** DEADLOCK ***
[  128.733989]
[  128.733989]  May be due to missing lock nesting notation
[  128.733989]
[  128.733989] 2 locks held by trinity-child0/523:
[  128.733989]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81057290>] sys_ptrace+0x13d/0x313
[  128.733989]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff810572ab>] sys_ptrace+0x158/0x313
[  128.733989]
[  128.733989] stack backtrace:
[  128.733989] Pid: 523, comm: trinity-child0 Not tainted 3.6.0-rc1 #1
[  128.733989] Call Trace:
[  128.733989]  [<ffffffff81085649>] __lock_acquire+0xbe0/0xcfb
[  128.733989]  [<ffffffff81084884>] ? mark_lock+0x2d/0x212
[  128.733989]  [<ffffffff81084884>] ? mark_lock+0x2d/0x212
[  128.733989]  [<ffffffff8108639d>] lock_acquire+0x82/0x9d
[  128.733989]  [<ffffffff810e0481>] ? get_task_comm+0x20/0x47
[  128.733989]  [<ffffffff81a35ddf>] _raw_spin_lock+0x3b/0x4a
[  128.733989]  [<ffffffff810e0481>] ? get_task_comm+0x20/0x47
[  128.733989]  [<ffffffff810e0481>] get_task_comm+0x20/0x47
[  128.733989]  [<ffffffff81392c01>] yama_ptrace_access_check+0x16a/0x1c7
[  128.733989]  [<ffffffff810864e3>] ? lock_release+0x12b/0x157
[  128.733989]  [<ffffffff81390bfb>] security_ptrace_access_check+0xe/0x10
[  128.733989]  [<ffffffff81056e2b>] __ptrace_may_access+0x109/0x11b
[  128.733989]  [<ffffffff810572b8>] sys_ptrace+0x165/0x313
[  128.733989]  [<ffffffff81a37079>] system_call_fastpath+0x16/0x1b
[  128.823670] ptrace of pid 522 was attempted by: trinity-child0 (pid 523)


(x86_64-randconfig-k056)
[   87.057392]
[   87.058009] =============================================
[   87.058009] [ INFO: possible recursive locking detected ]
[   87.058009] 3.6.0-rc1-00011-gf8cdda8 #2 Not tainted
[   87.058009] ---------------------------------------------
[   87.058009] trinity-child0/328 is trying to acquire lock:
[   87.058009]  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff81104632>] spin_lock+0x9/0xb
[   87.058009]
[   87.058009] but task is already holding lock:
[   87.058009]  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff8106cb40>] ptrace_attach+0xa4/0x208
[   87.058009]
[   87.058009] other info that might help us debug this:
[   87.058009]  Possible unsafe locking scenario:
[   87.058009]
[   87.058009]        CPU0
[   87.058009]        ----
[   87.058009]   lock(&(&p->alloc_lock)->rlock);
[   87.058009]   lock(&(&p->alloc_lock)->rlock);
[   87.058009]
[   87.058009]  *** DEADLOCK ***
[   87.058009]
[   87.058009]  May be due to missing lock nesting notation
[   87.058009]
[   87.058009] 2 locks held by trinity-child0/328:
[   87.058009]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff8106cb25>] ptrace_attach+0x89/0x208
[   87.058009]  #1:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff8106cb40>] ptrace_attach+0xa4/0x208
[   87.058009]
[   87.058009] stack backtrace:
[   87.058009] Pid: 328, comm: trinity-child0 Not tainted 3.6.0-rc1-00011-gf8cdda8 #2
[   87.058009] Call Trace:
[   87.058009]  [<ffffffff810a104e>] __lock_acquire+0xbe0/0xcfb
[   87.058009]  [<ffffffff810a07d3>] ? __lock_acquire+0x365/0xcfb
[   87.058009]  [<ffffffff810a0289>] ? mark_lock+0x2d/0x212
[   87.058009]  [<ffffffff810a0289>] ? mark_lock+0x2d/0x212
[   87.058009]  [<ffffffff810a1da2>] lock_acquire+0x82/0x9d
[   87.058009]  [<ffffffff81104632>] ? spin_lock+0x9/0xb
[   87.058009]  [<ffffffff816848af>] _raw_spin_lock+0x3b/0x4a
[   87.058009]  [<ffffffff81104632>] ? spin_lock+0x9/0xb
[   87.058009]  [<ffffffff81684a42>] ? _raw_spin_unlock_irqrestore+0x48/0x5c
[   87.058009]  [<ffffffff81104632>] spin_lock+0x9/0xb
[   87.058009]  [<ffffffff811058f3>] get_task_comm+0x20/0x47
[   87.058009]  [<ffffffff81239447>] yama_ptrace_access_check+0x15b/0x1a4
[   87.058009]  [<ffffffff812379fb>] security_ptrace_access_check+0xe/0x10
[   87.058009]  [<ffffffff8106ca8a>] __ptrace_may_access+0x110/0x122
[   87.058009]  [<ffffffff8106cb4d>] ptrace_attach+0xb1/0x208
[   87.058009]  [<ffffffff8106cfd0>] sys_ptrace+0x5c/0xb9
[   87.058009]  [<ffffffff81685b79>] system_call_fastpath+0x16/0x1b
[   87.122562] ptrace of pid 326 was attempted by: trinity-child0 (pid 328)
[   90.259448] ptrace of pid 332 was attempted by: trinity-child0 (pid 335)

Thanks,
Fengguang
