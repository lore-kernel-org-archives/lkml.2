Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab1JFXpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:45:04 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48628 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1JFXpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:45:01 -0400
Date: Thu, 6 Oct 2011 16:44:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, arjan.van.de.ven@intel.com,
        andi.kleen@intel.com
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111006234431.GA13163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
 <20111002230753.GB1835@somewhere>
 <20111003003247.GD2539@linux.vnet.ibm.com>
 <20111003130335.GD1835@somewhere>
 <20111003163036.GC2403@linux.vnet.ibm.com>
 <20111006005858.GA27619@linux.vnet.ibm.com>
 <20111006121118.GB23375@somewhere.redhat.com>
 <20111006184455.GK2386@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006184455.GK2386@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 11:44:55AM -0700, Paul E. McKenney wrote:
> On Thu, Oct 06, 2011 at 02:11:28PM +0200, Frederic Weisbecker wrote:
> > On Wed, Oct 05, 2011 at 05:58:58PM -0700, Paul E. McKenney wrote:
> > > On Mon, Oct 03, 2011 at 09:30:36AM -0700, Paul E. McKenney wrote:
> > > > On Mon, Oct 03, 2011 at 03:03:48PM +0200, Frederic Weisbecker wrote:
> > > > > On Sun, Oct 02, 2011 at 05:32:47PM -0700, Paul E. McKenney wrote:
> > > > > > > > -void rcu_irq_enter(void)
> > > > > > > > +int rcu_is_cpu_idle(void)
> > > > > > > >  {
> > > > > > > > -	rcu_exit_nohz();
> > > > > > > > +	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> > > > > > > >  }
> > > > > > > 
> > > > > > > So that's not used in this patch but it's interesting for me
> > > > > > > to backport "rcu: Detect illegal rcu dereference in extended quiescent state".
> > > > > > 
> > > > > > Yep, that is why it is there.
> > > > > 
> > > > > Ok.
> > > > > 
> > > > > > 
> > > > > > > The above should be read from a preempt disabled section though
> > > > > > > (remember "rcu: Fix preempt-unsafe debug check of rcu extended quiescent state")
> > > > > > 
> > > > > > Yes, and that is why the last line of the header comment reads "The
> > > > > > caller must have at least disabled preemption."  Disabling preemption
> > > > > > is not necessary in Tiny RCU because there is no other CPU for the task
> > > > > > to go to.  (Right?)
> > > > > 
> > > > > Right.
> > > > > 
> > > > > > > Those functions should probably lay in a separate patch. But I don't mind
> > > > > > > much keeping the things as is and use these APIs in my next patches though.
> > > > > > > I'll just fix the preempt enabled thing above.
> > > > > > 
> > > > > > Or were you saying that you wish to make calls to rcu_is_cpu_idle()
> > > > > > that have preemption enabled?
> > > > > 
> > > > > Yeah. That's going to be called from places like rcu_read_lock_held()
> > > > > and things like this that don't need to disable preemption themselves.
> > > > > 
> > > > > Would be better to disable preemption from that function.
> > > > 
> > > > Hmmm...  This might be a good use for the "drive-by" per-CPU access
> > > > functions.
> > > > 
> > > > No, that doesn't work.  We could pick up the pointer, switch to another
> > > > CPU, the original CPU could run a task that blocks before we start running,
> > > > and then we could incorrectly decide that we were running in idle context,
> > > > issuing a spurious warning.  This approach would only work in environments
> > > > that (unlike the Linux kernel) mapped all the per-CPU variables to the
> > > > same virtual address on all CPUs.  (DYNIX/ptx did this, but this leads
> > > > to other problems, like being unable to reasonably access other CPUs'
> > > > variables.  Double mapping has other issues on some architectures.)
> > > > 
> > > > OK, agreed.  I will make this function disable preemption.
> > > > 
> > > > > > And I can split the patch easily enough while keeping the diff the same,
> > > > > > so you should be able to do your porting on top of the existing code.
> > > > > 
> > > > > No I'm actually pretty fine with the current state. Whether that's defined
> > > > > in this patch or a following one is actually not important.
> > > > 
> > > > Fair enough!
> > > 
> > > And here is an update that might handle an irq entry/exit miscounting
> > > problem.  Thanks to Arjan van de Ven for pointing out that my earlier
> > > approach would in fact miscount irq entries/exits in face of things like
> > > upcalls to user-mode helpers.
> > 
> > I'm not sure what you mean. How could the current state miscount in user-mode?
> 
> It appears that some sorts of upcalls to userspace can have an irq_exit()
> without a matching irq_enter(), as shown by the stack trace below.  This
> splat was generated by some code in rcu_idle_enter() that complains when
> a non-idle task tries to become idle.
> 
> One possibility that I am considering is to have ____call_usermodehelper()
> set a task-structure flag just before the call to kernel_execve(), and
> to have rcu_idle_enter() check that flag, and, if set, zero the flag
> and just return without doing anything.  I don't claim to understand
> the code well enough to know whether this really works, though.

