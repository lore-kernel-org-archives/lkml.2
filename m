Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2E2T3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:29:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab2E2T3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:29:43 -0400
Date: Tue, 29 May 2012 21:27:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] uprobes: optimize is_swbp_at_addr() for current->mm
Message-ID: <20120529192744.GA8057@redhat.com>
References: <20120529192721.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529192721.GA8048@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change is_swbp_at_addr() to try to avoid the costly read_opcode()
if mm == current->mm, __copy_from_user_inatomic() should succeed
in the likely case.

Currently this optimization is not important, but we are going to
add more is_swbp_at_addr(current->mm) callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
 
-- 
1.5.5.1


