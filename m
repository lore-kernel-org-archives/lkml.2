Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1LNQVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:21:36 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45887 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab1LNQVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:21:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] modpost: add option to allow external modules to avoid taint
Date: Wed, 14 Dec 2011 11:20:03 -0500
Message-Id: <1323879603-2961-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323752547.2825.101.camel@deadeye>
References: <1323752547.2825.101.camel@deadeye>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases, it might be desirable to package a module from an
external source tree alongside the base kernel.  In those cases, it
might also be desirable to not have those modules tainting the kernel.

This patch provides a mechanism for an external module build to declare
itself as an "integrated build".  Such a module is then treated the same
as an intree module.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Any thoughts on this?  I'm thinking of adding this to Fedora kernels,
where I have been working to integrate the compat-wireless package as
part of the base kernel RPM.

 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..160c6fb 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -81,6 +81,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
+ $(if $(INTEGRATED_BUILD),-B) \
  $(if $(cross_build),-c)
 
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2bd594e..5d077f9 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -43,6 +43,9 @@ static int warn_unresolved = 0;
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
 
+/* Is this a module being built as part of an integrated package? */
+static int integrated_build = 0;
+
 enum export {
 	export_plain,      export_unused,     export_gpl,
 	export_unused_gpl, export_gpl_future, export_unknown
@@ -1851,7 +1854,7 @@ static void add_header(struct buffer *b, struct module *mod)
 
 static void add_intree_flag(struct buffer *b, int is_intree)
 {
-	if (is_intree)
+	if (is_intree || integrated_build)
 		buf_printf(b, "\nMODULE_INFO(intree, \"Y\");\n");
 }
 
@@ -2101,7 +2104,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:B")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2139,6 +2142,9 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
+		case 'B':
+			integrated_build = 1;
+			break;
 		default:
 			exit(1);
 		}
-- 
1.7.4.4

