Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2BGGu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:50:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab2BGGuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:50:25 -0500
Date: Tue, 7 Feb 2012 10:50:22 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] powerpc/mm: Fix possible race on task->mm
Message-ID: <20120207065022.GD1496@oksana.dev.rtsoft.ru>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for task->mm is dangerous as ->mm might disappear (exit_mm()
assigns NULL under task_lock(), so tasklist lock is not enough).

We can't use get_task_mm()/mmput() pair as mmput() might sleep,
so let's take the task lock while we care about its mm.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/powerpc/mm/mmu_context_nohash.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/mm/mmu_context_nohash.c b/arch/powerpc/mm/mmu_context_nohash.c
index 5b63bd3..13ec484 100644
--- a/arch/powerpc/mm/mmu_context_nohash.c
+++ b/arch/powerpc/mm/mmu_context_nohash.c
@@ -43,6 +43,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/bootmem.h>
 #include <linux/notifier.h>
@@ -360,8 +361,10 @@ static int __cpuinit mmu_context_cpu_notify(struct notifier_block *self,
 		/* We also clear the cpu_vm_mask bits of CPUs going away */
 		read_lock(&tasklist_lock);
 		for_each_process(p) {
+			task_lock(p);
 			if (p->mm)
 				cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
+			task_unlock(p);
 		}
 		read_unlock(&tasklist_lock);
 	break;
-- 
1.7.7.6

