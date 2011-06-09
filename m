Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1FIFpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:45:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2656 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1FIFpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:45:03 -0400
Subject: [PATCH V2] checkpatch: Validate signature styles and To: and Cc:
 lines
From: Joe Perches <joe@perches.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        anish singh <anish198519851985@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110608202408.GA20393@elliptictech.com>
References: <BANLkTi=AFbSXzjRHuY=uBFz=64C6vWLwNA@mail.gmail.com>
	 <100617f66cdceab04a87514d47929a4ec3aebc19.1307561278.git.joe@perches.com>
	 <20110608202408.GA20393@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 22:45:01 -0700
Message-ID: <1307598301.16453.25.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 23cfd1bbb676c9bf133038aee8c224ea83ec346b Mon Sep 17 00:00:00 2001
Message-Id: <23cfd1bbb676c9bf133038aee8c224ea83ec346b.1307598088.git.joe@perches.com>
From: Joe Perches <joe@perches.com>
Date: Wed, 8 Jun 2011 12:12:59 -0700
Subject: [PATCH] checkpatch: Validate signature styles and To: and Cc: lines

Signatures have many forms and can sometimes cause problems
if not in the correct format when using git send-email or quilt.

Try to verify the signature tags and email addresses to use
the generally accepted "Signed-off-by: Full Name <email@domain.tld>"
form.

Original-idea-by: anish kumar <anish198519851985@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Better email address validation.
    Don't complain about git-send-email "cc:" or "to:" email header lines
    Tested with all the patch descriptions in git.
    Seems to work well.

 scripts/checkpatch.pl |  123 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 115 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8657f99..ab65a16 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -216,6 +216,16 @@ our $logFunctions = qr{(?x:
 	MODULE_[A-Z_]+
 )};
 
+our $signature_tags = qr{(?xi:
+	Signed-off-by:|
+	Acked-by:|
+	Tested-by:|
+	Reviewed-by:|
+	Reported-by:|
+	To:|
+	Cc:
+)};
+
 our @typeList = (
 	qr{void},
 	qr{(?:unsigned\s+)?char},
@@ -341,6 +351,76 @@ sub top_of_kernel_tree {
 	return 1;
 }
 
+sub parse_email {
+	my ($formatted_email) = @_;
+
+	my $name = "";
+	my $address = "";
+	my $comment = "";
+
+	if ($formatted_email =~ /^(.*)<(\S+\@\S+)>(.*)$/) {
+		$name = $1;
+		$address = $2;
+		$comment = $3 if defined $3;
+	} elsif ($formatted_email =~ /^\s*<(\S+\@\S+)>(.*)$/) {
+		$address = $1;
+		$comment = $2 if defined $2;
+	} elsif ($formatted_email =~ /(\S+\@\S+)(.*)$/) {
+		$address = $1;
+		$comment = $2 if defined $2;
+		$formatted_email =~ s/$address.*$//;
+		$name = $formatted_email;
+		$name =~ s/^\s+|\s+$//g;
+		$name =~ s/^\"|\"$//g;
+		# If there's a name left after stripping spaces and
+		# leading quotes, and the address doesn't have both
+		# leading and trailing angle brackets, the address
+		# is invalid. ie:
+		#   "joe smith joe@smith.com" bad
+		#   "joe smith <joe@smith.com" bad
+		if ($name ne "" && $address !~ /^<[^>]+>$/) {
+			$name = "";
+			$address = "";
+			$comment = "";
+		}
+	}
+
+	$name =~ s/^\s+|\s+$//g;
+	$name =~ s/^\"|\"$//g;
+	$address =~ s/^\s+|\s+$//g;
+	$address =~ s/^\<|\>$//g;
+
+	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
+		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
+		$name = "\"$name\"";
+	}
+
+	return ($name, $address, $comment);
+}
+
+sub format_email {
+	my ($name, $address) = @_;
+
+	my $formatted_email;
+
+	$name =~ s/^\s+|\s+$//g;
+	$name =~ s/^\"|\"$//g;
+	$address =~ s/^\s+|\s+$//g;
+
+	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
+		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
+		$name = "\"$name\"";
+	}
+
+	if ("$name" eq "") {
+		$formatted_email = "$address";
+	} else {
+		$formatted_email = "$name <$address>";
+	}
+
+	return $formatted_email;
+}
+
 sub expand_tabs {
 	my ($str) = @_;
 
@@ -1365,17 +1445,44 @@ sub process {
 			}
 		}
 
-#check the patch for a signoff:
+# Check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
-			# This is a signoff, if ugly, so do not double report.
 			$signoff++;
-			if (!($line =~ /^\s*Signed-off-by:/)) {
-				WARN("Signed-off-by: is the preferred form\n" .
-					$herecurr);
+		}
+
+# Check signature styles
+		if ($line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
+			my $space_before = $1;
+			my $sign_off = $2;
+			my $space_after = $3;
+			my $email = $4;
+			my $ucfirst_sign_off = ucfirst(lc($sign_off));
+
+			if (defined $space_before && $space_before ne "") {
+				WARN("Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
 			}
-			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("space required after Signed-off-by:\n" .
-					$herecurr);
+			if ($sign_off =~ /-by:$/i && $sign_off ne $ucfirst_sign_off) {
+				WARN("'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr);
+			}
+			if (!defined $space_after || $space_after ne " ") {
+				WARN("Use a single space after $ucfirst_sign_off\n" . $herecurr);
+			}
+
+			my ($email_name, $email_address, $comment) = parse_email($email);
+			my $suggested_email = format_email(($email_name, $email_address));
+			if ($suggested_email eq "") {
+				ERROR("Unrecognized email address: '$email'\n" . $herecurr);
+			} else {
+				my $dequoted = $suggested_email;
+				$dequoted =~ s/^"//;
+				$dequoted =~ s/" </ </;
+				# Don't force email to have quotes
+				# Allow just an angle bracketed address
+				if ("$dequoted$comment" ne $email &&
+				    "<$email_address>$comment" ne $email &&
+				    "$suggested_email$comment" ne $email) {
+					WARN("email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
+				}
 			}
 		}
 
-- 
1.7.6.rc0



