Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0EJE4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:56:23 -0400
Received: from mail.perches.com ([173.55.12.10]:2119 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0EJE4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:56:07 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Florian Mickler <florian@mickler.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scripts/get_maintainer.pl: add .get_maintainer.conf default options file
Date: Sun,  9 May 2010 21:56:03 -0700
Message-Id: <61106722b46cbf707d3e2641765aae2db93b6ea7.1273466698.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <1273396544-4189-1-git-send-email-florian@mickler.org>
References: <1273396544-4189-1-git-send-email-florian@mickler.org>
In-Reply-To: <cover.1273466698.git.joe@perches.com>
References: <cover.1273466698.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the use of a .get_maintainer.conf file to control the
default options applied when scripts/get_maintainer.pl is run.

.get_maintainer.conf can contain any valid command-line argument.

File contents are prepended to any additional command line arguments.

Multiple lines may be used, blank lines ignored, # is a comment.

Updated scripts/get_maintainer.pl version to 0.24

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index f66018d..b82ac95 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.23';
+my $V = '0.24';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -107,6 +107,30 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([0-9a-f]+):"
 );
 
+if (-f "${lk_path}.get_maintainer.conf") {
+    my @conf_args;
+    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
+	or warn "$P: Can't open .get_maintainer.conf: $!\n";
+    while (<$conffile>) {
+	my $line = $_;
+
+	$line =~ s/\s*\n?$//g;
+	$line =~ s/^\s*//g;
+	$line =~ s/\s+/ /g;
+
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
+
+	my @words = split(" ", $line);
+	foreach my $word (@words) {
+	    last if ($word =~ m/^#/);
+	    push (@conf_args, $word);
+	}
+    }
+    close($conffile);
+    unshift(@ARGV, @conf_args) if @conf_args;
+}
+
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
@@ -573,6 +597,11 @@ Notes:
           --git-min-signatures, --git-max-maintainers, --git-min-percent, and
           --git-blame
       Use --hg-since not --git-since to control date selection
+  File ".get_maintainer.conf", if it exists in the linux kernel source root
+      directory, can change whatever get_maintainer defaults are desired.
+      Entries in this file can be any command line argument.
+      This file is prepended to any additional command line arguments.
+      Multiple lines and # comments are allowed.
 EOT
 }
 
-- 
1.7.0.3.311.g6a6955

