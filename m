Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2DTTgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:36:09 -0400
Received: from outmail025.snc4.facebook.com ([66.220.144.159]:59788 "EHLO
	intmgw003.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756812Ab2DTTgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:36:02 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] perf, x86: Don't leak kernel data via callchains
Date: Fri, 20 Apr 2012 12:35:26 -0700
Message-Id: <1334950527-5050-3-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1334950527-5050-1-git-send-email-asharma@fb.com>
References: <1334950527-5050-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NMI could fire when the kernel has done set_fs(KERNEL_DS).
Since we're interested in user space stack pointers only,
check against USER_DS explicitly.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/cpu/perf_event.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9f98636..ccd8c07 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1803,6 +1803,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	struct stack_frame frame;
 	const void __user *fp;
+	mm_segment_t oldfs = get_fs();
 
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
@@ -1816,8 +1817,9 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	if (!current->mm)
 		return;
 
+	set_fs(USER_DS);
 	if (perf_callchain_user32(regs, entry))
-		return;
+		goto out;
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		unsigned long bytes;
@@ -1831,6 +1833,10 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
+
+out:
+	set_fs(oldfs);
+	return;
 }
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
-- 
1.7.8.4

