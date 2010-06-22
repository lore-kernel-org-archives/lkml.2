Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0FVXYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:24:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:57923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0FVXYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,463,1272870000"; 
   d="scan'208";a="529317527"
Subject: [patch] x86: avoid unnecessary __clear_user() and xrstor in signal
 handling
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 22 Jun 2010 16:23:37 -0700
Message-Id: <1277249017.2847.85.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: avoid unnecessary __clear_user() and xrstor in signal handling

fxsave/xsave doesn't touch all the bytes in the memory layout used by
these instructions. Specifically SW reserved (bytes 464..511) fields
in the fxsave frame and the reserved fields in the xsave header.

To present a clean context for the signal handling, just clear these fields
instead of clearing the complete fxsave/xsave memory layout, when we dump these
registers directly to the user signal frame.

Also avoid the call to second xrstor (which inits the state not passed
in the signal frame) in restore_user_xstate() if all the state has already
been restored by the first xrstor.

These changes improve the performance of signal handling(by ~3-5% as measured
by the lat_sig).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/i387.h  |    9 +++++++++
 arch/x86/include/asm/xsave.h |   10 ++++++++++
 arch/x86/kernel/xsave.c      |   12 ++----------
 3 files changed, 21 insertions(+), 10 deletions(-)

Index: tree/arch/x86/kernel/xsave.c
===================================================================
--- tree.orig/arch/x86/kernel/xsave.c
+++ tree/arch/x86/kernel/xsave.c
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
@@ -184,8 +176,8 @@ static int restore_user_xstate(void __us
 	 * init the state skipped by the user.
 	 */
 	mask = pcntxt_mask & ~mask;
-
-	xrstor_state(init_xstate_buf, mask);
+	if (unlikely(mask))
+		xrstor_state(init_xstate_buf, mask);
 
 	return 0;
 
Index: tree/arch/x86/include/asm/i387.h
===================================================================
--- tree.orig/arch/x86/include/asm/i387.h
+++ tree/arch/x86/include/asm/i387.h
@@ -127,6 +127,15 @@ static inline int fxsave_user(struct i38
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
Index: tree/arch/x86/include/asm/xsave.h
===================================================================
--- tree.orig/arch/x86/include/asm/xsave.h
+++ tree/arch/x86/include/asm/xsave.h
@@ -59,6 +59,16 @@ static inline int fpu_xrstor_checking(st
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


