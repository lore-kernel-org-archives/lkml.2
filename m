Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2BASXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:23:12 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38970 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2BASXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:23:11 -0500
Date: Wed, 1 Feb 2012 10:22:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rcu warnings cause stack overflow
Message-ID: <20120201182209.GF2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201100652.GA2922@osiris.boeblingen.de.ibm.com>
 <20120201151445.GA6731@somewhere.redhat.com>
 <20120201171856.GC2382@linux.vnet.ibm.com>
 <20120201180813.GF6731@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201180813.GF6731@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020118-6148-0000-0000-00000313CB3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 07:08:15PM +0100, Frederic Weisbecker wrote:
> On Wed, Feb 01, 2012 at 09:18:56AM -0800, Paul E. McKenney wrote:
> > On Wed, Feb 01, 2012 at 04:14:48PM +0100, Frederic Weisbecker wrote:
> > > On Wed, Feb 01, 2012 at 11:06:52AM +0100, Heiko Carstens wrote:
> > > > Hi Frederic,
> > > > 
> > > > your patch 00f49e5729 "rcu: Warn when rcu_read_lock() is used in extended
> > > > quiescent state" adds a WARN_ON_ONCE to rcu_lock_acquire().
> > > > Actually this found a bug on s390 (thanks!) but it probably didn't work
> > > > as expected.
> > > > On architectures which implement WARN_ON_ONCE with an exception this
> > > > additional warning will lead to a stack overflow (if it triggers):
> > > > 
> > > > [   55.746956] Kernel stack overflow.
> > > > [   55.746966] Modules linked in: qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod qeth vmur ccwgroup [last unloaded: scsi_wait_
> > > > scan]
> > > > [   55.746999] CPU: 0 Not tainted 3.3.0-rc1-00167-gf8275f9 #90
> > > > [   55.747005] Process swapper/0 (pid: 0, task: 0000000000911100, ksp: 0000000000907d50)
> > > > [   55.747013] Krnl PSW : 0404000180000000 00000000005d5728 (illegal_op+0x1c/0x134)
> > > > [   55.747034]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
> > > > [   55.747043] Krnl GPRS: 0000000000000001 00000000005d570c 00000000009040e8 0000000000000002
> > > > [   55.747054]            00000000005d83dc ffffffffffffffff 0000000000000000 0400000000907cc8
> > > > [   55.747064]            0404100180000000 00000000005d8478 0000000000000008 00000000009040e8
> > > > [   55.747074]            0000000000904000 00000000005dc550 0000000000904048 0000000000904048
> > > > [   55.747096] Krnl Code: 00000000005d571c: b90400ef            lgr     %r14,%r15
> > > > [   55.747118]            00000000005d5720: b90400b2            lgr     %r11,%r2
> > > > [   55.747194]           #00000000005d5724: a7840001            brc     8,5d5726
> > > > [   55.747205]           >00000000005d5728: a7fbff18            aghi    %r15,-232
> > > > [   55.747216]            00000000005d572c: e3e0f0980024        stg     %r14,152(%r15)
> > > > [   55.747228]            00000000005d5732: e31020100004        lg      %r1,16(%r2)
> > > > [   55.747242]            00000000005d5738: 58c020a0            l       %r12,160(%r2)
> > > > [   55.747257]            00000000005d573c: 91012009            tm      9(%r2),1
> > > > [   55.747276] Call Trace:
> > > > [   55.747282] ([<00000000005d60b4>] pgm_check_handler+0x154/0x158)
> > > > [   55.747296]  [<00000000005d8478>] __atomic_notifier_call_chain+0xd8/0xfc
> > > > [   55.747309] ([<00000000005d83dc>] __atomic_notifier_call_chain+0x3c/0xfc)
> > > > [   55.747322]  [<00000000005d84c6>] atomic_notifier_call_chain+0x2a/0x3c
> > > > [   55.747335]  [<00000000005d852a>] notify_die+0x52/0x60
> > > > [   55.747349]  [<00000000005d57da>] illegal_op+0xce/0x134
> > > > [   55.747364]  [<00000000005d60b4>] pgm_check_handler+0x154/0x158
> > > > 
> > > > [...lots more of the same...] 
> > > > 
> > > > [   55.747379]  [<00000000005d8478>] __atomic_notifier_call_chain+0xd8/0xfc
> > > > [   55.747425] ([<00000000005d83dc>] __atomic_notifier_call_chain+0x3c/0xfc)
> > > > [   55.747432]  [<00000000005d84c6>] atomic_notifier_call_chain+0x2a/0x3c
> > > > [   55.747440]  [<00000000005d852a>] notify_die+0x52/0x60
> > > > [   55.747448]  [<00000000005d57da>] illegal_op+0xce/0x134
> > > > [   55.747457]  [<00000000005d60b4>] pgm_check_handler+0x154/0x158
> > > > [   55.747797]  [<00000000005d8478>] __atomic_notifier_call_chain+0xd8/0xfc
> > > > [   55.747806] ([<00000000005d83dc>] __atomic_notifier_call_chain+0x3c/0xfc)
> > > > [   55.747816]  [<00000000005d84c6>] atomic_notifier_call_chain+0x2a/0x3c
> > > > [   55.747826]  [<00000000005d852a>] notify_die+0x52/0x60
> > > > [   55.748456]  [<00000000005d57da>] illegal_op+0xce/0x134
> > > > [   55.748463]  [<00000000005d60b4>] pgm_check_handler+0x154/0x158
> > > > [   55.748472]  [<000000000017afa0>] select_task_rq_fair+0x1478/0x14b4
> > > > [   55.748483] ([<0000000000179bb8>] select_task_rq_fair+0x90/0x14b4)
> > > > [   55.748493]  [<0000000000170702>] try_to_wake_up+0x136/0x47c
> > > > [   55.748506]  [<000000000015b446>] autoremove_wake_function+0x26/0x58
> > > > [   55.748518]  [<000000000016693a>] __wake_up_common+0x76/0xb4
> > > > [   55.748530]  [<000000000016aed0>] __wake_up+0x4c/0x60
> > > > [   55.748541]  [<0000000000109ee0>] s390_handle_mcck+0x194/0x1f8
> > > > [   55.748557]  [<000000000010486a>] cpu_idle+0x192/0x1c0
> > > > [   55.748570]  [<0000000000977916>] start_kernel+0x402/0x410
> > > > [   55.748588]  [<0000000000100020>] _stext+0x20/0x80
> > > > [   55.748603] 2 locks held by swapper/0/0:
> > > > [   55.748612]  #0:  (crw_handler_wait_q.lock){......}, at: [<000000000016aeb6>] __wake_up+0x32/0x60
> > > > [   55.748648]  #1:  (&p->pi_lock){-.-.-.}, at: [<000000000017060c>] try_to_wake_up+0x40/0x47c
> > > > [   55.748663] Last Breaking-Event-Address:
> > > > [   55.748667]  [<0000000000000000>] 0x0
> > > > 
> > > > This simply happens because WARN_ON_ONCE causes an exception, the excpetion
> > > > handler wants to call a notifier call chain (notify_die), which again uses
> > > > rcu_read_lock(), which again causes an exception and so on...
> > > > Unfortunately WARN_ON_ONCE first causes an exception and only afterwards sets
> > > > the flag that the warning already happened. Seems to be quite some effort to
> > > > change this behaviour.
> > > > 
> > > > Removing the WARN_ON_ONCE will fix this and, if lockdep is turned on, still
> > > > will find illegal uses. But it won't work for lockdep off configs...
> > > > So we probably want something better than the patch below.
> > > 
> > > Ah ok. Hmm, but why are you using an exception to implement WARN_ON()
> > > in s390? Is it to have a whole new stack for the warning path in order
> > > to avoid stack overflow from the place that called the WARN_ON() ?
> > > 
> > > Anyway perhaps we need a recursion protection on WARN_ON_ONCE(), such
> > > as:
> > 
> > This makes sense to me, but I am also taking Heiko's patch
> > removing the WARN_ON()s in favor of the lockdep checks now in
> > rcu_read_lock_held().  After all, the rcu_lock_acquire() WARN_ON_ONCE()
> > only appears if PROVE_LOCKING=y, so the added requirement is not a
> > big deal.  Also, CONFIG_PROVE_RCU is in the testing requirements in
> > Documentation/SubmitChecklist.
> > 
> > 							Thanx, Paul
> 
> I think if we do this, we lose the debugging coverage on places that
> make use of rcu_read_lock{_sched,_bh}() without using rcu_dereference{_sched,_bh}().
> 
> It seems walking the task list with list_for_each_entry_rcu() under rcu_read_lock() is
> one such example because rcu lists are using rcu_dereference_raw().

