Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1GZB2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:28:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1GZBY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:28 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=-oWSxlIOik0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=9ciCiyK1mHrcaGtbbC4A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012425.839643162@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 06/19] ktest: Have wait on stdio honor bug timeout
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0006-ktest-Have-wait-on-stdio-honor-bug-timeout.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

After a bug is found, the STOP_AFTER_FAILURE timeout is used to
determine how much output should be printed before breaking out
of the monitor loop. This is to get things like call traces and
enough infromation about the bug to help determine what caused it.

The STOP_AFTER_FAILURE is usually much shorter than the TIMEOUT
that is used to determine when to quit after no more stdio is given.

But since the stdio read uses a wait on I/O, the STOP_AFTER_FAILURE is
only checked after we get something from I/O. But if the I/O does
not return any more data, we wait the TIMEOUT period instead, even
though we already triggered a bug report.

The wait on I/O should honor the STOP_AFTER_FAILURE time if a bug has
been found.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index aa442a9..1e1fe83 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -851,7 +851,16 @@ sub monitor {
 
     while (!$done) {
 
-	if ($booted) {
+	if ($bug && defined($stop_after_failure) &&
+	    $stop_after_failure >= 0) {
+	    my $time = $stop_after_failure - (time - $failure_start);
+	    $line = wait_for_input($monitor_fp, $time);
+	    if (!defined($line)) {
+		doprint "bug timed out after $booted_timeout seconds\n";
+		doprint "Test forced to stop after $stop_after_failure seconds after failure\n";
+		last;
+	    }
+	} elsif ($booted) {
 	    $line = wait_for_input($monitor_fp, $booted_timeout);
 	    if (!defined($line)) {
 		my $s = $booted_timeout == 1 ? "" : "s";
-- 
1.7.5.4


