Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2BWVXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:23:47 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64579 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2BWVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:23:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.229.114.220 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
From: Bobby Powers <bobbypowers@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, akpm@linux-foundation.org, airlied@linux.ie,
        Bobby Powers <bobbypowers@gmail.com>
Subject: [PATCH] headers_check: recursively search for linux/types.h inclusion
Date: Thu, 23 Feb 2012 16:23:41 -0500
Message-Id: <1330032221-1557-1-git-send-email-bobbypowers@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

headers_check.pl currently emits some spurious warnings, especially
for the drm headers, about using __[us]{8,16,32,64} types without
including linux/types.h.  Recursively search for types.h inclusion,
avoiding circular references.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
---
 scripts/headers_check.pl |   38 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 7957e7a..64ac238 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -19,6 +19,7 @@
 # 3) Check for leaked CONFIG_ symbols
 
 use strict;
+use File::Basename;
 
 my ($dir, $arch, @files) = @ARGV;
 
@@ -99,6 +100,39 @@ sub check_asm_types
 }
 
 my $linux_types;
+my %import_stack = ();
+sub check_include_typesh
+{
+	my $path = $_[0];
+	my $import_path;
+
+	my $fh;
+	my @file_paths = ($path, $dir . "/" .  $path, dirname($filename) . "/" . $path);
+	for my $possible ( @file_paths ) {
+	    if (not $import_stack{$possible} and open($fh, '<', $possible)) {
+		$import_path = $possible;
+		$import_stack{$import_path} = 1;
+		last;
+	    }
+	}
+	if (eof $fh) {
+	    return;
+	}
+
+	my $line;
+	while ($line = <$fh>) {
+		if ($line =~ m/^\s*#\s*include\s+<linux\/types.h>/) {
+			$linux_types = 1;
+			last;
+		}
+		if (my $included = ($line =~ /^\s*#\s*include\s+[<"](\S+)[>"]/)[0]) {
+			check_include_typesh($included);
+		}
+	}
+	close $fh;
+	delete $import_stack{$import_path};
+}
+
 sub check_sizetypes
 {
 	if ($filename =~ /types.h|int-l64.h|int-ll64.h/o) {
@@ -113,6 +147,9 @@ sub check_sizetypes
 		$linux_types = 1;
 		return;
 	}
+	if (my $included = ($line =~ /^\s*#\s*include\s+[<"](\S+)[>"]/)[0]) {
+		check_include_typesh($included);
+	}
 	if ($line =~ m/__[us](8|16|32|64)\b/) {
 		printf STDERR "$filename:$lineno: " .
 		              "found __[us]{8,16,32,64} type " .
@@ -122,4 +159,3 @@ sub check_sizetypes
 		#$ret = 1;
 	}
 }
-
-- 
1.7.7.6

