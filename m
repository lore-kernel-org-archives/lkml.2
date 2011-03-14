Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab1CNNmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:42:55 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53770 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab1CNNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:42:53 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:07:08 +0530
Message-Id: <20110314133708.27435.81257.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 16/20] 16: uprobes: register a notifier for uprobes.
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
index d8d4574..bbedcef 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -33,6 +33,7 @@
 #include <linux/rmap.h> /* needed for anon_vma_prepare */
 #include <linux/mman.h>	/* needed for PROT_EXEC, MAP_PRIVATE */
 #include <linux/file.h> /* needed for fput() */
+#include <linux/kdebug.h> /* needed for notifier mechanism */
 
 #define UINSNS_PER_PAGE	(PAGE_SIZE/UPROBES_XOL_SLOT_BYTES)
 #define MAX_UPROBES_XOL_SLOTS UINSNS_PER_PAGE
@@ -1242,3 +1243,21 @@ int uprobe_post_notifier(struct pt_regs *regs)
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
