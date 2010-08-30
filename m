Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0H3Ucn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:32:43 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46723 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab0H3Ucm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:32:42 -0400
Date: Mon, 30 Aug 2010 13:32:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, jmorris@namei.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] pid: make setpgid() system call use RCU read-side
 critical section
Message-ID: <20100830203233.GK2420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100830172631.GA11868@linux.vnet.ibm.com>
 <4C7C0BAB.3000709@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7C0BAB.3000709@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 09:51:07PM +0200, Jiri Slaby wrote:
> Ccing Oleg.
> 
> On 08/30/2010 07:26 PM, Paul E. McKenney wrote:
> > [   23.584720] ===================================================
> > [   23.585059] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [   23.585176] ---------------------------------------------------
> > [   23.585176] kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> > [   23.585176]
> > [   23.585176] other info that might help us debug this:
> > [   23.585176]
> > [   23.585176]
> > [   23.585176] rcu_scheduler_active = 1, debug_locks = 1
> > [   23.585176] 1 lock held by rc.sysinit/728:
> > [   23.585176]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8104771f>] sys_setpgid+0x5f/0x193
> > [   23.585176]
> > [   23.585176] stack backtrace:
> > [   23.585176] Pid: 728, comm: rc.sysinit Not tainted 2.6.36-rc2 #2
> > [   23.585176] Call Trace:
> > [   23.585176]  [<ffffffff8105b436>] lockdep_rcu_dereference+0x99/0xa2
> > [   23.585176]  [<ffffffff8104c324>] find_task_by_pid_ns+0x50/0x6a
> > [   23.585176]  [<ffffffff8104c35b>] find_task_by_vpid+0x1d/0x1f
> > [   23.585176]  [<ffffffff81047727>] sys_setpgid+0x67/0x193
> > [   23.585176]  [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
> > [   24.959669] type=1400 audit(1282938522.956:4): avc:  denied  { module_request } for  pid=766 comm="hwclock" kmod="char-major-10-135" scontext=system_u:system_r:hwclock_t:s0 tcontext=system_u:system_r:kernel_t:s0 tclas
> > 
> > It turns out that the setpgid() system call fails to enter an RCU
> > read-side critical section before doing a PID-to-task_struct translation.
> > This commit therefore does rcu_read_lock() before the translation, and
> > also does rcu_read_unlock() after the last use of the returned pointer.
> > 
> > Located-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  sys.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index e9ad444..05a4b0c 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -938,6 +938,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
> >  	write_lock_irq(&tasklist_lock);
> >  
> >  	err = -ESRCH;
> > +	rcu_read_lock();
> >  	p = find_task_by_vpid(pid);
> 
> AFAICT the missing lock doesn't harm due to the write_lock of tasklist
> above. But is probably a good thing to do anyway.

Or we can add the tasklist lock to the rcu_dereference_check() condition.

							Thanx, Paul

> regards,
> -- 
> js
> suse labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
