Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0IENG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:06:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:53184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0IENGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:06:25 -0400
Date: Sun, 5 Sep 2010 13:06:02 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100827092006.GB5348@loge.amd.com>
References: <20100827092006.GB5348@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mcheck: Avoid duplicate sysfs links/files for thresholding banks
Message-ID: <tip-1389298f7d14f179c2fa4b4b343079bd56082c70@git.kernel.org>
Git-Commit-ID: 1389298f7d14f179c2fa4b4b343079bd56082c70
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 13:06:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1389298f7d14f179c2fa4b4b343079bd56082c70
Gitweb:     http://git.kernel.org/tip/1389298f7d14f179c2fa4b4b343079bd56082c70
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 27 Aug 2010 11:20:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Sep 2010 14:35:49 +0200

x86, mcheck: Avoid duplicate sysfs links/files for thresholding banks

kobject_add_internal failed for threshold_bank2 with -EEXIST,
don't try to register things with the same name in the same
directory:

  Pid: 1, comm: swapper Tainted: G        W  2.6.31 #1
  Call Trace:
  [<ffffffff81161b07>] ? kobject_add_internal+0x156/0x180
  [<ffffffff81161cc0>] ? kobject_add+0x66/0x6b
  [<ffffffff81161793>] ? kobject_init+0x42/0x82
  [<ffffffff81161cf9>] ? kobject_create_and_add+0x34/0x63
  [<ffffffff81393963>] ? threshold_create_bank+0x14f/0x259
  [<ffffffff8139310a>] ? mce_create_device+0x8d/0x1b8
  [<ffffffff81646497>] ? threshold_init_device+0x3f/0x80
  [<ffffffff81646458>] ? threshold_init_device+0x0/0x80
  [<ffffffff81009050>] ? do_one_initcall+0x4f/0x143
  [<ffffffff816413a0>] ? kernel_init+0x14c/0x1a2
  [<ffffffff8100c8da>] ? child_rip+0xa/0x20
  [<ffffffff81641254>] ? kernel_init+0x0/0x1a2
  [<ffffffff8100c8d0>] ? child_rip+0x0/0x20
  kobject_create_and_add: kobject_add error: -17

(Probably the for_each_cpu loop should be entirely removed.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100827092006.GB5348@loge.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 224392d..5e97529 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -530,7 +530,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		err = -ENOMEM;
 		goto out;
 	}
-	if (!alloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
 		kfree(b);
 		err = -ENOMEM;
 		goto out;
@@ -543,7 +543,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #ifndef CONFIG_SMP
 	cpumask_setall(b->cpus);
 #else
-	cpumask_copy(b->cpus, c->llc_shared_map);
+	cpumask_set_cpu(cpu, b->cpus);
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
