Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1H2O5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:57:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:34538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab1H2O5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:57:03 -0400
Date: Mon, 29 Aug 2011 14:56:21 GMT
From: tip-bot for WANG Cong <amwang@redhat.com>
Message-ID: <tip-feff8fa0075bdfd43c841e9d689ed81adda988d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        amwang@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, amwang@redhat.com,
        mingo@elte.hu
In-Reply-To: <1313671017-4112-1-git-send-email-amwang@redhat.com>
References: <1313671017-4112-1-git-send-email-amwang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix a memory leak in __sdt_free()
Git-Commit-ID: feff8fa0075bdfd43c841e9d689ed81adda988d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 29 Aug 2011 14:56:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feff8fa0075bdfd43c841e9d689ed81adda988d6
Gitweb:     http://git.kernel.org/tip/feff8fa0075bdfd43c841e9d689ed81adda988d6
Author:     WANG Cong <amwang@redhat.com>
AuthorDate: Thu, 18 Aug 2011 20:36:57 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Aug 2011 12:27:01 +0200

sched: Fix a memory leak in __sdt_free()

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@kernel.org # 3.0
Link: http://lkml.kernel.org/r/1313671017-4112-1-git-send-email-amwang@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 511732c..c79e7c6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7453,6 +7453,7 @@ static void __sdt_free(const struct cpumask *cpu_map)
 			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
 			if (sd && (sd->flags & SD_OVERLAP))
 				free_sched_groups(sd->groups, 0);
+			kfree(*per_cpu_ptr(sdd->sd, j));
 			kfree(*per_cpu_ptr(sdd->sg, j));
 			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
