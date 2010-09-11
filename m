Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab0IKVWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 17:22:04 -0400
Received: from mail.perches.com ([173.55.12.10]:1704 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab0IKVWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 17:22:02 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100910095259.GC23903@sirena.org.uk>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910095259.GC23903@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 14:22:00 -0700
Message-ID: <1284240120.12180.111.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 10:53 +0100, Mark Brown wrote:
> On Fri, Sep 10, 2010 at 02:42:47AM -0700, Joe Perches wrote:
> > As the coverage of file patterns in MAINTAINERS is
> > now pretty good, the --git results are less useful.
> It's pretty good for subsystems and PC drivers but for embedded stuff it
> is much more patchy and fairly unlikely to find someone who actually
> knows about the specific hardware.
> > I'd much rather turn off --git as a default, or change
> > get_maintainers to add git signers only when there's no
> > specifically listed maintainer for a particular file.
> OTOH I'd still be somewhat in favour of this purely on the basis that
> the default results have way too many false positives.

Maybe something like this?

Add --git-fallback default enabled to add commit signers
only when there's no specifically listed maintainer.

Change --git default to off

 scripts/get_maintainer.pl |   41 +++++++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index a91ae63..0c4de78 100755
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
+    my $has_exact_pd = 0;
     my $tvi = find_first_section();
     while ($tvi < @typevalue) {
 	my $start = find_starting_index($tvi);
@@ -405,6 +408,7 @@ foreach my $file (@files) {
 			    my $value_pd = ($value =~ tr@/@@);
 			    my $file_pd = ($file  =~ tr@/@@);
 			    $value_pd++ if (substr($value,-1,1) ne "/");
+			    $has_exact_pd = 1 if ($file_pd == $value_pd);
 			    if ($pattern_depth == 0 ||
 				(($file_pd - $value_pd) < $pattern_depth)) {
 				$hash{$tvi} = $value_pd;
@@ -420,26 +424,26 @@ foreach my $file (@files) {
 
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	add_categories($line);
-	    if ($sections) {
-		my $i;
-		my $start = find_starting_index($line);
-		my $end = find_ending_index($line);
-		for ($i = $start; $i < $end; $i++) {
-		    my $line = $typevalue[$i];
-		    if ($line =~ /^[FX]:/) {		##Restore file patterns
-			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
-			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
-			$line =~ s/\\\./\./g;       	##Convert \. to .
-			$line =~ s/\.\*/\*/g;       	##Convert .* to *
-		    }
-		    $line =~ s/^([A-Z]):/$1:\t/g;
-		    print("$line\n");
+	if ($sections) {
+	    my $i;
+	    my $start = find_starting_index($line);
+	    my $end = find_ending_index($line);
+	    for ($i = $start; $i < $end; $i++) {
+		my $line = $typevalue[$i];
+		if ($line =~ /^[FX]:/) {		##Restore file patterns
+		    $line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+		    $line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+		    $line =~ s/\\\./\./g;       	##Convert \. to .
+		    $line =~ s/\.\*/\*/g;       	##Convert .* to *
 		}
-		print("\n");
+		$line =~ s/^([A-Z]):/$1:\t/g;
+		print("$line\n");
 	    }
+	    print("\n");
+	}
     }
 
-    if ($email && $email_git) {
+    if ($email && ($email_git || ($email_git_fallback && !$has_exact_pd))) {
 	vcs_file_signoffs($file);
     }
 
@@ -540,6 +544,7 @@ MAINTAINER field selection options:
     --git => include recent git \*-by: signers
     --git-all-signature-types => include signers regardless of signature type
         or use only ${signaturePattern} signers (default: $email_git_all_signature_types)
+    --git-fallback => use git when no exact MAINTAINERS pattern (default: $email_git_fallback)
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: $email_git_min_signatures)
     --git-max-maintainers => maximum maintainers to add (default: $email_git_max_maintainers)
@@ -568,7 +573,7 @@ Output type options:
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --keywords => scan patch for keywords (default: 1 (on))
-  --sections => print the entire subsystem sections with pattern matches
+  --sections => only print the entire subsystem sections with pattern matches
   --version => show version
   --help => show this help information
 


