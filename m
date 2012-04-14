Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2DNQUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:20:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47947 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2DNQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:02 -0400
Date: Sat, 14 Apr 2012 09:19:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: [PATCH RFC 0/7] rcu: v2 Inlinable preemptible rcu_read_lock() and
 rcu_read_unlock()
Message-ID: <20120414161953.GA18140@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-7408-0000-0000-0000043342F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series is version two of the inlinable versions of preemptible
RCU's __rcu_read_lock() and __rcu_read_unlock().  The first version may
be found at https://lkml.org/lkml/2012/3/25/94.  The individual commits
in this new series are as follows:

1.	Move preemptible RCU's hook in the scheduler from the common
	RCU scheduler-entry hook to just before the scheduler's call
	to switch_to.  This reduces overhead in the case where the
	scheduler is called but does not switch and also sets the
	stage for saving and restoring the per-CPU variables needed
	for inlining.

2.	Create the per-CPU variables and rename rcu_read_unlock_special()
	to avoid name conflict.

3.	Make exit_rcu() use a more precise method of checking the need
	for exit-time RCU-related cleanup, and consolidate the two
	identical versions of exit_rcu() into one place.

4.	Make __rcu_read_lock() and __rcu_read_unlock() use the per-CPU
	variables, but leave them out of line for the moment.  This
	requires adding a second preemptible-RCU hook in the scheduler
	to restore the values of the per-CPU variables.

5.	Silence bogus copy_to_user() build errors that seem to be triggered
	by differences in gcc's inlining decisions when __rcu_read_lock()
	becomes inlinable.  Apparently, copy_to_user() needs to be inlined
	in order to function correctly?  Hmmm, sort of like kfree_rcu().

6.	Inline __rcu_read_lock().

7.	Inline __rcu_read_unlock().

With these changes, the 32-bit x86 gcc compiler compiles this:

	void rcu_read_lock_code(void)
	{
		rcu_read_lock();
	}

to this:

	000000d0 <rcu_read_lock_code>:
	  d0:	64 ff 05 00 00 00 00 	incl   %fs:0x0
	  d7:	c3                   	ret    
	  d8:	90                   	nop
	  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

It also compiles this:

	void rcu_read_unlock_code(void)
	{
		rcu_read_unlock();
	}

to this:

	000000e0 <rcu_read_unlock_code>:
	  e0:	64 a1 00 00 00 00    	mov    %fs:0x0,%eax
	  e6:	83 f8 01             	cmp    $0x1,%eax
	  e9:	74 0d                	je     f8 <rcu_read_unlock_code+0x18>
	  eb:	64 ff 0d 00 00 00 00 	decl   %fs:0x0
	  f2:	c3                   	ret    
	  f3:	90                   	nop
	  f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  f8:	64 c7 05 00 00 00 00 	movl   $0x80000000,%fs:0x0
	  ff:	00 00 00 80 
	 103:	64 a1 00 00 00 00    	mov    %fs:0x0,%eax
	 109:	85 c0                	test   %eax,%eax
	 10b:	75 0c                	jne    119 <rcu_read_unlock_code+0x39>
	 10d:	64 c7 05 00 00 00 00 	movl   $0x0,%fs:0x0
	 114:	00 00 00 00 
	 118:	c3                   	ret    
	 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	 120:	e8 fc ff ff ff       	call   121 <rcu_read_unlock_code+0x41>
	 125:	eb e6                	jmp    10d <rcu_read_unlock_code+0x2d>

It is therefore not at all clear to me that the final patch in this
series is worthwhile.  Unless someone comes up with a good reason to
keep it, I will drop it.  The only possible justification I can see is
that gcc could (in theory, anyway) drop dead code in the case of nested
RCU read-side critical sections (everything from address f3 onwards),
but this just doesn't cut it for me at the moment.  I could also imagine
having the inlined portion contain only the nesting check and decrement,
along with a call to an out-of-line function that does the rest, but
this looks to me to bloat the code for no good reason.

Thoughts?

							Thanx, Paul

 arch/um/drivers/mconsole_kern.c   |    3 
 b/arch/um/drivers/mconsole_kern.c |    1 
 b/fs/binfmt_misc.c                |    4 -
 b/include/linux/init_task.h       |    4 -
 b/include/linux/rcupdate.h        |    1 
 b/include/linux/rcutiny.h         |    6 -
 b/include/linux/rcutree.h         |   12 ---
 b/include/linux/sched.h           |   10 +++
 b/kernel/rcu.h                    |    4 +
 b/kernel/rcupdate.c               |    5 +
 b/kernel/rcutiny_plugin.h         |   10 +--
 b/kernel/rcutree.c                |    1 
 b/kernel/rcutree.h                |    1 
 b/kernel/rcutree_plugin.h         |   14 ----
 b/kernel/sched/core.c             |    1 
 include/linux/rcupdate.h          |   72 ++++++++++++++++++++-
 include/linux/rcutiny.h           |    5 -
 include/linux/sched.h             |   92 +++++++++++++++++++++++++--
 kernel/rcu.h                      |    4 -
 kernel/rcupdate.c                 |  126 ++++++++++++++++++++++----------------
 kernel/rcutiny_plugin.h           |  123 +++++++------------------------------
 kernel/rcutree_plugin.h           |  114 ++++++++--------------------------
 kernel/sched/core.c               |    3 
 23 files changed, 321 insertions(+), 295 deletions(-)

