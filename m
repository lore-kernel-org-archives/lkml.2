Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1LAJdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:33:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1LAJd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:33:29 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 2/2] checkpatch: catch all occurances of type and cast spacing errors per line
Date: Thu,  1 Dec 2011 09:33:01 +0000
Message-Id: <1322731981-22130-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322731981-22130-1-git-send-email-apw@canonical.com>
References: <1322731981-22130-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up type and cast spacing checks such that all occurances on a line are
examined and reported.  For example the line below has a valid cast and
a bad type, but currently we check the cast first which is good and stop:

    u16* bar = (u16 *)baz;

We will also only report one of the errors in this example:

    u16* bar = (u16*)bad;

Move to iterating across all casts and all types, reporting any failure.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 331e832..4ac397b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2206,8 +2206,9 @@ sub process {
 
 # * goes on variable not on type
 		# (char*[ const])
-		if ($line =~ m{\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\)}) {
-			my ($from, $to) = ($1, $1);
+		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
+			#print "AA<$1>\n";
+			my ($from, $to) = ($2, $2);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
@@ -2222,8 +2223,10 @@ sub process {
 				ERROR("POINTER_LOCATION",
 				      "\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
-		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
-			my ($from, $to, $ident) = ($1, $1, $2);
+		} 
+		while ($line =~ m{(\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident))}g) {
+			#print "BB<$1>\n";
+			my ($from, $to, $ident) = ($2, $2, $3);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
-- 
1.7.5.4

