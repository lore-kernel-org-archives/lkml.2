Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1G1P6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab1G1Pu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/40] UAPI: Add script to audit drivers/gpu/ for #including
 system headers with "..." [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:49:50 +0100
Message-ID: <20110728154950.16618.50033.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a script to audit drivers/gpu/ for #include "..." referring to system
headers and change them to <...>.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/uapi-disintegration/drm-headers.pl |  103 ++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100755 scripts/uapi-disintegration/drm-headers.pl

diff --git a/scripts/uapi-disintegration/drm-headers.pl b/scripts/uapi-disintegration/drm-headers.pl
new file mode 100755
index 0000000..eab3eab
--- /dev/null
+++ b/scripts/uapi-disintegration/drm-headers.pl
@@ -0,0 +1,103 @@
+#!/usr/bin/perl -w
+
+use File::Find;
+
+#
+# Changes must be committed first
+#
+system("git diff --quiet") == 0 or die "Uncommitted changes; aborting\n";
+
+#
+# Delete the old patch under StGIT
+#
+system("stg delete uapi-convert-drivers_gpu-includes.diff");
+
+#
+# Set up the patch under StGIT
+#
+system("stg new -m '" .
+       "UAPI: Convert #include \"...\" to #include <path/...> in kernel system headers\n" .
+       "\n" .
+       "Convert #include \"...\" to #include <path/...> in kernel system headers.\n" .
+       "\n" .
+       "scripts/uapi-disintegrate/drm-headers.pl was used\n" .
+       "' --sign uapi-convert-drivers_gpu-includes.diff"
+    ) == 0 or die;
+
+#
+# Find all the .c and .h files under drivers/gpu/
+#
+%files = ();
+sub find_file()
+{
+    $files{$File::Find::name} = 1 if ($_ =~ /[.][ch]$/);
+}
+
+find(\&find_file, "drivers/gpu");
+
+#print join("\n", sort keys %files), "\n";
+
+foreach my $file (sort keys %files) {
+    my $dir = $file;
+    $dir =~ m@(^.*/)@, $dir = $1;
+
+    open FD, '<', $file or die "open $file: $!\n";
+    my @lines = <FD>;
+    close FD or die;
+
+    my $printed_name = 0;
+    my $alter_file = 0;
+
+    for (my $l = 0; $l <= $#lines; $l++) {
+	my $line = $lines[$l];
+
+	if ($line =~ /^(#\s*include\s+)["]([^"]+)["](.*[\n])/) {
+	    my $pre = $1;
+	    my $name = $2;
+	    my $post = $3;
+
+	    # If the included file really is in this directory, then "..." is
+	    # correct.
+	    next if (-f $dir.$2);
+
+	    if (!$printed_name) {
+		print "[[[ \e[36m$file\e[m ]]]\n";
+		$printed_name = 1;
+	    }
+
+	    my $path = "??";
+
+	    if ($name =~ m@[.][.]@) {
+		die;
+	    } else {
+		# Look in the system include paths for it
+		if (-f "include/$name") {
+		    $path = $name;
+		} elsif (-f "include/drm/$name") {
+		    $path = "drm/$name";
+		} else {
+		    die;
+		}
+	    }
+
+	    print $file, ": ", $name, " -> ", $path, "\n";
+	    $lines[$l] = $pre . "<" . $path . ">" . $post;
+	    $alter_file = 1;
+	}
+    }
+
+    if ($alter_file) {
+	my $temp = $file . ".drminc";
+	open FD, '>', $temp or die "create $temp: $!\n";
+	print FD @lines or die "write $temp: $!\n";
+	close FD or die "close $temp: $!\n";
+	rename $temp, $file or die "move $temp -> $file: $!\n";
+    }
+}
+
+#
+# Commit the changes
+#
+system("stg ref") == 0 or die;
+
+exit 0;

