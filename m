Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2KHRfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:35:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab2KHRfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:35:34 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH RFC v2 1/4] firmware: Add the firmware signing support to scripts/sign-file
Date: Thu,  8 Nov 2012 18:35:06 +0100
Message-Id: <1352396109-3989-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352396109-3989-1-git-send-email-tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de>
 <1352396109-3989-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -f option to sign-file script for generating a firmware signature
file.

A firmware signature file contains a pretty similar structure like a
signed module but in a different order (because it's a separate file
while the module signature is embedded at the tail of unsigned module
contents).  The file consists of
 - the magic string
 - the signature information, which is identical with the module
   signature
 - signer's name
 - key id
 - signature bytes

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 scripts/sign-file | 48 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/scripts/sign-file b/scripts/sign-file
index 87ca59d..5b9d44d 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -4,30 +4,40 @@
 #
 # Format:
 #
-#	./scripts/sign-file [-v] <key> <x509> <module> [<dest>]
+#	./scripts/sign-file [-v] [-f] <key> <x509> <module> [<dest>]
 #
 #
 use strict;
 use FileHandle;
 use IPC::Open2;
+use Getopt::Long;
 
-my $verbose = 0;
-if ($#ARGV >= 0 && $ARGV[0] eq "-v") {
-    $verbose = 1;
-    shift;
+sub usage()
+{
+    print "Format: ./scripts/sign-file [options] <key> <x509> <module> [<dest>]
+    -v       verbose output
+    -f       create a firmware signature file
+";
+    exit;
 }
 
-die "Format: ./scripts/sign-file [-v] <key> <x509> <module> [<dest>]\n"
-    if ($#ARGV != 2 && $#ARGV != 3);
+my $verbose = 0;
+my $sign_fw = 0;
+
+GetOptions(
+    'v|verbose' => \$verbose,
+    'f|firmware' => \$sign_fw) || usage();
+usage() if ($#ARGV != 2 && $#ARGV != 3);
 
 my $private_key = $ARGV[0];
 my $x509 = $ARGV[1];
 my $module = $ARGV[2];
-my $dest = ($#ARGV == 3) ? $ARGV[3] : $ARGV[2] . "~";
+my $dest = $ARGV[3] ? $ARGV[3] : $ARGV[2] . ($sign_fw ? ".sig" : "~");
+my $mode_name = $sign_fw ? "firmware" : "module";
 
 die "Can't read private key\n" unless (-r $private_key);
 die "Can't read X.509 certificate\n" unless (-r $x509);
-die "Can't read module\n" unless (-r $module);
+die "Can't read $mode_name\n" unless (-r $module);
 
 #
 # Read the kernel configuration
@@ -393,7 +403,9 @@ die "openssl rsautl died: $?" if ($? >> 8);
 #
 my $unsigned_module = read_file($module);
 
-my $magic_number = "~Module signature appended~\n";
+my $magic_number = $sign_fw ?
+    "~Linux firmware signature~\n" :
+    "~Module signature appended~\n";
 
 my $info = pack("CCCCCxxxN",
 		$algo, $hash, $id_type,
@@ -402,7 +414,7 @@ my $info = pack("CCCCCxxxN",
 		length($signature));
 
 if ($verbose) {
-    print "Size of unsigned module: ", length($unsigned_module), "\n";
+    print "Size of unsigned $mode_name: ", length($unsigned_module), "\n";
     print "Size of signer's name  : ", length($signers_name), "\n";
     print "Size of key identifier : ", length($key_identifier), "\n";
     print "Size of signature      : ", length($signature), "\n";
@@ -414,7 +426,16 @@ if ($verbose) {
 
 open(FD, ">$dest") || die $dest;
 binmode FD;
-print FD
+if ($sign_fw) {
+    print FD
+    $magic_number,
+    $info,
+    $signers_name,
+    $key_identifier,
+    $signature
+    ;
+} else {
+    print FD
     $unsigned_module,
     $signers_name,
     $key_identifier,
@@ -422,8 +443,9 @@ print FD
     $info,
     $magic_number
     ;
+}
 close FD || die $dest;
 
-if ($#ARGV != 3) {
+if (!$sign_fw && $#ARGV != 3) {
     rename($dest, $module) || die $module;
 }
-- 
1.8.0

