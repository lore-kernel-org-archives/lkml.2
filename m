Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849Ab0IZEKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 00:10:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2430 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0IZEKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 00:10:13 -0400
Subject: [RFC PATCH] scripts/get_maintainer.pl: Use vcs history of pattern
 match
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Florian Mickler <florian@mickler.org>, "Ted Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 21:10:11 -0700
Message-ID: <1285474211.6115.171.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When users make changes to individual files in a directory,
git history of just that file is searched.  This can lead
to poor generated results as the directory could actually
be the preferred history unit to find maintainers.

When a file has an exact pattern match, which may be a
directory, search the pattern matched rather than the file.

This may not work well for file in an active directory
like kernel/, because it does not have a named maintainer.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index d21ec3a..9a3627a 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -508,6 +508,7 @@ sub get_maintainers {
     @status = ();
     %deduplicate_name_hash = ();
     %deduplicate_address_hash = ();
+
     if ($email_git_all_signature_types) {
 	$signature_pattern = "(.+?)[Bb][Yy]:";
     } else {
@@ -515,8 +516,8 @@ sub get_maintainers {
     }
 
     # Find responsible parties
-
     my %exact_pattern_match_hash = ();
+    my %matched_pattern_hash = ();
 
     foreach my $file (@files) {
 
@@ -558,6 +559,7 @@ sub get_maintainers {
 				$value_pd = -1 if ($value =~ /^\.\*/);
 				if ($value_pd >= $file_pd) {
 				    $exact_pattern_match_hash{$file} = 1;
+				    $matched_pattern_hash{$value}++;
 				}
 				if ($pattern_depth == 0 ||
 				    (($file_pd - $value_pd) < $pattern_depth)) {
@@ -608,7 +610,13 @@ sub get_maintainers {
 	if ($email &&
 	    ($email_git || ($email_git_fallback &&
 			    !$exact_pattern_match_hash{$file}))) {
-	    vcs_file_signoffs($file);
+	    my $vcs_pattern;
+	    if (scalar keys %matched_pattern_hash) {
+		$vcs_pattern = join(" ", keys %matched_pattern_hash);
+	    } else {
+		$vcs_pattern = $file;
+	    }
+	    vcs_file_signoffs($vcs_pattern);
 	}
 	if ($email && $email_git_blame) {
 	    vcs_file_blame($file);


