Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966498Ab2EOTDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:03:30 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41836 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966449Ab2EOTDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:03:24 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RESEND PATCH 2/2] mn10300/CPU hotplug: Add missing call to
 notify_cpu_starting()
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, mingo@kernel.org, a.p.zijlstra@chello.nl,
        mpatocka@redhat.com, stepanm@codeaurora.org, tglx@linutronix.de,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-am33-list@redhat.com
Date: Wed, 16 May 2012 00:32:37 +0530
Message-ID: <20120515190228.22459.47763.stgit@srivatsabhat>
In-Reply-To: <20120515190115.22459.93544.stgit@srivatsabhat>
References: <20120515190115.22459.93544.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051508-1618-0000-0000-00000197CF33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/mn10300/kernel/smp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 910dddf..9cd69ad 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/profile.h>
 #include <linux/smp.h>
+#include <linux/cpu.h>
 #include <asm/tlbflush.h>
 #include <asm/bitops.h>
 #include <asm/processor.h>
@@ -38,7 +39,6 @@
 #include "internal.h"
 
 #ifdef CONFIG_HOTPLUG_CPU
-#include <linux/cpu.h>
 #include <asm/cacheflush.h>
 
 static unsigned long sleep_mode[NR_CPUS];
@@ -874,10 +874,13 @@ static void __init smp_online(void)
 
 	cpu = smp_processor_id();
 
-	local_irq_enable();
+	notify_cpu_starting(cpu);
 
+	ipi_call_lock();
 	set_cpu_online(cpu, true);
-	smp_wmb();
+	ipi_call_unlock();
+
+	local_irq_enable();
 }
 
 /**

