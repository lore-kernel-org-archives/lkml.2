Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1EQCO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:14:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61162 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1EQCOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:14:25 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=H24yS0ZBol4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=m9wVCJc_NltotJ5NkSgA:9 a=w5h1AkJpKzXSAlnymmUA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110517021423.339937849@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 16 May 2011 22:10:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 1/2] kbuild: Add force-deps to fixdep
References: <20110517021027.390391519@goodmis.org>
Content-Disposition: inline; filename=0001-kbuild-Add-force-deps-to-fixdep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Allow some files to cause a full recompile of the kernel.
There are some cases where all objects in the kernel may indirectly
depend on a tool or script. A force-deps option has been added
to fixdep to allow a list of files to be passed in to add them
to the dependency of kernel files that are not found by gcc -MD
option.

Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/Kbuild.include |    3 ++-
 scripts/Makefile.build |    4 ++--
 scripts/basic/fixdep.c |   18 ++++++++++++++++--
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index ed2773e..219f2c1 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -210,7 +210,8 @@ if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
 if_changed_dep = $(if $(strip $(any-prereq) $(arg-check) ),                  \
 	@set -e;                                                             \
 	$(echo-cmd) $(cmd_$(1));                                             \
-	scripts/basic/fixdep $(depfile) $@ '$(make-cmd)' > $(dot-target).tmp;\
+	scripts/basic/fixdep $(depfile) $@ '$(make-cmd)'		     \
+			      "$(force-deps)" > $(dot-target).tmp;	     \
 	rm -f $(depfile);                                                    \
 	mv -f $(dot-target).tmp $(dot-target).cmd)
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..0ff5a58 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -272,8 +272,8 @@ define rule_cc_o_c
 	$(cmd_modversions)						  \
 	$(call echo-cmd,record_mcount)					  \
 	$(cmd_record_mcount)						  \
-	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
-	                                              $(dot-target).tmp;  \
+	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)'	  \
+	                           "$(force-deps)" >  $(dot-target).tmp;  \
 	rm -f $(depfile);						  \
 	mv -f $(dot-target).tmp $(dot-target).cmd
 endef
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 291228e..2b5045d 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -62,7 +62,7 @@
  *
  * It is invoked as
  *
- *   fixdep <depfile> <target> <cmdline>
+ *   fixdep <depfile> <target> <cmdline> [<force-deps>]
  *
  * and will read the dependency file <depfile>
  *
@@ -91,6 +91,9 @@
  * unrelated CONFIG_ options all over the place, it's not an
  * efficiency problem either.
  *
+ * An optional <force-deps> may also be added to include a list of
+ * files that are forced dependencies.
+ *
  * (Note: it'd be easy to port over the complete mkdep state machine,
  *  but I don't think the added complexity is worth it)
  */
@@ -123,6 +126,7 @@
 char *target;
 char *depfile;
 char *cmdline;
+char *forced;
 
 static void usage(void)
 {
@@ -333,6 +337,7 @@ static void parse_dep_file(void *map, size_t len)
 	clear_config();
 
 	first = 1;
+ again:
 	while (m < end) {
 		while (m < end && (*m == ' ' || *m == '\\' || *m == '\n'))
 			m++;
@@ -362,6 +367,13 @@ static void parse_dep_file(void *map, size_t len)
 		first = 0;
 		m = p + 1;
 	}
+	if (forced) {
+		m = forced;
+		end = m + strlen(m);
+		forced = NULL;
+		goto again;
+	}
+
 	printf("\n%s: $(deps_%s)\n\n", target, target);
 	printf("$(deps_%s):\n", target);
 }
@@ -418,12 +430,14 @@ int main(int argc, char *argv[])
 {
 	traps();
 
-	if (argc != 4)
+	if (argc != 4 && argc != 5)
 		usage();
 
 	depfile = argv[1];
 	target = argv[2];
 	cmdline = argv[3];
+	if (argc == 5)
+		forced = argv[4];
 
 	print_cmdline();
 	print_deps();
-- 
1.7.2.3