Good point.  I will convert these to rcu_lockdep_assert()s.

> Also I realize a problem with my below patch. The exception will call rcu_read_lock()
> from another callsite so we are still going to recurse. Only of one level but we will
> recurse. This could mess up the warning output, although it prevents from the
> stack overflow. If we still go that direction, we probably need a more global, or per
> cpu, recursion protection of these RCU warnings.

Hmmm...  Should this be global or specific to S390?

							Thanx, Paul

> > > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> > > index 84458b0..f76635f 100644
> > > --- a/include/asm-generic/bug.h
> > > +++ b/include/asm-generic/bug.h
> > > @@ -137,9 +137,13 @@ extern void warn_slowpath_null(const char *file, const int line);
> > >  	static bool __warned;					\
> > >  	int __ret_warn_once = !!(condition);			\
> > >  								\
> > > -	if (unlikely(__ret_warn_once))				\
> > > -		if (WARN_ON(!__warned)) 			\
> > > +	if (unlikely(__ret_warn_once)) {			\
> > > +		if (!__warned) {				\
> > >  			__warned = true;			\
> > > +			barrier();				\
> > > +			WARN_ON(1);				\
> > > +		}						\
> > > +	}							\
> > >  	unlikely(__ret_warn_once);				\
> > >  })
> > > 
> > > 
> > 
> 

