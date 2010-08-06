Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569Ab0HFH0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:26:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56979 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760448Ab0HFH0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:26:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] tracing: extend recordmcount to better support Blackfin mcount
Date: Fri,  6 Aug 2010 03:26:24 -0400
Message-Id: <1281079584-21205-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mcount call on Blackfin systems includes some stack manipulation
around the actual call site, so extend the build time perl script to
support this.  This way we can avoid doing the calculation at runtime.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/recordmcount.pl |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index f3c9c0a..2c56539 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -159,6 +159,7 @@ my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
+my $mcount_adjust;	# Address adjustment to mcount offset
 my $alignment;		# The .align value to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
 my $can_use_local = 0; 	# If we can use local function references
@@ -213,6 +214,7 @@ $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
 $section_type = '@progbits';
+$mcount_adjust = 0;
 $type = ".long";
 
 if ($arch eq "x86_64") {
@@ -351,6 +353,9 @@ if ($arch eq "x86_64") {
 } elsif ($arch eq "microblaze") {
     # Microblaze calls '_mcount' instead of plain 'mcount'.
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+} elsif ($arch eq "blackfin") {
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
+    $mcount_adjust = -4;
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
@@ -511,7 +516,7 @@ while (<IN>) {
     }
     # is this a call site to mcount? If so, record it to print later
     if ($text_found && /$mcount_regex/) {
-	push(@offsets, hex $1);
+	push(@offsets, (hex $1) + $mcount_adjust);
     }
 }
 
-- 
1.7.2

