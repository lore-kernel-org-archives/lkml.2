Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2GZRpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:45:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:50890 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab2GZRpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:45:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127257821"
Subject: Re: [tip:x86:fpu 2/2] arch/x86/kernel/signal.c:626:4: error:
 implicit declaration of function '__setup_frame'
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: kernel-janitors@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jul 2012 10:48:04 -0700
In-Reply-To: <20120725232716.GB5758@localhost>
References: <20120725232716.GB5758@localhost>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1343324885.3696.527.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 07:27 +0800, Fengguang Wu wrote:
> Hi Suresh,
> 
> Kernel build failed on
> 
> tree:   tip/x86/fpu x86/fpu
> head:   29221d4b89d4e50f05ade42ad3b22e92bb564ca4
> commit: 29221d4b89d4e50f05ade42ad3b22e92bb564ca4 [2/2] x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels
> config: x86_64-randconfig-s003 (attached as .config)
> 
> All related error/warning messages:
> 
> arch/x86/kernel/signal.c: In function 'setup_rt_frame':
> arch/x86/kernel/signal.c:626:4: error: implicit declaration of function '__setup_frame' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> --
> arch/x86/kernel/xsave.c: In function 'save_fsave_header':
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: 'X86_FXSR_MAGIC' undeclared (first use in this function)
> arch/x86/kernel/xsave.c:145:7: note: each undeclared identifier is reported only once for each function it appears in
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c:145:7: error: dereferencing pointer to incomplete type
> arch/x86/kernel/xsave.c: In function 'save_user_xstate':
> arch/x86/kernel/xsave.c:209:15: warning: ignoring return value of '__clear_user', declared with attribute warn_unused_result [-Wunused-result]
> 

Appended the patch for this. Thanks!
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, fpu: fix x86_64 build without CONFIG_IA32_EMULATION

Fengguang's automated build reported some compilation failures:
> arch/x86/kernel/signal.c: In function 'setup_rt_frame':
> arch/x86/kernel/signal.c:626:4: error: implicit declaration of function '__setup_frame'
> arch/x86/kernel/xsave.c: In function 'save_fsave_header':
> arch/x86/kernel/xsave.c:144:7: error: dereferencing pointer to incomplete type
> ...

Fix x86_64 kernel build without CONFIG_IA32_EMULATION.

Code saving fsave prefix is applicable only for CONFIG_X86_32 or
CONFIG_IA32_EMULATION. Use config_enabled() checks to remove the unnecessary
code compile-time for x86_64 kernels build without CONFIG_IA32_EMULATION.

Also while we are at this, fix a spurious warning:
> arch/x86/kernel/xsave.c:209:15: warning: ignoring return value of ‘__clear_user’, declared with attribute warn_unused_result

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/fpu-internal.h |    2 +-
 arch/x86/kernel/xsave.c             |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 35ad161..5779184 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -22,7 +22,7 @@
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
 
-#ifdef CONFIG_IA32_EMULATION
+#ifdef CONFIG_X86_64
 # include <asm/sigcontext32.h>
 # include <asm/user32.h>
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2917e34..a23d100 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -205,8 +205,8 @@ static inline int save_user_xstate(struct xsave_struct __user *buf)
 	else
 		err = fsave_user((struct i387_fsave_struct __user *) buf);
 
-	if (unlikely(err))
-		__clear_user(buf, xstate_size);
+	if (unlikely(err) && __clear_user(buf, xstate_size))
+		err = -EFAULT;
 	return err;
 }
 
@@ -236,6 +236,9 @@ int save_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	struct task_struct *tsk = current;
 	int ia32_fxstate = (buf != buf_fx);
 
+	ia32_fxstate &= (config_enabled(CONFIG_X86_32) ||
+			 config_enabled(CONFIG_IA32_EMULATION));
+
 	if (!access_ok(VERIFY_WRITE, buf, size))
 		return -EACCES;
 
@@ -333,6 +336,9 @@ int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
 	u64 xstate_bv = 0;
 	int fx_only = 0;
 
+	ia32_fxstate &= (config_enabled(CONFIG_X86_32) ||
+			 config_enabled(CONFIG_IA32_EMULATION));
+
 	if (!buf) {
 		drop_fpu(tsk);
 		return 0;


