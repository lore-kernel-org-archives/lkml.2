Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1BBA6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:58:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab1BBAoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505141"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: heiko.carstens@de.ibm.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        ak@linux.intel.com, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [77/139] printk: Fix wake_up_klogd() vs cpu hotplug
Message-Id: <20110202004434.5D1BA3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 49f4138346b3cec2706adff02658fe27ceb1e46f upstream.

wake_up_klogd() may get called from preemptible context but uses
__raw_get_cpu_var() to write to a per cpu variable. If it gets preempted
between getting the address and writing to it, the cpu in question could be
offline if the process gets scheduled back and hence writes to the per cpu data
of an offline cpu.

This buggy behaviour was introduced with fa33507a "printk: robustify
printk, fix #2" which was supposed to fix a "using smp_processor_id() in
preemptible" warning.

Let's use this_cpu_write() instead which disables preemption and makes sure
that the outlined scenario cannot happen.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20101126124247.GC7023@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/printk.c
===================================================================
--- linux-2.6.35.y.orig/kernel/printk.c
+++ linux-2.6.35.y/kernel/printk.c
@@ -1042,7 +1042,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		__raw_get_cpu_var(printk_pending) = 1;
+		this_cpu_write(printk_pending, 1);
 }
 
 /**
