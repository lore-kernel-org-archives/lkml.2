Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798Ab0HLKqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:46:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0HLKqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:46:04 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] x86: fpu xstate fix memory poison overwritten
Date: Thu, 12 Aug 2010 18:45:45 +0800
Message-Id: <1281609945-2861-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fpu.state is allocated from task_xstate_cachep, the size of
task_xstate_cachep is xstate_size. But fpu.state is an union
struct, which size is bigger than xstate_size if cpu_has_xsave,
so if we want to visit fpu.state->xsave, the memory we allocated
for fpu.state is not enough.

This caused many poison/redzone overwritten alerts on task_xstate while using kvm.

[ 1899.399373] =============================================================================
[ 1899.399377] BUG task_xstate: Poison overwritten
[ 1899.399378] -----------------------------------------------------------------------------
[ 1899.399379]
[ 1899.399382] INFO: 0xffff88020aca2100-0xffff88020aca217f. First byte 0x0 instead of 0x6b
[ 1899.399385] INFO: Slab 0xffffea000725c300 objects=23 used=12 fp=0xffff88020aca2100 flags=0x200000000040c1
[ 1899.399387] INFO: Object 0xffff88020aca2100 @offset=8448 fp=0xffff88020aca23c0

With this patch applied, the poison overwritten alert disappeared.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index d401f1d..609bee5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -59,7 +59,7 @@ void free_thread_info(struct thread_info *ti)
 void arch_task_cache_init(void)
 {
         task_xstate_cachep =
-        	kmem_cache_create("task_xstate", xstate_size,
+		kmem_cache_create("task_xstate", sizeof(union thread_xstate),
 				  __alignof__(union thread_xstate),
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
-- 
1.7.2.1

