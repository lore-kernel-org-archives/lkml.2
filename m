Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2AWDq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:46:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2AWDqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:46:20 -0500
Message-ID: <4F1CD7CD.3080801@landley.net>
Date: Sun, 22 Jan 2012 21:45:17 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perl removal: Generate capflags.c with sed (POSIX 2008)
 instead of perl.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Generate capflags.c with sed (POSIX 2008) instead of perl.

Signed-off-by: Rob Landley <rob@landley.net>
---

This patch hasn't changed since 2009, just rediffed to eliminate fuzz.

 arch/x86/kernel/cpu/Makefile      |    4 +--
 arch/x86/kernel/cpu/mkcapflags.pl |   32 ----------------------------
 arch/x86/kernel/cpu/mkcapflags.sh |   28 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 34 deletions(-)

diff -ruN linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.pl linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.pl
--- linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.pl	2009-06-09 22:05:27.000000000 -0500
+++ linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.pl	1969-12-31 18:00:00.000000000 -0600
@@ -1,32 +0,0 @@
-#!/usr/bin/perl
-#
-# Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
-#
-
-($in, $out) = @ARGV;
-
-open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
-open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
-
-print OUT "#include <asm/cpufeature.h>\n\n";
-print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
-
-while (defined($line = <IN>)) {
-	if ($line =~ /^\s*\#\s*define\s+(X86_FEATURE_(\S+))\s+(.*)$/) {
-		$macro = $1;
-		$feature = $2;
-		$tail = $3;
-		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
-			$feature = $1;
-		}
-
-		if ($feature ne '') {
-			printf OUT "\t%-32s = \"%s\",\n",
-				"[$macro]", "\L$feature";
-		}
-	}
-}
-print OUT "};\n";
-
-close(IN);
-close(OUT);
diff -ruN linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.sh linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.sh
--- linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.sh	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.sh	2009-06-22 16:39:06.000000000 -0500
@@ -0,0 +1,28 @@
+#!/bin/sh
+#
+# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+#
+
+IN=$1
+OUT=$2
+
+(
+	echo "#include <asm/cpufeature.h>"
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
+		[ -z "$VALUE" ] && VALUE="\"$(echo "$NAME" | tr A-Z a-z)\""
+
+		[ "$VALUE" != '""' ] && echo "	[X86_FEATURE_$NAME] = $VALUE,"
+	done
+	echo "};"
+) > $OUT
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
