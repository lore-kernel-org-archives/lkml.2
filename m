Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2FMSwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab2FMSwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:52:54 -0400
Date: Wed, 13 Jun 2012 20:50:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] uprobes: move BUG_ON(UPROBE_SWBP_INSN_SIZE) from
	write_opcode() to install_breakpoint()
Message-ID: <20120613185047.GD13878@redhat.com>
References: <20120613184933.GA13870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613184933.GA13870@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_opcode() ensures that UPROBE_SWBP_INSN doesn't cross the
page boundary. This looks a bit confusing, the check does not
depend on vaddr and it is enough to do it only once right after
install_breakpoint()->arch_uprobe_analyze_insn().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 799d6ed..a4dc9fa 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -210,7 +210,6 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	void *vaddr_old, *vaddr_new;
 	struct vm_area_struct *vma;
 	struct uprobe *uprobe;
-	unsigned long pgoff;
 	int ret;
 retry:
 	/* Read the page with vaddr into memory */
@@ -251,11 +250,7 @@ retry:
 	vaddr_new = kmap_atomic(new_page);
 
 	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
-
-	/* poke the new insn in, ASSUMES we don't cross page boundary */
-	pgoff = (vaddr & ~PAGE_MASK);
-	BUG_ON(pgoff + UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
-	memcpy(vaddr_new + pgoff, &opcode, UPROBE_SWBP_INSN_SIZE);
+	memcpy(vaddr_new + (vaddr & ~PAGE_MASK), &opcode, UPROBE_SWBP_INSN_SIZE);
 
 	kunmap_atomic(vaddr_new);
 	kunmap_atomic(vaddr_old);
@@ -697,6 +692,10 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		if (ret)
 			return ret;
 
+		/* write_opcode() assumes we don't cross page boundary */
+		BUG_ON((uprobe->offset & ~PAGE_MASK) +
+				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
+
 		uprobe->flags |= UPROBE_COPY_INSN;
 	}
 
-- 
1.5.5.1


