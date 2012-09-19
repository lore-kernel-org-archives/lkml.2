Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2ISAJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:09:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2ISAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:09:35 -0400
Date: Tue, 18 Sep 2012 17:09:23 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-e00229819f306b1f86134095347e9187dc346bd1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1347300665-6209-5-git-send-email-suresh.b.siddha@intel.com>
References: <1347300665-6209-5-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: make eagerfpu= boot param tri-state
Git-Commit-ID: e00229819f306b1f86134095347e9187dc346bd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 18 Sep 2012 17:09:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e00229819f306b1f86134095347e9187dc346bd1
Gitweb:     http://git.kernel.org/tip/e00229819f306b1f86134095347e9187dc346bd1
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 10 Sep 2012 10:32:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Sep 2012 15:52:24 -0700

x86, fpu: make eagerfpu= boot param tri-state

Add the "eagerfpu=auto" (that selects the default scheme in
enabling eagerfpu) which can override compiled-in boot parameters
like "eagerfpu=on/off" (that force enable/disable eagerfpu).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1347300665-6209-5-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    4 +++-
 arch/x86/kernel/xsave.c             |   17 ++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e8f7faa..46a6a82 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1834,8 +1834,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			enabling legacy floating-point and sse state.
 
 	eagerfpu=	[X86]
-			on	enable eager fpu restore (default for xsaveopt)
+			on	enable eager fpu restore
 			off	disable eager fpu restore
+			auto	selects the default scheme, which automatically
+				enables eagerfpu restore for xsaveopt.
 
 	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
 			wfi(ARM) instruction doesn't work correctly and not to
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index e99f754..4e89b3d 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -508,13 +508,15 @@ static void __init setup_init_fpu_buf(void)
 	xsave_state(init_xstate_buf, -1);
 }
 
-static int disable_eagerfpu;
+static enum { AUTO, ENABLE, DISABLE } eagerfpu = AUTO;
 static int __init eager_fpu_setup(char *s)
 {
 	if (!strcmp(s, "on"))
-		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+		eagerfpu = ENABLE;
 	else if (!strcmp(s, "off"))
-		disable_eagerfpu = 1;
+		eagerfpu = DISABLE;
+	else if (!strcmp(s, "auto"))
+		eagerfpu = AUTO;
 	return 1;
 }
 __setup("eagerfpu=", eager_fpu_setup);
@@ -557,8 +559,9 @@ static void __init xstate_enable_boot_cpu(void)
 	prepare_fx_sw_frame();
 	setup_init_fpu_buf();
 
-	if (cpu_has_xsaveopt && !disable_eagerfpu)
-		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+	/* Auto enable eagerfpu for xsaveopt */
+	if (cpu_has_xsaveopt && eagerfpu != DISABLE)
+		eagerfpu = ENABLE;
 
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
@@ -598,6 +601,10 @@ void __cpuinit eager_fpu_init(void)
 
 	clear_used_math();
 	current_thread_info()->status = 0;
+
+	if (eagerfpu == ENABLE)
+		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+
 	if (!cpu_has_eager_fpu) {
 		stts();
 		return;
