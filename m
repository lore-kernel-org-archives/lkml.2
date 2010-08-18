Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0HRPsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51920 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0HRPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:13 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH 10/16] checkpatch: check for incorrect permissions
Date: Wed, 18 Aug 2010 16:46:43 +0100
Message-Id: <1282146409-30544-11-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Throw an error when a source file has been given execute permissions
using the mode change line present in git diffs.  Also alow the filename
matching to use the "diff" line in addition to the "+++" line, since the
mode change lines appear before any "+++" lines.

[apw@canonical.com: simplified filename logic slightly, added tests]
Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e44ff91..93fa145 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1315,7 +1315,11 @@ sub process {
 		$here = "#$realline: " if ($file);
 
 		# extract the filename as it passes
-		if ($line=~/^\+\+\+\s+(\S+)/) {
+		if ($line =~ /^diff --git.*?(\S+)$/) {
+			$realfile = $1;
+			$realfile =~ s@^([^/]*)/@@;
+
+		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
 
@@ -1339,6 +1343,14 @@ sub process {
 
 		$cnt_lines++ if ($realcnt != 0);
 
+# Check for incorrect file permissions
+		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
+			my $permhere = $here . "FILE: $realfile\n";
+			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+				ERROR("do not set execute permissions for source files\n" . $permhere);
+			}
+		}
+
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
-- 
1.7.0.4

