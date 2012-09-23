Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2IWUSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2IWUSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:18:02 -0400
Date: Sun, 23 Sep 2012 22:19:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] uprobes: Kill set_swbp()->is_swbp_at_addr()
Message-ID: <20120923201945.GA27446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120923201921.GA27424@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A separate patch for better documentation.

set_swbp()->is_swbp_at_addr() is not needed for correctness, it is
harmless to do the unnecessary __replace_page(old_page, new_page)
when these 2 pages are identical.

And it can not be counted as optimization. mmap/register races are
very unlikely, while in the likely case is_swbp_at_addr() adds the
extra get_user_pages() even if the caller is uprobe_mmap(current->mm)
and returns false.

Note also that the semantics/usage of is_swbp_at_addr() in uprobe.c
is confusing. set_swbp() uses it to detect the case when this insn
was already modified by uprobes, that is why it should always compare
the opcode with UPROBE_SWBP_INSN even if the hardware (like powerpc)
has other trap insns. It doesn't matter if this "int3" was in fact
installed by gdb or application itself, we are going to "steal" this
breakpoint anyway and execute the original insn from vm_file even if
it no longer matches the memory.

OTOH, handle_swbp()->find_active_uprobe() uses is_swbp_at_addr() to
figure out whether we need to send SIGTRAP or not if we can not find
uprobe, so in this case it should return true for all trap variants,
not only for UPROBE_SWBP_INSN.

This patch removes set_swbp()->is_swbp_at_addr(), the next patches
will remove it from set_orig_insn() which is similar to set_swbp()
in this respect. So the only caller will be handle_swbp() and we
can make its semantics clear.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 78364a2..04f3259 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -321,17 +321,6 @@ out:
  */
 int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	int result;
-	/*
-	 * See the comment near uprobes_hash().
-	 */
-	result = is_swbp_at_addr(mm, vaddr);
-	if (result == 1)
-		return 0;
-
-	if (result)
-		return result;
-
 	return write_opcode(auprobe, mm, vaddr, UPROBE_SWBP_INSN);
 }
 
-- 
1.5.5.1

