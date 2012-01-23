Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2AWXsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:48:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab2AWXsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:48:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:26 2012
Message-Id: <20120123234026.510303172@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>
Subject: [42/90] kconfig/streamline-config.pl: Simplify backslash line concatination
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit d060d963e88f3e990cec2fe5214de49de9a49eca upstream.

Simplify the way lines ending with backslashes (continuation) in Makefiles
is parsed. This is needed to implement a necessary fix.

Tested-by: Thomas Lange <thomas-lange2@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/kconfig/streamline_config.pl |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -245,17 +245,22 @@ if ($kconfig) {
 # Read all Makefiles to map the configs to the objects
 foreach my $makefile (@makefiles) {
 
-    my $cont = 0;
+    my $line = "";
 
     open(MIN,$makefile) || die "Can't open $makefile";
     while (<MIN>) {
-	my $objs;
-
-	# is this a line after a line with a backslash?
-	if ($cont && /(\S.*)$/) {
-	    $objs = $1;
+	# if this line ends with a backslash, continue
+	chomp;
+	if (/^(.*)\\$/) {
+	    $line .= $1;
+	    next;
 	}
-	$cont = 0;
+
+	$line .= $_;
+	$_ = $line;
+	$line = "";
+
+	my $objs;
 
 	# collect objects after obj-$(CONFIG_FOO_BAR)
 	if (/obj-\$\((CONFIG_[^\)]*)\)\s*[+:]?=\s*(.*)/) {
@@ -263,12 +268,6 @@ foreach my $makefile (@makefiles) {
 	    $objs = $2;
 	}
 	if (defined($objs)) {
-	    # test if the line ends with a backslash
-	    if ($objs =~ m,(.*)\\$,) {
-		$objs = $1;
-		$cont = 1;
-	    }
-
 	    foreach my $obj (split /\s+/,$objs) {
 		$obj =~ s/-/_/g;
 		if ($obj =~ /(.*)\.o$/) {


