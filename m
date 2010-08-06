Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915Ab0HFXDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:03:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:55026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935895Ab0HFXCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:02:53 -0400
Date: Fri, 6 Aug 2010 23:02:23 GMT
Message-Id: <201008062302.o76N2NX4016644@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/fpu for 2.6.36
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 23:02:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fc1caf6eafb30ea185720e29f7f5eccca61ecd60:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-08-05 16:02:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

Suresh Siddha (1):
      x86: Avoid unnecessary __clear_user() and xrstor in signal handling

 arch/x86/include/asm/i387.h  |    9 +++++++++
 arch/x86/include/asm/xsave.h |   10 ++++++++++
 arch/x86/kernel/xsave.c      |   12 ++----------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 815c5b2..f1accc6 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -127,6 +127,15 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
 
+	/*
+	 * Clear the bytes not touched by the fxsave and reserved
+	 * for the SW usage.
+	 */
+	err = __clear_user(&fx->sw_reserved,
+			   sizeof(struct _fpx_sw_bytes));
+	if (unlikely(err))
+		return -EFAULT;
+
 	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
 		     "2:\n"
 		     ".section .fixup,\"ax\"\n"
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 32c3666..06acdbd 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -65,6 +65,16 @@ static inline int fpu_xrstor_checking(struct fpu *fpu)
 static inline int xsave_user(struct xsave_struct __user *buf)
 {
 	int err;
+
+	/*
+	 * Clear the xsave header first, so that reserved fields are
+	 * initialized to zero.
+	 */
+	err = __clear_user(&buf->xsave_hdr,
+			   sizeof(struct xsave_hdr_struct));
+	if (unlikely(err))
+		return -EFAULT;
+
 	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
 			     "2:\n"
 			     ".section .fixup,\"ax\"\n"
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 37e68fc..6e73db1 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -91,14 +91,6 @@ int save_i387_xstate(void __user *buf)
 		return 0;
 
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		/*
-	 	 * Start with clearing the user buffer. This will present a
-	 	 * clean context for the bytes not touched by the fxsave/xsave.
-		 */
-		err = __clear_user(buf, sig_xstate_size);
-		if (err)
-			return err;
-
 		if (use_xsave())
 			err = xsave_user(buf);
 		else
@@ -184,8 +176,8 @@ static int restore_user_xstate(void __user *buf)
 	 * init the state skipped by the user.
 	 */
 	mask = pcntxt_mask & ~mask;
-
-	xrstor_state(init_xstate_buf, mask);
+	if (unlikely(mask))
+		xrstor_state(init_xstate_buf, mask);
 
 	return 0;
 
