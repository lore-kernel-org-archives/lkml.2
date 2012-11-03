Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2KCX6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 19:58:01 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:60322 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2KCX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 19:58:00 -0400
Date: Sun, 4 Nov 2012 00:57:58 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Call perf_event_comm under task_lock
Message-ID: <20121103235758.GD18106@order.stressinduktion.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following RCU warning showed up while executing a script under perf-record
(could even be an empty script) on a 3.6.5 stable kernel:

  [  735.600772]
  [  735.600866] ===============================
  [  735.600939] [ INFO: suspicious RCU usage. ]
  [  735.601004] 3.6.5+ #1 Not tainted
  [  735.601016] -------------------------------
  [  735.601016] include/linux/cgroup.h:546 suspicious rcu_dereference_check() usage!
  [  735.601016]
  [  735.601016] other info that might help us debug this:
  [  735.601016]
  [  735.601016]
  [  735.601016] rcu_scheduler_active = 1, debug_locks = 0
  [  735.601016] 1 lock held by test3.sh/562:
  [  735.601016]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811cfa86>] prepare_bprm_creds+0x36/0x80
  [  735.601016]
  [  735.601016] stack backtrace:
  [  735.601016] Pid: 562, comm: test3.sh Not tainted 3.6.5+ #1
  [  735.601016] Call Trace:
  [  735.601016]  [<ffffffff810d1d1d>] lockdep_rcu_suspicious+0xfd/0x130
  [  735.601016]  [<ffffffff81151a26>] perf_event_comm+0x436/0x610
  [  735.601016]  [<ffffffff810d01fd>] ? trace_hardirqs_off+0xd/0x10
  [  735.601016]  [<ffffffff810ac12f>] ? local_clock+0x6f/0x80
  [  735.601016]  [<ffffffff810d0b5f>] ? lock_release_holdtime.part.26+0xf/0x180
  [  735.601016]  [<ffffffff811cf943>] set_task_comm+0x73/0x180
  [  735.601016]  [<ffffffff811d022e>] setup_new_exec+0x9e/0x340
  [  735.601016]  [<ffffffff81221143>] load_elf_binary+0x3e3/0x1a80
  [  735.601016]  [<ffffffff810abea5>] ? sched_clock_local+0x25/0xa0
  [  735.601016]  [<ffffffff810ac048>] ? sched_clock_cpu+0xa8/0x120
  [  735.601016]  [<ffffffff810d01fd>] ? trace_hardirqs_off+0xd/0x10
  [  735.601016]  [<ffffffff810ac12f>] ? local_clock+0x6f/0x80
  [  735.601016]  [<ffffffff81220d60>] ? load_elf_library+0x240/0x240
  [  735.601016]  [<ffffffff81220d60>] ? load_elf_library+0x240/0x240
  [  735.601016]  [<ffffffff811cf214>] search_binary_handler+0x194/0x4f0
  [  735.601016]  [<ffffffff811cf0e1>] ? search_binary_handler+0x61/0x4f0
  [  735.601016]  [<ffffffff81220670>] ? compat_sys_ioctl+0x1360/0x1360
  [  735.601016]  [<ffffffff81220904>] load_script+0x294/0x2c0
  [  735.601016]  [<ffffffff810d0b5f>] ? lock_release_holdtime.part.26+0xf/0x180
  [  735.601016]  [<ffffffff81220670>] ? compat_sys_ioctl+0x1360/0x1360
  [  735.601016]  [<ffffffff811cf214>] search_binary_handler+0x194/0x4f0
  [  735.601016]  [<ffffffff811cf0e1>] ? search_binary_handler+0x61/0x4f0
  [  735.601016]  [<ffffffff811d003b>] do_execve_common.isra.32+0x50b/0x5b0
  [  735.601016]  [<ffffffff811cfc5a>] ? do_execve_common.isra.32+0x12a/0x5b0
  [  735.601016]  [<ffffffff811ad330>] ? kmem_cache_alloc+0xe0/0x260
  [  735.601016]  [<ffffffff811d00fb>] do_execve+0x1b/0x20
  [  735.601016]  [<ffffffff810243f7>] sys_execve+0x47/0x70
  [  735.601016]  [<ffffffff816b49ac>] stub_execve+0x6c/0xc0

I think this dereference qualifies for the task_lock exception, thus
this patch ensures calling perf_event_comm before giving up the task_lock.

Patch based on linux-stable v3.6.5.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index fab2c6d..781cf77 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1065,8 +1065,8 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	memset(tsk->comm, 0, TASK_COMM_LEN);
 	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
-	task_unlock(tsk);
 	perf_event_comm(tsk);
+	task_unlock(tsk);
 }
 
 static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)

