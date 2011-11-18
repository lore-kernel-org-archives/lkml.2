Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab1KRLjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:39:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63110 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab1KRLg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:36:58 -0500
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 2/3] ktest: check parent options for a repeated test
Date: Fri, 18 Nov 2011 17:05:30 +0530
Message-Id: <1321616131-21352-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321616131-21352-1-git-send-email-rabin@rab.in>
References: <1321616131-21352-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's say we have "OUTPUT_DIR = build/${TEST_NAME}", and we're iterating
a test.  In the second iteration of a test, the TEST_NAME of the test
we're repeating is not used.  Instead, ${TEST_NAME} appears literally:

   touch /home/rabin/kernel/test/build/${TEST_NAME}/.config ... SUCCESS

Fix this by making __eval_option() check the parent test options
for a repeated test.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 tools/testing/ktest/ktest.pl |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 3185e0a..e93c21c 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -748,6 +748,18 @@ sub __eval_option {
     # Add space to evaluate the character before $
     $option = " $option";
     my $retval = "";
+    my $repeated = 0;
+    my $parent = 0;
+
+    foreach my $test (keys %repeat_tests) {
+	if ($i >= $test &&
+	    $i < $test + $repeat_tests{$test}) {
+
+	    $repeated = 1;
+	    $parent = $test;
+	    last;
+	}
+    }
 
     while ($option =~ /(.*?[^\\])\$\{(.*?)\}(.*)/) {
 	my $start = $1;
@@ -761,10 +773,14 @@ sub __eval_option {
 	# otherwise see if the default OPT (without [$i]) exists.
 
 	my $o = "$var\[$i\]";
+	my $parento = "$var\[$parent\]";
 
 	if (defined($opt{$o})) {
 	    $o = $opt{$o};
 	    $retval = "$retval$o";
+	} elsif ($repeated && defined($opt{$parento})) {
+	    $o = $opt{$parento};
+	    $retval = "$retval$o";
 	} elsif (defined($opt{$var})) {
 	    $o = $opt{$var};
 	    $retval = "$retval$o";
-- 
1.7.7.3

