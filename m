Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2FFPMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:12:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2FFPMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:12:13 -0400
Date: Wed, 6 Jun 2012 08:11:48 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-8d65fee35e63f11f18b658df7c655f674c4bc660@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120529192928.GE8057@redhat.com>
References: <20120529192928.GE8057@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Change register_for_each_vma()
  to take mm-%3Emmap_sem for writing
Git-Commit-ID: 8d65fee35e63f11f18b658df7c655f674c4bc660
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:11:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d65fee35e63f11f18b658df7c655f674c4bc660
Gitweb:     http://git.kernel.org/tip/8d65fee35e63f11f18b658df7c655f674c4bc660
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 29 May 2012 21:29:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:30:56 +0200

uprobes: Change register_for_each_vma() to take mm-%3Emmap_sem for writing

Change register_for_each_vma() to take mm->mmap_sem for writing.
This is a bit unfortunate but hopefully not too bad, this is the
slow path anyway.

This is needed to ensure that find_active_uprobe() can not race
with uprobe_register() which adds the new bp at the same
bp_vaddr, after find_uprobe() fails and before
is_swbp_at_addr_fast() checks the memory.

IOW, this is needed to ensure that if find_active_uprobe()
returns NULL but is_swbp == true, we can safely assume that it
was the "normal" int3 and we should send SIGTRAP.

There is another reason for this change. We are going to replace
uprobes_state->count with MMF_ flags set by register/unregister
and cleared by find_active_uprobe(), and set/clear shouldn't
race with each other.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120529192928.GE8057@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
