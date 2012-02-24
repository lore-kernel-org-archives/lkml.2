Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab2BXAIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:08:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48593 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab2BXAGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:06:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.135.71 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120224000220.759957746@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 23 Feb 2012 16:02:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 05/10] i387: move TS_USEDFPU clearing out of __save_init_fpu and into callers
In-Reply-To: <20120224000510.GA1005@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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


