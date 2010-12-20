Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0LTJWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:22:19 -0500
Received: from mail.perches.com ([173.55.12.10]:2778 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab0LTJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:22:18 -0500
Subject: Re: [PATCH][RESEND] scripts: add no-warning option to the
 checkpatch script
From: Joe Perches <joe@perches.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, apw@canonical.com
In-Reply-To: <AANLkTi=WP9k_yqyvvJmy2ZW0ErO9Yt=jQjVvWQ_RGByv@mail.gmail.com>
References: <4D0DD027.4000507@gmail.com>
	 <1292813544.22702.342.camel@Joe-Laptop>
	 <AANLkTi=WP9k_yqyvvJmy2ZW0ErO9Yt=jQjVvWQ_RGByv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 01:22:17 -0800
Message-ID: <1292836937.22702.424.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 09:37 +0100, Marco Stornelli wrote:
> 2010/12/20 Joe Perches <joe@perches.com>:
> > Why do you think it's useful?
> To "debug" a patch from style point of view, I think it's useful to
> fix before the errors and then the warnings. So this option it's
> useful as a "filter". However, I added you in cc: because of a reply
> to my first patch that indicated you as a person interested in this
> scope.

Perhaps then it'd be better to filter/enable/disable
the 3 current categories of messages.

Maybe something like this:

 scripts/checkpatch.pl |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..467be6f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -22,7 +22,9 @@ my $tst_only;
 my $emacs = 0;
 my $terse = 0;
 my $file = 0;
-my $check = 0;
+my $emit_error = 1;
+my $emit_warn = 1;
+my $emit_chk = 0;
 my $summary = 1;
 my $mailback = 0;
 my $summary_file = 0;
@@ -45,7 +47,9 @@ Options:
   --emacs                    emacs compile window format
   --terse                    one line per report
   -f, --file                 treat FILE as regular source file
-  --subjective, --strict     enable more subjective tests
+  --errors                   print the errors found (default: 1=on, 0=off)
+  --warnings                 print the warnings found (default: 1=on, 0=off)
+  --subjective, --strict     print the subjective defects found (default: 0=off)
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
   --mailback                 only produce a report in case of warnings/errors
@@ -71,8 +75,10 @@ GetOptions(
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
 	'f|file!'	=> \$file,
-	'subjective!'	=> \$check,
-	'strict!'	=> \$check,
+	'errors!'	=> \$emit_error,
+	'warnings!'	=> \$emit_warn,
+	'subjective!'	=> \$emit_chk,
+	'strict!'	=> \$emit_chk,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -1102,19 +1108,19 @@ sub report_dump {
 	our @report;
 }
 sub ERROR {
-	if (report("ERROR: $_[0]\n")) {
+	if ($emit_error && report("ERROR: $_[0]\n")) {
 		our $clean = 0;
 		our $cnt_error++;
 	}
 }
 sub WARN {
-	if (report("WARNING: $_[0]\n")) {
+	if ($emit_warn && report("WARNING: $_[0]\n")) {
 		our $clean = 0;
 		our $cnt_warn++;
 	}
 }
 sub CHK {
-	if ($check && report("CHECK: $_[0]\n")) {
+	if ($emit_chk && report("CHECK: $_[0]\n")) {
 		our $clean = 0;
 		our $cnt_chk++;
 	}
@@ -2922,9 +2928,11 @@ sub process {
 	print report_dump();
 	if ($summary && !($clean == 1 && $quiet == 1)) {
 		print "$filename " if ($summary_file);
-		print "total: $cnt_error errors, $cnt_warn warnings, " .
-			(($check)? "$cnt_chk checks, " : "") .
-			"$cnt_lines lines checked\n";
+		print "total:" .
+			(($emit_error) ? " $cnt_error errors," : "") .
+			(($emit_warn) ? " $cnt_warn warnings," : "") .
+			(($emit_chk) ? " $cnt_chk checks," : "") .
+			" $cnt_lines lines checked\n";
 		print "\n" if ($quiet == 0);
 	}
 


