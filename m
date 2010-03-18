Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0CRRrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:47:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:28732 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0CRRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:47:22 -0400
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: [PATCH] scripts/bootgraph.pl: ignore times until the clock is running
Date: Thu, 18 Mar 2010 19:49:55 +0200
Message-Id: <1268934595-22544-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 18 Mar 2010 17:47:11.0060 (UTC) FILETIME=[094F6140:01CAC6C3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock used for printk.time=1 does not necessarily start running
from zero. On such platforms the bootgraph does not work properly as
the calculated boottime will be too long.

To correct this, the patch modifies the script to accept only non-zero
start times. This ensures the report contains entries only from the
period when the clock was running.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 scripts/bootgraph.pl |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index 12caa82..ec57dd4 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -44,7 +44,7 @@ my %end;
 my %type;
 my $done = 0;
 my $maxtime = 0;
-my $firsttime = 100;
+my $firsttime = undef;
 my $count = 0;
 my %pids;
 my %pidctr;
@@ -54,10 +54,12 @@ while (<>) {
 	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_\.]+)\+/) {
 		my $func = $2;
 		if ($done == 0) {
-			$start{$func} = $1;
+			my $time = $1;
+			next unless $time =~ /[1-9]/;
+			$start{$func} = $time;
 			$type{$func} = 0;
-			if ($1 < $firsttime) {
-				$firsttime = $1;
+			if (not defined $firsttime) {
+				$firsttime = $time;
 			}
 		}
 		if ($line =~ /\@ ([0-9]+)/) {
@@ -77,10 +79,12 @@ while (<>) {
 			$func = "wait_" . $pid . "_" . $pidctr{$pid};
 		}
 		if ($done == 0) {
-			$start{$func} = $1;
+			my $time = $1;
+			next unless $time =~ /[1-9]/;
+			$start{$func} = $time;
 			$type{$func} = 1;
-			if ($1 < $firsttime) {
-				$firsttime = $1;
+			if (not defined $firsttime) {
+				$firsttime = $time;
 			}
 		}
 		$pids{$func} = $pid;
-- 
1.5.6.5

