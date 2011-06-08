Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1FHTeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:34:37 -0400
Received: from mail.perches.com ([173.55.12.10]:2641 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab1FHTee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:34:34 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: anish singh <anish198519851985@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Validate signature styles and To: and Cc: lines
Date: Wed,  8 Jun 2011 12:34:33 -0700
Message-Id: <100617f66cdceab04a87514d47929a4ec3aebc19.1307561278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc0
In-Reply-To: <BANLkTi=AFbSXzjRHuY=uBFz=64C6vWLwNA@mail.gmail.com>
References: <BANLkTi=AFbSXzjRHuY=uBFz=64C6vWLwNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signatures have many forms and can sometimes cause problems
if not in the correct format when using git send-email or quilt.

Try to verify the signature tags and email addresses to use
the generally accepted "Signed-off-by: Full Name <email@domain.tld>"
form.

Original-idea-by: anish kumar <anish198519851985@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   96 ++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 88 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8657f99..c8bde02 100755
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
@@ -341,6 +351,60 @@ sub top_of_kernel_tree {
 	return 1;
 }
 
+sub parse_email {
+	my ($formatted_email) = @_;
+
+	my $name = "";
+	my $address = "";
+
+	if ($formatted_email =~ /^([^<]+)<(.+\@.*)>.*$/) {
+		$name = $1;
+		$address = $2;
+	} elsif ($formatted_email =~ /^\s*<(\S+\@\S+)>.*$/) {
+		$address = $1;
+	} elsif ($formatted_email =~ /(\S+\@\S+)$/) {
+		$address = $1;
+		$formatted_email =~ s/$address.*$//;
+		$name = $formatted_email;
+	}
+
+	$name =~ s/^\s+|\s+$//g;
+	$name =~ s/^\"|\"$//g;
+	$address =~ s/^\s+|\s+$//g;
+	$address =~ s/^\<|\>$//g;
+	$address =~ s/\s//g;
+
+	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
+		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
+		$name = "\"$name\"";
+	}
+
+	return ($name, $address);
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
 
@@ -1365,17 +1429,33 @@ sub process {
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
+			if ($sign_off ne $ucfirst_sign_off) {
+				WARN("'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr);
+			}
+			if (!defined $space_after || $space_after ne " ") {
+				WARN("Use a single space after $ucfirst_sign_off\n" . $herecurr);
+			}
+			my $suggested_email = format_email(parse_email($email));
+			if ($suggested_email eq "") {
+				ERROR("email address '$email' is unrecognizable\n" . $herecurr);
+			} elsif ($suggested_email ne $email) {
+				WARN("email address '$email' might be better as '$suggested_email'\n" . $herecurr);
 			}
 		}
 
-- 
1.7.6.rc0

