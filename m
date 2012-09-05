Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab2IETmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:42:15 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:46064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2IETmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:42:14 -0400
Message-ID: <1346874169.4364.42.camel@jlt4.sipsolutions.net>
Subject: [PATCH] checkpatch: fix erroneous indentation errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Wed, 05 Sep 2012 21:42:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In a few cases, checkpatch gives false indentation CHECKs:

@@ ... @@
-	foo(1, 2, 3,
+	foo(1, 2, 3, 4,
 	    5, 6, 7, 8);

will warn.

@@ ... @@
	foo(1, 2, 3, 4,
-	    5, 6, 7, 8);
+		5, 6, 7, 8);

will not warn.

Change this. The only disadvantage of the new code is
that it will warn about context-only indentation problems,
e.g.

@@ ... @@
	foo(1, 2, 3, 4,
		5, 6, 7, 8);
-	unrelated();

will cause a warning now. It could probably be prevented
by a match on $rawline, but I wasn't sure how to do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e5bd60f..6a97c3b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1841,14 +1841,14 @@ sub process {
 
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
-		    $prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
-			$prevline =~ /^\+(\t*)(.*)$/;
+		    $prevline =~ /^[ \+](\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
+			$prevline =~ /^[ \+](\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;
 
 			my $pos = pos_last_openparen($rest);
 			if ($pos >= 0) {
-				$line =~ /^\+([ \t]*)/;
+				$line =~ /^[\+ ]([ \t]*)/;
 				my $newindent = $1;
 
 				my $goodtabindent = $oldindent .
-- 
1.7.10.4



