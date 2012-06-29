Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2F2PeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:34:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44579 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2F2Pd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:33:58 -0400
Date: Fri, 29 Jun 2012 17:33:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120629153352.GA3065@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 1b6b7c9ff3514772958c075f8c89e42dddf6a4d8 x86, cpufeature: Remove stray %s, add -w to mkcapflags.pl


out-of-topic modifications in x86-urgent-for-linus:
---------------------------------------------------
drivers/hwmon/coretemp.c           # 4ad3341: x86, cpufeature: Rename X86_FEATU

 Thanks,

	Ingo

------------------>
H. Peter Anvin (3):
      x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM
      x86, cpufeature: Catch duplicate CPU feature strings
      x86, cpufeature: Remove stray %s, add -w to mkcapflags.pl

Suresh Siddha (1):
      x86, compat: Use test_thread_flag(TIF_IA32) in compat signal delivery

Wanpeng Li (1):
      x86: Fix kernel-doc warnings


 arch/x86/ia32/ia32_signal.c       |    2 +-
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/cpu/mkcapflags.pl |   25 +++++++++++++++++++------
 arch/x86/kernel/cpu/scattered.c   |    2 +-
 arch/x86/kernel/kgdb.c            |    8 ++++----
 arch/x86/lib/csum-wrappers_64.c   |    2 +-
 drivers/hwmon/coretemp.c          |    4 ++--
 7 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index daeca56..673ac9b 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -38,7 +38,7 @@
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
-	bool ia32 = is_ia32_task();
+	bool ia32 = test_thread_flag(TIF_IA32);
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 340ee49..f91e80f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -176,7 +176,7 @@
 #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
 #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
-#define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
 
 /* Virtualization flags: Linux defined, word 8 */
diff --git a/arch/x86/kernel/cpu/mkcapflags.pl b/arch/x86/kernel/cpu/mkcapflags.pl
index dfea390..c7b3fe2 100644
--- a/arch/x86/kernel/cpu/mkcapflags.pl
+++ b/arch/x86/kernel/cpu/mkcapflags.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/perl -w
 #
 # Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
 #
@@ -11,22 +11,35 @@ open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
 print OUT "#include <asm/cpufeature.h>\n\n";
 print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
 
+%features = ();
+$err = 0;
+
 while (defined($line = <IN>)) {
 	if ($line =~ /^\s*\#\s*define\s+(X86_FEATURE_(\S+))\s+(.*)$/) {
 		$macro = $1;
-		$feature = $2;
+		$feature = "\L$2";
 		$tail = $3;
 		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
-			$feature = $1;
+			$feature = "\L$1";
 		}
 
-		if ($feature ne '') {
-			printf OUT "\t%-32s = \"%s\",\n",
-				"[$macro]", "\L$feature";
+		next if ($feature eq '');
+
+		if ($features{$feature}++) {
+			print STDERR "$in: duplicate feature name: $feature\n";
+			$err++;
 		}
+		printf OUT "\t%-32s = \"%s\",\n", "[$macro]", $feature;
 	}
 }
 print OUT "};\n";
 
 close(IN);
 close(OUT);
+
+if ($err) {
+	unlink($out);
+	exit(1);
+}
+
+exit(0);
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index addf9e8..ee8e9ab 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -31,7 +31,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_DTS,		CR_EAX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_DTHERM,		CR_EAX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8bfb614..3f61904 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -444,12 +444,12 @@ void kgdb_roundup_cpus(unsigned long flags)
 
 /**
  *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.
- *	@vector: The error vector of the exception that happened.
+ *	@e_vector: The error vector of the exception that happened.
  *	@signo: The signal number of the exception that happened.
  *	@err_code: The error code of the exception that happened.
- *	@remcom_in_buffer: The buffer of the packet we have read.
- *	@remcom_out_buffer: The buffer of %BUFMAX bytes to write a packet into.
- *	@regs: The &struct pt_regs of the current process.
+ *	@remcomInBuffer: The buffer of the packet we have read.
+ *	@remcomOutBuffer: The buffer of %BUFMAX bytes to write a packet into.
+ *	@linux_regs: The &struct pt_regs of the current process.
  *
  *	This function MUST handle the 'c' and 's' command packets,
  *	as well packets to set / remove a hardware breakpoint, if used.
diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index 459b58a..25b7ae8 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -115,7 +115,7 @@ EXPORT_SYMBOL(csum_partial_copy_to_user);
  * @src: source address
  * @dst: destination address
  * @len: number of bytes to be copied.
- * @isum: initial sum that is added into the result (32bit unfolded)
+ * @sum: initial sum that is added into the result (32bit unfolded)
  *
  * Returns an 32bit unfolded checksum of the buffer.
  */
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index b9d5123..0f52799 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -664,7 +664,7 @@ static void __cpuinit get_core_online(unsigned int cpu)
 	 * sensors. We check this bit only, all the early CPUs
 	 * without thermal sensors will be filtered out.
 	 */
-	if (!cpu_has(c, X86_FEATURE_DTS))
+	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return;
 
 	if (!pdev) {
@@ -765,7 +765,7 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
 };
 
 static const struct x86_cpu_id coretemp_ids[] = {
-	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTS },
+	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTHERM },
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, coretemp_ids);
