Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2I3Vcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 17:32:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37189 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2I3Vct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 17:32:49 -0400
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>
Subject: [PATCH 2/2] scripts/kernel-doc: check that non-void fcts describe their return value
Date: Sun, 30 Sep 2012 23:32:16 +0200
Message-Id: <1349040737-1659-2-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1349040737-1659-1-git-send-email-yacine.belkadi.1@gmail.com>
References: <1349040737-1659-1-git-send-email-yacine.belkadi.1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a function has a return value, but its kernel-doc comment doesn't contain a
"Return" section, then emit the following warning:

   Warning(file.h:129): No description found for return value of 'fct'

Note: This check emits a lot of warnings at the moment, because many functions
don't have a 'Return' doc section. So until the number of warnings goes
sufficiently down, the check is only performed in verbose mode.

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
---
 scripts/kernel-doc |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 8fd107a..7f82aa8 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -130,6 +130,8 @@ use strict;
 # should document the "Context:" of the function, e.g. whether the functions
 # can be called form interrupts. Unlike other sections you can end it with an
 # empty line.
+# A non-void function should have a "Return:" section describing the return
+# value.
 # Example-sections should contain the string EXAMPLE so that they are marked
 # appropriately in DocBook.
 #
@@ -298,6 +300,7 @@ my $section_default = "Description";	# default section
 my $section_intro = "Introduction";
 my $section = $section_default;
 my $section_context = "Context";
+my $section_return = "Return";
 
 my $undescribed = "-- undescribed --";
 
@@ -1767,6 +1770,28 @@ sub check_sections($$$$$$) {
 }
 
 ##
+# Checks the section describing the return value of a function.
+sub check_return_section {
+        my $file = shift;
+        my $declaration_name = shift;
+        my $return_type = shift;
+
+        # Ignore an empty return type (It's a macro)
+        # Ignore functions with a "void" return type. (But don't ignore "void *")
+        if (($return_type eq "") || ($return_type =~ /void\s*\w*\s*$/)) {
+                return;
+        }
+
+        if (!defined($sections{$section_return}) ||
+            $sections{$section_return} eq "") {
+                print STDERR "Warning(${file}:$.): " .
+                "No description found for return value of " .
+                "'$declaration_name'\n";
+                ++$warnings;
+        }
+}
+
+##
 # takes a function prototype and the name of the current file being
 # processed and spits out all the details stored in the global
 # arrays/hashes.
@@ -1837,6 +1862,15 @@ sub dump_function($$) {
 	my $prms = join " ", @parameterlist;
 	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
 
+        # This check emits a lot of warnings at the moment, because many
+        # functions don't have a 'Return' doc section. So until the number
+        # of warnings goes sufficiently down, the check is only performed in
+        # verbose mode.
+        # TODO: always perform the check.
+        if ($verbose) {
+                check_return_section($file, $declaration_name, $return_type);
+        }
+
     output_declaration($declaration_name,
 		       'function',
 		       {'function' => $declaration_name,
-- 
1.7.9.5

