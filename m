Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab2KHRfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:35:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab2KHRfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:35:34 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH RFC v2 2/4] firmware: Add -a option to scripts/sign-file
Date: Thu,  8 Nov 2012 18:35:07 +0100
Message-Id: <1352396109-3989-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352396109-3989-1-git-send-email-tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de>
 <1352396109-3989-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new option -a to sign-file for specifying the hash algorithm
to sign a file, to make it working without .config file.
This will be useful signing external module or firmware files.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 scripts/sign-file | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/scripts/sign-file b/scripts/sign-file
index 5b9d44d..581cdcd 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -4,7 +4,7 @@
 #
 # Format:
 #
-#	./scripts/sign-file [-v] [-f] <key> <x509> <module> [<dest>]
+#	./scripts/sign-file [-v] [-f] [-a algo] <key> <x509> <module> [<dest>]
 #
 #
 use strict;
@@ -17,16 +17,19 @@ sub usage()
     print "Format: ./scripts/sign-file [options] <key> <x509> <module> [<dest>]
     -v       verbose output
     -f       create a firmware signature file
+    -a algo  specify hash algorithm
 ";
     exit;
 }
 
 my $verbose = 0;
+my $hashalgo = "";
 my $sign_fw = 0;
 
 GetOptions(
     'v|verbose' => \$verbose,
-    'f|firmware' => \$sign_fw) || usage();
+    'f|firmware' => \$sign_fw,
+    'a|algo=s' => \$hashalgo) || usage();
 usage() if ($#ARGV != 2 && $#ARGV != 3);
 
 my $private_key = $ARGV[0];
@@ -42,10 +45,7 @@ die "Can't read $mode_name\n" unless (-r $module);
 #
 # Read the kernel configuration
 #
-my %config = (
-    CONFIG_MODULE_SIG_SHA512 => 1
-    );
-
+my %config;
 if (-r ".config") {
     open(FD, "<.config") || die ".config";
     while (<FD>) {
@@ -56,6 +56,22 @@ if (-r ".config") {
     close(FD);
 }
 
+if ($hashalgo eq "") {
+    if (exists $config{"CONFIG_MODULE_SIG_SHA1"}) {
+	$hashalgo="sha1";
+    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA224"}) {
+	$hashalgo="sha224";
+    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA256"}) {
+	$hashalgo="sha256";
+    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA384"}) {
+	$hashalgo="sha384";
+    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA512"}) {
+	$hashalgo="sha512";
+    } else {
+	die "Can't determine hash algorithm";
+    }
+}
+
 #
 # Function to read the contents of a file into a variable.
 #
@@ -332,35 +348,35 @@ my $id_type = 1;	# Identifier type: X.509
 # Digest the data
 #
 my ($dgst, $prologue) = ();
-if (exists $config{"CONFIG_MODULE_SIG_SHA1"}) {
+if ($hashalgo eq "sha1") {
     $prologue = pack("C*",
 		     0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
 		     0x2B, 0x0E, 0x03, 0x02, 0x1A,
 		     0x05, 0x00, 0x04, 0x14);
     $dgst = "-sha1";
     $hash = 2;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA224"}) {
+} elsif ($hashalgo eq "sha224") {
     $prologue = pack("C*",
 		     0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
 		     0x05, 0x00, 0x04, 0x1C);
     $dgst = "-sha224";
     $hash = 7;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA256"}) {
+} elsif ($hashalgo eq "sha256") {
     $prologue = pack("C*",
 		     0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
 		     0x05, 0x00, 0x04, 0x20);
     $dgst = "-sha256";
     $hash = 4;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA384"}) {
+} elsif ($hashalgo eq "sha384") {
     $prologue = pack("C*",
 		     0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
 		     0x05, 0x00, 0x04, 0x30);
     $dgst = "-sha384";
     $hash = 5;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA512"}) {
+} elsif ($hashalgo eq "sha512") {
     $prologue = pack("C*",
 		     0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
@@ -368,7 +384,7 @@ if (exists $config{"CONFIG_MODULE_SIG_SHA1"}) {
     $dgst = "-sha512";
     $hash = 6;
 } else {
-    die "Can't determine hash algorithm";
+    die "Invalid hash algorithm $hashalgo";
 }
 
 #
-- 
1.8.0

