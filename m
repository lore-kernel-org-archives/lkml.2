Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789Ab1ESV3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:29:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665Ab1ESV33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:29:29 -0400
Date: Thu, 19 May 2011 23:29:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] x86/smep changes for v2.6.40
Message-ID: <20110519212913.GA28313@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-smep-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-smep-for-linus

 Thanks,

	Ingo

------------------>
Fenghua Yu (5):
      x86, cpufeature: Fix cpuid leaf 7 feature detection
      x86, cpufeature: Add CPU feature bit for enhanced REP MOVSB/STOSB
      x86, cpufeature: Add cpufeature flag for SMEP
      x86, cpu: Add SMEP CPU feature in CR4
      x86, cpu: Enable/disable Supervisor Mode Execution Protection


 Documentation/kernel-parameters.txt    |    4 ++++
 arch/x86/include/asm/cpufeature.h      |    2 ++
 arch/x86/include/asm/processor-flags.h |    1 +
 arch/x86/kernel/cpu/common.c           |   26 ++++++++++++++++++++++++--
 4 files changed, 31 insertions(+), 2 deletions(-)

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
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 91f3e087..8808cdb 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -195,6 +195,8 @@
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
+#define X86_FEATURE_SMEP	(9*32+ 7) /* Supervisor Mode Execution Protection */
+#define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index a898a2b..59ab4df 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -60,6 +60,7 @@
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
 #define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
+#define X86_CR4_SMEP	0x00100000 /* enable SMEP support */
 
 /*
  * x86-64 Task Priority Register, CR8
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2ced007..cbc70a2 100644
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
@@ -565,8 +584,7 @@ void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 
 		cpuid_count(0x00000007, 0, &eax, &ebx, &ecx, &edx);
 
-		if (eax > 0)
-			c->x86_capability[9] = ebx;
+		c->x86_capability[9] = ebx;
 	}
 
 	/* AMD-defined flags: level 0x80000001 */
@@ -668,6 +686,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	c->cpu_index = 0;
 #endif
 	filter_cpuid_features(c, false);
+
+	setup_smep(c);
 }
 
 void __init early_cpu_init(void)
@@ -753,6 +773,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 #endif
 	}
 
+	setup_smep(c);
+
 	get_model_name(c); /* Default name */
 
 	detect_nopl(c);
