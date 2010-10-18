Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab0JRWNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:13:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35904 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab0JRWNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=cD+gWky66OHDZrhjlsnurdL/XYsIoYUJDg/e6r8UO71Xptt0Wa3egjT3cVG2BLsRr/
         uxSpOWGQTxCM72Uq3Mo4JlvHU++ZY606CxDrx6NkrThZQS6dFidFELZUK4lVaqrAA/CV
         md1jijU6WTWQOyKjX71HaHJOrEKu4RognLnBo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] x86: Remove stale TIF_DEBUG
Date: Tue, 19 Oct 2010 00:12:37 +0200
Message-Id: <1287439957-8560-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287434158-24362-2-git-send-regression-fweisbec@gmail.com>
References: <1287434158-24362-2-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user was ptrace breakpoints, which doesn't use that
since 2.6.33.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/thread_info.h |    3 ---
 arch/x86/kernel/process_32.c       |    2 +-
 arch/x86/kernel/process_64.c       |    2 +-
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f0b6e5d..7d0fed5 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -88,7 +88,6 @@ struct thread_info {
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
-#define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
@@ -110,7 +109,6 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
-#define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
@@ -148,7 +146,6 @@ struct thread_info {
 	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP)
 
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
-#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
 
 #define PREEMPT_ACTIVE		0x10000000
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 96586c3..44726fb 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -350,7 +350,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
-		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
+		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW))
 		__switch_to_xtra(prev_p, next_p, tss);
 
 	/* If we're going to preload the fpu context, make sure clts
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3d7a3a..399760d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -484,7 +484,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Now maybe reload the debug registers and handle I/O bitmaps
 	 */
-	if (unlikely(task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT ||
+	if (unlikely(task_thread_info(next_p)->flags & _TIF_WORK_CTXSW ||
 		     task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-- 
1.6.2.3

