Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab1BLBhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:37:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:60299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1BLBhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:37:12 -0500
Date: Sat, 12 Feb 2011 01:36:47 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1297458466.5226.93.camel@laptop>
References: <1297458466.5226.93.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86: Fix text_poke_smp_batch() deadlock
Message-ID: <tip-d91309f69b7bdb64aeb30106fde8d18c5dd354b5@git.kernel.org>
Git-Commit-ID: d91309f69b7bdb64aeb30106fde8d18c5dd354b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Feb 2011 01:36:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d91309f69b7bdb64aeb30106fde8d18c5dd354b5
Gitweb:     http://git.kernel.org/tip/d91309f69b7bdb64aeb30106fde8d18c5dd354b5
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 11 Feb 2011 22:07:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 12 Feb 2011 02:34:34 +0100

x86: Fix text_poke_smp_batch() deadlock

Fix this deadlock - we are already holding the mutex:

=======================================================
[ INFO: possible circular locking dependency detected ] 2.6.38-rc4-test+ #1
-------------------------------------------------------
bash/1850 is trying to acquire lock:
 (text_mutex){+.+.+.}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f

but task is already holding lock:
 (smp_alt){+.+...}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (smp_alt){+.+...}:
       [<ffffffff81082d02>] lock_acquire+0xcd/0xf8
       [<ffffffff8192e119>] __mutex_lock_common+0x4c/0x339
       [<ffffffff8192e4ca>] mutex_lock_nested+0x3e/0x43
       [<ffffffff8101050f>] alternatives_smp_switch+0x77/0x1d8
       [<ffffffff81926a6f>] do_boot_cpu+0xd7/0x762
       [<ffffffff819277dd>] native_cpu_up+0xe6/0x16a
       [<ffffffff81928e28>] _cpu_up+0x9d/0xee
       [<ffffffff81928f4c>] cpu_up+0xd3/0xe7
       [<ffffffff82268d4b>] kernel_init+0xe8/0x20a
       [<ffffffff8100ba24>] kernel_thread_helper+0x4/0x10

-> #1 (cpu_hotplug.lock){+.+.+.}:
       [<ffffffff81082d02>] lock_acquire+0xcd/0xf8
       [<ffffffff8192e119>] __mutex_lock_common+0x4c/0x339
       [<ffffffff8192e4ca>] mutex_lock_nested+0x3e/0x43
       [<ffffffff810568cc>] get_online_cpus+0x41/0x55
       [<ffffffff810a1348>] stop_machine+0x1e/0x3e
       [<ffffffff819314c1>] text_poke_smp_batch+0x3a/0x3c
       [<ffffffff81932b6c>] arch_optimize_kprobes+0x10d/0x11c
       [<ffffffff81933a51>] kprobe_optimizer+0x152/0x222
       [<ffffffff8106bb71>] process_one_work+0x1d3/0x335
       [<ffffffff8106cfae>] worker_thread+0x104/0x1a4
       [<ffffffff810707c4>] kthread+0x9d/0xa5
       [<ffffffff8100ba24>] kernel_thread_helper+0x4/0x10

-> #0 (text_mutex){+.+.+.}:

other info that might help us debug this:

6 locks held by bash/1850:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f
 #1:  (s_active#75){.+.+.+}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f
 #2:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f
 #3:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f
 #4:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f
 #5:  (smp_alt){+.+...}, at: [<ffffffff8100a9c1>] return_to_handler+0x0/0x2f

stack backtrace:
Pid: 1850, comm: bash Not tainted 2.6.38-rc4-test+ #1
Call Trace:

 [<ffffffff81080eb2>] print_circular_bug+0xa8/0xb7
 [<ffffffff8192e4ca>] mutex_lock_nested+0x3e/0x43
 [<ffffffff81010302>] alternatives_smp_unlock+0x3d/0x93
 [<ffffffff81010630>] alternatives_smp_switch+0x198/0x1d8
 [<ffffffff8102568a>] native_cpu_die+0x65/0x95
 [<ffffffff818cc4ec>] _cpu_down+0x13e/0x202
 [<ffffffff8117a619>] sysfs_write_file+0x108/0x144
 [<ffffffff8111f5a2>] vfs_write+0xac/0xff
 [<ffffffff8111f7a9>] sys_write+0x4a/0x6e

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mathieu.desnoyers@efficios.com
Cc: rusty@rustcorp.com.au
Cc: ananth@in.ibm.com
Cc: masami.hiramatsu.pt@hitachi.com
Cc: fweisbec@gmail.com
Cc: jbeulich@novell.com
Cc: jbaron@redhat.com
Cc: mhiramat@redhat.com
LKML-Reference: <1297458466.5226.93.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1236085..7038b95 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -671,7 +671,7 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
-	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 }
 
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
