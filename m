Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1HSIys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 04:54:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:49671 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1HSIyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 04:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,250,1312182000"; 
   d="scan'208";a="40177118"
Subject: Re: Hanging threads with pthread_detach and gdb
From: Lin Ming <ming.m.lin@intel.com>
To: Philipp Marek <philipp.marek@linbit.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAF1ivSZ-CCzFUH4WtxqL2QBoyB3WtF+KMqnCBdjaHhZ7-bbVjA@mail.gmail.com>
References: <201108161458.35774.philipp.marek@linbit.com>
	 <CAF1ivSZ-CCzFUH4WtxqL2QBoyB3WtF+KMqnCBdjaHhZ7-bbVjA@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-EbItRhUUs18DZ8OtMbIp"
Date: Fri, 19 Aug 2011 16:54:43 +0800
Message-ID: <1313744083.4115.206.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EbItRhUUs18DZ8OtMbIp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit


> From: Philipp Marek <philipp.marek@linbit.com>
> Date: Tue, Aug 16, 2011 at 8:58 PM
> Subject: Hanging threads with pthread_detach and gdb
> To: linux-kernel@vger.kernel.org
> 
> 
> Hello everybody,
> 
> 
> I've found a strange behaviour, and I think it's a kernel bug - or, at
> least, a bad interaction with GDB.
> 
> 
> The attached program creates a few detached pthreads, and quits.
> Running the program as-is works without any problem; but when it's started
> via gdb there's an occasional hang at the end (1 out of 5 to 10 runs).

(Add Ingo and PeterZ)

Hi,

I can reproduce this problem.

After gdb hangs,

mlin@wsm:~$ ps -eLf
mlin      2277  2220  2277 13    1 00:27 pts/0    00:00:07 gdb test
mlin      2431  2277  2431  0    2 00:28 pts/0    00:00:00 [test] <defunct>
mlin      2431  2277  2436  0    2 00:28 pts/0    00:00:00 [test] <defunct>

I did some investigation and find the cause as below.
With the attached debug patch applied, here is the last output lines
before gdb hangs.

=====
gdb wait for pid=2431
gdb is going to sleep ...
gdb children list:
    pid=2431, exit_state=16, exit_signal=17
gdb ptrace list:
    pid=2436, exit_state=16, exit_signal=-1
    pid=2431, exit_state=16, exit_signal=17
=====

exit_state 16 is EXIT_ZOMBIE state.
pid 2431 is the thread group leader.
pid 2436 is the thread group member(other members have been removed).

gdb is waiting the group leader, but it fails because the group is not
empty. Then gdb goes to sleep.

At this moment, all threads have gone into EXIT_ZOMBIE state.
So no thread can wake up gdb anymore.

That's why gdb hangs.

I'm not familiar with pthread semantics.
Is this a problem need to be fixed?

Thanks,
Lin Ming

