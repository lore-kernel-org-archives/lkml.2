Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1D0O0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:26:53 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:3113
	"EHLO CH1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752479Ab1D0O0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:26:50 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKBESH-02-BQY-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <brgerst@gmail.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 2/2] fork: avoid weak function arch_dup_task_struct
Date: Wed, 27 Apr 2011 16:26:35 +0200
Message-ID: <1303914395-841373-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>
References: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid potential gcc bug by not using a weak function for
arch_dup_task_struct. Use an #ifdef'ed static function for
archs that don't have a special arch_dup_task_struct implementation.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/sh/include/asm/thread_info.h  |    1 +
 arch/x86/include/asm/thread_info.h |    1 +
 kernel/fork.c                      |    5 +++--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index ea2d508..2d27e1c 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -100,6 +100,7 @@ extern void free_thread_info(struct thread_info *ti);
 extern void arch_task_cache_init(void);
 #define arch_task_cache_init arch_task_cache_init
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+#define arch_dup_task_struct arch_dup_task_struct
 extern void init_thread_xstate(void);
 
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 07c8cfe..ce97947 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -266,6 +266,7 @@ extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 extern int arch_prealloc_fpu(struct task_struct *tsk);
+#define arch_dup_task_struct arch_dup_task_struct
 #define arch_prealloc_fpu arch_prealloc_fpu
 #define arch_task_cache_init arch_task_cache_init
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..6d929d0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -243,12 +243,13 @@ void __init fork_init(unsigned long mempages)
 		init_task.signal->rlim[RLIMIT_NPROC];
 }
 
-int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
-					       struct task_struct *src)
+#ifndef arch_dup_task_struct
+static int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
 	return 0;
 }
+#endif
 
 static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
-- 
1.5.6.5


