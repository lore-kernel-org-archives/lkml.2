Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0EHVdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 17:33:22 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44102 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0EHVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 17:33:20 -0400
From: florian@mickler.org
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH] get_maintainer.pl: optionally ignore non-maintainer tags
Date: Sat,  8 May 2010 23:32:44 +0200
Message-Id: <1273354364-6016-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4BE46E7D.1040906@s5r6.in-berlin.de>
References: <4BE46E7D.1040906@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using --git to determine who to send a patch to, it is not
reasonable to include people that only reported an issue or tested a
patch. Thus we restrict the candidates to be the one's listed with
Reviewed-By, Signed-Off-By and Acked-By tags.

Signed-Off-By:'s because that are people who are responsible for the code
in question.

Reviewed-By:'s because people responsible for the code in question
obviously thought that the review-feedback for this changeset by that
person was valuable.

The Acked-By: is questionable, but as people listed with this tag
tend to be active linux gatekeepers, false positives are tolerable.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 6f97a13..8e974bb 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -25,6 +25,7 @@ my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
 my $email_git = 1;
+my $email_git_maintainers = 0;
 my $email_git_blame = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
@@ -50,6 +51,15 @@ my $help = 0;
 
 my $exit = 0;
 
+#
+# tags for people who are either
+# 	a) responsible for the code in question, or
+# 	b) familiar enough with it to give relevant feedback
+my @maintainer_tags = ();
+push(@maintainer_tags,"Signed-Off");
+push(@maintainer_tags,"Reviewed");
+push(@maintainer_tags,"Acked");
+
 my @penguin_chief = ();
 push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
 #Andrew wants in on most everything - 2009/01/14
@@ -100,6 +110,7 @@ my %VCS_cmds_hg = (
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
+		'git-maintainers!' => \$email_git_maintainers,
 		'git-blame!' => \$email_git_blame,
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
@@ -497,6 +508,7 @@ version: $V
 MAINTAINER field selection options:
   --email => print email address(es) if any
     --git => include recent git \*-by: signers
+    --git-maintainers => only use 'Signed-Off-By:', 'Reviewed-By:' and 'Acked-By:' signers
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
@@ -957,6 +969,13 @@ sub vcs_find_signers {
     my ($cmd) = @_;
     my @lines = ();
     my $commits;
+    my $tagPattern;
+    if ($email_git_maintainers) {
+	    $tagPattern = join("|",@maintainer_tags);
+    } else {
+	    $tagPattern = "[^ \t]+";
+    }
+
 
     @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
@@ -964,7 +983,7 @@ sub vcs_find_signers {
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
-    @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
+    @lines = grep(/^[ \t]*($tagPattern)-by:.*\@.*$/i, @lines);
     if (!$email_git_penguin_chiefs) {
 	@lines = grep(!/${penguin_chiefs}/i, @lines);
     }
-- 
1.7.0.4

