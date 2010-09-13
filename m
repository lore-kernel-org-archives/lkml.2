Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0IMFVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 01:21:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1802 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0IMFVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 01:21:41 -0400
Subject: [PATCH] get_maintainer.pl: Look for .get_maintainer.conf in lk,
 then $HOME then scripts
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <30366.1284350506@localhost>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910123040.5a6f0128@schatten.dmk.lab>  <30366.1284350506@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 22:21:39 -0700
Message-ID: <1284355299.22185.65.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 00:01 -0400, Valdis.Kletnieks@vt.edu wrote:
> Any chance of getting that to be ~/.get_maintainer.conf rather than
> ./.get_maintainer.conf? I've just gotten bit like the 3rd or 4th time by "oh but
> you didn't create that file in *this* tree" (I usually have a linus git tree, a linux-next
> tree, and 3-4 -mm trees lying around).

Sure.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b228198..ea54561 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -107,10 +107,12 @@ my %VCS_cmds_hg = (
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
 
@@ -952,6 +954,18 @@ sub which {
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


