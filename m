Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2HaNSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:18:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2HaNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:29 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: mcgrof@gmail.com
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 2/4] scripts/checkincludes.pl: Simplify and shorten argument logic
Date: Fri, 31 Aug 2012 23:18:08 +1000
Message-Id: <1346419090-3808-3-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows for much easier implementation of arguments
when modifying checkincludes.pl

The variable $file is also initially named $arg - I wasn't sure
if memory would be a problem (I know it would be in Java/C#) if
another $file variable was initialized with the value of $arg,
so I just left it.

Overall, this still works nicely. There are some more
potential simplifications, but I will cover those in another
patch if I decide to implement them tonight.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 scripts/checkincludes.pl |   85 +++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 46 deletions(-)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 801ed5f..7d713c2 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -30,64 +30,57 @@ if ($#ARGV < 0) {
 	usage();
 }
 
-if ($#ARGV >= 1) {
-	if ($ARGV[0] =~ /^-/) {
-		if ($ARGV[0] eq "-r") {
-			$remove = 1;
-			shift;
-		} else {
-			usage();
-		}
-	}
-}
+foreach my $arg (@ARGV) {
+	if ($arg eq "-r") {
+		$remove = 1;
+	} else {
+		open(my $f, '<', $arg)
+		    or die "Cannot open $arg: $!.\n";
 
-foreach my $file (@ARGV) {
-	open(my $f, '<', $file)
-	    or die "Cannot open $file: $!.\n";
+		my %includedfiles = ();
+		my @file_lines = ();
 
-	my %includedfiles = ();
-	my @file_lines = ();
-
-	while (<$f>) {
-		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
-			++$includedfiles{$1};
+		while (<$f>) {
+			if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
+				++$includedfiles{$1};
+			}
+			push(@file_lines, $_);
 		}
-		push(@file_lines, $_);
-	}
 
-	close($f);
+		close($f);
 
-	if (!$remove) {
-		foreach my $filename (keys %includedfiles) {
-			if ($includedfiles{$filename} > 1) {
-				print "$file: $filename is included more than once.\n";
+		if (!$remove) {
+			foreach my $filename (keys %includedfiles) {
+				if ($includedfiles{$filename} > 1) {
+					print "$arg: $filename is included more than once.\n";
+				}
 			}
+			next;
 		}
-		next;
-	}
 
-	open($f, '>', $file)
-	    or die("Cannot write to $file: $!");
+		open($f, '>', $arg)
+			or die("Cannot write to $arg: $!");
 
-	my $dups = 0;
-	foreach (@file_lines) {
-		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
-			foreach my $filename (keys %includedfiles) {
-				if ($1 eq $filename) {
-					if ($includedfiles{$filename} > 1) {
-						$includedfiles{$filename}--;
-						$dups++;
-					} else {
-						print {$f} $_;
+		my $dups = 0;
+		foreach(@file_lines) {
+			if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
+				foreach my $filename (keys %includedfiles) {
+					if ($1 eq $filename) {
+						if ($includedfiles{$filename} > 1) {
+							$includedfiles{$filename}--;
+							$dups++;
+						} else {
+							print {$f} $_;
+						}
 					}
 				}
+			} else {
+				print {$f} $_;
 			}
-		} else {
-			print {$f} $_;
 		}
+		if ($dups > 0) {
+			print "$arg: removed $dups duplicate includes \n";
+		}
+		close($f);
 	}
-	if ($dups > 0) {
-		print "$file: removed $dups duplicate includes\n";
-	}
-	close($f);
 }
-- 
1.7.9.5

