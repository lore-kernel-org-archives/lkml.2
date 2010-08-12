Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab0HLVQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:16:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0HLVQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:16:23 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=1vWONz4sPGsA:10 a=GzHTLUccyWwA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=7mOBRU54AAAA:8 a=meVymXHHAAAA:8 a=m-DQbsy-lrDnxNyD1c0A:9 a=wQ9mlR7DB8U8CsJkm3hsmy--eHEA:4 a=DHQQ7jDAcw4A:10 a=WeOa-AV5lc8A:10 a=jeBq3FmKZ4MA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Message-Id: <20100812211620.694683277@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 12 Aug 2010 17:14:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 1/2] tracing: Extend recordmcount to better support Blackfin mcount
References: <20100812211422.440965474@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Extend-recordmcount-to-better-support-Blackf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

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
 
-- 
1.7.1


