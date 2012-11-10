Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2KJFcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 00:32:33 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:44987 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2KJFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 00:32:30 -0500
Date: Sat, 10 Nov 2012 06:32:28 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Subject: [PATCH] perf: call perf_event_comm under task_lock to fix suspicious rcu usage
Message-ID: <20121110053228.GB11317@order.stressinduktion.org>
Mail-Followup-To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following RCU warning showed up while executing a shebang-script under
perf-record (could even be an empty script) on a 3.7-rc4 stable kernel:

  [   32.185108] 
  [   32.185332] ===============================
  [   32.185602] [ INFO: suspicious RCU usage. ]
  [   32.185903] 3.7.0-rc4 #1 Not tainted
  [   32.186021] -------------------------------
  [   32.186021] include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!
  [   32.186021] 
  [   32.186021] other info that might help us debug this:
  [   32.186021] 
  [   32.186021] 
  [   32.186021] rcu_scheduler_active = 1, debug_locks = 0
  [   32.186021] 1 lock held by empty.sh/556:
  [   32.186021]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811d1d16>] prepare_bprm_creds+0x36/0x80
  [   32.186021] 
  [   32.186021] stack backtrace:
  [   32.186021] Pid: 556, comm: empty.sh Not tainted 3.7.0-rc4 #1
  [   32.186021] Call Trace:
  [   32.186021]  [<ffffffff810d336d>] lockdep_rcu_suspicious+0xfd/0x130
  [   32.186021]  [<ffffffff81153de6>] perf_event_comm+0x436/0x610
  [   32.186021]  [<ffffffff810d181d>] ? trace_hardirqs_off+0xd/0x10
  [   32.186021]  [<ffffffff810ac37f>] ? local_clock+0x6f/0x80
  [   32.186021]  [<ffffffff810d217f>] ? lock_release_holdtime.part.26+0xf/0x180
  [   32.186021]  [<ffffffff811d1bd3>] set_task_comm+0x73/0x180
  [   32.186021]  [<ffffffff811d24ba>] setup_new_exec+0x9a/0x210
  [   32.186021]  [<ffffffff81225cf3>] load_elf_binary+0x3e3/0x1ab0
  [   32.186021]  [<ffffffff810ac0f5>] ? sched_clock_local+0x25/0xa0
  [   32.186021]  [<ffffffff810ac298>] ? sched_clock_cpu+0xa8/0x120
  [   32.186021]  [<ffffffff810d181d>] ? trace_hardirqs_off+0xd/0x10
  [   32.186021]  [<ffffffff810ac37f>] ? local_clock+0x6f/0x80
  [   32.186021]  [<ffffffff81225910>] ? load_elf_library+0x240/0x240
  [   32.186021]  [<ffffffff81225910>] ? load_elf_library+0x240/0x240
  [   32.186021]  [<ffffffff811d14a4>] search_binary_handler+0x194/0x4f0
  [   32.186021]  [<ffffffff811d136f>] ? search_binary_handler+0x5f/0x4f0
  [   32.186021]  [<ffffffff81225220>] ? compat_sys_ioctl+0x1510/0x1510
  [   32.186021]  [<ffffffff812254b4>] load_script+0x294/0x2c0
  [   32.186021]  [<ffffffff810d217f>] ? lock_release_holdtime.part.26+0xf/0x180
  [   32.186021]  [<ffffffff81225220>] ? compat_sys_ioctl+0x1510/0x1510
  [   32.186021]  [<ffffffff811d14a4>] search_binary_handler+0x194/0x4f0
  [   32.186021]  [<ffffffff811d136f>] ? search_binary_handler+0x5f/0x4f0
  [   32.186021]  [<ffffffff811d22cb>] do_execve_common.isra.25+0x50b/0x5b0
  [   32.186021]  [<ffffffff811d1eea>] ? do_execve_common.isra.25+0x12a/0x5b0
  [   32.186021]  [<ffffffff811d238b>] do_execve+0x1b/0x20
  [   32.186021]  [<ffffffff811d26c4>] sys_execve+0x54/0x80
  [   32.186021]  [<ffffffff816d8f99>] stub_execve+0x69/0xc0

I think this dereference qualifies for the task_lock exception (as noted
in kernel/cgroup.c), thus this patch ensures calling perf_event_comm
before giving up the task_lock.

Changelog -v2 (since <20121103235758.GD18106@order.stressinduktion.org>):
  1) rebased to 3.7-rc4
  2) slightly improved/updated commit msg and added more people to Cc

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0039055..a961b9d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1038,8 +1038,8 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	memset(tsk->comm, 0, TASK_COMM_LEN);
 	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
-	task_unlock(tsk);
 	perf_event_comm(tsk);
+	task_unlock(tsk);
 }
 
 static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)

