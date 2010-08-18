Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0HRPsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51889 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0HRPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:11 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 04/16] checkpatch: ensure we do not collapse bracketed sections into constants
Date: Wed, 18 Aug 2010 16:46:37 +0100
Message-Id: <1282146409-30544-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When determining if a return () sequence is a function style bracketing
we simplify the expression one bracket at a time replacing each with a
constant.  However this can trigger a false merge with expressions as
below:

	return (foo)0;

Prevent this false merging.

Reported-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 32d6a23..8d010ac 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2183,15 +2183,16 @@ sub process {
 			my $value = $2;
 
 			# Flatten any parentheses
-			$value =~ s/\)\(/\) \(/g;
+			$value =~ s/\(/ \(/g;
+			$value =~ s/\)/\) /g;
 			while ($value =~ s/\[[^\{\}]*\]/1/ ||
 			       $value !~ /(?:$Ident|-?$Constant)\s*
 					     $Compare\s*
 					     (?:$Ident|-?$Constant)/x &&
 			       $value =~ s/\([^\(\)]*\)/1/) {
 			}
-
-			if ($value =~ /^(?:$Ident|-?$Constant)$/) {
+#print "value<$value>\n";
+			if ($value =~ /^\s*(?:$Ident|-?$Constant)\s*$/) {
 				ERROR("return is not a function, parentheses are not required\n" . $herecurr);
 
 			} elsif ($spacing !~ /\s+/) {
-- 
1.7.0.4

