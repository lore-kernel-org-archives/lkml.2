Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1EWNxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:53:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab1EWNxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:17 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=3oCzxmNqH3gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1SNeGJNQfss_roUCbfEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Q0GrEUzttrIYAxC9:21 a=qLEEeFaFI1wuO5cL:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110523135315.817306035@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 May 2011 09:51:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/6] ktest: Allow options to be used by other options
References: <20110523135120.309567301@goodmis.org>
Content-Disposition: inline; filename=0006-ktest-Allow-options-to-be-used-by-other-options.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are cases where one ktest option may be used within another
ktest option. Allow them to be reused just like config variables
but there are evaluated at time of test not config processing time.

Thus having something like:

MAKE_CMD = make ARCH=${ARCH}

TEST_START
ARCH = powerpc

TEST_START
ARCH = arm

Will have the arch defined for each test iteration.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   68 ++++++++++++++++++++++++++++++++++++++-
 tools/testing/ktest/sample.conf |   30 +++++++++++++++++
 2 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 18ef668..1fd29b2 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2019,7 +2019,7 @@ for (my $i = 0, my $repeat = 1; $i <= $opt{"NUM_TESTS"}; $i += $repeat) {
     }
 }
 
-sub set_test_option {
+sub __set_test_option {
     my ($name, $i) = @_;
 
     my $option = "$name\[$i\]";
@@ -2045,6 +2045,72 @@ sub set_test_option {
     return undef;
 }
 
+sub eval_option {
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
+sub set_test_option {
+    my ($name, $i) = @_;
+
+    my $option = __set_test_option($name, $i);
+    return $option if (!defined($option));
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
+	    die "Over 100 evaluations accurred with $name\n" .
+		"Check for recursive variables\n";
+	}
+	$prev = $option;
+	$option = eval_option($option, $i);
+    }
+
+    return $option;
+}
+
 # First we need to do is the builds
 for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 761079e..48cbcc80 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -133,6 +133,36 @@
 # the MAKE_CMD option will be evaluated by the shell when
 # the MAKE_CMD option is passed into shell processing.
 
+#### Using options in other options ####
+#
+# Options that are defined in the config file may also be used
+# by other options. All options are evaulated at time of
+# use (except that config variables are evaluated at config
+# processing time).
+#
+# If an ktest option is used within another option, instead of
+# typing it again in that option you can simply use the option
+# just like you can config variables.
+#
+# MACHINE = mybox
+#
+# TEST = ssh root@${MACHINE} /path/to/test
+#
+# The option will be used per test case. Thus:
+#
+# TEST_TYPE = test
+# TEST = ssh root@{MACHINE}
+#
+# TEST_START
+# MACHINE = box1
+#
+# TEST_START
+# MACHINE = box2
+#
+# For both test cases, MACHINE will be evaluated at the time
+# of the test case. The first test will run ssh root@box1
+# and the second will run ssh root@box2.
+
 #### Mandatory Default Options ####
 
 # These options must be in the default section, although most
-- 
1.7.4.4


