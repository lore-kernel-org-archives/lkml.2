Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2KUAac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:30:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:48778 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab2KUAab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:30:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,288,1352102400"; 
   d="scan'208";a="222400959"
Message-ID: <50AC20A5.8040500@linux.intel.com>
Date: Tue, 20 Nov 2012 16:30:29 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: pi futex oops in __lock_acquire
References: <20121018015312.GA29865@redhat.com> <507F9944.50505@kernel.dk> <20121019052136.GA30852@redhat.com> <1350650972.30157.34.camel@twins> <20121023195026.GA2872@redhat.com> <20121024202411.GA20597@redhat.com> <5088C397.3000501@linux.intel.com> <20121120164637.GA19893@redhat.com> <50AC0DFA.3000103@linux.intel.com>
In-Reply-To: <50AC0DFA.3000103@linux.intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/20/2012 03:10 PM, Darren Hart wrote:
> 
> 
> On 11/20/2012 08:46 AM, Dave Jones wrote:
>> On Wed, Oct 24, 2012 at 09:44:07PM -0700, Darren Hart wrote:
>>  
>>  > > I've been able to trigger this for the last week or so.
>>  > > Unclear whether this is a new bug, or my fuzzer got smarter, but I see the
>>  > > pi-futex code hasn't changed since the last time it found something..
>>  > > 
>>  > >  > BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
>>  > >  > IP: [<ffffffff810e185e>] __lock_acquire+0x5e/0x1ba0
>>  > >  > PGD 8e72c067 PUD 34f07067 PMD 0 
>>  > >  > Oops: 0000 [#1] PREEMPT SMP 
>>  > >  > CPU 7 
>>  > >  > Pid: 27513, comm: trinity-child0 Not tainted 3.7.0-rc2+ #43
>>  > >  > RIP: 0010:[<ffffffff810e185e>]  [<ffffffff810e185e>] __lock_acquire+0x5e/0x1ba0
>>  > >  > RSP: 0018:ffff8800803f7b28  EFLAGS: 00010046
>>  > >  > RAX: 0000000000000086 RBX: 0000000000000000 RCX: 0000000000000000
>>  > >  > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
>>  > >  > RBP: ffff8800803f7c18 R08: 0000000000000002 R09: 0000000000000000
>>  > >  > R10: 0000000000000000 R11: 2222222222222222 R12: 0000000000000002
>>  > >  > R13: ffff880051dd8000 R14: 0000000000000002 R15: 0000000000000018
>>  > >  > FS:  00007f9fc6ccb740(0000) GS:ffff880148a00000(0000) knlGS:0000000000000000
>>  > >  > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  > >  > CR2: 0000000000000018 CR3: 000000008e6fb000 CR4: 00000000001407e0
>>  > >  > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>  > >  > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>  > >  > Process trinity-child0 (pid: 27513, threadinfo ffff8800803f6000, task ffff880051dd8000)
>>  > >  > Stack:
>>  > >  >  ffff8800803f7b48 ffffffff816c5c59 ffff8800803f7b48 ffff88014840ebc0
>>  > >  >  ffff8800803f7b68 ffffffff816c18e3 ffff8800803f7d10 0000000000000001
>>  > >  >  ffff8800803f7ba8 ffffffff810a1e62 ffff8800803f7d10 0000000000000282
>>  > >  > Call Trace:
>>  > >  >  [<ffffffff816c5c59>] ? sub_preempt_count+0x79/0xd0
>>  > >  >  [<ffffffff816c18e3>] ? _raw_spin_unlock_irqrestore+0x73/0xa0
>>  > >  >  [<ffffffff810a1e62>] ? hrtimer_try_to_cancel+0x52/0x210
>>  > >  >  [<ffffffff810eb9e5>] ? debug_rt_mutex_free_waiter+0x15/0x180
>>  > >  >  [<ffffffff816c0107>] ? rt_mutex_slowlock+0x127/0x1b0
>>  > >  >  [<ffffffff810b7039>] ? local_clock+0x89/0xa0
>>  > >  >  [<ffffffff810e3ac2>] lock_acquire+0xa2/0x220
>>  > >  >  [<ffffffff810e812c>] ? futex_lock_pi.isra.18+0x1cc/0x390
>>  > >  >  [<ffffffff816c09e0>] _raw_spin_lock+0x40/0x80
>>  > >  >  [<ffffffff810e812c>] ? futex_lock_pi.isra.18+0x1cc/0x390
>>  > >  >  [<ffffffff810e812c>] futex_lock_pi.isra.18+0x1cc/0x390
>>  > >  >  [<ffffffff810a1980>] ? update_rmtp+0x70/0x70
>>  > >  >  [<ffffffff810e99e4>] do_futex+0x394/0xa50
>>  > >  >  [<ffffffff8119ec43>] ? might_fault+0x53/0xb0
>>  > >  >  [<ffffffff810ea12d>] sys_futex+0x8d/0x190
>>  > >  >  [<ffffffff816ca288>] tracesys+0xe1/0xe6
>>  > >  > Code: d8 45 0f 45 e0 4c 89 75 f0 4c 89 7d f8 85 c0 0f 84 f8 00 00 00 8b 05 22 fe f3 00 49 89 ff 89 f3 41 89 d2 85 c0 0f 84 02 01 00 00 <49> 8b 07 ba 01 00 00 00 48 3d c0 81 06 82 44 0f 44 e2 83 fb 01 
>>  > >  > RIP  [<ffffffff810e185e>] __lock_acquire+0x5e/0x1ba0
>>  > >  >  RSP <ffff8800803f7b28>
>>  > >  > CR2: 0000000000000018
>>  > > 
>>  > > It looks like we got all the way to lock_acquire with a NULL 'lock' somehow.
>>  > > 
>>  > > Darren, any idea how this could happen ?
>>  > 
>>  > I'm digging. Can you get trinity to provide the arguments it used that
>>  > trigger the crash?u That might help hone in on the exact path.
>>
>> Still seeing this on rc6. It happens very quickly when I run with "-c futex"
>> I just pushed out all the pending trinity changes I was running with, but
>> I don't think they would have been responsible.
>>
>> 	Dave
>>
> 
> OK, so some instrumentation yields:
> 
> [ 1320.762028] futex_lock_pi: timed lock
> [ 1320.762488] futex_lock_pi: hb=ffffffff81e89e28,
> hb->lock=ffffffff81e89e28, &q=ffff880181fa5cd8, q.lock_ptr=ffffffff81e89e28
> [ 1320.763647] q.lock_ptr=ffffffff81e89e28
> [ 1320.764132] fixup_owner: uaddr=00007f05465ac000, q=ffff880181fa5cd8,
> locked=0
> [ 1323.066371] futex_lock_pi: hb=ffffffff81e89e28,
> hb->lock=ffffffff81e89e28, &q=ffff880181fc5cd8, q.lock_ptr=          (null)
> [ 1323.069032] ------------[ cut here ]------------
> [ 1323.069817] kernel BUG at kernel/futex.c:2052!
> 
> So somewhere between blocking on the lock and waking, q.lock_ptr is
> getting set to NULL. The only legitimate place this happens in is
> wake_futex, and I see some wake_futex calls after the futex_lock_pi
> calls with the same uaddr in the trinity log. We are supposed to be
> protected by the q lock_ptr here and wake_futex aborts any wakes of q's
> with a pi_state or rt_waiter.... but .... there appears to be a window
> in there. I say a window because I see a similar failure where the
> instrumentation doesn't catch the lock_ptr as NULL and fails at a later
> point on the same lock. Nice nasty parallel locking race. Digging in.
> 

OK, the problem is a futex_wake_op() calling wake_futex() without checking
for a pi_state or rt_waiters. I'm looking at the best way to fix it,
considering moving the check out of futex_wake and into wake_futex... some
more analysis needed for the best fix, but will have one by tomorrow.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
