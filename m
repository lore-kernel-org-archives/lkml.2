Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1GSScc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:32:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39837 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GSScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:32:31 -0400
Date: Tue, 19 Jul 2011 21:30:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: joe@perches.com
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [patch] Add scripts/rename_review.pl
Message-ID: <20110719183023.GB6445@shale.localdomain>
References: <1310959183-24787-1-git-send-email-Larry.Finger@lwfinger.net>
 <1310959183-24787-2-git-send-email-Larry.Finger@lwfinger.net>
 <1310961230.2286.45.camel@Joe-Laptop>
 <4E244436.7040302@lwfinger.net>
 <20110718171812.GB4010@shale.localdomain>
 <1311013831.2286.116.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311013831.2286.116.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename_review.pl is a tool for reviewing refactoring patches that
rename variables.  You pipe a diff to it, and it strips out the
renames and the white space changes and leaves the more complicated
and interesting code changes.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/scripts/rename_review.pl b/scripts/rename_review.pl
new file mode 100755
index 0000000..2cc7b6f
--- /dev/null
+++ b/scripts/rename_review.pl
@@ -0,0 +1,154 @@
+#!/usr/bin/perl
+
+# This is a tool to help review variable rename patches. The goal is
+# to strip out the automatic sed renames and the white space changes
+# and leaves the interesting code changes.
+#
+# Example 1: A patch renames openInfo to open_info:
+#     cat diff | rename_review.pl openInfo open_info
+#
+# Example 2: A patch swaps the first two arguments to some_func():
+#     cat diff | rename_review.pl \
+#                    -e 's/some_func\((.*?),(.*?),/some_func\($2, $1,/'
+#
+# Example 3: A patch removes the xkcd_ prefix from some but not all the
+# variables.  Instead of trying to figure out which variables were renamed
+# just remove the prefix from them all:
+#     cat diff | rename_review.pl -ea 's/xkcd_//g'
+#
+# Example 4: A patch renames 20 CamelCase variables.  To review this let's
+# just ignore all case changes and all '_' chars.
+#     cat diff | rename_review -ea 'tr/[A-Z]/[a-z]/' -ea 's/_//g'
+#
+# The other arguments are:
+# -nc removes comments
+# -ns removes '\' chars if they are at the end of the line.
+
+use strict;
+use File::Temp qw/ :mktemp  /;
+
+sub usage() {
+    print "usage: cat diff | $0 old new old new old new...\n";
+    print "   or: cat diff | $0 -e 's/old/new/g'\n";
+    print " -e : execute on old lines\n";
+    print " -ea: execute on all lines\n";
+    print " -nc: strip one line comments\n";
+    print " -ns: no slashes at the end of a line\n";
+    exit(1);
+}
+my @subs;
+my @cmds;
+my $strip_comments;
+my $strip_slashes;
+
+sub filter($) {
+    my $_ = shift();
+    my $old = 0;
+    if ($_ =~ /^-/) {
+        $old = 1;
+    }
+    # remove the first char
+    s/^[ +-]//;
+    if ($strip_comments) {
+        s/\/\*.*?\*\///g;
+        s/\/\/.*//;
+    }
+    foreach my $cmd (@cmds) {
+        if ($old || $cmd->[0] =~ /^-ea$/) {
+		eval $cmd->[1];
+	}
+    }
+    foreach my $sub (@subs) {
+	if ($old) {
+		s/$sub->[0]/$sub->[1]/g;
+	}
+    }
+    return $_;
+}
+
+while (my $param1 = shift()) {
+    if ($param1 =~ /^-nc$/) {
+        $strip_comments = 1;
+        next;
+    }
+    if ($param1 =~ /^-ns$/) {
+        $strip_slashes = 1;
+        next;
+    }
+    my $param2 = shift();
+    if ($param2 =~ /^$/) {
+	usage();
+    }
+    if ($param1 =~ /^-e(a|)$/) {
+        push @cmds, [$param1, $param2];
+	next;
+    }
+    push @subs, [$param1, $param2];
+}
+
+my ($oldfh, $oldfile) = mkstemp("/tmp/oldXXXXX");
+my ($newfh, $newfile) = mkstemp("/tmp/newXXXXX");
+
+while (<>) {
+    if ($_ =~ /^(---|\+\+\+)/) {
+	next;
+    }
+    my $output = filter($_);
+    if ($_ =~ /^-/) {
+	print $oldfh $output;
+	next;
+    }
+    if ($_ =~ /^\+/) {
+	print $newfh $output;
+	next;
+    }
+    print $oldfh $output;
+    print $newfh $output;
+}
+
+my $hunk;
+my $old_txt;
+my $new_txt;
+
+open diff, "diff -uw $oldfile $newfile |";
+while (<diff>) {
+    if ($_ =~ /^(---|\+\+\+)/) {
+	next;
+    }
+
+    if ($_ =~ /^@/) {
+	if ($old_txt ne $new_txt) {
+ 	    print $hunk;
+	    print $_;
+	}
+	$hunk = "";
+	$old_txt = "";
+	$new_txt = "";
+	next;
+    }
+
+    $hunk = $hunk . $_;
+
+    if ($strip_slashes) {
+	s/\\$//;
+    }
+
+    if ($_ =~ /^-/) {
+	s/-//;
+	s/[ \t\n]//g;
+	$old_txt = $old_txt . $_;
+	next;
+    }
+    if ($_ =~ /^\+/) {
+	s/\+//;
+	s/[ \t\n]//g;
+	$new_txt = $new_txt . $_;
+	next;
+    }
+}
+if ($old_txt ne $new_txt) {
+    print $hunk;
+}
+
+unlink($oldfile);
+unlink($newfile);

