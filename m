Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1KPJRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:17:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39229 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1KPJRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:17:05 -0500
Date: Wed, 16 Nov 2011 17:16:53 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
Message-ID: <20111116091653.GA8692@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
 <20111115084059.GA23250@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111115084059.GA23250@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at commit 4799401f [memcg: Fix race condition in
memcg_check_events() with this_cpu usage], we just want
to disable migration. So use the right API in -rt. This
will cure below warning.

BUG: sleeping function called from invalid context at linux/kernel/rtmutex.c:645
in_atomic(): 1, irqs_disabled(): 0, pid: 1, name: swapper/0
1 lock held by swapper/0/1:
 #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81154c45>] prepare_bprm_creds+0x35/0x80
Pid: 1, comm: swapper/0 Not tainted 3.2.0-rc1-rt2-11311-g3c4c0e7-dirty #10
Call Trace:
 [<ffffffff81040c4e>] __might_sleep+0x12e/0x1e0
 [<ffffffff815f4d74>] rt_spin_lock+0x24/0x60
 [<ffffffff8114506e>] memcg_check_events+0x11e/0x230
 [<ffffffff81146c5a>] T.1144+0x8a/0xf0
 [<ffffffff81146d16>] __mem_cgroup_commit_charge_lrucare+0x56/0x180
 [<ffffffff810430c9>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff81147d08>] mem_cgroup_cache_charge+0xd8/0xe0
 [<ffffffff81103a49>] add_to_page_cache_locked+0x49/0x100
 [<ffffffff8110344f>] ? find_get_page+0xdf/0x1a0
 [<ffffffff81103b22>] add_to_page_cache_lru+0x22/0x50
 [<ffffffff81103ca5>] do_read_cache_page+0x75/0x1a0
 [<ffffffff812695f0>] ? nfs_follow_link+0xc0/0xc0
 [<ffffffff81103e1c>] read_cache_page_async+0x1c/0x20
 [<ffffffff81103e2e>] read_cache_page+0xe/0x20
 [<ffffffff81269589>] nfs_follow_link+0x59/0xc0
 [<ffffffff8115de07>] path_openat+0x2a7/0x470
 [<ffffffff8115e0e9>] do_filp_open+0x49/0xa0
 [<ffffffff81155b22>] open_exec+0x32/0xf0
 [<ffffffff811a3e0b>] load_elf_binary+0x85b/0x1d30
 [<ffffffff81096d55>] ? __lock_acquire+0x4f5/0xbf0
 [<ffffffff8100a819>] ? native_sched_clock+0x29/0x80
 [<ffffffff8108429f>] ? local_clock+0x4f/0x60
 [<ffffffff815f4658>] ? rt_spin_lock_slowunlock+0x78/0x80
 [<ffffffff81091a39>] ? trace_hardirqs_off_caller+0x29/0x120
 [<ffffffff8109119e>] ? put_lock_stats+0xe/0x40
 [<ffffffff815f4658>] ? rt_spin_lock_slowunlock+0x78/0x80
 [<ffffffff811a35b0>] ? elf_map+0x1d0/0x1d0
 [<ffffffff810430c9>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff811a35b0>] ? elf_map+0x1d0/0x1d0
 [<ffffffff81154748>] search_binary_handler+0x1c8/0x4b0
 [<ffffffff811545d7>] ? search_binary_handler+0x57/0x4b0
 [<ffffffff81156876>] do_execve_common+0x276/0x330
 [<ffffffff811569ba>] do_execve+0x3a/0x40
 [<ffffffff8100bdca>] sys_execve+0x4a/0x80
 [<ffffffff815f85e8>] kernel_execve+0x68/0xd0
 [<ffffffff81000333>] ? run_init_process+0x23/0x30
 [<ffffffff81000398>] init_post+0x58/0xd0
 [<ffffffff81b5e6bd>] kernel_init+0x156/0x160
 [<ffffffff815f8574>] kernel_thread_helper+0x4/0x10
 [<ffffffff810423bc>] ? finish_task_switch+0x8c/0x110
 [<ffffffff815f5bab>] ? _raw_spin_unlock_irq+0x3b/0x70
 [<ffffffff815f5f61>] ? retint_restore_args+0xe/0xe
 [<ffffffff81b5e567>] ? parse_early_options+0x20/0x20
 [<ffffffff815f8570>] ? gs_change+0xb/0xb

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 mm/memcontrol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6aff93c..afa1954 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -722,7 +722,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
  */
 static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 {
-	preempt_disable();
+	migrate_disable();
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(memcg);
@@ -742,7 +742,7 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 		}
 #endif
 	}
-	preempt_enable();
+	migrate_enable();
 }
 
 static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
-- 
1.7.5.4

