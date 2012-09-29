Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2I2Gqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 02:46:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34352 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2I2Gqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 02:46:30 -0400
Message-ID: <50669952.1000805@gmail.com>
Date: Sat, 29 Sep 2012 08:46:42 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: eqs related warnings in linux-next
References: <50659D37.2020206@gmail.com> <20120928133633.GC12843@somewhere.redhat.com> <20120928173133.GB2498@linux.vnet.ibm.com>
In-Reply-To: <20120928173133.GB2498@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 07:31 PM, Paul E. McKenney wrote:
> On Fri, Sep 28, 2012 at 03:36:43PM +0200, Frederic Weisbecker wrote:
>> > On Fri, Sep 28, 2012 at 02:51:03PM +0200, Sasha Levin wrote:
>>> > > Hi all,
>>> > > 
>>> > > While fuzzing with trinity inside a KVM tools guest with the latest linux-next kernel, I've stumbled on the following during boot:
>>> > > 
>>> > > [  199.224369] WARNING: at kernel/rcutree.c:513 rcu_eqs_exit_common+0x4a/0x3a0()
>>> > > [  199.225307] Pid: 1, comm: init Tainted: G        W    3.6.0-rc7-next-20120928-sasha-00001-g8b2d05d-dirty #13
>>> > > [  199.226611] Call Trace:
>>> > > [  199.226951]  [<ffffffff811c8d1a>] ? rcu_eqs_exit_common+0x4a/0x3a0
>>> > > [  199.227773]  [<ffffffff81108e36>] warn_slowpath_common+0x86/0xb0
>>> > > [  199.228572]  [<ffffffff81108f25>] warn_slowpath_null+0x15/0x20
>>> > > [  199.229348]  [<ffffffff811c8d1a>] rcu_eqs_exit_common+0x4a/0x3a0
>>> > > [  199.230037]  [<ffffffff8117f267>] ? __lock_acquire+0x1c37/0x1ca0
>>> > > [  199.230037]  [<ffffffff811c936c>] rcu_eqs_exit+0x9c/0xb0
>>> > > [  199.230037]  [<ffffffff811c940c>] rcu_user_exit+0x8c/0xf0
>>> > > [  199.230037]  [<ffffffff810a98bb>] do_page_fault+0x1b/0x40
>>> > > [  199.230037]  [<ffffffff810a2a90>] do_async_page_fault+0x30/0xa0
>>> > > [  199.230037]  [<ffffffff83a3eea8>] async_page_fault+0x28/0x30
>>> > > [  199.230037]  [<ffffffff819f357b>] ? debug_object_activate+0x6b/0x1b0
>>> > > [  199.230037]  [<ffffffff819f3586>] ? debug_object_activate+0x76/0x1b0
>>> > > [  199.230037]  [<ffffffff8111af13>] ? lock_timer_base.isra.19+0x33/0x70
>>> > > [  199.230037]  [<ffffffff8111d45f>] mod_timer_pinned+0x9f/0x260
>>> > > [  199.230037]  [<ffffffff811c5ff4>] rcu_eqs_enter_common+0x894/0x970
>>> > > [  199.230037]  [<ffffffff839dc2ac>] ? init_post+0x75/0xc8
>>> > > [  199.230037]  [<ffffffff85abfed5>] ? kernel_init+0x1e1/0x1e1
>>> > > [  199.230037]  [<ffffffff811c63df>] rcu_eqs_enter+0xaf/0xc0
>>> > > [  199.230037]  [<ffffffff811c64c5>] rcu_user_enter+0xd5/0x140
>>> > > [  199.230037]  [<ffffffff8107d0fd>] syscall_trace_leave+0xfd/0x150
>>> > > [  199.230037]  [<ffffffff83a3f7af>] int_check_syscall_exit_work+0x34/0x3d
>>> > > [  199.230037] ---[ end trace a582c3a264d5bd1a ]---
>> > 
>> > Ok, we can't decently protect against any kind of exception messing up everything
>> > in the middle of RCU APIs anyway. The only solution is to find out what cause this
>> > page fault in mod_timer_pinned() and work around that.
>> > 
>> > Anybody, an idea?
> Wow...  So I pass mod_timer_pinned() the address of a per-CPU timer while
> running on that CPU, with interrupts disabled, no less.  I initialize
> this timer at CPU_UP_PREPARE time.  So why the page fault?
> 
> Please see below for a severe diagnostic patch.

Maybe I could help here a bit.

lappy linux # addr2line -i -e vmlinux ffffffff8111d45f
/usr/src/linux/kernel/timer.c:549
/usr/src/linux/include/linux/jump_label.h:101
/usr/src/linux/include/trace/events/timer.h:44
/usr/src/linux/kernel/timer.c:601
/usr/src/linux/kernel/timer.c:734
/usr/src/linux/kernel/timer.c:886

Which means that it was about to:

	debug_object_activate(timer, &timer_debug_descr);


Thanks,
Sasha
