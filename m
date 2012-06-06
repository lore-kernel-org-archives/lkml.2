Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2FFQGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:06:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40448 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab2FFQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:06:07 -0400
Date: Wed, 6 Jun 2012 09:05:41 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-c00b275043adc14d668f36266b890f0c53d46640@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120529192744.GA8057@redhat.com>
References: <20120529192744.GA8057@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Optimize is_swbp_at_addr() for current->
 mm
Git-Commit-ID: c00b275043adc14d668f36266b890f0c53d46640
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:05:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c00b275043adc14d668f36266b890f0c53d46640
Gitweb:     http://git.kernel.org/tip/c00b275043adc14d668f36266b890f0c53d46640
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 29 May 2012 21:27:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:13:59 +0200

uprobes: Optimize is_swbp_at_addr() for current->mm

Change is_swbp_at_addr() to try to avoid the costly
read_opcode() if mm == current->mm, __copy_from_user_inatomic()
should succeed in the likely case.

Currently this optimization is not important, but we are going
to add more is_swbp_at_addr(current->mm) callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120529192744.GA8057@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 985be4d..d0f5ec0 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -333,10 +333,20 @@ static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
 	uprobe_opcode_t opcode;
 	int result;
 
+	if (current->mm == mm) {
+		pagefault_disable();
+		result = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
+								sizeof(opcode));
+		pagefault_enable();
+
+		if (likely(result == 0))
+			goto out;
+	}
+
 	result = read_opcode(mm, vaddr, &opcode);
 	if (result)
 		return result;
-
+out:
 	if (is_swbp_insn(&opcode))
 		return 1;
 
