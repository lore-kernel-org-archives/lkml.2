Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1ERFNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:13:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:47184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1ERFNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:13:41 -0400
Date: Wed, 18 May 2011 05:13:36 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-de5397ad5b9ad22e2401c4dacdf1bb3b19c05679@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305157865-31727-1-git-send-email-fenghua.yu@intel.com>
References: <1305157865-31727-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smep] x86, cpu: Enable/disable Supervisor Mode Execution Protection
Git-Commit-ID: de5397ad5b9ad22e2401c4dacdf1bb3b19c05679
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 05:13:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de5397ad5b9ad22e2401c4dacdf1bb3b19c05679
Gitweb:     http://git.kernel.org/tip/de5397ad5b9ad22e2401c4dacdf1bb3b19c05679
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Wed, 11 May 2011 16:51:05 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 21:22:00 -0700

x86, cpu: Enable/disable Supervisor Mode Execution Protection

Enable/disable newly documented SMEP (Supervisor Mode Execution Protection) CPU
feature in kernel. CR4.SMEP (bit 20) is 0 at power-on. If the feature is
supported by CPU (X86_FEATURE_SMEP), enable SMEP by setting CR4.SMEP. New kernel
option nosmep disables the feature even if the feature is supported by CPU.

[ hpa: moved the call to setup_smep() until after the vendor-specific
  initialization; that ensures that CPUID features are unmasked.  We
  will still run it before we have userspace (never mind uncontrolled
  userspace). ]

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
LKML-Reference: <1305157865-31727-1-git-send-email-fenghua.yu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/cpu/common.c        |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cc85a92..56fb8c1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1664,6 +1664,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
+	nosmep		[X86]
+			Disable SMEP (Supervisor Mode Execution Protection)
+			even if it is supported by processor.
+
 	noexec32	[X86-64]
 			This affects only 32-bit executables.
 			noexec32=on: enable non-executable mappings (default)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 173f3a3..cbc70a2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,6 +254,25 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
+static int disable_smep __initdata;
+static __init int setup_disable_smep(char *arg)
+{
+	disable_smep = 1;
+	return 1;
+}
+__setup("nosmep", setup_disable_smep);
+
+static __init void setup_smep(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SMEP)) {
+		if (unlikely(disable_smep)) {
+			setup_clear_cpu_cap(X86_FEATURE_SMEP);
+			clear_in_cr4(X86_CR4_SMEP);
+		} else
+			set_in_cr4(X86_CR4_SMEP);
+	}
+}
+
 /*
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
@@ -667,6 +686,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	c->cpu_index = 0;
 #endif
 	filter_cpuid_features(c, false);
+
+	setup_smep(c);
 }
 
 void __init early_cpu_init(void)
@@ -752,6 +773,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 #endif
 	}
 
+	setup_smep(c);
+
 	get_model_name(c); /* Default name */
 
 	detect_nopl(c);
