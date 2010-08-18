Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0HRPuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:50:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51878 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0HRPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:10 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 01/16] checkpatch: fix regressions in "fix handling of leading spaces"
Date: Wed, 18 Aug 2010 16:46:34 +0100
Message-Id: <1282146409-30544-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below added checks for leading spaces on lines, but this
introduces regressions.  Firstly it does not correctly detect when we are
in a comment.  Secondly it does not allow for preprocessor command spacing.
Finally it does not allow for label indentation which is required to be
less than one tab.  Fix these up:

    checkpatch: fix handling of leading spaces:

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..0a87c74 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1459,10 +1459,13 @@ sub process {
 		}
 
 # check for spaces at the beginning of a line.
-		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
+# Exceptions:
+#  1) within comments
+#  2) indented preprocessor commands
+#  3) hanging labels
+		if ($rawline =~ /^\+ / && $line !~ /\+ *(?:$;|#|$Ident:)/)  {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("please, no space for starting a line, \
-				excluding comments\n" . $herevet);
+			WARN("please, no spaces at the start of a line\n" . $herevet);
 		}
 
 # check we are in a valid C source file if not then ignore this hunk
-- 
1.7.0.4

