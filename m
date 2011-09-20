Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1ITMQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:16:33 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34734 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab1ITMQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:16:30 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 Sep 2011 17:32:55 +0530
Message-Id: <20110920120255.25326.50394.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v5 3.1.0-rc4-tip 14/26]   uprobe: register exception notifier
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the notifier mechanism to register uprobes exception notifier.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 8b6654e..083c577 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -30,6 +30,7 @@
 #include <linux/mmu_notifier.h>	/* set_pte_at_notify */
 #include <linux/swap.h>		/* try_to_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
+#include <linux/kdebug.h>	/* notifier mechanism */
 #include <linux/uprobes.h>
 
 static struct rb_root uprobes_tree = RB_ROOT;
@@ -1209,3 +1210,20 @@ int uprobe_post_notifier(struct pt_regs *regs)
 	set_thread_flag(TIF_UPROBE);
 	return 1;
 }
+
+struct notifier_block uprobe_exception_nb = {
+	.notifier_call = uprobe_exception_notify,
+	.priority = INT_MAX - 1,	/* notified after kprobes, kgdb */
+};
+
+static int __init init_uprobes(void)
+{
+	return register_die_notifier(&uprobe_exception_nb);
+}
+
+static void __exit exit_uprobes(void)
+{
+}
+
+module_init(init_uprobes);
+module_exit(exit_uprobes);
