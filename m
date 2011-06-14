Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1FNMky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:40:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38648 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab1FNMkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:40:52 -0400
Date: Tue, 14 Jun 2011 05:40:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.0-rc3] tree RCU boost vs hang notifier...
Message-ID: <20110614124048.GB2264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTin2osfkSiu8maGmJAnzv4O5ODK0dw@mail.gmail.com>
 <20110614045150.GA2264@linux.vnet.ibm.com>
 <BANLkTinvygi9aSkFcnOs2CHCmExD2ixJuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinvygi9aSkFcnOs2CHCmExD2ixJuQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 01:46:04PM +0800, Daniel J Blueman wrote:
> On 14 June 2011 12:51, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Jun 14, 2011 at 12:02:24PM +0800, Daniel J Blueman wrote:
> >> With 3.0-rc3 configured with CONFIG_TREE_PREEMPT_RCU, CONFIG_RCU_BOOST
> >> and CONFIG_DETECT_HUNG_TASK, we see frequent task hung reports [1],
> >> possibly as the tree RCU boost kthreads sleep uninterruptably.
> >>
> >> It looks like tinyRCU sleeps interruptably, so won't trigger the hangcheck.
> >>
> >> Thanks,
> >>   Daniel
> >>
> >> --- [1]
> >>
> >> INFO: task rcub0:9 blocked for more than 120 seconds.
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> rcub0           D ffffffff81c29c80  6768     9      2 0x00000000
> >>  ffff880221713ea0 0000000000000046 ffff880221713db0 ffffffff8171b825
> >>  ffff880221712000 0000000000004000 ffff8802214d0000 ffff88022170c060
> >>  ffff88022ec00000 0000000000010ac0 0000000000000001 ffff88022ec10ac0
> >> Call Trace:
> >>  [<ffffffff8171b825>] ? _raw_spin_unlock_irqrestore+0x75/0x80
> >>  [<ffffffff8171822a>] ? preempt_schedule+0x3a/0x50
> >>  [<ffffffff8171b825>] ? _raw_spin_unlock_irqrestore+0x75/0x80
> >>  [<ffffffff810cec90>] ? rcu_boost+0x120/0x120
> >>  [<ffffffff8107e1a3>] kthread+0x93/0xc0
> >>  [<ffffffff81098bad>] ? trace_hardirqs_on_caller+0x13d/0x180
> >>  [<ffffffff8171d4d4>] kernel_thread_helper+0x4/0x10
> >>  [<ffffffff81048ad7>] ? finish_task_switch+0x77/0x100
> >>  [<ffffffff8171bc04>] ? retint_restore_args+0xe/0xe
> >>  [<ffffffff8107e110>] ? __init_kthread_worker+0x70/0x70
> >>  [<ffffffff8171d4d0>] ? gs_change+0xb/0xb
> >> no locks held by rcub0/9.
> >
> > Hello, Daniel,
> >
> > Does the following patch help?
> >
> >                                                        Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > rcu: Simplify curing of load woes
> >
> > Make the functions creating the kthreads wake them up.  Leverage the
> > fact that the per-node and boost kthreads can run anywhere, thus
> > dispensing with the need to wake them up once the incoming CPU has
> > gone fully online.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> []
> 
> Superb - this addresses the hangcheck warnings.
> 
> Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>

Thank you very much for testing this!

							Thanx, Paul
