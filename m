Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0IPMLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:11:22 -0400
Received: from mail.perches.com ([173.55.12.10]:2085 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0IPMLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:11:14 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] scripts/get_maintainer.pl: Add default --git-fallback, remove default --git
Date: Thu, 16 Sep 2010 05:11:11 -0700
Message-Id: <268d6a9a48af6f6ad270caf1b745e1e21b3ab2e4.1284636516.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284636516.git.joe@perches.com>
References: <cover.1284636516.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding commit signers when there is a listed MAINTAINER for a file
can make the output list longer than necessary.

Change the --git default from on to off.

Add a new --git-fallback option (default on) used to add commit signers
only when there is no MAINTAINER for a file.

git history is used when --git-fallback is enabled and the pattern
directory depth is not the same as the file directory depth.

For instance:

X86 ARCHITECTURE (32-BIT AND 64-BIT)
M:	Thomas Gleixner <tglx@linutronix.de>
M:	Ingo Molnar <mingo@redhat.com>
M:	"H. Peter Anvin" <hpa@zytor.com>
M:	x86@kernel.org
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
S:	Maintained
F:	Documentation/x86/
F:	arch/x86/

If using "./scripts/get_maintainer -f arch/x86/lib/atomic64_32.c", the pattern
for "arch/x86/" does not match the directory depth of "arch/x86/lib"
so the MAINTAINERS entries and git history is used to produce:

$ ./scripts/get_maintainer.pl -f --rolestats arch/x86/lib/atomic64_32.c
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...)
"H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...,commit_signer:1/1=100%)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Luca Barbieri <luca@luca-barbieri.com> (commit_signer:1/1=100%)
linux-kernel@vger.kernel.org (open list)

Luca Barbieri is added because he signed the only commit to
arch/x86/lib/atomic64_32.c during the last year and he meets the
other default qualifications.
	--git-min-percent (default:10)
	--git-min-signatures (default:1)

If current users of ./scripts/get_maintainers.pl have scripts
that use --nogit that expect git history to be excluded, those
scripts should be updated to include --nogit-fallback or a
.get_maintainer.conf file should be created with --nogit-fallback.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 36e889f..ac20d58 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -24,9 +24,10 @@ my $email_maintainer = 1;
 my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
-my $email_git = 1;
+my $email_git = 0;
 my $email_git_all_signature_types = 0;
 my $email_git_blame = 0;
+my $email_git_fallback = 1;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
@@ -138,6 +139,7 @@ if (!GetOptions(
 		'git!' => \$email_git,
 		'git-all-signature-types!' => \$email_git_all_signature_types,
 		'git-blame!' => \$email_git_blame,
+		'git-fallback!' => \$email_git_fallback,
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
@@ -371,6 +373,7 @@ my @status = ();
 foreach my $file (@files) {
 
     my %hash;
+    my $exact_pattern_match = 0;
     my $tvi = find_first_section();
     while ($tvi < @typevalue) {
 	my $start = find_starting_index($tvi);
@@ -405,6 +408,8 @@ foreach my $file (@files) {
 			    my $value_pd = ($value =~ tr@/@@);
 			    my $file_pd = ($file  =~ tr@/@@);
 			    $value_pd++ if (substr($value,-1,1) ne "/");
+			    $value_pd = -1 if ($value =~ /^\.\*/);
+			    $exact_pattern_match = 1 if ($value_pd >= $file_pd);
 			    if ($pattern_depth == 0 ||
 				(($file_pd - $value_pd) < $pattern_depth)) {
 				$hash{$tvi} = $value_pd;
@@ -439,7 +444,8 @@ foreach my $file (@files) {
 	}
     }
 
-    if ($email && $email_git) {
+    if ($email &&
+	($email_git || ($email_git_fallback && !$exact_pattern_match))) {
 	vcs_file_signoffs($file);
     }
 
@@ -540,6 +546,7 @@ MAINTAINER field selection options:
     --git => include recent git \*-by: signers
     --git-all-signature-types => include signers regardless of signature type
         or use only ${signaturePattern} signers (default: $email_git_all_signature_types)
+    --git-fallback => use git when no exact MAINTAINERS pattern (default: $email_git_fallback)
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: $email_git_min_signatures)
     --git-max-maintainers => maximum maintainers to add (default: $email_git_max_maintainers)
-- 
1.7.3.rc1

