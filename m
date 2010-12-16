Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0LPKDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:03:01 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48613 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0LPKC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:02:59 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:30:21 +0530
Message-Id: <20101216100021.23751.19275.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 16/20] 16: uprobes: register a notifier for uprobes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Uprobe needs to be intimated on int3 and singlestep exceptions.
Hence uprobes registers a die notifier so that its notified of the events.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 3d21d8f..93a3118 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -34,6 +34,7 @@
 #include <linux/rmap.h> /* needed for anon_vma_prepare */
 #include <linux/mman.h>	/* needed for PROT_EXEC, MAP_PRIVATE */
 #include <linux/file.h> /* needed for fput() */
+#include <linux/kdebug.h> /* needed for notifier mechanism */
 
 #define UINSNS_PER_PAGE	(PAGE_SIZE/UPROBES_XOL_SLOT_BYTES)
 #define MAX_UPROBES_XOL_SLOTS UINSNS_PER_PAGE
@@ -1170,3 +1171,21 @@ int uprobe_post_notifier(struct pt_regs *regs)
 	}
 	return 0;
 }
+
+struct notifier_block uprobes_exception_nb = {
+	.notifier_call = uprobes_exception_notify,
+	.priority = 0x7ffffff0,
+};
+
+static int __init init_uprobes(void)
+{
+	register_die_notifier(&uprobes_exception_nb);
+	return 0;
+}
+
+static void __exit exit_uprobes(void)
+{
+}
+
+module_init(init_uprobes);
+module_exit(exit_uprobes);
