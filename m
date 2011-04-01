Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab1DAOpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:45:35 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54197 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab1DAOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:45:32 -0400
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
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 01 Apr 2011 20:05:48 +0530
Message-Id: <20110401143548.15455.81188.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 2.6.39-rc1-tip 17/26] 17: uprobes: register a notifier for uprobes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Uprobe needs to be intimated on int3 and singlestep exceptions.
Hence uprobes registers a die notifier so that its notified of the events.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index e0ff6ba..cdd52d0 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -33,6 +33,7 @@
 #include <linux/rmap.h> /* needed for anon_vma_prepare */
 #include <linux/mman.h>	/* needed for PROT_EXEC, MAP_PRIVATE */
 #include <linux/file.h> /* needed for fput() */
+#include <linux/kdebug.h> /* needed for notifier mechanism */
 
 #define UINSNS_PER_PAGE	(PAGE_SIZE/UPROBES_XOL_SLOT_BYTES)
 #define MAX_UPROBES_XOL_SLOTS UINSNS_PER_PAGE
@@ -1387,3 +1388,20 @@ int uprobe_post_notifier(struct pt_regs *regs)
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
+	return register_die_notifier(&uprobes_exception_nb);
+}
+
+static void __exit exit_uprobes(void)
+{
+}
+
+module_init(init_uprobes);
+module_exit(exit_uprobes);
