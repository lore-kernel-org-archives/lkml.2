Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0GGAeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:34:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:43127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab0GGAeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:34:08 -0400
Date: Wed, 7 Jul 2010 00:33:45 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1277249017.2847.85.camel@sbs-t61.sc.intel.com>
References: <1277249017.2847.85.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Avoid unnecessary __clear_user() and xrstor in signal handling
Message-ID: <tip-8e221b6db4477643fefc885a97ea9889ac733140@git.kernel.org>
Git-Commit-ID: 8e221b6db4477643fefc885a97ea9889ac733140
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 07 Jul 2010 00:33:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e221b6db4477643fefc885a97ea9889ac733140
Gitweb:     http://git.kernel.org/tip/8e221b6db4477643fefc885a97ea9889ac733140
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 22 Jun 2010 16:23:37 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Jul 2010 16:31:04 -0700

x86: Avoid unnecessary __clear_user() and xrstor in signal handling

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
LKML-Reference: <1277249017.2847.85.camel@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h  |    9 +++++++++
 arch/x86/include/asm/xsave.h |   10 ++++++++++
 arch/x86/kernel/xsave.c      |   12 ++----------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index c991b3a..0f1cf5d 100644
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
index 2c4390c..30dfc81 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -59,6 +59,16 @@ static inline int fpu_xrstor_checking(struct fpu *fpu)
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
 
