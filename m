Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0HaPND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:13:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51540 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359Ab0HaPNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:13:01 -0400
Date: Tue, 31 Aug 2010 08:12:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com,
        jslaby@suse.cz, jmorris@namei.org
Subject: Re: [PATCH RFC] pid: make setpgid() system call use RCU read-side
 critical section
Message-ID: <20100831151212.GB2421@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100830172631.GA11868@linux.vnet.ibm.com>
 <7899.1283259751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7899.1283259751@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 02:02:31PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> >  	write_lock_irq(&tasklist_lock);
> >  
> >  	err = -ESRCH;
> > +	rcu_read_lock();
> > ...
> > +	rcu_read_unlock();
> >  	write_unlock_irq(&tasklist_lock);
> 
> I would generally put the rcu lock outside the IRQ disabled section on the
> basis that it's better to keep the amount of time we have interrupts disabled
> shortest.
> 
> > Located-by: Andrew Morton <akpm@linux-foundation.org>
> 
> 'Reported-by' might be more consistent with what others use.
> 
> David

Good points, how about the following?

							Thanx, Paul

------------------------------------------------------------------------

pid: make setpgid() system call use RCU read-side critical section

[   23.584719]
[   23.584720] ===================================================
[   23.585059] [ INFO: suspicious rcu_dereference_check() usage. ]
[   23.585176] ---------------------------------------------------
[   23.585176] kernel/pid.c:419 invoked rcu_dereference_check() without protection!
[   23.585176]
[   23.585176] other info that might help us debug this:
[   23.585176]
[   23.585176]
[   23.585176] rcu_scheduler_active = 1, debug_locks = 1
[   23.585176] 1 lock held by rc.sysinit/728:
[   23.585176]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8104771f>] sys_setpgid+0x5f/0x193
[   23.585176]
[   23.585176] stack backtrace:
[   23.585176] Pid: 728, comm: rc.sysinit Not tainted 2.6.36-rc2 #2
[   23.585176] Call Trace:
[   23.585176]  [<ffffffff8105b436>] lockdep_rcu_dereference+0x99/0xa2
[   23.585176]  [<ffffffff8104c324>] find_task_by_pid_ns+0x50/0x6a
[   23.585176]  [<ffffffff8104c35b>] find_task_by_vpid+0x1d/0x1f
[   23.585176]  [<ffffffff81047727>] sys_setpgid+0x67/0x193
[   23.585176]  [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
[   24.959669] type=1400 audit(1282938522.956:4): avc:  denied  { module_request } for  pid=766 comm="hwclock" kmod="char-major-10-135" scontext=system_u:system_r:hwclock_t:s0 tcontext=system_u:system_r:kernel_t:s0 tclas

It turns out that the setpgid() system call fails to enter an RCU
read-side critical section before doing a PID-to-task_struct translation.
This commit therefore does rcu_read_lock() before the translation, and
also does rcu_read_unlock() after the last use of the returned pointer.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/sys.c b/kernel/sys.c
index e9ad444..7f5a0cd 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -931,6 +931,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 		pgid = pid;
 	if (pgid < 0)
 		return -EINVAL;
+	rcu_read_lock();
 
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
@@ -984,6 +985,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	return err;
 }
 
