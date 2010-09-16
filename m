Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0IPMLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:11:21 -0400
Received: from mail.perches.com ([173.55.12.10]:2086 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab0IPMLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:11:14 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] scripts/get_maintainer.pl: Use .get_maintainer.conf from . then $HOME then scripts
Date: Thu, 16 Sep 2010 05:11:12 -0700
Message-Id: <58b5b260aeb56bce71c1ad739fe0cd6df24587d9.1284636516.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284636516.git.joe@perches.com>
References: <cover.1284636516.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 00:01 -0400, Valdis.Kletnieks@vt.edu wrote:
> Any chance of getting that to be ~/.get_maintainer.conf rather than
> ./.get_maintainer.conf? I've just gotten bit like the 3rd or 4th time by
> "oh but you didn't create that file in *this* tree"
> (I usually have a linus git tree, a linux-next tree, and 3-4 -mm trees)

Sure.

Add a search path for the .conf file.

3 paths are added:

.             customized per-tree configurations
$HOME         user global configuration when per-tree configs don't exist
./scripts     lk defaults to override script

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index ac20d58..b7f93db 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -110,10 +110,12 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([0-9a-f]+):"
 );
 
-if (-f "${lk_path}.get_maintainer.conf") {
+my $conf = which_conf(".get_maintainer.conf");
+if (-f $conf) {
     my @conf_args;
-    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
-	or warn "$P: Can't open .get_maintainer.conf: $!\n";
+    open(my $conffile, '<', "$conf")
+	or warn "$P: Can't find a readable .get_maintainer.conf file $!\n";
+
     while (<$conffile>) {
 	my $line = $_;
 
@@ -961,6 +963,18 @@ sub which {
     return "";
 }
 
+sub which_conf {
+    my ($conf) = @_;
+
+    foreach my $path (split(/:/, ".:$ENV{HOME}:.scripts")) {
+	if (-e "$path/$conf") {
+	    return "$path/$conf";
+	}
+    }
+
+    return "";
+}
+
 sub mailmap {
     my (@lines) = @_;
     my %hash;
-- 
1.7.3.rc1

