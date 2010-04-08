Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0DHMcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:32:22 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:60786 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0DHMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b2RRsHRTU10Fg4x4oi28StJr1ztV7YIcubteybUnS5QpoC1azxjTJRXNTobYfy0Iy4
         sKaeWlaYgFNoTQ3OPB4HaVUO/XkAD0rfev4AK8/ZA+BW0wHIU6DZGn7EXwiqAH5Sby8j
         RjgmQIKyoqMM5kwAY41teEqCdX99fmrIMn2Hc=
Date: Thu, 8 Apr 2010 14:32:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Archs <linux-arch@vger.kernel.org>
Subject: [PATCH] perf: Fix unsafe frame rewinding with hot regs fetching
Message-ID: <20100408123209.GA6096@nowhere>
References: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com> <1269568362-13690-6-git-send-regression-fweisbec@gmail.com> <1270720640.2215.43.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270720640.2215.43.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:57:20AM +0200, Eric Dumazet wrote:
> Hello
> 
> Current linux-2.6 tree panics on my dev machine
> 
> 64 bit kernel, 32bit user land
> CONFIG_FRAME_POINTER=y
> 
> perf timechart record &
> 
> Instant crash
> 
> Call Trace:
>  perf_trace_sched_switch+0xd5/0x120
>  schedule+0x6b5/0x860
>  retint_careful+0xd/0x21
>  
> RIP ffffffff81010955 perf_arch_fetch_caller_regs+0x15/0x40
> CR2: 00000000d21f1422
> 
> 
> rewind_frame_pointer() is probably wrong.
> 
> No test performed to check frame is in current stack, or
> that (!user_mode_vm(regs))
> 
> 
> static inline unsigned long rewind_frame_pointer(int n)
> {
> 	struct stack_frame *frame;
> 
> 	get_bp(frame);
> 
> #ifdef CONFIG_FRAME_POINTER
> 	while (n--)
> 		frame = frame->next_frame;
> #endif
> 
> 	return (unsigned long)frame;
> }
> 
> 
> 


Can you please test this fix?

Thanks.

---
>From 60d5c4e8498efc4a01abceef54ad3bc91993bf41 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 8 Apr 2010 14:05:50 +0200
Subject: [PATCH] perf: Fix unsafe frame rewinding with hot regs fetching

When we fetch the hot regs and rewind to the nth caller, it
might happen that we dereference a frame pointer outside the
kernel stack boundaries, like in this example:

	perf_trace_sched_switch+0xd5/0x120
        schedule+0x6b5/0x860
        retint_careful+0xd/0x21

Since we directly dereference a userspace frame pointer here while
rewinding behind retint_careful, this may end up in a crash.

Fix this by simply using probe_kernel_address() when we rewind the
frame pointer.

This issue will have a much more proper fix in the next version of the
perf_arch_fetch_caller_regs() API that will only need to rewind to the
first caller.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>
Cc: Archs <linux-arch@vger.kernel.org>
---
 arch/x86/kernel/dumpstack.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index e39e771..e1a93be 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -14,6 +14,8 @@
 #define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
 #endif
 
+#include <linux/uaccess.h>
+
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl);
@@ -42,8 +44,10 @@ static inline unsigned long rewind_frame_pointer(int n)
 	get_bp(frame);
 
 #ifdef CONFIG_FRAME_POINTER
-	while (n--)
-		frame = frame->next_frame;
+	while (n--) {
+		if (probe_kernel_address(&frame->next_frame, frame))
+			break;
+	}
 #endif
 
 	return (unsigned long)frame;
-- 
1.6.2.3



