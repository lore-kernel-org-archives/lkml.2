Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2FKGC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:02:59 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:53927 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FKGC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:02:57 -0400
Date: Mon, 11 Jun 2012 11:32:42 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [Patch][perf] Invoke __perf_event_disable without an IPI
Message-ID: <20120611060242.GA2538@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061106-8936-0000-0000-0000070886D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please review the following patch, the details of which are
described in the commit message below.

Basic perf commands (and memory tracing event '-e mem') were tested
to work fine with this patch and can be applied over commit
b1dab2f0409c478fd2d9e227c2c018524eca9603.

Kindly let me know if there could be a better approach or if there's a
need for further testing.

Thanks,
K.Prasad

---

While debugging a warning message on PowerPC while using hardware
breakpoints, it was discovered that when perf_event_disable is invoked
through hw_breakpoint_handler function with interrupts disabled, a
subsequent IPI in the code path would trigger a WARN_ON_ONCE message in
smp_call_function_single function.

This patch avoids the use of an IPI to invoke __perf_event_disable when
it is safe to do so i.e. when the process associated with the perf-event
would run on the current CPU and interrupts are disabled on the system.
Since interrupts are always disabled before hw_breakpoint_handler in
PowerPC, the warning message will no longer be seen.

Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/events/core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fd126f8..0e2c1eb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1302,6 +1302,7 @@ static int __perf_event_disable(void *info)
  */
 void perf_event_disable(struct perf_event *event)
 {
+	int ret;
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
@@ -1314,6 +1315,17 @@ void perf_event_disable(struct perf_event *event)
 	}
 
 retry:
+	/*
+	 * perf_event_disable may be called when interrupts are disabled.
+	 * For e.g. hw_breakpoint_handler exception in PowerPC. Hence using
+	 * IPIs to invoke __perf_event_disable is not always suitable. When
+	 * possible invoke __perf_event_disable directly.
+	 */
+	if ((task_cpu(task) == smp_processor_id()) && irqs_disabled()) {
+		ret = __perf_event_disable(event);
+		if (!ret)
+			return;
+	}
 	if (!task_function_call(task, __perf_event_disable, event))
 		return;
 

