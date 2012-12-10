Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2LJSIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:08:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43372 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751617Ab2LJSIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:08:52 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Add --strict test for switch/default missing break
Date: Mon, 10 Dec 2012 10:08:49 -0800
Message-Id: <c60daec392171d2a0b8fe7d7571fc73a51f00882.1355162756.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <CA+MoWDrKR2SRgo6yPSBOK-D-YuxaXYCUMmTubwL777bd4midaQ@mail.gmail.com>
References: <CA+MoWDrKR2SRgo6yPSBOK-D-YuxaXYCUMmTubwL777bd4midaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch default case is sometimes written
as "default:;".  This can cause new cases
added below the default to be defective.

Suggest adding a break; after empty default
cases to avoid fallthrough defects.

Fixed indentation in the other semicolon
test above it.

Suggested-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f18750e..73302d8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3450,8 +3450,22 @@ sub process {
 
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
-		    WARN("ONE_SEMICOLON",
-			 "Statements terminations use 1 semicolon\n" . $herecurr);
+			WARN("ONE_SEMICOLON",
+			     "Statements terminations use 1 semicolon\n" . $herecurr);
+		}
+
+# check for switch/default statements without a break;
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+[$;\s]*(?:case[$;\s]+\w+[$;\s]*:[$;\s]*|)*[$;\s]*\bdefault[$;\s]*:[$;\s]*;/g) {
+			my $ctx = '';
+			my $herectx = $here . "\n";
+			my $cnt = statement_rawlines($stat);
+			for (my $n = 0; $n < $cnt; $n++) {
+				$herectx .= raw_line($linenr, $n) . "\n";
+			}
+			WARN("DEFAULT_NO_BREAK",
+			     "switch default: should use break\n" . $herectx);
 		}
 
 # check for gcc specific __FUNCTION__
-- 
1.7.8.112.g3fd21

