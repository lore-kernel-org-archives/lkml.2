Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1CHP0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:26:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab1CHPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:30 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=_rbhpJZD0XEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=VYA7YNalwNW5knJk97sA:9 a=H_YTBnxhGXGOOmFJHJIA:7 a=TuZHAkEpcNKNW0ggzKKj1lXi3XQA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152529.255662201@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/9] ktest: Monitor kernel while running of user tests
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0008-ktest-Monitor-kernel-while-running-of-user-tests.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Record the console of tests to both the console and the log.
Also, record the bug reports afte the test has completed.
Currently, if a kernel bug happens while running the userland
test, the test stops and will not record the kernel bug. This
makes it difficult to solve what happened.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 125ab94..8bbfcee 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1110,6 +1110,7 @@ sub do_run_test {
 
 	    # we are not guaranteed to get a full line
 	    $full_line .= $line;
+	    doprint $line;
 
 	    if ($full_line =~ /call trace:/i) {
 		$bug = 1;
@@ -1126,6 +1127,19 @@ sub do_run_test {
     } while (!$child_done && !$bug);
 
     if ($bug) {
+	my $failure_start = time;
+	my $now;
+	do {
+	    $line = wait_for_input($monitor_fp, 1);
+	    if (defined($line)) {
+		doprint $line;
+	    }
+	    $now = time;
+	    if ($now - $failure_start >= $stop_after_failure) {
+		last;
+	    }
+	} while (defined($line));
+
 	doprint "Detected kernel crash!\n";
 	# kill the child with extreme prejudice
 	kill 9, $child_pid;
-- 
1.7.2.3


