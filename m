Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2E2Tdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab2E2TbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:31:10 -0400
Date: Tue, 29 May 2012 21:29:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] uprobes: change register_for_each_vma() to take
	mm->mmap_sem for writing
Message-ID: <20120529192928.GE8057@redhat.com>
References: <20120529192721.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529192721.GA8048@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change register_for_each_vma() to take mm->mmap_sem for writing.
This is a bit unfortunate but hopefully not too bad, this is the
slow path anyway.

This is needed to ensure that find_active_uprobe() can not race
with uprobe_register() which adds the new bp at the same bp_vaddr,
after find_uprobe() fails and before is_swbp_at_addr_fast() checks
the memory.

IOW, this is needed to ensure that if find_active_uprobe() returns
NULL but is_swbp == true, we can safely assume that it was the
"normal" int3 and we should send SIGTRAP.

There is another reason for this change. We are going to replace
uprobes_state->count with MMF_ flags set by register/unregister
and cleared by find_active_uprobe(), and set/clear shouldn't race
with each other.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ee3df70..a2ed82b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -853,12 +853,12 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		}
 
 		mm = vi->mm;
-		down_read(&mm->mmap_sem);
+		down_write(&mm->mmap_sem);
 		vma = find_vma(mm, (unsigned long)vi->vaddr);
 		if (!vma || !valid_vma(vma, is_register)) {
 			list_del(&vi->probe_list);
 			kfree(vi);
-			up_read(&mm->mmap_sem);
+			up_write(&mm->mmap_sem);
 			mmput(mm);
 			continue;
 		}
@@ -867,7 +867,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 						vaddr != vi->vaddr) {
 			list_del(&vi->probe_list);
 			kfree(vi);
-			up_read(&mm->mmap_sem);
+			up_write(&mm->mmap_sem);
 			mmput(mm);
 			continue;
 		}
@@ -877,7 +877,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		else
 			remove_breakpoint(uprobe, mm, vi->vaddr);
 
-		up_read(&mm->mmap_sem);
+		up_write(&mm->mmap_sem);
 		mmput(mm);
 		if (is_register) {
 			if (ret && ret == -EEXIST)
-- 
1.5.5.1


