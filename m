Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2BVU6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:58:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42987 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab2BVU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:58:14 -0500
Date: Wed, 22 Feb 2012 12:58:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
cc: Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] i387: move TS_USEDFPU clearing out of __save_init_fpu
 and into callers
In-Reply-To: <alpine.LFD.2.02.1202221256450.20522@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1202221257410.20522@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221255150.20522@i5.linux-foundation.org> <alpine.LFD.2.02.1202221256130.20522@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202221256450.20522@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Feb 2012 12:22:48 -0800

[ Upstream commit b6c66418dcad0fcf83cd1d0a39482db37bf4fc41 ]

Touching TS_USEDFPU without touching CR0.TS is confusing, so don't do
it.  By moving it into the callers, we always do the TS_USEDFPU next to
the CR0.TS accesses in the source code, and it's much easier to see how
the two go hand in hand.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org	# Helps backporting
---
 arch/x86/include/asm/i387.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 6e87fa43c357..55fb3aa84b0d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -259,7 +259,6 @@ static inline void fpu_save_init(struct fpu *fpu)
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	fpu_save_init(&tsk->thread.fpu);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
 static inline int fpu_fxrstor_checking(struct fpu *fpu)
@@ -290,6 +289,7 @@ static inline void __unlazy_fpu(struct task_struct *tsk)
 {
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
 		__save_init_fpu(tsk);
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else
 		tsk->fpu_counter = 0;
@@ -356,9 +356,11 @@ static inline void kernel_fpu_begin(void)
 
 	WARN_ON_ONCE(!irq_fpu_usable());
 	preempt_disable();
-	if (me->status & TS_USEDFPU)
+	if (me->status & TS_USEDFPU) {
 		__save_init_fpu(me->task);
-	else
+		me->status &= ~TS_USEDFPU;
+		/* We do 'stts()' in kernel_fpu_end() */
+	} else
 		clts();
 }
 
@@ -449,6 +451,7 @@ static inline void save_init_fpu(struct task_struct *tsk)
 	WARN_ON_ONCE(!(task_thread_info(tsk)->status & TS_USEDFPU));
 	preempt_disable();
 	__save_init_fpu(tsk);
+	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 	stts();
 	preempt_enable();
 }
-- 
1.7.9.188.g12766.dirty

