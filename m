Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2DPDiE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:38:04 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48420 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2DPDiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:38:01 -0400
Message-ID: <4F8B9411.8090600@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:37:53 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [RFC PATCH 2/4] linsched: add check on invoke "tick_nohz_irq_exit"
 in "irq_exit"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-5816-0000-0000-000002260140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

"tick_nohz_irq_exit" will make sure the tick timer reprogram correctly
after cpu enter idle.

With out this check, after the interrupt, tick timer will be enabled
even cpu is still in idle, this will cause inaccuracy if cpu do load
balance in next tick.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 arch/linsched/kernel/irq.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/linsched/kernel/irq.c b/arch/linsched/kernel/irq.c
index a800bbd..d5d16e5 100644
--- a/arch/linsched/kernel/irq.c
+++ b/arch/linsched/kernel/irq.c
@@ -1,6 +1,7 @@
 #include <linux/interrupt.h>
 #include <asm/hardirq.h>
 #include <linux/sched.h>
+#include <linux/tick.h>

 unsigned long linsched_irq_flags = ARCH_IRQ_ENABLED;

@@ -81,6 +82,9 @@ void irq_exit(void)
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		do_softirq();
+
+	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+		tick_nohz_irq_exit();
 }

 void local_bh_enable_ip(unsigned long ip)
-- 
1.7.1

