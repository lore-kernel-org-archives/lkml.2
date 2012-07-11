Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370Ab2GKWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:06:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:35504 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030288Ab2GKWFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:05:20 -0400
Message-Id: <20120711215611.943318314@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 11 Jul 2012 22:05:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>
Subject: [patch RT 4/7] Latency histograms: Detect another yet overlooked
 sharedprio condition
References: <20120711214552.036760674@linutronix.de>
Content-Disposition: inline;
 filename=latency-histograms-detect-another-yet-overlooked-sharedprio-condition.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While waiting for an RT process to be woken up, the previous process may
go to wait and switch to another one with the same priority which then
becomes current. This condition was not correctly recognized and led to
erroneously high latency recordings during periods of low CPU load.

This patch correctly marks such latencies as sharedprio and prevents
them from being recorded as actual system latency. 

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/trace/latency_hist.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-3.4.2-rt10-64+/kernel/trace/latency_hist.c
===================================================================
--- linux-3.4.2-rt10-64+.orig/kernel/trace/latency_hist.c
+++ linux-3.4.2-rt10-64+/kernel/trace/latency_hist.c
@@ -935,6 +935,9 @@ static notrace void probe_wakeup_latency
 		goto out;
 	}
 
+	if (current->prio == cpu_wakeup_task->prio)
+		per_cpu(wakeup_sharedprio, cpu) = 1;
+
 	/*
 	 * The task we are waiting for is about to be switched to.
 	 * Calculate latency and store it in histogram.





