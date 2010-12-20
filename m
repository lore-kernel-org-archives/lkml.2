Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab0LTP1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:27:39 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:42508 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab0LTPYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iPyKPfwZPQdUb5CtgcHZM3Ny3OGt9FRo7TbWHxewxnU7FrvxDB9vXzvS1Zzvf3/OKD
         psfwULllT4T+ad/pQunOhftgkEu9qhn7Pn9UZJOSL6q/kzrdFkvIdDWOVhebB7ezRVeq
         fLChVp3LJDL9aoXTVgsNMIYCTxK05fcQ9BAFY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 02/15] nohz_task: Avoid nohz task cpu as non-idle timer target
Date: Mon, 20 Dec 2010 16:24:09 +0100
Message-Id: <1292858662-5650-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbound timers are preferably targeted for non idle cpu. If
possible though, prioritize idle cpus over nohz task cpus,
because the main point of nohz task is to avoid unnecessary
timer interrupts.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/sched.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..2cd6823 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1209,16 +1209,29 @@ static void resched_cpu(int cpu)
 int get_nohz_timer_target(void)
 {
 	int cpu = smp_processor_id();
+	int fallback = -1;
 	int i;
 	struct sched_domain *sd;
 
 	for_each_domain(cpu, sd) {
-		for_each_cpu(i, sched_domain_span(sd))
+		for_each_cpu(i, sched_domain_span(sd)) {
+			if (cpu_has_nohz_task(i))
+				continue;
+
 			if (!idle_cpu(i))
 				return i;
+
+			if (fallback == -1 || i == cpu)
+				fallback = i;
+		}
 	}
-	return cpu;
+
+	if (fallback == -1)
+		fallback = cpu;
+
+	return fallback;
 }
+
 /*
  * When add_timer_on() enqueues a timer into the timer wheel of an
  * idle CPU then this timer might expire before the next timer event
-- 
1.7.3.2

