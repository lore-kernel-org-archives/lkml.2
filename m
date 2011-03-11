Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1CKVfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:35:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:49112 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab1CKVfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:35:04 -0500
From: Michal Marek <mmarek@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Fix computing srcversion for modules
Date: Fri, 11 Mar 2011 22:34:47 +0100
Message-Id: <1299879287-30889-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110311092811.GA2079@polaris.bitmath.org>
References: <20110311092811.GA2079@polaris.bitmath.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent change to fixdep:

    commit b7bd182176960fdd139486cadb9962b39f8a2b50
    Author: Michal Marek <mmarek@suse.cz>
    Date:   Thu Feb 17 15:13:54 2011 +0100

    fixdep: Do not record dependency on the source file itself

changed the format of the *.cmd files without realizing that it is also
used by modpost. Put the path to the source file to the file back, in a
special variable, so that modpost sees all source files when calculating
srcversion for modules.

Reported-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/basic/fixdep.c   |   19 +++++++++++++------
 scripts/mod/sumversion.c |   19 +++++++++++++++++--
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 6c94c6c..291228e 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -309,6 +309,11 @@ static void do_config_file(const char *filename)
 	close(fd);
 }
 
+/*
+ * Important: The below generated source_foo.o and deps_foo.o variable
+ * assignments are parsed not only by make, but also by the rather simple
+ * parser in scripts/mod/sumversion.c.
+ */
 static void parse_dep_file(void *map, size_t len)
 {
 	char *m = map;
@@ -323,7 +328,6 @@ static void parse_dep_file(void *map, size_t len)
 		exit(1);
 	}
 	memcpy(s, m, p-m); s[p-m] = 0;
-	printf("deps_%s := \\\n", target);
 	m = p+1;
 
 	clear_config();
@@ -343,12 +347,15 @@ static void parse_dep_file(void *map, size_t len)
 		    strrcmp(s, "arch/um/include/uml-config.h") &&
 		    strrcmp(s, ".ver")) {
 			/*
-			 * Do not output the first dependency (the
-			 * source file), so that kbuild is not confused
-			 * if a .c file is rewritten into .S or vice
-			 * versa.
+			 * Do not list the source file as dependency, so that
+			 * kbuild is not confused if a .c file is rewritten
+			 * into .S or vice versa. Storing it in source_* is
+			 * needed for modpost to compute srcversions.
 			 */
-			if (!first)
+			if (first) {
+				printf("source_%s := %s\n\n", target, s);
+				printf("deps_%s := \\\n", target);
+			} else
 				printf("  %s \\\n", s);
 			do_config_file(s);
 		}
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index ecf9c7d..9dfcd6d 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -300,8 +300,8 @@ static int is_static_library(const char *objfile)
 		return 0;
 }
 
-/* We have dir/file.o.  Open dir/.file.o.cmd, look for deps_ line to
- * figure out source file. */
+/* We have dir/file.o.  Open dir/.file.o.cmd, look for source_ and deps_ line
+ * to figure out source files. */
 static int parse_source_files(const char *objfile, struct md4_ctx *md)
 {
 	char *cmd, *file, *line, *dir;
@@ -340,6 +340,21 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
 	*/
 	while ((line = get_next_line(&pos, file, flen)) != NULL) {
 		char* p = line;
+
+		if (strncmp(line, "source_", sizeof("source_")-1) == 0) {
+			p = strrchr(line, ' ');
+			if (!p) {
+				warn("malformed line: %s\n", line);
+				goto out_file;
+			}
+			p++;
+			if (!parse_file(p, md)) {
+				warn("could not open %s: %s\n",
+				     p, strerror(errno));
+				goto out_file;
+			}
+			continue;
+		}
 		if (strncmp(line, "deps_", sizeof("deps_")-1) == 0) {
 			check_files = 1;
 			continue;
-- 
1.7.4.1

