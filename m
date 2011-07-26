Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1GZB2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:28:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1GZBY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:29 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=a93SwSrlLhkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1SNeGJNQfss_roUCbfEA:9 a=G2rsltM_fqSHtYH0bCQA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012426.083790429@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 07/19] ktest: Have LOG_FILE evaluate options as well
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0007-ktest-Have-LOG_FILE-evaluate-options-as-well.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The LOG_FILE variable needs to evaluate the $ options as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |  126 ++++++++++++++++++++++-------------------
 1 files changed, 68 insertions(+), 58 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 1e1fe83..83dcfaf 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -478,6 +478,69 @@ sub read_config {
     }
 }
 
+sub __eval_option {
+    my ($option, $i) = @_;
+
+    # Add space to evaluate the character before $
+    $option = " $option";
+    my $retval = "";
+
+    while ($option =~ /(.*?[^\\])\$\{(.*?)\}(.*)/) {
+	my $start = $1;
+	my $var = $2;
+	my $end = $3;
+
+	# Append beginning of line
+	$retval = "$retval$start";
+
+	# If the iteration option OPT[$i] exists, then use that.
+	# otherwise see if the default OPT (without [$i]) exists.
+
+	my $o = "$var\[$i\]";
+
+	if (defined($opt{$o})) {
+	    $o = $opt{$o};
+	    $retval = "$retval$o";
+	} elsif (defined($opt{$var})) {
+	    $o = $opt{$var};
+	    $retval = "$retval$o";
+	} else {
+	    $retval = "$retval\$\{$var\}";
+	}
+
+	$option = $end;
+    }
+
+    $retval = "$retval$option";
+
+    $retval =~ s/^ //;
+
+    return $retval;
+}
+
+sub eval_option {
+    my ($option, $i) = @_;
+
+    my $prev = "";
+
+    # Since an option can evaluate to another option,
+    # keep iterating until we do not evaluate any more
+    # options.
+    my $r = 0;
+    while ($prev ne $option) {
+	# Check for recursive evaluations.
+	# 100 deep should be more than enough.
+	if ($r++ > 100) {
+	    die "Over 100 evaluations accurred with $option\n" .
+		"Check for recursive variables\n";
+	}
+	$prev = $option;
+	$option = __eval_option($option, $i);
+    }
+
+    return $option;
+}
+
 sub _logit {
     if (defined($opt{"LOG_FILE"})) {
 	open(OUT, ">> $opt{LOG_FILE}") or die "Can't write to $opt{LOG_FILE}";
@@ -2079,6 +2142,10 @@ EOF
 }
 read_config $ktest_config;
 
+if (defined($opt{"LOG_FILE"})) {
+    $opt{"LOG_FILE"} = eval_option($opt{"LOG_FILE"}, -1);
+}
+
 # Append any configs entered in manually to the config file.
 my @new_configs = keys %entered_configs;
 if ($#new_configs >= 0) {
@@ -2147,70 +2214,13 @@ sub __set_test_option {
     return undef;
 }
 
-sub eval_option {
-    my ($option, $i) = @_;
-
-    # Add space to evaluate the character before $
-    $option = " $option";
-    my $retval = "";
-
-    while ($option =~ /(.*?[^\\])\$\{(.*?)\}(.*)/) {
-	my $start = $1;
-	my $var = $2;
-	my $end = $3;
-
-	# Append beginning of line
-	$retval = "$retval$start";
-
-	# If the iteration option OPT[$i] exists, then use that.
-	# otherwise see if the default OPT (without [$i]) exists.
-
-	my $o = "$var\[$i\]";
-
-	if (defined($opt{$o})) {
-	    $o = $opt{$o};
-	    $retval = "$retval$o";
-	} elsif (defined($opt{$var})) {
-	    $o = $opt{$var};
-	    $retval = "$retval$o";
-	} else {
-	    $retval = "$retval\$\{$var\}";
-	}
-
-	$option = $end;
-    }
-
-    $retval = "$retval$option";
-
-    $retval =~ s/^ //;
-
-    return $retval;
-}
-
 sub set_test_option {
     my ($name, $i) = @_;
 
     my $option = __set_test_option($name, $i);
     return $option if (!defined($option));
 
-    my $prev = "";
-
-    # Since an option can evaluate to another option,
-    # keep iterating until we do not evaluate any more
-    # options.
-    my $r = 0;
-    while ($prev ne $option) {
-	# Check for recursive evaluations.
-	# 100 deep should be more than enough.
-	if ($r++ > 100) {
-	    die "Over 100 evaluations accurred with $name\n" .
-		"Check for recursive variables\n";
-	}
-	$prev = $option;
-	$option = eval_option($option, $i);
-    }
-
-    return $option;
+    return eval_option($option, $i);
 }
 
 # First we need to do is the builds
-- 
1.7.5.4


