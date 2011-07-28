Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1G1PzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab1G1PzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:55:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 32/40] UAPI: Add a script to create a commit to set up new
 UAPI dirs [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:54:24 +0100
Message-ID: <20110728155424.16618.81588.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a script to create and set up new UAPI dirs and then commit them to GIT or
StGIT:

	scripts/uapi-disintegration/set-up-Kbuild.pl

Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/uapi-disintegration/set-up-Kbuild.pl |  107 ++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100755 scripts/uapi-disintegration/set-up-Kbuild.pl

diff --git a/scripts/uapi-disintegration/set-up-Kbuild.pl b/scripts/uapi-disintegration/set-up-Kbuild.pl
new file mode 100755
index 0000000..6e497fb
--- /dev/null
+++ b/scripts/uapi-disintegration/set-up-Kbuild.pl
@@ -0,0 +1,107 @@
+#!/usr/bin/perl -w
+
+use File::Find;
+use File::Path;
+use strict;
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
+system("stg delete uapi-set-up-Kbuild.diff");
+
+#
+# Set up the patch under StGIT
+#
+system("stg new -m '" .
+       "UAPI: Set up UAPI Kbuild files\n" .
+       "\n" .
+       "Set up empty UAPI Kbuild files to be populated by the header splitter using\n" .
+       "scripts/uapi-disintegrate/set-up-Kbuild.pl\n" .
+       "' --sign uapi-set-up-Kbuild.diff"
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
+my %kbuilds = ();
+sub find_Kbuild()
+{
+    $kbuilds{$File::Find::name} = 1 if ($_ =~ /Kbuild$/);
+}
+
+find(\&find_Kbuild, @sys_header_dirs);
+
+#print join("\n", sort keys %kbuilds), "\n";
+
+foreach my $kbuild (sort grep { $_ !~ m@arch/um/@} keys %kbuilds) {
+
+    my $uapi_kbuild = $kbuild;
+    $uapi_kbuild =~ s@include/@include/uapi/@;
+
+    print "[[[ $uapi_kbuild ]]]\n";
+
+    open FD, '<', $kbuild or die "open $kbuild: $!\n";
+    my @old = <FD>;
+    close FD or die;
+
+    my @new = ();
+
+    if ($#old > -1) {
+	if ($old[0] =~ /^#/) {
+	    for (my $l = 0; $l <= $#old; $l++) {
+		last if ($old[$l] !~ /^#/);
+		push @new, $old[$l];
+	    }
+	    push @new, "\n";
+	}
+
+	push @new, map {
+	    my $x = $_;
+	    $x =~ s@include/@include/uapi/@;
+	    $x;
+	} grep { $_ =~ m@^include@; } @old;
+
+	push @new, "\n" if ($#new > -1);
+
+	push @new, grep { $_ =~ m@header-y\s+[+]=\s+[a-z0-9A-Z-]+/\s*@; } @old;
+    }
+
+    #print @new;
+
+    my $uapidir = $uapi_kbuild;
+    $uapidir = $1 if ($uapidir =~ m!(.*)/!);
+    mkpath($uapidir) if (! -d $uapidir);
+
+    open FD, '>', $uapi_kbuild or die "create $uapi_kbuild: $!\n";
+    print FD "# UAPI Header export list\n" or die "write $uapi_kbuild: $!\n";
+    print FD @new or die "write $uapi_kbuild: $!\n";
+    close FD or die "close $uapi_kbuild: $!\n";
+    system("stg add $uapi_kbuild") == 0 or die;
+}
+
+#
+# Commit the changes
+#
+system("stg ref") == 0 or die;
+
+exit 0;

