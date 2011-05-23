Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1EWNyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:54:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1EWNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:16 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Bf9LM9a78QAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=qElbTcKNFUMruBC7lO0A:9 a=EL01VTH7HNDg6uMqIFYA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110523135315.494798793@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 May 2011 09:51:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/6] ktest: Create variables for the ktest config files
References: <20110523135120.309567301@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Create-variables-for-the-ktest-config-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

I found that I constantly reuse information for each test case.
It would be nice to just define a variable to reuse.

For example I may have:

TEST_START
[...]
TEST = ssh root@mybox /path/to/my/script

TEST_START
[...]
TEST = ssh root@mybox /path/to/my/script

[etc]

The issue is, I may wont to change that script or one of the other
fields. Then I need to update each line individually.

With the addition of config variables (variables only used during parsing
the config) we can simplify the config files. These variables can
also be defined multiple times and each time the new value will
overwrite the old value.

The convention to use a config variable over a ktest option is to use :=
instead of =.

Now we could do:

USER := root
TARGET := mybox
TEST_SCRIPT := /path/to/my/script
TEST_CASE := ${USER}@${TARGET} ${TEST_SCRIPT}

TEST_START
[...]
TEST = ${TEST_CASE}

TEST_START
[...]
TEST = ${TEST_CASE}

[etc]

Now we just need to update the variables at the top.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   62 +++++++++++++++++++++++++++++++++++++++
 tools/testing/ktest/sample.conf |   59 +++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 65003a1..18ef668 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -114,6 +114,7 @@ my $successes = 0;
 
 my %entered_configs;
 my %config_help;
+my %variable;
 
 $config_help{"MACHINE"} = << "EOF"
  The machine hostname that you will test.
@@ -262,6 +263,39 @@ sub get_ktest_configs {
     }
 }
 
+sub process_variables {
+    my ($value) = @_;
+    my $retval = "";
+
+    # We want to check for '\', and it is just easier
+    # to check the previous characet of '$' and not need
+    # to worry if '$' is the first character. By adding
+    # a space to $value, we can just check [^\\]\$ and
+    # it will still work.
+    $value = " $value";
+
+    while ($value =~ /(.*?[^\\])\$\{(.*?)\}(.*)/) {
+	my $begin = $1;
+	my $var = $2;
+	my $end = $3;
+	# append beginning of value to retval
+	$retval = "$retval$begin";
+	if (defined($variable{$var})) {
+	    $retval = "$retval$variable{$var}";
+	} else {
+	    # put back the origin piece.
+	    $retval = "$retval\$\{$var\}";
+	}
+	$value = $end;
+    }
+    $retval = "$retval$value";
+
+    # remove the space added in the beginning
+    $retval =~ s/ //;
+
+    return "$retval"
+}
+
 sub set_value {
     my ($lvalue, $rvalue) = @_;
 
@@ -271,10 +305,22 @@ sub set_value {
     if ($rvalue =~ /^\s*$/) {
 	delete $opt{$lvalue};
     } else {
+	$rvalue = process_variables($rvalue);
 	$opt{$lvalue} = $rvalue;
     }
 }
 
+sub set_variable {
+    my ($lvalue, $rvalue) = @_;
+
+    if ($rvalue =~ /^\s*$/) {
+	delete $variable{$lvalue};
+    } else {
+	$rvalue = process_variables($rvalue);
+	$variable{$lvalue} = $rvalue;
+    }
+}
+
 sub read_config {
     my ($config) = @_;
 
@@ -387,6 +433,22 @@ sub read_config {
 		    $repeats{$val} = $repeat;
 		}
 	    }
+	} elsif (/^\s*([A-Z_\[\]\d]+)\s*:=\s*(.*?)\s*$/) {
+	    next if ($skip);
+
+	    my $lvalue = $1;
+	    my $rvalue = $2;
+
+	    # process config variables.
+	    # Config variables are only active while reading the
+	    # config and can be defined anywhere. They also ignore
+	    # TEST_START and DEFAULTS, but are skipped if they are in
+	    # on of these sections that have SKIP defined.
+	    # The save variable can be
+	    # defined multiple times and the new one simply overrides
+	    # the prevous one.
+	    set_variable($lvalue, $rvalue);
+
 	} else {
 	    die "$name: $.: Garbage found in config\n$_";
 	}
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 87bf92a..761079e 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -73,6 +73,65 @@
 # ktest will fail to execute, and no tests will run.
 #
 
+#### Config variables ####
+#
+# This config file can also contain "config variables".
+# These are assigned with ":=" instead of the ktest option
+# assigment "=".
+#
+# The difference between ktest options and config variables
+# is that config variables can be used multiple times,
+# where each instance will override the previous instance.
+# And that they only live at time of processing this config.
+#
+# The advantage to config variables are that they can be used
+# by any option or any other config variables to define thing
+# that you may use over and over again in the options.
+#
+# For example:
+#
+# USER      := root
+# TARGET    := mybox
+# TEST_CASE := ssh ${USER}@${TARGET} /path/to/my/test
+#
+# TEST_START
+# MIN_CONFIG = config1
+# TEST = ${TEST_CASE}
+#
+# TEST_START
+# MIN_CONFIG = config2
+# TEST = ${TEST_CASE}
+#
+# TEST_CASE := ssh ${USER}@${TARGET} /path/to/my/test2
+#
+# TEST_START
+# MIN_CONFIG = config1
+# TEST = ${TEST_CASE}
+#
+# TEST_START
+# MIN_CONFIG = config2
+# TEST = ${TEST_CASE}
+#
+# TEST_DIR := /home/me/test
+#
+# BUILD_DIR = ${TEST_DIR}/linux.git
+# OUTPUT_DIR = ${TEST_DIR}/test
+#
+# Note, the config variables are evaluated immediately, thus
+# updating TARGET after TEST_CASE has been assigned does nothing
+# to TEST_CASE.
+#
+# As shown in the example, to evaluate a config variable, you
+# use the ${X} convention. Simple $X will not work.
+#
+# If the config variable does not exist, the ${X} will not
+# be evaluated. Thus:
+#
+# MAKE_CMD = PATH=/mypath:${PATH} make
+#
+# If PATH is not a config variable, then the ${PATH} in
+# the MAKE_CMD option will be evaluated by the shell when
+# the MAKE_CMD option is passed into shell processing.
 
 #### Mandatory Default Options ####
 
-- 
1.7.4.4


