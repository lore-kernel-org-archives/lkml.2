Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab2LHU0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 15:26:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38160 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375Ab2LHU0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 15:26:36 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] checkpatch: Warn on CamelCase variable names
Date: Sat,  8 Dec 2012 12:26:15 -0800
Message-Id: <da2f998bd07cecaaa84540f0a3b0cb735324259f.1354998301.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <0b287cacc469535c55296c22acb18f0df3a0c45d.1354998301.git.joe@perches.com>
References: <0b287cacc469535c55296c22acb18f0df3a0c45d.1354998301.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the camelcase variables in a hash and only emit a
warning on the first use of each new variable.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index acf5045..5396345 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1398,6 +1398,8 @@ sub process {
 	my %suppress_export;
 	my $suppress_statement = 0;
 
+	my %camelcase = ();
+
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
 	#
@@ -2905,12 +2907,17 @@ sub process {
 			}
 		}
 
-#studly caps, commented out until figure out how to distinguish between use of existing and adding new
-#		if (($line=~/[\w_][a-z\d]+[A-Z]/) and !($line=~/print/)) {
-#		    print "No studly caps, use _\n";
-#		    print "$herecurr";
-#		    $clean = 0;
-#		}
+#CamelCase
+		while ($line =~ m{($Constant|$Lval)}g) {
+			my $var = $1;
+			if ($var !~ /$Constant/ &&
+			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    !defined $camelcase{$var}) {
+				$camelcase{$var} = 1;
+				WARN("CAMELCASE",
+				     "Avoid CamelCase: <$var>\n" . $herecurr);
+			}
+		}
 
 #no spaces allowed after \ in define
 		if ($line=~/\#\s*define.*\\\s$/) {
-- 
1.7.8.112.g3fd21

