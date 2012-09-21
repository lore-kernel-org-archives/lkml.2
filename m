Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2IUUF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:05:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab2IUUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:05:24 -0400
Date: Fri, 21 Sep 2012 13:05:13 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-52b6179ac87d33c2eeaff5292786a10fe98cff64@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-10-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-10-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, smap:
  Turn on Supervisor Mode Access Prevention
Git-Commit-ID: 52b6179ac87d33c2eeaff5292786a10fe98cff64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 13:05:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52b6179ac87d33c2eeaff5292786a10fe98cff64
Gitweb:     http://git.kernel.org/tip/52b6179ac87d33c2eeaff5292786a10fe98cff64
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:13 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:27 -0700

x86, smap: Turn on Supervisor Mode Access Prevention

If Supervisor Mode Access Prevention is available and not disabled by
the user, turn it on.  Also fix the expansion of SMEP (Supervisor Mode
Execution Prevention.)

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-10-git-send-email-hpa@linux.intel.com
---
 Documentation/kernel-parameters.txt |    6 +++++-
 arch/x86/kernel/cpu/common.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ad7e2e5..49c5c41 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1812,8 +1812,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
+	nosmap		[X86]
+			Disable SMAP (Supervisor Mode Access Prevention)
+			even if it is supported by processor.
+
 	nosmep		[X86]
-			Disable SMEP (Supervisor Mode Execution Protection)
+			Disable SMEP (Supervisor Mode Execution Prevention)
 			even if it is supported by processor.
 
 	noexec32	[X86-64]
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cd43e52..7d35d65 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -278,6 +278,31 @@ static __cpuinit void setup_smep(struct cpuinfo_x86 *c)
 	}
 }
 
+static int disable_smap __cpuinitdata;
+static __init int setup_disable_smap(char *arg)
+{
+	disable_smap = 1;
+	return 1;
+}
+__setup("nosmap", setup_disable_smap);
+
+static __cpuinit void setup_smap(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SMAP)) {
+		if (unlikely(disable_smap)) {
+			setup_clear_cpu_cap(X86_FEATURE_SMAP);
+			clear_in_cr4(X86_CR4_SMAP);
+		} else {
+			set_in_cr4(X86_CR4_SMAP);
+			/*
+			 * Don't use clac() here since alternatives
+			 * haven't run yet...
+			 */
+			asm volatile(__stringify(__ASM_CLAC) ::: "memory");
+		}
+	}
+}
+
 /*
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
@@ -713,6 +738,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
+	setup_smap(c);
 
 	if (this_cpu->c_bsp_init)
 		this_cpu->c_bsp_init(c);
