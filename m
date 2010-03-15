Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab0COPfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:35:06 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51368 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab0COPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=VRH/Vx1Ia1qmY8DdAI8O7FjL9QvpXrHXfdjxcg++VtEGmupkKyhcPTpO5AtF8T4U4R
         /J1qwcDyAKsnmnIxr9Xscv605mAx5e5e5q/Ag+UjRDgR9D16ZSItCHw8yRYvv0ufG2WC
         k6ORE5esAG4pVma7BtwUw2PmJOtw1DsfoEpTc=
From: =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH] perf: x86: fix callgraphs of 32-bit processes on 64-bit kernels.
Date: Mon, 15 Mar 2010 17:34:20 +0200
Message-Id: <1268667260-5505-2-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268667260-5505-1-git-send-email-edwintorok@gmail.com>
References: <1268667260-5505-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When profiling a 32-bit process on a 64-bit kernel, callgraph tracing
stopped after the first function, because it has seen a garbage memory address
(tried to interpret the frame pointer, and return address as a 64-bit pointer).

Fix this by using a struct stack_frame with 32-bit pointers when the TIF_IA32 flag is set.

Note that TIF_IA32 flag must be used, and not is_compat_task(), because the
latter is only set when the 32-bit process is executing a syscall,
which may not always be the case (when tracing page fault events for example).

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8c1c070..13ee83a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2401,6 +2401,20 @@ static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
 	return bytes == sizeof(*frame);
 }
 
+struct stack_frame_ia32 {
+    u32 next_frame;
+    u32 return_address;
+};
+
+static int copy_stack_frame_ia32(u32 fp, struct stack_frame_ia32 *frame)
+{
+	unsigned long bytes;
+
+	bytes = copy_from_user_nmi(frame, (const void __user*)(unsigned long)fp, sizeof(*frame));
+
+	return bytes == sizeof(*frame);
+}
+
 static void
 perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
@@ -2414,6 +2428,25 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 
 	callchain_store(entry, PERF_CONTEXT_USER);
 	callchain_store(entry, regs->ip);
+	if (test_thread_flag(TIF_IA32)) {
+	    /* 32-bit process in 64-bit kernel. */
+	    u32 fp = regs->bp;
+	    struct stack_frame_ia32 frame;
+	    while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		frame.next_frame     = 0;
+		frame.return_address = 0;
+
+		if (!copy_stack_frame_ia32(fp, &frame))
+			break;
+
+		if ((unsigned long)fp < regs->sp)
+			break;
+
+		callchain_store(entry, frame.return_address);
+		fp = frame.next_frame;
+	    }
+	    return;
+	}
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		frame.next_frame	     = NULL;
-- 
1.7.0

