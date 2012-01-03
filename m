Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2ACWiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab2ACWiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:35 2012
Message-Id: <20120103223035.028831573@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [44/67] sparc64: Patch sun4v code sequences properly on module load.
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 0b64120cceb86e93cb1bda0dc055f13016646907 ]

Some of the sun4v code patching occurs in inline functions visible
to, and usable by, modules.

Therefore we have to patch them up during module load.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/entry.h    |    7 ++++++
 arch/sparc/kernel/module.c   |   27 ++++++++++++++++++++++++
 arch/sparc/kernel/setup_64.c |   48 +++++++++++++++++++++++++------------------
 3 files changed, 63 insertions(+), 19 deletions(-)

--- a/arch/sparc/kernel/entry.h
+++ b/arch/sparc/kernel/entry.h
@@ -42,6 +42,9 @@ extern void fpsave(unsigned long *fpregs
 extern void fpload(unsigned long *fpregs, unsigned long *fsr);
 
 #else /* CONFIG_SPARC32 */
+
+#include <asm/trap_block.h>
+
 struct popc_3insn_patch_entry {
 	unsigned int	addr;
 	unsigned int	insns[3];
@@ -57,6 +60,10 @@ extern struct popc_6insn_patch_entry __p
 	__popc_6insn_patch_end;
 
 extern void __init per_cpu_patch(void);
+extern void sun4v_patch_1insn_range(struct sun4v_1insn_patch_entry *,
+				    struct sun4v_1insn_patch_entry *);
+extern void sun4v_patch_2insn_range(struct sun4v_2insn_patch_entry *,
+				    struct sun4v_2insn_patch_entry *);
 extern void __init sun4v_patch(void);
 extern void __init boot_cpu_id_too_large(int cpu);
 extern unsigned int dcache_parity_tl1_occurred;
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -17,6 +17,8 @@
 #include <asm/processor.h>
 #include <asm/spitfire.h>
 
+#include "entry.h"
+
 #ifdef CONFIG_SPARC64
 
 #include <linux/jump_label.h>
@@ -220,6 +222,29 @@ int apply_relocate_add(Elf_Shdr *sechdrs
 }
 
 #ifdef CONFIG_SPARC64
+static void do_patch_sections(const Elf_Ehdr *hdr,
+			      const Elf_Shdr *sechdrs)
+{
+	const Elf_Shdr *s, *sun4v_1insn = NULL, *sun4v_2insn = NULL;
+	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
+		if (!strcmp(".sun4v_1insn_patch", secstrings + s->sh_name))
+			sun4v_1insn = s;
+		if (!strcmp(".sun4v_2insn_patch", secstrings + s->sh_name))
+			sun4v_2insn = s;
+	}
+
+	if (sun4v_1insn && tlb_type == hypervisor) {
+		void *p = (void *) sun4v_1insn->sh_addr;
+		sun4v_patch_1insn_range(p, p + sun4v_1insn->sh_size);
+	}
+	if (sun4v_2insn && tlb_type == hypervisor) {
+		void *p = (void *) sun4v_2insn->sh_addr;
+		sun4v_patch_2insn_range(p, p + sun4v_2insn->sh_size);
+	}
+}
+
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
@@ -227,6 +252,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 	/* make jump label nops */
 	jump_label_apply_nops(me);
 
+	do_patch_sections(hdr, sechdrs);
+
 	/* Cheetah's I-cache is fully coherent.  */
 	if (tlb_type == spitfire) {
 		unsigned long va;
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -234,40 +234,50 @@ void __init per_cpu_patch(void)
 	}
 }
 
-void __init sun4v_patch(void)
+void sun4v_patch_1insn_range(struct sun4v_1insn_patch_entry *start,
+			     struct sun4v_1insn_patch_entry *end)
 {
-	extern void sun4v_hvapi_init(void);
-	struct sun4v_1insn_patch_entry *p1;
-	struct sun4v_2insn_patch_entry *p2;
-
-	if (tlb_type != hypervisor)
-		return;
+	while (start < end) {
+		unsigned long addr = start->addr;
 
-	p1 = &__sun4v_1insn_patch;
-	while (p1 < &__sun4v_1insn_patch_end) {
-		unsigned long addr = p1->addr;
-
-		*(unsigned int *) (addr +  0) = p1->insn;
+		*(unsigned int *) (addr +  0) = start->insn;
 		wmb();
 		__asm__ __volatile__("flush	%0" : : "r" (addr +  0));
 
-		p1++;
+		start++;
 	}
+}
 
-	p2 = &__sun4v_2insn_patch;
-	while (p2 < &__sun4v_2insn_patch_end) {
-		unsigned long addr = p2->addr;
+void sun4v_patch_2insn_range(struct sun4v_2insn_patch_entry *start,
+			     struct sun4v_2insn_patch_entry *end)
+{
+	while (start < end) {
+		unsigned long addr = start->addr;
 
-		*(unsigned int *) (addr +  0) = p2->insns[0];
+		*(unsigned int *) (addr +  0) = start->insns[0];
 		wmb();
 		__asm__ __volatile__("flush	%0" : : "r" (addr +  0));
 
-		*(unsigned int *) (addr +  4) = p2->insns[1];
+		*(unsigned int *) (addr +  4) = start->insns[1];
 		wmb();
 		__asm__ __volatile__("flush	%0" : : "r" (addr +  4));
 
-		p2++;
+		start++;
 	}
+}
+
+void __init sun4v_patch(void)
+{
+	extern void sun4v_hvapi_init(void);
+
+	if (tlb_type != hypervisor)
+		return;
+
+	sun4v_patch_1insn_range(&__sun4v_1insn_patch,
+				&__sun4v_1insn_patch_end);
+
+	sun4v_patch_2insn_range(&__sun4v_2insn_patch,
+				&__sun4v_2insn_patch_end);
 
 	sun4v_hvapi_init();
 }


