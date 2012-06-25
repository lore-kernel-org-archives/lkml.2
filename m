Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2FYQOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:14:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab2FYQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:14:48 -0400
Date: Mon, 25 Jun 2012 09:14:29 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-55f6cb9d0b364e7e8cb65b51193f5e4743c44fde@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        JBeulich@suse.com, khali@linux-fr.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, khali@linux-fr.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4FE34BCB.5050305@linux.intel.com>
References: <4FE34BCB.5050305@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpufeature:
  Catch duplicate CPU feature strings
Git-Commit-ID: 55f6cb9d0b364e7e8cb65b51193f5e4743c44fde
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 25 Jun 2012 09:14:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55f6cb9d0b364e7e8cb65b51193f5e4743c44fde
Gitweb:     http://git.kernel.org/tip/55f6cb9d0b364e7e8cb65b51193f5e4743c44fde
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 22 Jun 2012 11:47:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 25 Jun 2012 09:02:13 -0700

x86, cpufeature: Catch duplicate CPU feature strings

We had a case of duplicate CPU feature strings, a user space ABI
violation, for almost two years.  Make it a build error so that
doesn't happen again.

Link: http://lkml.kernel.org/r/4FE34BCB.5050305@linux.intel.com
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Jean Delvare <khali@linux-fr.org>
---
 arch/x86/kernel/cpu/mkcapflags.pl |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mkcapflags.pl b/arch/x86/kernel/cpu/mkcapflags.pl
index dfea390..0c5b549 100644
--- a/arch/x86/kernel/cpu/mkcapflags.pl
+++ b/arch/x86/kernel/cpu/mkcapflags.pl
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
+		printf OUT "\t%-32s = \"%s\",%s\n", "[$macro]", $feature;
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
