Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1LLD27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:28:59 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:4569
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab1LLD2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:39 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Steven Miao <realmz6@gmail.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 07/11] blackfin: smp: fix msg queue overflow issue
Date: Mon, 12 Dec 2011 11:28:29 +0800
Message-ID: <1323660513-9620-7-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

disable preemption when icache flush and use wait mode cross call, hold the msg
queue lock while handle cross function call to avoid overflow

Signed-off-by: Steven Miao <realmz6@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/mach-common/smp.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index d346405..ac8f8a4 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -193,14 +193,10 @@ static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
 			scheduler_ipi();
 			break;
 		case BFIN_IPI_CALL_FUNC:
-			spin_unlock_irqrestore(&msg_queue->lock, flags);
 			ipi_call_function(cpu, msg);
-			spin_lock_irqsave(&msg_queue->lock, flags);
 			break;
 		case BFIN_IPI_CPU_STOP:
-			spin_unlock_irqrestore(&msg_queue->lock, flags);
 			ipi_cpu_stop(cpu);
-			spin_lock_irqsave(&msg_queue->lock, flags);
 			break;
 		default:
 			printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%lx\n",
@@ -482,8 +478,10 @@ void smp_icache_flush_range_others(unsigned long start, unsigned long end)
 	smp_flush_data.start = start;
 	smp_flush_data.end = end;
 
-	if (smp_call_function(&ipi_flush_icache, &smp_flush_data, 0))
+	preempt_disable();
+	if (smp_call_function(&ipi_flush_icache, &smp_flush_data, 1))
 		printk(KERN_WARNING "SMP: failed to run I-cache flush request on other CPUs\n");
+	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(smp_icache_flush_range_others);
 
-- 
1.7.0.4


