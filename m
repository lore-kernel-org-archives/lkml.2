Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2DQPxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:53:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46849 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab2DQPxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:53:51 -0400
Date: Tue, 17 Apr 2012 08:53:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: New RCU related warning due to rcu_preempt_depth() changes
Message-ID: <20120417155316.GE2404@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+1xoqdJjTe+BMe_ebMBSg57gs2FA60T_0WKhrHvfDoE8AvCuw@mail.gmail.com>
 <20120417150556.GB2404@linux.vnet.ibm.com>
 <CA+1xoqc=ssJmfMTogN8H_8yqNXys8-yJbx7=XVVSN3CvOPcyWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqc=ssJmfMTogN8H_8yqNXys8-yJbx7=XVVSN3CvOPcyWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041715-7182-0000-0000-0000014AB9BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 05:36:59PM +0200, Sasha Levin wrote:
> On Tue, Apr 17, 2012 at 5:05 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Apr 17, 2012 at 10:42:47AM +0200, Sasha Levin wrote:
> >> Hi Paul,
> >>
> >> It looks like commit 7298b03 ("rcu: Move __rcu_read_lock() and
> >> __rcu_read_unlock() to per-CPU variables") is causing the following
> >> warning (I've added the extra fields on the second line):
> >>
> >> [   77.330920] BUG: sleeping function called from invalid context at
> >> mm/memory.c:3933
> >> [   77.336571] in_atomic(): 0, irqs_disabled(): 0, preempt count: 0,
> >> preempt offset: 0, rcu depth: 1, pid: 5669, name: trinity
> >> [   77.344135] no locks held by trinity/5669.
> >> [   77.349644] Pid: 5669, comm: trinity Tainted: G        W
> >> 3.4.0-rc3-next-20120417-sasha-dirty #83
> >> [   77.354401] Call Trace:
> >> [   77.355956]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
> >> [   77.358811]  [<ffffffff81198eaf>] might_fault+0x2f/0xa0
> >> [   77.361997]  [<ffffffff810e3228>] schedule_tail+0x88/0xb0
> >> [   77.364671]  [<ffffffff826a01d3>] ret_from_fork+0x13/0x80
> >>
> >> As you can see, rcu_preempt_depth() returns 1 when running in that
> >> context, which looks pretty odd.
> >
> > Ouch!!!
> >
> > So it looks like I missed a place where I need to save and restore
> > the new per-CPU rcu_read_lock_nesting and rcu_read_unlock_special
> > variables.  My (probably hopelessly naive) guess is that I need to add
> > a rcu_switch_from() and rcu_switch_to() into schedule_tail(), but to
> > make rcu_switch_from() take the task_struct pointer as an argument,
> > passing in prev.
> >
> > Does this make sense, or am I still missing something here?
> 
> I've let the test run for a bit more, and it appears that I'm getting
> this warning from lots of different sources, would this
> schedule_tail() fix all of them?

If I understand the failure correctly, yes.  If the task switches without
RCU paying attention, the nesting count for both the outgoing and the
incoming tasks can get messed up.  The messed-up counts could easily
cause problems downstream.

Of course, there might well be additional bugs.

I will put a speculative patch together and send it along.

							Thanx, Paul

> Here's several traces for reference:
> 
> [  223.068875]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
> [  223.070719]  [<ffffffff810b2a05>] close_files+0x1d5/0x220
> [  223.072531]  [<ffffffff810b2830>] ? find_new_reaper+0x230/0x230
> [  223.076325]  [<ffffffff810b4811>] put_files_struct+0x21/0x1b0
> [  223.080649]  [<ffffffff8269eb20>] ? _raw_spin_unlock+0x30/0x60
> [  223.084455]  [<ffffffff810b4a5d>] exit_files+0x4d/0x60
> [  223.087967]  [<ffffffff810b51ac>] do_exit+0x28c/0x470
> [  223.091369]  [<ffffffff810e44d1>] ? get_parent_ip+0x11/0x50
> [  223.093190]  [<ffffffff810b5473>] do_group_exit+0xa3/0xe0
> [  223.095061]  [<ffffffff810c4759>] get_signal_to_deliver+0x389/0x400
> [  223.098400]  [<ffffffff8104bce2>] do_signal+0x42/0x120
> [  223.100222]  [<ffffffff8104c4d7>] ? do_divide_error+0xa7/0xb0
> [  223.102267]  [<ffffffff8269fa7f>] ? retint_signal+0x11/0x92
> [  223.104145]  [<ffffffff8104be34>] do_notify_resume+0x54/0xa0
> [  223.106033]  [<ffffffff8269fabb>] retint_signal+0x4d/0x92
> 
> [  176.217632]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
> [  176.223583]  [<ffffffff81081b83>] do_page_fault+0x243/0x4f0
> [  176.229932]  [<ffffffff811151ca>] ? __lock_release+0x1ba/0x1d0
> [  176.233651]  [<ffffffff8269ec1b>] ? _raw_spin_unlock_irq+0x2b/0x80
> [  176.239389]  [<ffffffff810e44d1>] ? get_parent_ip+0x11/0x50
> [  176.242507]  [<ffffffff810e469e>] ? sub_preempt_count+0xae/0xe0
> [  176.248795]  [<ffffffff8269ec41>] ? _raw_spin_unlock_irq+0x51/0x80
> [  176.255454]  [<ffffffff81079e51>] do_async_page_fault+0x31/0xa0
> [  176.260342]  [<ffffffff8269fcd5>] async_page_fault+0x25/0x30
> 
> [  173.587864]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
> [  173.593134]  [<ffffffff811f5542>] ? __d_alloc+0x32/0x1a0
> [  173.603730]  [<ffffffff811c0f8d>] kmem_cache_alloc+0x4d/0x160
> [  173.604746]  [<ffffffff811f5e40>] ? __d_lookup_rcu+0x240/0x240
> [  173.608932]  [<ffffffff811f5542>] __d_alloc+0x32/0x1a0
> [  173.612444]  [<ffffffff811f56f3>] d_alloc+0x23/0x80
> [  173.616887]  [<ffffffff811e773b>] __lookup_hash+0x9b/0x110
> [  173.621488]  [<ffffffff811e77c4>] lookup_hash+0x14/0x20
> [  173.624395]  [<ffffffff811ecc99>] do_unlinkat+0x79/0x1e0
> [  173.626483]  [<ffffffff8269ec41>] ? _raw_spin_unlock_irq+0x51/0x80
> [  173.632242]  [<ffffffff826a02e9>] ? sysret_check+0x22/0x5d
> [  173.637884]  [<ffffffff8186db5e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  173.642176]  [<ffffffff811ece51>] sys_unlink+0x11/0x20
> [  173.645320]  [<ffffffff826a02bd>] system_call_fastpath+0x1a/0x1f
> 

