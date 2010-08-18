Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0HRPrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:47:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51907 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0HRPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:12 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 09/16] checkpatch: ensure kconfig help checks only apply when we are adding help
Date: Wed, 18 Aug 2010 16:46:42 +0100
Message-Id: <1282146409-30544-10-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking the length of the help we need to be sure we are seeing
the whole story before erroring.  Firstly we only want to check when
adding the help in the first place.  Second we need to be sure that we
are seeing the end of the entry, nominally when there is no context below
or that context shows the start of the next entry.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cb19f54..e44ff91 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1400,18 +1400,34 @@ sub process {
 		}
 
 # check for Kconfig help text having a real description
+# Only applies when adding the entry originally, after that we do not have
+# sufficient context to determine whether it is indeed long enough.
 		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /\+?\s*(---)?help(---)?$/) {
+		    $line =~ /\+\s*(?:---)?help(?:---)?$/) {
 			my $length = 0;
-			for (my $l = $linenr; defined($lines[$l]); $l++) {
-				my $f = $lines[$l];
+			my $cnt = $realcnt;
+			my $ln = $linenr + 1;
+			my $f;
+			my $is_end = 0;
+			while ($cnt > 0 && defined $lines[$ln - 1]) {
+				$f = $lines[$ln - 1];
+				$cnt-- if ($lines[$ln - 1] !~ /^-/);
+				$is_end = $lines[$ln - 1] =~ /^\+/;
+				$ln++;
+
+				next if ($f =~ /^-/);
+				$f =~ s/^.//;
 				$f =~ s/#.*//;
 				$f =~ s/^\s+//;
 				next if ($f =~ /^$/);
-				last if ($f =~ /^\s*config\s/);
+				if ($f =~ /^\s*config\s/) {
+					$is_end = 1;
+					last;
+				}
 				$length++;
 			}
-			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);
+			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
+			#print "is_end<$is_end> length<$length>\n";
 		}
 
 # check we are in a valid source file if not then ignore this hunk
-- 
1.7.0.4

