Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1DSATp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:19:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38117 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1DSATn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:19:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] mm: convert mm->cpu_vm_cpumask into cpumask_var_t
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <20110418211950.9365.A69D9226@jp.fujitsu.com>
References: <20110418211455.9359.A69D9226@jp.fujitsu.com> <20110418211950.9365.A69D9226@jp.fujitsu.com>
Message-Id: <20110419091947.936D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 19 Apr 2011 09:19:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  Documentation/cachetlb.txt |    2 +-
>  include/linux/mm_types.h   |    9 ++++++---
>  include/linux/sched.h      |    1 +
>  init/main.c                |    2 ++
>  kernel/fork.c              |   37 ++++++++++++++++++++++++++++++++++---
>  mm/init-mm.c               |    1 -
>  6 files changed, 44 insertions(+), 8 deletions(-)
> 
> This patch don't touch x86/kerrnel/tboot.c. because it can't be compiled.

My bad. I confounded CONFIG_HAVE_INTEL_TXT with CONFIG_INTEL_TXT. Proper
fixing (and incremental) patch is here.



>From 0b443d8dbdf7ce97f92e6622840585ca41abca83 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 19 Apr 2011 08:38:01 +0900
Subject: [PATCH 4/4] fix tboot

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/x86/kernel/tboot.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 998e972..0f0d1a3 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -110,7 +110,6 @@ static struct mm_struct tboot_mm = {
 	.mmap_sem       = __RWSEM_INITIALIZER(init_mm.mmap_sem),
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist         = LIST_HEAD_INIT(init_mm.mmlist),
-	.cpu_vm_mask    = CPU_MASK_ALL,
 };
 
 static inline void switch_to_tboot_pt(void)
@@ -337,9 +336,18 @@ static struct notifier_block tboot_cpu_notifier __cpuinitdata =
 
 static __init int tboot_late_init(void)
 {
+	int ret;
+
 	if (!tboot_enabled())
 		return 0;
 
+	ret = mm_init_cpumask(&tboot_mm, 0);
+	if (ret) {
+		pr_warning("tboot: Allocation failure, disable tboot.\n");
+		tboot = NULL;
+		return ret;
+	}
+
 	tboot_create_trampoline();
 
 	atomic_set(&ap_wfs_count, 0);
-- 
1.7.3.1




