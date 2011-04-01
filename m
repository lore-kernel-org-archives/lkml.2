Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1DAOrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:47:25 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42085 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab1DAOrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:47:21 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 01 Apr 2011 20:07:37 +0530
Message-Id: <20110401143737.15455.30181.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 2.6.39-rc1-tip 26/26] 26: uprobes: filter chain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Loops through the filters callbacks of currently registered
consumers to see if any consumer is interested in tracing this task.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index c950f13..62ccb56 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -450,6 +450,23 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	up_read(&uprobe->consumer_rwsem);
 }
 
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
 static void add_consumer(struct uprobe *uprobe,
 				struct uprobe_consumer *consumer)
 {
