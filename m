Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2CUXnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:43:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46425 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2CUXnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:43:22 -0400
MIME-Version: 1.0
Date: Thu, 22 Mar 2012 01:43:22 +0200
Message-ID: <CAEbykaXUy7HEyW7mBaTNmB94NwyjuJBbA1R-H49Jjk5M-iL_fw@mail.gmail.com>
Subject: [PATCH] perf: Fix RCU dereference check in perf_event_comm
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning below is printed when executing a command like
sudo perf record su - user -c "echo hello"

It's fixed by moving the call of perf_event_comm to be protected
by the task lock.

===============================
[ INFO: suspicious RCU usage. ]
3.3.0 #49 Not tainted
-------------------------------
include/linux/cgroup.h:567 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by su/3304:
 #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff8117af66>]
prepare_bprm_creds+0x36/0x80

stack backtrace:
Pid: 3304, comm: su Not tainted 3.3.0 #49
Call Trace:
 [<ffffffff8109be55>] lockdep_rcu_suspicious+0xe5/0x100
 [<ffffffff811131fa>] perf_event_comm+0x37a/0x4d0
 [<ffffffff81144525>] ? remove_vma+0x65/0x80
 [<ffffffff810722e1>] ? get_parent_ip+0x11/0x50
 [<ffffffff814e6fad>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff8117ae05>] set_task_comm+0x75/0x1a0
 [<ffffffff8102b945>] ? mmap_rnd+0x45/0x50
 [<ffffffff8117b6d2>] setup_new_exec+0xa2/0x340
 [<ffffffff811c98f7>] load_elf_binary+0x3c7/0x19d0
 [<ffffffff814e3275>] ? _raw_read_unlock+0x35/0x60
 [<ffffffff8117a313>] ? search_binary_handler+0x1c3/0x530
 [<ffffffff810722e1>] ? get_parent_ip+0x11/0x50
 [<ffffffff814e6fad>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff814e6fad>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff811c9530>] ? do_mmap+0x40/0x40
 [<ffffffff8117a2f0>] search_binary_handler+0x1a0/0x530
 [<ffffffff8117a1a7>] ? search_binary_handler+0x57/0x530
 [<ffffffff8117974d>] ? copy_strings.isra.32+0x1fd/0x230
 [<ffffffff8117b44f>] do_execve_common.isra.36+0x43f/0x570
 [<ffffffff8117b166>] ? do_execve_common.isra.36+0x156/0x570
 [<ffffffff81296837>] ? __strncpy_from_user+0x27/0x60
 [<ffffffff8117b59b>] do_execve+0x1b/0x20
 [<ffffffff8100c317>] sys_execve+0x47/0x70
 [<ffffffff814eb39c>] stub_execve+0x6c/0xc0

Signed-off-by: Ari Savolainen <ari.m.savolainen@gmail.com>
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 153dee1..373ff93 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1067,8 +1067,8 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	memset(tsk->comm, 0, TASK_COMM_LEN);
 	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
-	task_unlock(tsk);
 	perf_event_comm(tsk);
+	task_unlock(tsk);
 }

 static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)
-- 
1.7.9.1
