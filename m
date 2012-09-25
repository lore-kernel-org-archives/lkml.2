Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2IYW6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:58:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41043 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2IYW6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:58:18 -0400
Date: Tue, 25 Sep 2012 15:58:02 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-e139e95590dfebab81841bf7a3ac46500f51a47c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1343171129-2747-3-git-send-email-suresh.b.siddha@intel.com>
References: <1343171129-2747-3-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, smap: Do not abuse the [f][x]rstor_checking()
  functions for user space
Git-Commit-ID: e139e95590dfebab81841bf7a3ac46500f51a47c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 25 Sep 2012 15:58:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e139e95590dfebab81841bf7a3ac46500f51a47c
Gitweb:     http://git.kernel.org/tip/e139e95590dfebab81841bf7a3ac46500f51a47c
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 25 Sep 2012 15:42:18 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 25 Sep 2012 15:42:18 -0700

x86, smap: Do not abuse the [f][x]rstor_checking() functions for user space

With SMAP, the [f][x]rstor_checking() functions are no longer usable
for user-space pointers by applying a simple __force cast.  Instead,
create new [f][x]rstor_user() functions which do the proper SMAP
magic.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1343171129-2747-3-git-send-email-suresh.b.siddha@intel.com
---
 arch/x86/include/asm/fpu-internal.h |   17 +++++++++++++++++
 arch/x86/kernel/xsave.c             |    6 +++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 409b9cc..831dbb9 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -181,11 +181,28 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 			  "m" (*fx));
 }
 
+static inline int fxrstor_user(struct i387_fxsave_struct __user *fx)
+{
+	if (config_enabled(CONFIG_X86_32))
+		return user_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+	else if (config_enabled(CONFIG_AS_FXSAVEQ))
+		return user_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
+
+	/* See comment in fpu_fxsave() below. */
+	return user_insn(rex64/fxrstor (%[fx]), "=m" (*fx), [fx] "R" (fx),
+			  "m" (*fx));
+}
+
 static inline int frstor_checking(struct i387_fsave_struct *fx)
 {
 	return check_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
 }
 
+static inline int frstor_user(struct i387_fsave_struct __user *fx)
+{
+	return user_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
 static inline void fpu_fxsave(struct fpu *fpu)
 {
 	if (config_enabled(CONFIG_X86_32))
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 4e89b3d..ada87a3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -315,7 +315,7 @@ static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
 		if ((unsigned long)buf % 64 || fx_only) {
 			u64 init_bv = pcntxt_mask & ~XSTATE_FPSSE;
 			xrstor_state(init_xstate_buf, init_bv);
-			return fxrstor_checking((__force void *) buf);
+			return fxrstor_user(buf);
 		} else {
 			u64 init_bv = pcntxt_mask & ~xbv;
 			if (unlikely(init_bv))
@@ -323,9 +323,9 @@ static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
 			return xrestore_user(buf, xbv);
 		}
 	} else if (use_fxsr()) {
-		return fxrstor_checking((__force void *) buf);
+		return fxrstor_user(buf);
 	} else
-		return frstor_checking((__force void *) buf);
+		return frstor_user(buf);
 }
 
 int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
