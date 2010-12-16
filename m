Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0LPKDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:03:15 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39509 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0LPKDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:03:13 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:30:35 +0530
Message-Id: <20101216100035.23751.82055.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 17/20] 17: uprobes: filter chain
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
index 93a3118..b0d323c 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -429,6 +429,24 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
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
