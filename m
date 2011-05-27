Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1E0AfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:35:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2092 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab1E0AfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:35:04 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] checkpatch: Suggest using min_t or max_t
Date: Thu, 26 May 2011 17:35:02 -0700
Message-Id: <7f59aa30d3af02ae522dc38105e51107e34826f2.1306455946.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.2.365.g5cfe4
In-Reply-To: <20110525165345.5f775c7b.akpm@linux-foundation.org>
References: <20110525165345.5f775c7b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common issue with min() or max() is using a cast on
one or both of the arguments when using min_t/max_t could
be better.

Add cast detection to uses of min/max and suggest an
appropriate use of min_t or max_t instead.

Caveat:  This only works for min() or max() on a single line.
         It does not find min() or max() split across multiple lines.

This does find:
	min((u32)foo, bar);
But it does not find:
	max((unsigned long)foo,
	    bar);

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
---

v2: Make $match_balanced_parentheses work in perl 5.8

 scripts/checkpatch.pl |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8657f99..897aff8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -268,6 +268,20 @@ sub build_types {
 }
 build_types();
 
+our $match_balanced_parentheses = qr/(\((?:[^\(\)]+|(-1))*\))/;
+
+our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
+our $LvalOrFunc	= qr{($Lval)\s*($match_balanced_parentheses{0,1})\s*};
+
+sub deparenthesize {
+	my ($string) = @_;
+	return "" if (!defined($string));
+	$string =~ s@^\s*\(\s*@@g;
+	$string =~ s@\s*\)\s*$@@g;
+	$string =~ s@\s+@ @g;
+	return $string;
+}
+
 $chk_signoff = 0 if ($file);
 
 my @dep_includes = ();
@@ -2285,6 +2299,27 @@ sub process {
 			}
 		}
 
+# typecasts on min/max could be min_t/max_t
+		if ($line =~ /^\+(?:.*?)\b(min|max)\s*\($Typecast{0,1}($LvalOrFunc)\s*,\s*$Typecast{0,1}($LvalOrFunc)\s*\)/) {
+			if (defined $2 || defined $8) {
+				my $call = $1;
+				my $cast1 = deparenthesize($2);
+				my $arg1 = $3;
+				my $cast2 = deparenthesize($8);
+				my $arg2 = $9;
+				my $cast;
+
+				if ($cast1 ne "" && $cast2 ne "") {
+					$cast = "$cast1 or $cast2";
+				} elsif ($cast1 ne "") {
+					$cast = $cast1;
+				} else {
+					$cast = $cast2;
+				}
+				WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
+			}
+		}
+
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
 			ERROR("space required before the open parenthesis '('\n" . $herecurr);
-- 
1.7.5.2.365.g5cfe4
