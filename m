Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1ERUkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:40:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:56190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1ERUki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:40:38 -0400
Date: Wed, 18 May 2011 20:40:31 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-161ec53c702ce9df2f439804dfb9331807066daa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-3-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-3-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, mem, intel: Initialize Enhanced REP MOVSB/STOSB
Git-Commit-ID: 161ec53c702ce9df2f439804dfb9331807066daa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:40:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  161ec53c702ce9df2f439804dfb9331807066daa
Gitweb:     http://git.kernel.org/tip/161ec53c702ce9df2f439804dfb9331807066daa
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:11 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:23 -0700

x86, mem, intel: Initialize Enhanced REP MOVSB/STOSB

If kernel intends to use enhanced REP MOVSB/STOSB, it must ensure
IA32_MISC_ENABLE.Fast_String_Enable (bit 0) is set and CPUID.(EAX=07H, ECX=0H):
EBX[bit 9] also reports 1.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-3-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index df86bc8..fc73a34 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,10 +29,10 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
@@ -118,8 +118,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * (model 2) with the same problem.
 	 */
 	if (c->x86 == 15) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
@@ -130,6 +128,19 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/*
+	 * If fast string is not enabled in IA32_MISC_ENABLE for any reason,
+	 * clear the fast string and enhanced fast string CPU capabilities.
+	 */
+	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+			printk(KERN_INFO "Disabled fast string operations\n");
+			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
+			setup_clear_cpu_cap(X86_FEATURE_ERMS);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
