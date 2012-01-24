Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2AXCph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:45:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab2AXCpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:45:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:29 2012
Message-Id: <20120124023929.649918114@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arend van Spriel <arend@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [065/129] kconfig/streamline-config.pl: Fix parsing Makefile with variables
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2442
Lines: 91

From: Steven Rostedt <srostedt@redhat.com>

commit 364212fddaaa60c5a64f67a0f5624ad996ecc8a0 upstream.

Thomas Lange reported that when he did a 'make localmodconfig', his
config was missing the brcmsmac driver, even though he had the module
loaded.

Looking into this, I found the file:
drivers/net/wireless/brcm80211/brcmsmac/Makefile
had the following in the Makefile:

MODULEPFX := brcmsmac

obj-$(CONFIG_BRCMSMAC)  += $(MODULEPFX).o

The way streamline-config.pl works, is parsing all the
 obj-$(CONFIG_FOO) += foo.o
lines to find that CONFIG_FOO belongs to the module foo.ko.

But in this case, the brcmsmac.o was not used, but a variable in its place.

By changing streamline-config.pl to remember defined variables in Makefiles
and substituting them when they are used in the obj-X lines, allows
Thomas (and others) to have their brcmsmac module stay configured
when it is loaded and running "make localmodconfig".

Reported-by: Thomas Lange <thomas-lange2@gmx.de>
Tested-by: Thomas Lange <thomas-lange2@gmx.de>
Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/kconfig/streamline_config.pl |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -250,10 +250,33 @@ if ($kconfig) {
     read_kconfig($kconfig);
 }
 
+sub convert_vars {
+    my ($line, %vars) = @_;
+
+    my $process = "";
+
+    while ($line =~ s/^(.*?)(\$\((.*?)\))//) {
+	my $start = $1;
+	my $variable = $2;
+	my $var = $3;
+
+	if (defined($vars{$var})) {
+	    $process .= $start . $vars{$var};
+	} else {
+	    $process .= $start . $variable;
+	}
+    }
+
+    $process .= $line;
+
+    return $process;
+}
+
 # Read all Makefiles to map the configs to the objects
 foreach my $makefile (@makefiles) {
 
     my $line = "";
+    my %make_vars;
 
     open(MIN,$makefile) || die "Can't open $makefile";
     while (<MIN>) {
@@ -270,10 +293,16 @@ foreach my $makefile (@makefiles) {
 
 	my $objs;
 
+	$_ = convert_vars($_, %make_vars);
+
 	# collect objects after obj-$(CONFIG_FOO_BAR)
 	if (/obj-\$\((CONFIG_[^\)]*)\)\s*[+:]?=\s*(.*)/) {
 	    $var = $1;
 	    $objs = $2;
+
+	# check if variables are set
+	} elsif (/^\s*(\S+)\s*[:]?=\s*(.*\S)/) {
+	    $make_vars{$1} = $2;
 	}
 	if (defined($objs)) {
 	    foreach my $obj (split /\s+/,$objs) {


