Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2JNTXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:23:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2JNTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:23:49 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 7/9] uprobes: add arch write opcode hook
Date: Sun, 14 Oct 2012 21:23:11 +0200
Message-Id: <1350242593-17761-7-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350242593-17761-1-git-send-email-rabin@rab.in>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow arches to write the opcode with a custom function.  ARM needs to
customize the swbp instruction depending on the condition code of the
instruction it replaces.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/uprobes.h |    3 +++
 kernel/events/uprobes.c |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index c3dc5de..35b9490 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -131,6 +131,9 @@ extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs)
 extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void __weak arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr);
 extern int __weak arch_uprobes_init(void);
+extern void __weak arch_uprobe_write_opcode(struct arch_uprobe *auprobe,
+					    void *vaddr,
+					    uprobe_opcode_t opcode);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 8c52f93..95ea618 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -203,6 +203,12 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
  * have fixed length instructions.
  */
 
+void __weak arch_uprobe_write_opcode(struct arch_uprobe *auprobe, void *vaddr,
+				     uprobe_opcode_t opcode)
+{
+	memcpy(vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
+}
+
 /*
  * write_opcode - write the opcode at a given virtual address.
  * @auprobe: arch breakpointing information.
@@ -242,7 +248,7 @@ retry:
 	vaddr_new = kmap_atomic(new_page);
 
 	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
-	memcpy(vaddr_new + (vaddr & ~PAGE_MASK), &opcode, UPROBE_SWBP_INSN_SIZE);
+	arch_uprobe_write_opcode(auprobe, vaddr_new + (vaddr & ~PAGE_MASK), opcode);
 
 	kunmap_atomic(vaddr_new);
 	kunmap_atomic(vaddr_old);
-- 
1.7.9.5

