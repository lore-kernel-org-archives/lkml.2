Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab2B1Be3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:34:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37330 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2B1BHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.125.134 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010212.514772067@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 50/73] i387: move TS_USEDFPU clearing out of __save_init_fpu and into callers
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b6c66418dcad0fcf83cd1d0a39482db37bf4fc41 upstream.

Touching TS_USEDFPU without touching CR0.TS is confusing, so don't do
it.  By moving it into the callers, we always do the TS_USEDFPU next to
the CR0.TS accesses in the source code, and it's much easier to see how
the two go hand in hand.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/i387.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -259,7 +259,6 @@ static inline void fpu_save_init(struct
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	fpu_save_init(&tsk->thread.fpu);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
 static inline int fpu_fxrstor_checking(struct fpu *fpu)
@@ -290,6 +289,7 @@ static inline void __unlazy_fpu(struct t
 {
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
 		__save_init_fpu(tsk);
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else
 		tsk->fpu_counter = 0;
@@ -356,9 +356,11 @@ static inline void kernel_fpu_begin(void
 
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
 
@@ -449,6 +451,7 @@ static inline void save_init_fpu(struct
 	WARN_ON_ONCE(!(task_thread_info(tsk)->status & TS_USEDFPU));
 	preempt_disable();
 	__save_init_fpu(tsk);
+	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 	stts();
 	preempt_enable();
 }


