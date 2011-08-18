Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1HRMiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1HRMiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:38:01 -0400
From: WANG Cong <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <amwang@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [Patch] sched: fix a memory leak in __sdt_free()
Date: Thu, 18 Aug 2011 20:36:57 +0800
Message-Id: <1313671017-4112-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following memory leak:

unreferenced object 0xffff880107266800 (size 512):
  comm "sched-powersave", pid 3718, jiffies 4323097853 (age 27495.450s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81133940>] create_object+0x187/0x28b
    [<ffffffff814ac103>] kmemleak_alloc+0x73/0x98
    [<ffffffff811232ba>] __kmalloc_node+0x104/0x159
    [<ffffffff81044b98>] kzalloc_node.clone.97+0x15/0x17
    [<ffffffff8104cb90>] build_sched_domains+0xb7/0x7f3
    [<ffffffff8104d4df>] partition_sched_domains+0x1db/0x24a
    [<ffffffff8109ee4a>] do_rebuild_sched_domains+0x3b/0x47
    [<ffffffff810a00c7>] rebuild_sched_domains+0x10/0x12
    [<ffffffff8104d5ba>] sched_power_savings_store+0x6c/0x7b
    [<ffffffff8104d5df>] sched_mc_power_savings_store+0x16/0x18
    [<ffffffff8131322c>] sysdev_class_store+0x20/0x22
    [<ffffffff81193876>] sysfs_write_file+0x108/0x144
    [<ffffffff81135b10>] vfs_write+0xaf/0x102
    [<ffffffff81135d23>] sys_write+0x4d/0x74
    [<ffffffff814c8a42>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..bd2d8c3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7443,6 +7443,7 @@ static void __sdt_free(const struct cpumask *cpu_map)
 			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
 			if (sd && (sd->flags & SD_OVERLAP))
 				free_sched_groups(sd->groups, 0);
+			kfree(*per_cpu_ptr(sdd->sd, j));
 			kfree(*per_cpu_ptr(sdd->sg, j));
 			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
