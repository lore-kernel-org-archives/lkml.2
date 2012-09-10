Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab2IJSMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:12:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:29484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab2IJSMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:12:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="191253109"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v2 4/5] x86, fpu: make eagerfpu= boot param tri-state
Date: Mon, 10 Sep 2012 11:11:04 -0700
Message-Id: <1347300665-6209-5-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
References: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "eagerfpu=auto" (that selects the default scheme in
enabling eagerfpu) which can override compiled-in boot parameters
like "eagerfpu=on/off" (that force enable/disable eagerfpu).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 Documentation/kernel-parameters.txt |    4 +++-
 arch/x86/kernel/xsave.c             |   17 ++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b21bcbd..e0edd14 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1835,8 +1835,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index a447a7c..f9dfaba 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -507,13 +507,15 @@ static void __init setup_init_fpu_buf(void)
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
@@ -556,8 +558,9 @@ static void __init xstate_enable_boot_cpu(void)
 	prepare_fx_sw_frame();
 	setup_init_fpu_buf();
 
-	if (cpu_has_xsaveopt && !disable_eagerfpu)
-		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+	/* Auto enable eagerfpu for xsaveopt */
+	if (cpu_has_xsaveopt && eagerfpu != DISABLE)
+		eagerfpu = ENABLE;
 
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
@@ -597,6 +600,10 @@ void __cpuinit eager_fpu_init(void)
 
 	clear_used_math();
 	current_thread_info()->status = 0;
+
+	if (eagerfpu == ENABLE)
+		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+
 	if (!cpu_has_eager_fpu) {
 		stts();
 		return;
-- 
1.7.6.5

