Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2ICD61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:58:27 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59095 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ICD6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:58:25 -0400
Message-ID: <50442ACE.9070807@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2012 11:58:06 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 2/4] linsched: add check on invoke tick_nohz_irq_exit()
 in irq_exit()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090303-1396-0000-0000-000001CF237B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

tick_nohz_irq_exit() will make sure the tick timer reprogram correctly
after cpu enter idle.

With out this check, after the interrupt, tick timer will be enabled
even cpu is still in idle, this will cause inaccuracy.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 arch/linsched/kernel/irq.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/linsched/kernel/irq.c b/arch/linsched/kernel/irq.c
index 3000d47..5f88af4 100644
--- a/arch/linsched/kernel/irq.c
+++ b/arch/linsched/kernel/irq.c
@@ -2,6 +2,7 @@
 #include <asm/hardirq.h>
 #include <linux/sched.h>
 #include <linux/irq_work.h>
+#include <linux/tick.h>

 unsigned long linsched_irq_flags = ARCH_IRQ_ENABLED;

@@ -87,6 +88,9 @@ void irq_exit(void)
        sub_preempt_count(IRQ_EXIT_OFFSET);
        if (!in_interrupt() && local_softirq_pending())
                do_softirq();
+
+       if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+               tick_nohz_irq_exit();
 }

 void local_bh_enable_ip(unsigned long ip)
--  
1.7.1

