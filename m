Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1G1Ps6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:48:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab1G1Ps4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:48:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/40] UAPI: Add script to convert #include "..." to #include
 <path/...> in sys headers
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:48:21 +0100
Message-ID: <20110728154821.16519.38457.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a script to convert #include "..." to #include <path/...> in kernel system
headers.

Observations:

 (1) There are quite a lot of #includes of things like "linux/fs.h" which
     should really use <...>.  These are changed within include/ dirs.

 (2) Some referenced header files are missing for no obvious reason - pm2fb.h
     and via_drmclient.h for example.

 (3) The DRM video driving code uses -Iinclude/drm when it should probably
     just preface its header file names with drm/ in #include.  These are
     changed within include/drm/.

 (4) Under arch/cris/include/ there are some directories (arch-v10 and
     arch-v32) that should perhaps be renamed to arch/cris/arch-vXX/include.

     Similarly, under arch/sh/, arch/sh/include/mach-X/ should perhaps be
     arch/sh/boards/mach-X/include/.

     However, I've left these alone as they aren't really a problem.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/uapi-disintegration/system-headers.pl |  165 +++++++++++++++++++++++++
 1 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100755 scripts/uapi-disintegration/system-headers.pl

diff --git a/scripts/uapi-disintegration/system-headers.pl b/scripts/uapi-disintegration/system-headers.pl
new file mode 100755
index 0000000..c905568
--- /dev/null
+++ b/scripts/uapi-disintegration/system-headers.pl
@@ -0,0 +1,165 @@
+#!/usr/bin/perl -w
+
+use File::Find;
+
+my @sys_header_dirs = (
+    "include"
+    );
+
+#
+# Changes must be committed first
+#
+system("git diff --quiet") == 0 or die "Uncommitted changes; aborting\n";
+
+#
+# Delete the old patch under StGIT
+#
+system("stg delete uapi-convert-include-quote-to-angle.diff");
+
+#
+# Set up the patch under StGIT
+#
+system("stg new -m '" .
+       "UAPI: Convert #include \"...\" to #include <path/...> in kernel system headers\n" .
+       "\n" .
+       "Convert #include \"...\" to #include <path/...> in kernel system headers.\n" .
+       "\n" .
+       "scripts/uapi-disintegrate/system-headers.pl was used\n" .
+       "' --sign uapi-convert-include-quote-to-angle.diff"
+    ) == 0 or die;
+
+#
+# Find all the system header directories under arch
+#
+opendir DIR, "arch" or die;
+push @sys_header_dirs,
+    map { "arch/$_/include"; }
+sort grep { -d "arch/$_/include"; }
+grep { $_ !~ /^[.]/ }
+readdir DIR;
+closedir DIR;
+
+#
+# Find all the header files
+#
+%headers = ();
+sub find_header()
+{
+    $headers{$File::Find::name} = 1 if ($_ =~ /[.]h$/);
+}
+
+find(\&find_header, @sys_header_dirs);
+
+#print join("\n", sort keys %headers), "\n";
+
+foreach my $hdr (sort grep { $_ !~ m@arch/um/@} keys %headers) {
+    my $dir = $hdr;
+    $dir =~ m@(^.*/)@, $dir = $1;
+
+    open FD, '<', $hdr or die "open $hdr: $!\n";
+    my @lines = <FD>;
+    close FD or die;
+
+    my $printed_name = 0;
+    my $alter_header = 0;
+
+    for (my $l = 0; $l <= $#lines; $l++) {
+	my $line = $lines[$l];
+
+	if ($line =~ /^(#\s*include\s+)["]([^"]+)["](.*[\n])/) {
+	    #print $1, '@', $2, '@', $3;
+
+	    if (!$printed_name) {
+		#print "[[[ $hdr [\e[36m$dir\e[m] ]]]\n";
+		$printed_name = 1;
+	    }
+
+	    my $pre = $1;
+	    my $name = $2;
+	    my $post = $3;
+
+	    my $inc = undef;
+	    my $base = "??";
+	    my $path = "??";
+	    my $realpath = "??";
+	    my $do_existence_check = 1;
+
+	    if ($name eq "platform/acenv.h") {
+		# ACPI includes this relative to the current dir
+		$inc = $dir . $name;
+	    } elsif ($name =~ m@^[a-z].*/@) {
+		# We found something like "linux/foo.h" so just accept as is
+		$base = "";
+		$realpath = $path = $name;
+		$do_existence_check = 0;
+		goto no_disassemble;
+	    } elsif ($name =~ m@^[.][.]/@) {
+		# We found something like "../foo.h" so we jam the dir on the
+		# front and then remove "dir/.." pairs
+		$inc = $dir . $name;
+		while ($inc =~ m@[^/]*/[.][.]/@) {
+		    $inc =~ s@[^/]*/[.][.]/@@;
+		}
+	    } elsif ($name !~ m@/@) {
+		# We found something like "foo.h" so we again stick the dir on
+		# the front and then cut off the "include/" prefix.
+		if ($name =~ m@^drm_@) {
+		    # Unless it's a DRM header - the drm stuff adds
+		    # -Iinclude/drm to the build flags rather than use
+		    # <drm/foo.h> for some reason
+		    $inc = "include/drm/$name";
+		} else {
+		    $inc = $dir . $name;
+		}
+	    } else {
+		die "Don't handle \"$name\"\n";
+	    }
+
+	    $inc =~ m@(.*include/)(.*/[^/]*)@, $base = $1, $path = $2;
+
+	    $realpath = $path;
+	    if ($dir =~ m@^arch/cris/@ && $path =~ m@^arch-v[0-9]+/(arch/.*)@) {
+		$realpath = $1;
+	    } elsif ($dir =~ m@^arch/sh/@ && $path =~ m@^mach-[^/]+/(mach/.*)@) {
+		$realpath = $1;
+	    }
+
+	  no_disassemble:
+	    print $hdr, ": ", $name, " -> \e[36m", $base, "\e[m", $path;
+
+	    if ($do_existence_check && ! -f $inc) {
+		if (($hdr eq "arch/powerpc/include/asm/bootx.h" && $name eq "linux_type_defs.h") ||
+		    ($hdr eq "include/acpi/platform/acenv.h" && $name =~ /ac[a-z]*[0-9]*[.]h/) ||
+		    ($hdr eq "include/linux/jbd.h" && $name eq "jfs_compat.h") ||
+		    ($hdr eq "include/linux/jbd2.h" && $name eq "jfs_compat.h") ||
+		    ($hdr eq "include/video/cvisionppc.h" && $name eq "pm2fb.h") ||
+		    ($hdr eq "include/drm/via_drm.h" && $name eq "via_drmclient.h")
+		    ) {
+		    print " \e[33mnot present\e[m\n";
+		} else {
+		    print " \e[31mnot found\e[m\n";
+		    die;
+		}
+	    } else {
+		$lines[$l] = $pre . "<" . $realpath . ">" . $post;
+		$alter_header = 1;
+		print "\n";
+	    }
+	}
+    }
+
+    if ($alter_header) {
+	my $temp = $hdr . ".syshdr";
+	open FD, '>', $temp or die "create $temp: $!\n";
+	print FD @lines or die "write $temp: $!\n";
+	close FD or die "close $temp: $!\n";
+	rename $temp, $hdr or die "move $temp -> $hdr: $!\n";
+    }
+}
+
+#
+# Commit the changes
+#
+system("stg ref") == 0 or die;
+
+exit 0;

