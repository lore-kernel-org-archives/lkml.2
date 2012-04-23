Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2DWHKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:10:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48179 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2DWHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:10:06 -0400
Date: Mon, 23 Apr 2012 00:08:49 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linaro-kernel@lists.linaro.org, patches@linaro.org, linux-mm@kvack.org
Subject: [PATCH 4/9] sh: Use clear_tasks_mm_cpumask()
Message-ID: <20120423070849.GD30752@lizard>
References: <20120423070641.GA27702@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120423070641.GA27702@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for process->mm is not enough because process' main
thread may exit or detach its mm via use_mm(), but other threads
may still have a valid mm.

To fix this we would need to use find_lock_task_mm(), which would
walk up all threads and returns an appropriate task (with task
lock held).

clear_tasks_mm_cpumask() has the issue fixed, so let's use it.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/sh/kernel/smp.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index eaebdf6..4664f76 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -123,7 +123,6 @@ void native_play_dead(void)
 int __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
-	struct task_struct *p;
 	int ret;
 
 	ret = mp_ops->cpu_disable(cpu);
@@ -153,11 +152,7 @@ int __cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	read_lock(&tasklist_lock);
-	for_each_process(p)
-		if (p->mm)
-			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
-	read_unlock(&tasklist_lock);
+	clear_tasks_mm_cpumask(cpu);
 
 	return 0;
 }
-- 
1.7.9.2

