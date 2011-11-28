Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1K1PnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:43:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1K1Pm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:58 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 02/11] checkpatch: check for common memset parameter issues against statments
Date: Mon, 28 Nov 2011 15:42:44 +0000
Message-Id: <1322494973-29225-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the memset checks over to work against the statement.  Also add
checks for 0 and 1 used as lengths.  Generally these indicate badly
ordered parameters.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index eac342d..e07c36a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3111,6 +3111,28 @@ sub process {
 			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
 
+# Check for misused memsets
+		if (defined $stat && $stat =~ /\bmemset\s*\((.*)\)/s) {
+			my $args = $1;
+
+			# Flatten any parentheses and braces
+			while ($args =~ s/\([^\(\)]*\)/10/s ||
+			       $args =~ s/\{[^\{\}]*\}/10/s ||
+			       $args =~ s/\[[^\[\]]*\]/10/s)
+			{
+			}
+			# Extract the simplified arguments.
+			my ($ms_addr, $ms_val, $ms_size) =
+						split(/\s*,\s*/, $args);
+			if ($ms_size =~ /^(0x|)0$/i) {
+				ERROR("MEMSET",
+				      "memset size is 3rd argument, not the second.\n" . $herecurr);
+			} elsif ($ms_size =~ /^(0x|)1$/i) {
+				WARN("MEMSET",
+				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
@@ -3282,12 +3304,6 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
-
-		# Check for memset with swapped arguments
-		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
-			ERROR("MEMSET",
-			      "memset size is 3rd argument, not the second.\n" . $herecurr);
-		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
-- 
1.7.5.4