> 
> 
> CTRL-C doesn't work:
>    $ gdb -ex r --args ./t
>    ...
>    Starting program: t
>    [Thread debugging using libthread_db enabled]
>    [New Thread 0x7ffff783c700 (LWP 8227)]
>    thread (nil) START
>    [New Thread 0x7ffff703b700 (LWP 8228)]
>    thread 0x1 START
>    [New Thread 0x7ffff683a700 (LWP 8229)]
>    thread 0x2 START
>    [New Thread 0x7ffff6039700 (LWP 8230)]
>    thread 0x3 START
>    [New Thread 0x7ffff5838700 (LWP 8231)]
>    thread 0x4 START
>    thread 0x4 END
>    thread 0x2 END
>    thread (nil) END
>    the end is near.
>    [Thread 0x7ffff6039700 (LWP 8230) exited]
>    [Thread 0x7ffff683a700 (LWP 8229) exited]
>    [Thread 0x7ffff703b700 (LWP 8228) exited]
>    [Thread 0x7ffff783c700 (LWP 8227) exited]
>    ^C
> 
> 
> "ps fax" shows that the test program would be done:
>     8210 pts/13   S      0:00          \_ gdb -ex r --args ./t
>     8226 pts/13   Zl+    0:00              \_ [t] <defunct>
> 
> 
> but GDB still waits for it:
>    $ strace -p 8210
>    Process 8120 attached - interrupt to quit
>    wait4(8226, ^C <unfinished ...>
>    Process 8120 detached
> 
> The kernel stack trace shows need_resched()
>    $ sudo cat /proc/8226/task/*/stack
>    [<ffffffff810383fc>] need_resched+0x1a/0x23
>    [<ffffffff8103840a>] should_resched+0x5/0x24
>    [<ffffffff81049ea0>] do_exit+0x73e/0x740
>    [<ffffffff8104a119>] do_group_exit+0x77/0xa1
>    [<ffffffff8104a155>] sys_exit_group+0x12/0x19
>    [<ffffffff8133ba92>] system_call_fastpath+0x16/0x1b
>    [<ffffffffffffffff>] 0xffffffffffffffff
>    [<ffffffff810383fc>] need_resched+0x1a/0x23
>    [<ffffffff8103840a>] should_resched+0x5/0x24
>    [<ffffffff81049ea0>] do_exit+0x73e/0x740
>    [<ffffffff8104a119>] do_group_exit+0x77/0xa1
>    [<ffffffff8105676f>] get_signal_to_deliver+0x37c/0x3a3
>    [<ffffffff810d22bb>] handle_pte_fault+0x295/0x79b
>    [<ffffffff81008e37>] do_signal+0x6c/0x649
>    [<ffffffff8133983a>] do_page_fault+0x2d3/0x30e
>    [<ffffffff810383fc>] need_resched+0x1a/0x23
>    [<ffffffff8103840a>] should_resched+0x5/0x24
>    [<ffffffff8103aec8>] mmdrop+0xd/0x1c
>    [<ffffffff8103b0a2>] finish_task_switch+0x84/0xaf
>    [<ffffffff810383fc>] need_resched+0x1a/0x23
>    [<ffffffff81009450>] do_notify_resume+0x25/0x6b
>    [<ffffffff81336fd2>] paranoid_userspace+0x46/0x50
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> (but I've seen traces like this, too:)
>    [<ffffffff810ed076>] kmem_cache_free+0x2d/0x69
>    [<ffffffff81055739>] ptrace_stop+0xff/0x19e
>    [<ffffffff81056550>] get_signal_to_deliver+0x15d/0x3a3
>    [<ffffffff81008e37>] do_signal+0x6c/0x649
>    [<ffffffff81035861>] __wake_up_common+0x41/0x78
>    [<ffffffff810383fc>] need_resched+0x1a/0x23
>    [<ffffffff8103840a>] should_resched+0x5/0x24
>    [<ffffffff810121dd>] arch_ptrace+0x7d/0x1bd
>    [<ffffffff8104fc48>] put_task_struct+0xd/0x1c
>    [<ffffffff8105084e>] sys_ptrace+0x7d/0x8d
>    [<ffffffff810fc8b0>] fput+0x1a/0x1a2
>    [<ffffffff81009450>] do_notify_resume+0x25/0x6b
>    [<ffffffff810fbd2d>] sys_write+0x5f/0x6b
>    [<ffffffff81336fd2>] paranoid_userspace+0x46/0x50
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> This is with a distribution kernel (sorry), recent userspace:
>    $ uname -a
>    Linux 3.0.0-1-amd64 #1 SMP Sun Jul 24 02:24:44 UTC 2011 x86_64 GNU/Linux
>    $ gdb --version
>    GNU gdb (GDB) 7.2-debian
>    $ dpkg-query -l libpth20 gdb
>    ii  libpth20         2.0.7-16       The GNU Portable Threads
>    ii  gdb              7.2-1          The GNU Debugger
> 
> 
> I've tried with a vanilla 3.0 ARCH=um (clean 3.0 checkout, git rev
> (02f8c6aee8df3cdc935e9bdd4f2d020306035dbe), but get hit by
> "Couldn't write debug register: Input/Output error" which seems to be
> reported as http://marc.info/?l=user-mode-linux-devel&m=126038615513701 and
> http://marc.info/?l=user-mode-linux-devel&m=127181550231140.
> 
> 
> Any help would be appreciated!
> Please keep me CC'ed; thank you.
> 
> 
> Regards,
> 
> Phil


--=-EbItRhUUs18DZ8OtMbIp
Content-Disposition: attachment; filename="debug.patch"
Content-Type: text/x-patch; name="debug.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..09b81da 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1678,6 +1678,29 @@ void __wake_up_parent(struct task_struct *p, struct task_struct *parent)
 				TASK_INTERRUPTIBLE, 1, p);
 }
 
+static void debug_dump(void)
+{
+	struct task_struct *tsk = current;
+	struct task_struct *p;
+
+	if (strcmp(current->comm, "gdb"))
+		return;
+
+	printk("gdb is going to sleep ...\n");
+	
+	printk("gdb children list:\n");
+	read_lock(&tasklist_lock);
+	list_for_each_entry(p, &tsk->children, sibling)
+		printk("    pid=%d, exit_state=%d, exit_signal=%d\n",
+			p->pid, p->exit_state, p->exit_signal);
+
+	printk("gdb ptrace list:\n");
+	list_for_each_entry(p, &tsk->ptraced, ptrace_entry)
+		printk("    pid=%d, exit_state=%d, exit_signal=%d\n",
+			p->pid, p->exit_state, p->exit_signal);
+	read_unlock(&tasklist_lock);
+}
+
 static long do_wait(struct wait_opts *wo)
 {
 	struct task_struct *tsk;
@@ -1722,6 +1745,7 @@ notask:
 	if (!retval && !(wo->wo_flags & WNOHANG)) {
 		retval = -ERESTARTSYS;
 		if (!signal_pending(current)) {
+			debug_dump();
 			schedule();
 			goto repeat;
 		}
@@ -1815,6 +1839,9 @@ SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
 			__WNOTHREAD|__WCLONE|__WALL))
 		return -EINVAL;
 
+	if (!strcmp(current->comm, "gdb"))
+		printk("gdb wait for pid=%d\n", upid);
+
 	if (upid == -1)
 		type = PIDTYPE_MAX;
 	else if (upid < 0) {

--=-EbItRhUUs18DZ8OtMbIp--

