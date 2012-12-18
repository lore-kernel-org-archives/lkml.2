Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2LRBTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:19:54 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46486 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2LRBTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:19:52 -0500
Message-ID: <50cfc30c.6327b60a.1727.05f1@mx.google.com>
Date: Mon, 17 Dec 2012 17:12:44 -0800 (PST)
From: rob@landley.net
Subject: [PATCH 1/3] convert mkcapflags.pl->mkcapflags.sh
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Generate asm-x86/cpufeature.h with posix-2008 commands instead of perl.

Signed-off-by: Rob Landley <rob@landley.net>
---

 arch/x86/kernel/cpu/Makefile      |    4 +-
 arch/x86/kernel/cpu/mkcapflags.pl |   48 ----------------------------
 arch/x86/kernel/cpu/mkcapflags.sh |   41 +++++++++++++++++++++++
 3 files changed, 43 insertions(+), 50 deletions(-)

--- linux/arch/x86/kernel/cpu/mkcapflags.pl
+++ /dev/null
@@ -1,48 +0,0 @@
-#!/usr/bin/perl -w
-#
-# Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
-#
-
-($in, $out) = @ARGV;
-
-open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
-open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
-
-print OUT "#ifndef _ASM_X86_CPUFEATURE_H\n";
-print OUT "#include <asm/cpufeature.h>\n";
-print OUT "#endif\n";
-print OUT "\n";
-print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
-
-%features = ();
-$err = 0;
-
-while (defined($line = <IN>)) {
-	if ($line =~ /^\s*\#\s*define\s+(X86_FEATURE_(\S+))\s+(.*)$/) {
-		$macro = $1;
-		$feature = "\L$2";
-		$tail = $3;
-		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
-			$feature = "\L$1";
-		}
-
-		next if ($feature eq '');
-
-		if ($features{$feature}++) {
-			print STDERR "$in: duplicate feature name: $feature\n";
-			$err++;
-		}
-		printf OUT "\t%-32s = \"%s\",\n", "[$macro]", $feature;
-	}
-}
-print OUT "};\n";
-
-close(IN);
-close(OUT);
-
-if ($err) {
-	unlink($out);
-	exit(1);
-}
-
-exit(0);
--- /dev/null	2012-07-11 05:54:12.790418331 -0500
+++ linux/arch/x86/kernel/cpu/mkcapflags.sh	2012-07-22 13:13:57.700823094 -0500
@@ -0,0 +1,41 @@
+#!/bin/sh
+#
+# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+#
+
+IN=$1
+OUT=$2
+
+TABS="$(printf '\t\t\t\t\t')"
+trap 'rm "$OUT"' EXIT
+
+(
+	echo "#ifndef _ASM_X86_CPUFEATURE_H"
+	echo "#include <asm/cpufeature.h>"
+	echo "#endif"
+	echo ""
+	echo "const char * const x86_cap_flags[NCAPINTS*32] = {"
+
+	# Iterate through any input lines starting with #define X86_FEATURE_
+	sed -n -e 's/\t/ /g' -e 's/^ *# *define *X86_FEATURE_//p' $IN |
+	while read i
+	do
+		# Name is everything up to the first whitespace
+		NAME="$(echo "$i" | sed 's/ .*//')"
+
+		# If the /* comment */ starts with a quote string, grab that.
+		VALUE="$(echo "$i" | sed -n 's@.*/\* *\("[^"]*"\).*\*/@\1@p')"
+		[ -z "$VALUE" ] && VALUE="\"$NAME\""
+		[ "$VALUE" == '""' ] && continue
+
+		# Name is uppercase, VALUE is all lowercase
+		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
+
+		TABCOUNT=$(( ( 5*8 - 14 - $(echo "$NAME" | wc -c) ) / 8 ))
+		printf "\t[%s]%.*s = %s,\n" \
+			"X86_FEATURE_$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+	done
+	echo "};"
+) > $OUT
+
+trap - EXIT
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 25f24dc..9edf7e7 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -40,10 +40,10 @@ obj-$(CONFIG_MTRR)			+= mtrr/
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
-      cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
+      cmd_mkcapflags = $(CONFIG_SHELL) $(srctree)/$(src)/mkcapflags.sh $< $@
 
 cpufeature = $(src)/../../include/asm/cpufeature.h
 
 targets += capflags.c
-$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.pl FORCE
+$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
 	$(call if_changed,mkcapflags)
