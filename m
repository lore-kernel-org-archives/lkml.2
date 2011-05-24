Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031098Ab1EXBSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:18:32 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36001 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031077Ab1EXBS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:18:28 -0400
Date: Mon, 23 May 2011 18:18:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110524011824.GL7428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DD6F64C.3030402@kernel.org>
 <20110520234923.GQ2366@linux.vnet.ibm.com>
 <4DD70120.9090801@kernel.org>
 <20110521131844.GE2271@linux.vnet.ibm.com>
 <20110521140845.GA12157@linux.vnet.ibm.com>
 <4DDAC01E.7050602@kernel.org>
 <20110523212530.GF7428@linux.vnet.ibm.com>
 <4DDAD934.9010603@kernel.org>
 <4DDAE5FA.2030303@kernel.org>
 <4DDAE6A5.6060701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDAE6A5.6060701@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 03:58:45PM -0700, Yinghai Lu wrote:
> On 05/23/2011 03:55 PM, Yinghai Lu wrote:
> > On 05/23/2011 03:01 PM, Yinghai Lu wrote:
> >> On 05/23/2011 02:25 PM, Paul E. McKenney wrote:
> >>> On Mon, May 23, 2011 at 01:14:22PM -0700, Yinghai Lu wrote:
> >>>> On 05/21/2011 07:08 AM, Paul E. McKenney wrote:
> >>>>> On Sat, May 21, 2011 at 06:18:44AM -0700, Paul E. McKenney wrote:
> >>>>>> On Fri, May 20, 2011 at 05:02:40PM -0700, Yinghai Lu wrote:
> >>>>>>> On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
> >>>>>>>> On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
> >>>>>>> ...
> >>>>>>>>>
> >>>>>>>>> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
> >>>>>>>>
> >>>>>>>> OK, just to make sure I understand...  You are compiling exactly the
> >>>>>>>> same kernel source tree with exactly the same .config, just with two
> >>>>>>>> different versions of gcc, correct?
> >>>>>>> yes.
> >>>>>>>>
> >>>>>>>> If so, it is quite possible that the slow one is the correct one.  :-/
> >>>>>>> yeah, new version always have problem.
> >>>>>>>
> >>>>>>> looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1
> >>>>>>
> >>>>>> OK, so fedora14 is the fast one (4.5.1) and opensuse11.3 is the slow
> >>>>>> one (4.5.0), correct?
> >>>>>
> >>>>> And does commit c7a3786030 help?  This commit (from Peter Zijlstra)
> >>>>> tidied up RCU kthreads' scheduler interactions.  The patch is below,
> >>>>> though it is probably more convenient to pull it from the rcu/next
> >>>>> branch of:
> >>>>>
> >>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> >>>>>
> >>>
> > gcc in Fedora 14 is fine with your tree.
> > 
> 
> sorry, I should wait for longer to see Fedora 14 is ok.
> 
> got same warning with the one compiled from fedora 14...
> 
> [  372.937251] INFO: task rcun0:8 blocked for more than 120 seconds.
> [  372.937618] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  372.956130] rcun0           D 0000000000000000     0     8      2 0x00000000
> [  372.956498]  ffff882070d65e90 0000000000000046 ffff882070d64000 0000000000004000
> [  372.956528]  00000000001d1f40 ffff882070d65fd8 00000000001d1f40 ffff882070d65fd8
> [  372.956555]  0000000000004000 00000000001d1f40 ffff882070d18000 ffff882070d6a2b0
> [  372.956581] Call Trace:
> [  372.956605]  [<ffffffff810afce3>] ? __lock_release+0x166/0x16f
> [  372.956624]  [<ffffffff81c229d1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
> [  372.956639]  [<ffffffff810ce941>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> [  372.956650]  [<ffffffff810adfd5>] ? trace_hardirqs_on+0xd/0xf
> [  372.956661]  [<ffffffff810ce941>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> [  372.956673]  [<ffffffff8109a0a5>] kthread+0x8c/0xa8
> [  372.956689]  [<ffffffff81c2a754>] kernel_thread_helper+0x4/0x10
> [  372.956701]  [<ffffffff81c22c80>] ? retint_restore_args+0xe/0xe
> [  372.956711]  [<ffffffff8109a019>] ? __init_kthread_worker+0x5b/0x5b
> [  372.956722]  [<ffffffff81c2a750>] ? gs_change+0xb/0xb
> [  372.956726] INFO: lockdep is turned off.
> [  492.750827] INFO: task rcun0:8 blocked for more than 120 seconds.
> [  492.751150] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  492.762991] rcun0           D 0000000000000000     0     8      2 0x00000000
> [  492.763264]  ffff882070d65e90 0000000000000046 ffff882070d64000 0000000000004000
> [  492.763294]  00000000001d1f40 ffff882070d65fd8 00000000001d1f40 ffff882070d65fd8
> [  492.763320]  0000000000004000 00000000001d1f40 ffff882070d18000 ffff882070d6a2b0
> [  492.763346] Call Trace:
> [  492.763359]  [<ffffffff810afce3>] ? __lock_release+0x166/0x16f
> [  492.763371]  [<ffffffff81c229d1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
> [  492.763382]  [<ffffffff810ce941>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> [  492.763393]  [<ffffffff810adfd5>] ? trace_hardirqs_on+0xd/0xf
> [  492.763404]  [<ffffffff810ce941>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> [  492.763414]  [<ffffffff8109a0a5>] kthread+0x8c/0xa8
> [  492.763427]  [<ffffffff81c2a754>] kernel_thread_helper+0x4/0x10
> [  492.763439]  [<ffffffff81c22c80>] ? retint_restore_args+0xe/0xe
> [  492.763449]  [<ffffffff8109a019>] ? __init_kthread_worker+0x5b/0x5b
> [  492.763460]  [<ffffffff81c2a750>] ? gs_change+0xb/0xb
> [  492.763463] INFO: lockdep is turned off.
> 
> if reverting PeterZ's patch will not have that warning.

OK, so it looks like I need to get this out of the way in order to track
down the delays.  Or does reverting PeterZ's patch get you a stable
system, but with the longish delays in memory_dev_init()?  If the latter,
it might be more productive to handle the two problems separately.

For whatever it is worth, I do see about 5% increase in grace-period
duration when switching to kthreads.  This is acceptable -- your
30x increase clearly is completely unacceptable and must be fixed.
Other than that, the main thing that affects grace period duration is
the setting of CONFIG_HZ -- the smaller the HZ value, the longer the
grace-period duration.

							Thanx, Paul
