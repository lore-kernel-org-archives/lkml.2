Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1CNNnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:43:11 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46608 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab1CNNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:43:07 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:07:22 +0530
Message-Id: <20110314133722.27435.55663.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 17/20] 17: uprobes: filter chain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Loops through the filters callbacks of currently registered
consumers to see if any consumer is interested in tracing this task.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index bbedcef..e3a3051 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -428,6 +428,24 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 }
 
 /* Acquires uprobe->consumer_rwsem */
+static bool filter_chain(struct uprobe *uprobe, struct task_struct *t)
+{
+	struct uprobe_consumer *consumer;
+	bool ret = false;
+
+	down_read(&uprobe->consumer_rwsem);
+	for (consumer = uprobe->consumers; consumer;
+					consumer = consumer->next) {
+		if (!consumer->filter || consumer->filter(consumer, t)) {
+			ret = true;
+			break;
+		}
+	}
+	up_read(&uprobe->consumer_rwsem);
+	return ret;
+}
+
+/* Acquires uprobe->consumer_rwsem */
 static void add_consumer(struct uprobe *uprobe,
 				struct uprobe_consumer *consumer)
 {
