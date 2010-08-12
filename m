Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0HLFQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 01:16:12 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:47999 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab0HLFQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 01:16:08 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Andy Whitcroft <apw@canonical.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] checkpatch: check for incorrect permissions
Date: Thu, 12 Aug 2010 10:45:45 +0530
Message-ID: <1281590145-30708-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Throw an error when a source file has been given execute permissions
using the mode change line present in git diffs.  Also alow the filename
matching to use the "diff" line in addition to the "+++" line, since the
mode change lines appear before any "+++" lines.

Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 scripts/checkpatch.pl |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..4c35cb9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1308,7 +1308,7 @@ sub process {
 		$here = "#$realline: " if ($file);
 
 		# extract the filename as it passes
-		if ($line=~/^\+\+\+\s+(\S+)/) {
+		if ($line=~/^\+\+\+\s+(\S+)/ || $line=~/^diff\s.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
 
@@ -1332,6 +1332,14 @@ sub process {
 
 		$cnt_lines++ if ($realcnt != 0);
 
+# Check for incorrect file permissions
+		if ($line=~/^new (file )?mode.*[7531]\d{0,2}$/) {
+			my $permhere = $here . "FILE: $realfile\n";
+			if ($realfile=~/(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+				ERROR("do not set execute permissions for source files\n" . $permhere);
+			}
+		}
+
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
-- 
1.7.2.dirty