And not a chance -- too many opportunities for interrupts and preemption
at any number of points in this code.  Back to the drawing board...

							Thanx, Paul

> ------------------------------------------------------------------------
> 
> [    0.373084] WARNING: at kernel/rcutree.c:398
> [    0.373089] Modules linked in:
> [    0.373097] NIP: c0000000000d3c4c LR: c0000000000d3c34 CTR: 0000000000000000
> [    0.373106] REGS: c000000042212f50 TRAP: 0700   Not tainted  (3.1.0-rc8-autokern1)
> [    0.373114] MSR: 8000000000021032 <ME,CE,IR,DR>  CR: 48008022  XER: 00000000
> [    0.373134] CFAR: c000000000053340
> [    0.373140] TASK = c0000000421f2640[5] 'kworker/u:0' THREAD: c000000042210000 CPU: 1
> [    0.373149] GPR00: 0000000000000001 c0000000422131d0 c000000000a1a7c0 0000000000000000 
> [    0.373165] GPR04: 0000000000000001 c000000008123d50 0000000004000000 0000000000000000 
> [    0.373182] GPR08: 0000000000000001 c000000000a8809d c0000000008f9520 c000000000a47d58 
> [    0.373198] GPR12: 8000000000009032 c000000007578280 0000000002080000 c0000000007b89d8 
> [    0.373214] GPR16: c0000000007b5078 0000000000000000 0000000000000000 0000000000000000 
> [    0.373231] GPR20: c000000042213a00 c000000000940480 c0000000428076a0 c000000042807600 
> [    0.373247] GPR24: c000000042807600 0000000000000040 c0000000009405f0 0000000000000000 
> [    0.373263] GPR28: 0000000000000001 0000000000000001 c0000000009991b0 0000000000000001 
> [    0.373284] NIP [c0000000000d3c4c] .rcu_idle_exit+0x1f4/0x248
> [    0.373293] LR [c0000000000d3c34] .rcu_idle_exit+0x1dc/0x248
> [    0.373300] Call Trace:
> [    0.373306] [c0000000422131d0] [c0000000000d3c28] .rcu_idle_exit+0x1d0/0x248 (unreliable)
> [    0.373319] [c000000042213270] [c00000000006f8d4] .irq_enter+0x20/0x88
> [    0.373330] [c0000000422132f0] [c00000000001b264] .timer_interrupt+0x150/0x2d0
> [    0.373341] [c000000042213390] [c0000000000038a4] decrementer_common+0x124/0x180
> [    0.373354] --- Exception: 901 at .dup_fd+0x1a0/0x2d8
> [    0.373355]     LR = .dup_fd+0x160/0x2d8
> [    0.373365] [c000000042213680] [c000000000172678] .dup_fd+0xf8/0x2d8 (unreliable)
> [    0.373378] [c000000042213750] [c000000000065f2c] .copy_process+0x64c/0x115c
> [    0.373388] [c000000042213840] [c000000000066f4c] .do_fork+0x118/0x338
> [    0.373399] [c000000042213920] [c0000000000134d8] .sys_clone+0x5c/0x74
> [    0.373409] [c000000042213990] [c000000000009914] .ppc_clone+0x8/0xc
> [    0.373421] --- Exception: c00 at .kernel_thread+0x28/0x70
> [    0.373423]     LR = .__call_usermodehelper+0x68/0xf0
> [    0.373433] [c000000042213c80] [c000000042213d10] 0xc000000042213d10 (unreliable)
> [    0.373445] [c000000042213cf0] [c000000042213d80] 0xc000000042213d80
> [    0.373455] [c000000042213d80] [c000000000086394] .process_one_work+0x2e8/0x4d0
> [    0.373467] [c000000042213e40] [c000000000089484] .worker_thread+0x1b0/0x2f4
> [    0.373477] [c000000042213ed0] [c000000000091bf8] .kthread+0xb4/0xc0
> [    0.373488] [c000000042213f90] [c00000000001de90] .kernel_thread+0x54/0x70
> [    0.373497] Instruction dump:
> [    0.373502] 485117d9 60000000 482428bd 60000000 7c6307b4 4bf7f711 60000000 2fa30000 
> [    0.373523] 40be0028 e93e8300 88090000 68000001 <0b000000> 2fa00000 41be0010 e93e8300 
> [    0.373549] ---[ end trace 75d2b1226921d2ff ]---
