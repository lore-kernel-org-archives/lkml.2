Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1BUOZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:25:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1BUOZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:25:43 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu
Cc: masami.hiramatsu.pt@hitachi.com, acme@redhat.com, fweisbec@gmail.com,
        hpa@zytor.com, ananth@in.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, eric.dumazet@gmail.com,
        2nddept-manager@sdl.hitachi.co.jp, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] kprobes: disabling optimized kprobes for entry text section
Date: Mon, 21 Feb 2011 15:25:13 +0100
Message-Id: <1298298313-5980-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1298298313-5980-1-git-send-email-jolsa@redhat.com>
References: <20110220125948.GC25700@elte.hu>
 <1298298313-5980-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can crash the kernel using kprobe tracer by running:

echo "p system_call_after_swapgs" > ./kprobe_events
echo 1 > ./events/kprobes/enable

The reason is that at the system_call_after_swapgs label, the kernel
stack is not set up. If optimized kprobes are enabled, the user space
stack is being used in this case (see optimized kprobe template) and
this might result in a crash.

There are several places like this over the entry code (entry_$BIT).
As it seems there's no any reasonable/maintainable way to disable only
those places where the stack is not ready, I switched off the whole
entry code from kprobe optimizing.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/kprobes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index d91c477..d03bc1e 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1276,6 +1276,14 @@ static int __kprobes can_optimize(unsigned long paddr)
 	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
 		return 0;
 
+	/*
+	 * Do not optimize in the entry code due to the unstable
+	 * stack handling.
+	 */
+	if ((paddr >= (unsigned long ) __entry_text_start) &&
+	    (paddr <  (unsigned long ) __entry_text_end))
+		return 0;
+
 	/* Check there is enough space for a relative jump. */
 	if (size - offset < RELATIVEJUMP_SIZE)
 		return 0;
-- 
1.7.1

