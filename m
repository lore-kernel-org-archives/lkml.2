Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab1ETUYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:24:52 -0400
Received: from mail.perches.com ([173.55.12.10]:1794 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934278Ab1ETUYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:24:49 -0400
Subject: [PATCH] checkpatch: Suggest using min_t or max_t
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110520113830.3faf5230.akpm@linux-foundation.org>
References: <4DD50B35.2000005@indesign-llc.com>
	 <20110519115859.e11a7ca3.akpm@linux-foundation.org>
	 <1305909981.4209.33.camel@Joe-Laptop>
	 <20110520095037.25eadc0a.akpm@linux-foundation.org>
	 <1305912602.4209.41.camel@Joe-Laptop>
	 <20110520103529.1ef3917c.akpm@linux-foundation.org>
	 <1305915161.4209.56.camel@Joe-Laptop>
	 <20110520113830.3faf5230.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 13:24:48 -0700
Message-ID: <1305923088.4209.79.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common issue with min() or max() is using a cast on
one or both of the arguments when using min_t/max_t could
be better.

Add cast detection to uses of min/max and suggest an
appropriate use of min_t or max_t instead.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>

---

 scripts/checkpatch.pl |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..77a2743 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -268,6 +268,20 @@ sub build_types {
 }
 build_types();
 
+our $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
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
+		if ($line =~ /^\+.*\b(min|max)\s*\($Typecast{0,1}($LvalOrFunc)\s*,\s*$Typecast{0,1}($LvalOrFunc)\s*\)/) {
+			if (defined $2 || defined $7) {
+				my $call = $1;
+				my $cast1 = deparenthesize($2);
+				my $arg1 = $3;
+				my $cast2 = deparenthesize($7);
+				my $arg2 = $8;
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


