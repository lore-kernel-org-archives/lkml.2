Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab1KJTFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:05:33 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35199 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab1KJTF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:05:28 -0500
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
Date: Fri, 11 Nov 2011 00:10:16 +0530
Message-Id: <20111110184016.11361.91824.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111110183725.11361.57827.sendpatchset@srdronam.in.ibm.com>
References: <20111110183725.11361.57827.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v6 3.2-rc1 14/28]   uprobe: register exception notifier
x-cbid: 11111009-5140-0000-0000-00000033D8F6
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
index 2461b20..c4ccb89 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -30,6 +30,7 @@
 #include <linux/mmu_notifier.h>	/* set_pte_at_notify */
 #include <linux/swap.h>		/* try_to_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
+#include <linux/kdebug.h>	/* notifier mechanism */
 #include <linux/uprobes.h>
 
 static bulkref_t uprobes_srcu;
@@ -1235,6 +1236,11 @@ int uprobe_post_notifier(struct pt_regs *regs)
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
@@ -1244,7 +1250,7 @@ static int __init init_uprobes(void)
 		mutex_init(&uprobes_mmap_mutex[i]);
 	}
 	init_bulkref(&uprobes_srcu);
-	return 0;
+	return register_die_notifier(&uprobe_exception_nb);
 }
 
 static void __exit exit_uprobes(void)

