Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2LTSt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:49:59 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64817 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2LTStx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:49:53 -0500
From: Jonathan Kliegman <kliegs@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-kbuild@vger.kernel.org,
        Jonathan Kliegman <kliegs@chromium.org>
Subject: [PATCH] modpost: Add flag -f for making section mismatches fatal
Date: Thu, 20 Dec 2012 13:49:24 -0500
Message-Id: <1356029364-11346-1-git-send-email-kliegs@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section mismatch warning can be easy to miss during the kernel build
process.  Allow it to be marked as fatal to be easily caught and prevent
bugs from slipping in.

Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
---
 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |   24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index a1cb022..1e496d3 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -81,6 +81,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
+ $(if $(CONFIG_SECTION_MISMATCH_FATAL),,-f)      \
  $(if $(cross_build),-c)
 
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ff36c50..5648882 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -42,6 +42,7 @@ static int warn_unresolved = 0;
 /* How a symbol is exported */
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
+static int sec_mismatch_fatal = 0;
 
 enum export {
 	export_plain,      export_unused,     export_gpl,
@@ -2126,7 +2127,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:f")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2164,6 +2165,9 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
+		case 'f':
+			sec_mismatch_fatal = 1;
+			break;
 		default:
 			exit(1);
 		}
@@ -2210,14 +2214,20 @@ int main(int argc, char **argv)
 		sprintf(fname, "%s.mod.c", mod->name);
 		write_if_changed(&buf, fname);
 	}
-
 	if (dump_write)
 		write_dump(dump_write);
-	if (sec_mismatch_count && !sec_mismatch_verbose)
-		warn("modpost: Found %d section mismatch(es).\n"
-		     "To see full details build your kernel with:\n"
-		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
-		     sec_mismatch_count);
+	if (sec_mismatch_count) {
+		if (!sec_mismatch_verbose) {
+			warn("modpost: Found %d section mismatch(es).\n"
+			     "To see full details build your kernel with:\n"
+			     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
+			     sec_mismatch_count);
+		}
+		if (sec_mismatch_fatal) {
+			fatal("modpost: Section mismatches detected.\n"
+			      "Unset CONFIG_SECTION_MISMATCH_FATAL to allow them.\n");
+		}
+	}
 
 	return err;
 }
-- 
1.7.7.3

