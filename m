Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0I1XcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:32:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:36863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0I1XcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:32:16 -0400
Date: Tue, 28 Sep 2010 23:31:52 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bugzilla.kernel.org@boris64.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bugzilla.kernel.org@boris64.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <tip-@git.kernel.org>
References: <tip-@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpu: After uncapping CPUID, re-run CPU feature detection
Message-ID: <tip-a1a5e645e92d572fdaec284bab6b55fb3985da9a@git.kernel.org>
Git-Commit-ID: a1a5e645e92d572fdaec284bab6b55fb3985da9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 28 Sep 2010 23:31:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1a5e645e92d572fdaec284bab6b55fb3985da9a
Gitweb:     http://git.kernel.org/tip/a1a5e645e92d572fdaec284bab6b55fb3985da9a
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 28 Sep 2010 15:35:01 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 28 Sep 2010 15:50:27 -0700

x86, cpu: After uncapping CPUID, re-run CPU feature detection

After uncapping the CPUID level, we need to also re-run the CPU
feature detection code.

This resolves kernel bugzilla 16322.

Reported-by: boris64 <bugzilla.kernel.org@boris64.net>
Cc: <stable@kernel.org> v2.6.29..2.6.35
LKML-Reference: <tip-@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/cpu/cpu.h    |    1 +
 arch/x86/kernel/cpu/intel.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 490dac6..f2f9ac7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -545,7 +545,7 @@ void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
+void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
 	u32 ebx;
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 3624e8a..522d820 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -33,5 +33,6 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+extern void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 85f69cd..b438944 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -39,6 +39,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
 			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 			c->cpuid_level = cpuid_eax(0);
+			get_cpu_cap(c);
 		}
 	}
 
