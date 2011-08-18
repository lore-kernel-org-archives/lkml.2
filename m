Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1HRNqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:46:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:64776 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1HRNqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:46:43 -0400
X-IronPort-AV: E=Sophos;i="4.68,245,1312171200"; 
   d="scan'208";a="159496802"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] signals: move trace header #include to after all others.
Date: Thu, 18 Aug 2011 14:46:38 +0100
Message-ID: <1313675198-7413-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt says:
    The trace events headers are suppose to be the last headers
    included.
and this fixes a build error when another header already includes trace stuff,
which I saw when adding a highmem.h include to skbuff.h e.g.:
In file included from include/trace/ftrace.h:296:0,
                 from include/trace/define_trace.h:96,
                 from include/trace/events/irq.h:150,
                 from include/linux/interrupt.h:23,
                 from arch/x86/include/asm/highmem.h:23,
                 from include/linux/highmem.h:33,
                 from include/linux/skbuff.h:32,
                 from kernel/audit.h:24,
                 from kernel/signal.c:38:
include/trace/events/irq.h: In function 'ftrace_raw_output_softirq':
include/trace/events/irq.h:87:1: error: 'HI_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: note: each undeclared identifier is reported only once for each function it appears in
include/trace/events/irq.h:87:1: error: 'TIMER_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'NET_TX_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'NET_RX_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'BLOCK_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'BLOCK_IOPOLL_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'TASKLET_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'SCHED_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'HRTIMER_SOFTIRQ' undeclared (first use in this function)
include/trace/events/irq.h:87:1: error: 'RCU_SOFTIRQ' undeclared (first use in this function)

See http://lkml.kernel.org/r/1313668307.5010.300.camel@zakaz.uk.xensource.com

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/signal.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..d3cd4e7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -28,8 +28,6 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
-#define CREATE_TRACE_POINTS
-#include <trace/events/signal.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -37,6 +35,9 @@
 #include <asm/siginfo.h>
 #include "audit.h"	/* audit_signal_info() */
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/signal.h>
+
 /*
  * SLAB caches for signal bits.
  */
-- 
1.7.2.5

