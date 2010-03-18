Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0CRJIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:08:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60065 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0CRJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W9V5yqT3oPKLU5Rn2W3Q/x95uBGAgJrY78V6IEzWs6ebRIZQ66ba3vSQbNAI1HdP5S
         xtblV+L6Gms6/rQ1Rxgxa+o/uUx5rhM3M/rNt0nqWeBNhfO768LOCNEtS7j3NIl6+53/
         l+g0ZVLHZt5yN55igygeEqYJNQGG8NFiR0TsE=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Ursula Braun <ursula.braun@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH 08/12] iucv: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:20 +0900
Message-Id: <1268903124-10237-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for iucv.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 net/iucv/iucv.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index fd8b283..f28ad2c 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -632,13 +632,14 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 		iucv_irq_data[cpu] = kmalloc_node(sizeof(struct iucv_irq_data),
 					GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
 		if (!iucv_irq_data[cpu])
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
+
 		iucv_param[cpu] = kmalloc_node(sizeof(union iucv_param),
 				     GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
 		if (!iucv_param[cpu]) {
 			kfree(iucv_irq_data[cpu]);
 			iucv_irq_data[cpu] = NULL;
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		iucv_param_irq[cpu] = kmalloc_node(sizeof(union iucv_param),
 					GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
@@ -647,7 +648,7 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 			iucv_param[cpu] = NULL;
 			kfree(iucv_irq_data[cpu]);
 			iucv_irq_data[cpu] = NULL;
-			return NOTIFY_BAD;
+			return notifier_from_errno(-ENOMEM);
 		}
 		break;
 	case CPU_UP_CANCELED:
@@ -677,7 +678,7 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 		cpu_clear(cpu, cpumask);
 		if (cpus_empty(cpumask))
 			/* Can't offline last IUCV enabled cpu. */
-			return NOTIFY_BAD;
+			return notifier_from_errno(-EINVAL);
 		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 1);
 		if (cpus_empty(iucv_irq_cpumask))
 			smp_call_function_single(first_cpu(iucv_buffer_cpumask),
-- 
1.6.0.6

