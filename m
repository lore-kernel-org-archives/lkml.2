Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2HaNSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:18:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab2HaNSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:35 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: mcgrof@gmail.com
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 4/4] scripts/checkincludes.pl: Introduce 'quiet' mode
Date: Fri, 31 Aug 2012 23:18:10 +1000
Message-Id: <1346419090-3808-5-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make checkincludes more like checkpatch in terms
of functionality, I have introduced a 'quiet' mode.

This mode can be turned on with the -q argument.

When not in quiet mode, each file that does not have duplicated
includes will have a message generated. Not having this is
sometimes annoying when performing checks on a single file
or directory without problems - "No output, does that mean it's
all good or I wrote the wrong command?"

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 scripts/checkincludes.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index cde7ce1..bff7316 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -20,11 +20,14 @@ By default, we just warn of duplicates.
 
 Options:
   -r                Remove duplicated includes in place
+  -q                Do not show messages for files that do not
+                    have duplicated includes
 EOM
 	exit 1;
 }
 
 my $remove = 0;
+my $quiet = 0;
 
 if ($#ARGV < 0) {
 	usage();
@@ -35,6 +38,8 @@ my $argc = 0;
 foreach my $arg (@ARGV) {
 	if ($arg eq "-r") {
 		$remove = 1;
+	} elsif($arg eq "-q") {
+		$quiet = 1;
 	} else {
 		open(my $f, '<', $arg)
 		    or die "Cannot open $arg: $!.\n";
@@ -54,11 +59,16 @@ foreach my $arg (@ARGV) {
 		close($f);
 
 		if (!$remove) {
+			my $detected = 0;
 			foreach my $filename (keys %includedfiles) {
 				if ($includedfiles{$filename} > 1) {
+					$detected++;
 					print "$arg: $filename is included more than once.\n";
 				}
 			}
+			if (!$detected && !$quiet) {
+				print "$arg: No duplicated includes detected.\n";
+			}
 			next;
 		}
 
@@ -84,6 +94,8 @@ foreach my $arg (@ARGV) {
 		}
 		if ($dups > 0) {
 			print "$arg: removed $dups duplicate includes \n";
+		} elsif (!$quiet) {
+			print "$arg: no duplicated includes to remove \n";
 		}
 		close($f);
 	}
-- 
1.7.9.5

