Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1KRLfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:35:39 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52466 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1KRLfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:35:34 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Fri, 18 Nov 2011 16:39:23 +0530
Message-Id: <20111118110923.10512.69644.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 14/30] uprobe: register exception notifier
x-cbid: 11111811-8878-0000-0000-000000446C43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the notifier mechanism to register uprobes exception notifier.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 9789b65..b9e1932 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -30,6 +30,7 @@
 #include <linux/mmu_notifier.h>	/* set_pte_at_notify */
 #include <linux/swap.h>		/* try_to_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
+#include <linux/kdebug.h>	/* notifier mechanism */
 #include <linux/uprobes.h>
 
 static bulkref_t uprobes_srcu;
@@ -1229,6 +1230,11 @@ int uprobe_post_notifier(struct pt_regs *regs)
 	return 1;
 }
 
+struct notifier_block uprobe_exception_nb = {
+	.notifier_call = uprobe_exception_notify,
+	.priority = INT_MAX - 1,	/* notified after kprobes, kgdb */
+};
+
 static int __init init_uprobes(void)
 {
 	int i;
@@ -1238,7 +1244,7 @@ static int __init init_uprobes(void)
 		mutex_init(&uprobes_mmap_mutex[i]);
 	}
 	init_bulkref(&uprobes_srcu);
-	return 0;
+	return register_die_notifier(&uprobe_exception_nb);
 }
 
 static void __exit exit_uprobes(void)

