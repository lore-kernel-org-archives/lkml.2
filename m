Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0DND7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:59:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54124 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab0DND7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:59:11 -0400
Date: Wed, 14 Apr 2010 13:59:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: linux-next: manual merge of the tip tree with the limits tree
Message-Id: <20100414135905.47494958.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/posix-cpu-timers.c between commit
0c1b5ce8de67c36bbf67db38240a91f358133bdd ("core: add task_struct to
update_rlimit_cpu") from the limits tree and commit
f55db609042faecd5e518ce372b87f846659b32e ("cpu-timers: Simplify
RLIMIT_CPU handling") from the tip tree.

I did the obvious fixup (see below) but it is probably not completely
correct.   Jiri, did I see Linus ask for major revisions of the writable
limits work?
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/posix-cpu-timers.c
index 2807ef8,799f360..0000000
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@@ -11,19 -11,18 +11,18 @@@
  #include <trace/events/timer.h>
  
  /*
-  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
+  * Called after updating RLIMIT_CPU to run cpu timer and update
+  * tsk->signal->cputime_expires expiration cache if necessary. Needs
+  * siglock protection since other code may update expiration cache as
+  * well.
   */
 -void update_rlimit_cpu(unsigned long rlim_new)
 +void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
  {
  	cputime_t cputime = secs_to_cputime(rlim_new);
- 	struct signal_struct *const sig = task->signal;
  
- 	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
- 	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
- 		spin_lock_irq(&task->sighand->siglock);
- 		set_process_cpu_timer(task, CPUCLOCK_PROF, &cputime, NULL);
- 		spin_unlock_irq(&task->sighand->siglock);
- 	}
 -	spin_lock_irq(&current->sighand->siglock);
 -	set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 -	spin_unlock_irq(&current->sighand->siglock);
++	spin_lock_irq(&task->sighand->siglock);
++	set_process_cpu_timer(task, CPUCLOCK_PROF, &cputime, NULL);
++	spin_unlock_irq(&task->sighand->siglock);
  }
  
  static int check_clock(const clockid_t which_clock)
