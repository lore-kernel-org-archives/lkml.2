Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0LTPYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:24:53 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63472 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab0LTPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uRDmocZAQ+hnbR0AtSKk143Pu4Nx09EDrlHDFatLmx+UCDoPJ7xOwmIfLuWr5Jqgiw
         APL5+KRs8hvP016WFUeyoMlt8j2q2DMrjmbqPKSxF/ltO1hvE53DjwgEnStQPtswJhZ3
         fADCxRo8nzszKEqeN/WjZsnuXzhjPEGjgwkVU=
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
Subject: [RFC PATCH 08/15] smp: Don't warn if irq are disabled but we don't wait for the ipi
Date: Mon, 20 Dec 2010 16:24:15 +0100
Message-Id: <1292858662-5650-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment in smp_call_function_single() says it wants the irqs
to be enabled otherwise it may deadlock.

I can't find the reason for that though, except if we had to wait
for a self triggered IPI but we execute the local IPI by just
calling the function in place.

In doubt, only suppress the warning if we are not waiting for the
IPI to complete as it should really not raise any deadlock.

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
 kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 12ed8b0..886a406 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -289,7 +289,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
+	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
 		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
-- 
1.7.3.2

