Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1K1PoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:44:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54200 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1K1Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:59 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 05/11] checkpatch: only apply kconfig help checks for options which prompt
Date: Mon, 28 Nov 2011 15:42:47 +0000
Message-Id: <1322494973-29225-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of this check is to catch the options which the user will see
and ensure they are properly described.  It is also common for internal
only options to have a brief description.  Allow this form.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 74d3d65..ca70bbf 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1670,19 +1670,26 @@ sub process {
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
 		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /\+\s*(?:---)?help(?:---)?$/) {
+		    $line =~ /.\s*config\s+/) {
 			my $length = 0;
 			my $cnt = $realcnt;
 			my $ln = $linenr + 1;
 			my $f;
+			my $is_start = 0;
 			my $is_end = 0;
-			while ($cnt > 0 && defined $lines[$ln - 1]) {
+			for (; $cnt > 0 && defined $lines[$ln - 1]; $ln++) {
 				$f = $lines[$ln - 1];
 				$cnt-- if ($lines[$ln - 1] !~ /^-/);
 				$is_end = $lines[$ln - 1] =~ /^\+/;
-				$ln++;
 
 				next if ($f =~ /^-/);
+
+				if ($lines[$ln - 1] =~ /.\s*(?:bool|tristate)\s*\"/) {
+					$is_start = 1;
+				} elsif ($lines[$ln - 1] =~ /.\s*(?:---)?help(?:---)?$/) {
+					$length = -1;
+				}
+
 				$f =~ s/^.//;
 				$f =~ s/#.*//;
 				$f =~ s/^\s+//;
@@ -1694,8 +1701,8 @@ sub process {
 				$length++;
 			}
 			WARN("CONFIG_DESCRIPTION",
-			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
-			#print "is_end<$is_end> length<$length>\n";
+			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
+			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
-- 
1.7.5.4

