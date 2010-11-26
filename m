Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0KZMCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:02:39 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:53162 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0KZMCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:02:37 -0500
Message-Id: <20101126120235.091835714@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 13:00:58 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 1/3] printk: fix wake_up_klogd() vs cpu hotplug
References: <20101126120057.879397696@de.ibm.com>
Content-Disposition: inline; filename=001_printk_preempt.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

wake_up_klogd() may get called from preemtible context but uses
__raw_get_cpu_var() to write to a per cpu variable. If it gets preempted between
getting the address and writing to it, the cpu in question could be offline if
the process gets scheduled back and hence writes to the per cpu data of an offline
cpu.

No idea why that behaviour was introduced with fa33507a "printk: robustify
printk, fix #2" which was supposed to fix a "using smp_processor_id() in
preemptible" warning.

Let's use get_cpu_var() instead which disables preemption and makes sure that
the outlined scenario cannot happen.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/printk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1087,8 +1087,10 @@ int printk_needs_cpu(int cpu)
 
 void wake_up_klogd(void)
 {
-	if (waitqueue_active(&log_wait))
-		__raw_get_cpu_var(printk_pending) = 1;
+	if (waitqueue_active(&log_wait)) {
+		get_cpu_var(printk_pending) = 1;
+		put_cpu_var(printk_pending);
+	}
 }
 
 /**

