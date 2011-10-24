Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1JXLsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:48:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45167 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab1JXLsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:48:37 -0400
Date: Mon, 24 Oct 2011 04:48:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: eric.dumazet@gmail.com, shaohua.li@intel.com, ak@linux.intel.com,
        mhocko@suse.cz, alex.shi@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
Message-ID: <20111024114806.GA3340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110930204503.GA32687@linux.vnet.ibm.com>
 <20111001152514.GA16930@elte.hu>
 <20111003055302.GA23527@elte.hu>
 <20111003161335.GA2403@linux.vnet.ibm.com>
 <20111004074637.GA14061@elte.hu>
 <20111024100501.GA24913@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024100501.GA24913@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102411-5930-0000-0000-00000087147A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:05:01AM -0700, Paul E. McKenney wrote:
> On Tue, Oct 04, 2011 at 09:46:37AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Mon, Oct 03, 2011 at 07:53:02AM +0200, Ingo Molnar wrote:
> > > > 
> > > > Not sure whether you've seen this one already:
> > > 
> > > This is a new one for me.
> > > 
> > > > [   18.110320] Adding 3911820k swap on /dev/sda2.  Priority:-1 extents:1 across:3911820k 
> > > > [   31.803721] 
> > > > [   31.804597] ===============================
> > > > [   31.804597] [ INFO: suspicious RCU usage. ]
> > > > [   31.804597] -------------------------------
> > > > [   31.804597] include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
> > > > [   31.804597] 
> > > > [   31.804597] other info that might help us debug this:
> > > > [   31.804597] 
> > > > [   31.804597] 
> > > > [   31.804597] rcu_scheduler_active = 1, debug_locks = 0
> > > > [   31.804597] 1 lock held by true/845:
> > > > [   31.804597]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<4109f06f>] prepare_bprm_creds+0x20/0x55
> > > > [   31.804597] 
> > > > [   31.804597] stack backtrace:
> > > > [   31.804597] Pid: 845, comm: true Not tainted 3.1.0-rc8-tip-01699-gde204a2-dirty #157471
> > > > [   31.804597] Call Trace:
> > > > [   31.804597]  [<412d78fa>] ? printk+0x18/0x1a
> > > > [   31.804597]  [<41044190>] lockdep_rcu_suspicious+0xb1/0xb9
> > > > [   31.804597]  [<4106d6de>] perf_event_comm+0xb1/0x357
> > > > [   31.804597]  [<4109f048>] set_task_comm+0x4d/0x54
> > > 
> > > 	This one does task_lock(), which acquires the task's
> > > 	->alloc lock.  In theory, this should prevent the
> > > 	lockdep-RCU splat.  It clearly does not, and here are
> > > 	some possible reasons why:
> > > 
> > > 	1.	Something redirects to some other task along the way.
> > > 
> > > 	2.	Something releases ->alloc_lock along the way.
> > > 
> > > 	The output above shows no locks held, which points to #2.
> > > 
> > > 	set_task_comm() calls perf_event_comm() shown above, which calls
> > > 	perf_event_comm_event(), which does rcu_read_lock(), which should
> > > 	also prevent the splat.  Then perf_event_comm_event() calls
> > > 	perf_event_comm_ctx(), which calls perf_event_comm_output()...
> > > 
> > > 	Holy inlining, Batman!!!
> > > 
> > > 	OK, I confess, I am a wuss...  Any chance of reproducing this
> > > 	with CONFIG_SCHED_OMIT_FRAME_POINTER=n?  Or would someone more
> > > 	familiar with these functions be willing to enlighten me?
> > 
> > Ok, i ran the tests some more and here's a similar splat with 
> > framepointers enabled:
> > 
> > [   50.402719] eth0: no IPv6 routers present
> > [   59.147572] 
> > [   59.149064] ===============================
> > [   59.151257] [ INFO: suspicious RCU usage. ]
> > [   59.156865] -------------------------------
> > [   59.156865] include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
> > [   59.156865] 
> > [   59.156865] other info that might help us debug this:
> > [   59.156865] 
> > [   59.156865] 
> > [   59.156865] rcu_scheduler_active = 1, debug_locks = 0
> > [   59.156865] 1 lock held by true/667:
> > [   59.156865]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<c111d927>] prepare_bprm_creds+0x27/0x70
> > [   59.156865] 
> > [   59.156865] stack backtrace:
> > [   59.156865] Pid: 667, comm: true Not tainted 3.1.0-rc8-tip+ #157499
> > [   59.156865] Call Trace:
> > [   59.156865]  [<c1a41f7c>] ? printk+0x28/0x2a
> > [   59.156865]  [<c109d540>] lockdep_rcu_suspicious+0xc0/0xd0
> > [   59.156865]  [<c10d8a98>] perf_event_enable_on_exec+0x1c8/0x1d0
> > [   59.156865]  [<c109c364>] ? __lock_release+0x54/0xd0
> > [   59.156865]  [<c10daef8>] perf_event_comm+0x18/0x60
> > [   59.156865]  [<c111d80d>] ? set_task_comm+0x5d/0x80
> > [   59.156865]  [<c1a6ac6d>] ? _raw_spin_unlock+0x1d/0x30
> > [   59.156865]  [<c111d814>] set_task_comm+0x64/0x80
> > [   59.156865]  [<c111e355>] setup_new_exec+0xc5/0x1f0
> > [   59.156865]  [<c115313b>] load_elf_binary+0x28b/0xa00
> > [   59.156865]  [<c111de59>] ? search_binary_handler+0xd9/0x1d0
> > [   59.156865]  [<c109c364>] ? __lock_release+0x54/0xd0
> > [   59.156865]  [<c1152eb0>] ? do_mmap+0x60/0x60
> > [   59.156865]  [<c111de60>] search_binary_handler+0xe0/0x1d0
> > [   59.156865]  [<c111ddb0>] ? search_binary_handler+0x30/0x1d0
> > [   59.156865]  [<c111e17f>] do_execve_common+0x22f/0x2a0
> > [   59.156865]  [<c111e202>] do_execve+0x12/0x20
> > [   59.156865]  [<c1036462>] sys_execve+0x32/0x70
> > [   59.156865]  [<c1a6c052>] ptregs_execve+0x12/0x18
> > [   59.156865]  [<c1a6bfd7>] ? sysenter_do_call+0x12/0x36
> > 
> > Config and full bootlog attached.
> 
> Hello, Ingo,
> 
> It appears that inlining has defeated me, so I tried reproducing under
> KVM, using the closest bootable approximation to your .config (attached).
> I booted ten times without seeing this error.  I have my changes against
> 3.1-rc8.  I will try against 3.1, but in the meantime any enlightenment
> would be most welcome.  ;-)

And I cannot reproduce after merging into 3.1.  :-(

							Thanx, Paul

