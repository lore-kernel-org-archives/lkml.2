Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1K2SaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:30:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1K2SaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:30:15 -0500
Date: Tue, 29 Nov 2011 19:24:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 3/5] uprobes: introduce uprobe_xol_slots[NR_CPUS]
Message-ID: <20111129182442.GA7339@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com> <20111128190614.GA4602@redhat.com> <20111128190714.GD4602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128190714.GD4602@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Oleg Nesterov wrote:
>
> This patch adds uprobe_xol_slots[UPROBES_XOL_SLOT_BYTES][NR_CPUS] array.

Typo, it should be uprobe_xol_slots[NR_CPUS][UPROBES_XOL_SLOT_BYTES].


-------------------------------------------------------------------------
[PATCH 3/5] uprobes: introduce uprobe_xol_slots[NR_CPUS]

This patch adds uprobe_xol_slots[UPROBES_XOL_SLOT_BYTES][NR_CPUS] array.
Each CPU has its own slot for xol (used in the next patch).

We "export" this data to the user-space via set_fixmap(PAGE_KERNEL_VSYSCALL).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/fixmap.h |    9 +++++++++
 arch/x86/kernel/uprobes.c     |   10 ++++++++++
 include/linux/uprobes.h       |    1 +
 kernel/uprobes.c              |    4 ++++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 460c74e..a902e19 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -81,6 +81,15 @@ enum fixed_addresses {
 	VVAR_PAGE,
 	VSYSCALL_HPET,
 #endif
+
+#ifdef CONFIG_UPROBES
+	#define UPROBES_XOL_SLOT_BYTES  128
+
+	UPROBE_XOL_LAST_PAGE,
+	UPROBE_XOL_FIRST_PAGE = UPROBE_XOL_LAST_PAGE
+			      + NR_CPUS * UPROBES_XOL_SLOT_BYTES / PAGE_SIZE,
+#endif
+
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 4140137..ebb280c 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -664,3 +664,13 @@ bool can_skip_xol(struct pt_regs *regs, struct uprobe *u)
 	u->flags &= ~UPROBES_SKIP_SSTEP;
 	return false;
 }
+
+void __init map_uprobe_xol_slots(void *pages)
+{
+	int idx = UPROBE_XOL_FIRST_PAGE;
+
+	do {
+		__set_fixmap(idx, __pa(pages), PAGE_KERNEL_VSYSCALL);
+		pages += PAGE_SIZE;
+	} while (idx-- != UPROBE_XOL_LAST_PAGE);
+}
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index d590d66..bb59a66 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -142,6 +142,7 @@ extern bool uprobe_deny_signal(void);
 extern bool __weak can_skip_xol(struct pt_regs *regs, struct uprobe *u);
 extern void __weak set_xol_ip(struct pt_regs *regs);
 extern void uprobe_switch_to(struct task_struct *);
+extern void map_uprobe_xol_slots(void *);
 #else /* CONFIG_UPROBES is not defined */
 static inline int register_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer)
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 9c509dc..20007da 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1342,6 +1342,9 @@ bool __weak can_skip_xol(struct pt_regs *regs, struct uprobe *u)
 	return false;
 }
 
+static unsigned char
+uprobe_xol_slots[NR_CPUS][UPROBES_XOL_SLOT_BYTES] __page_aligned_bss;
+
 void __weak set_xol_ip(struct pt_regs *regs)
 {
 	set_instruction_pointer(regs, current->utask->xol_vaddr);
@@ -1490,6 +1493,7 @@ static int __init init_uprobes(void)
 		mutex_init(&uprobes_mmap_mutex[i]);
 	}
 	init_bulkref(&uprobes_srcu);
+	map_uprobe_xol_slots(uprobe_xol_slots);
 	return register_die_notifier(&uprobe_exception_nb);
 }
 
-- 
1.5.5.1


