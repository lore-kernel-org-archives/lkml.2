Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0HPRbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:31:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:40361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab0HPRbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:31:41 -0400
Date: Mon, 16 Aug 2010 17:31:20 GMT
From: tip-bot for Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, vapier@gentoo.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, vapier@gentoo.org, tglx@linutronix.de
In-Reply-To: <1281079584-21205-1-git-send-email-vapier@gentoo.org>
References: <1281079584-21205-1-git-send-email-vapier@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Extend recordmcount to better support Blackfin mcount
Message-ID: <tip-465c6cca2668a2db2a4ffce3dca5714017873f2b@git.kernel.org>
Git-Commit-ID: 465c6cca2668a2db2a4ffce3dca5714017873f2b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 17:31:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  465c6cca2668a2db2a4ffce3dca5714017873f2b
Gitweb:     http://git.kernel.org/tip/465c6cca2668a2db2a4ffce3dca5714017873f2b
Author:     Mike Frysinger <vapier@gentoo.org>
AuthorDate: Fri, 6 Aug 2010 03:26:24 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 12 Aug 2010 10:06:51 -0400

tracing: Extend recordmcount to better support Blackfin mcount

The mcount call on Blackfin systems includes some stack manipulation
around the actual call site, so extend the build time perl script to
support this.  This way we can avoid doing the calculation at runtime.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
LKML-Reference: <1281079584-21205-1-git-send-email-vapier@gentoo.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
 
