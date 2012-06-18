Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2FRI7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:59:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2FRI7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:59:09 -0400
Date: Mon, 18 Jun 2012 01:58:49 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-d9c4a30e82614d43b55893a73f31e7284007ce82@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154350.GA9611@redhat.com>
References: <20120615154350.GA9611@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Move BUG_ON(UPROBE_SWBP_INSN_SIZE)
  from write_opcode() to install_breakpoint()
Git-Commit-ID: d9c4a30e82614d43b55893a73f31e7284007ce82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:58:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9c4a30e82614d43b55893a73f31e7284007ce82
Gitweb:     http://git.kernel.org/tip/d9c4a30e82614d43b55893a73f31e7284007ce82
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:47 +0200

uprobes: Move BUG_ON(UPROBE_SWBP_INSN_SIZE) from write_opcode() to install_breakpoint()

write_opcode() ensures that UPROBE_SWBP_INSN doesn't cross the
page boundary. This looks a bit confusing, the check does not
depend on vaddr and it is enough to do it only once right after
install_breakpoint()->arch_uprobe_analyze_insn().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154350.GA9611@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 14c71a2..b9c61bd 100644
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
@@ -699,6 +694,10 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		if (ret)
 			return ret;
 
+		/* write_opcode() assumes we don't cross page boundary */
+		BUG_ON((uprobe->offset & ~PAGE_MASK) +
+				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
+
 		uprobe->flags |= UPROBE_COPY_INSN;
 	}
 
