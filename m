Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2GQPfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:35:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2GQPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:32:44 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=tYVNPAi_OwwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D_SbEOMbAAAA:8 a=iq8gveTgglRJqZf6-awA:9 a=7KbvKZvEaC0A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120717153243.340760961@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Jul 2012 11:31:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 04/12] Latency histograms: Detect another yet overlooked sharedprio
 condition
References: <20120717153115.606116459@goodmis.org>
Content-Disposition: inline; filename=0004-Latency-histograms-Detect-another-yet-overlooked-sha.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <C.Emde@osadl.org>

While waiting for an RT process to be woken up, the previous process may
go to wait and switch to another one with the same priority which then
becomes current. This condition was not correctly recognized and led to
erroneously high latency recordings during periods of low CPU load.

This patch correctly marks such latencies as sharedprio and prevents
them from being recorded as actual system latency.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/latency_hist.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/latency_hist.c b/kernel/trace/latency_hist.c
index d514eef..6a4c869 100644
--- a/kernel/trace/latency_hist.c
+++ b/kernel/trace/latency_hist.c
@@ -935,6 +935,9 @@ static notrace void probe_wakeup_latency_hist_stop(void *v,
 		goto out;
 	}
 
+	if (current->prio == cpu_wakeup_task->prio)
+		per_cpu(wakeup_sharedprio, cpu) = 1;
+
 	/*
 	 * The task we are waiting for is about to be switched to.
 	 * Calculate latency and store it in histogram.
-- 
1.7.10.4


