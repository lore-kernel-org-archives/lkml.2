Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0FATaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:30:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59072 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0FATaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:30:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=TxiAcybQHLdezhayESL7l4C2N5yCY17a1/UwvXWoMDP81yfzIlPPlDiYpgF+RZrIU
	/U4iveFl0VBcZZnu7R9RQ==
Message-ID: <4c055fb7.df0ce30a.5f0d.ffffae52@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 1 Jun 2010 21:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, tzanussi@gmail.com
Subject: [PATCH] perf: add perfconfig option to specify buildid cache dir
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to specify an alternate directory
to store the buildid cache (buildids, copy of binaries). By
default, it is hardcoded to $HOME/.debug. This directory
contains immutable data. The layout of the directory is such
that no conflicts in filenames are possible. A modification
in a file, yields a different buildid and thus a different
location in the subdir hierarchy.

You may want to put the buildid cache elsewhere because of
disk space limitation or simply to share the cache between
users. It is also useful for remote collect vs. local
analysis of profiles.

This patch adds a new config option to the perfconfig file.
Under the tag 'buildid', there is a dir option. For instance,
if you have:

$ cat /etc/perfconfig
[builid]
dir = /var/cache/perf-buildid

All buildids and binaries are be saved in the directory
specified. The perf record, buildid-list, buildid-cache,
report, annotate, and archive commands will it to pull
information out.

The option can be set in the system-wide perfconfig file
or in the $HOME/.perfconfig file.

Signed-off-by: Stephane Eranian <eranian@google.com>

--

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index f8e3d18..29ad20e 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -78,8 +78,7 @@ static int __cmd_buildid_cache(void)
 	struct str_node *pos;
 	char debugdir[PATH_MAX];
 
-	snprintf(debugdir, sizeof(debugdir), "%s/%s", getenv("HOME"),
-		 DEBUG_CACHE_DIR);
+	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
 
 	if (add_name_list_str) {
 		list = strlist__new(true, add_name_list_str);
diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index 2e7a4f4..677e59d 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -7,7 +7,17 @@ if [ $# -ne 0 ] ; then
 	PERF_DATA=$1
 fi
 
-DEBUGDIR=~/.debug/
+#
+# PERF_BUILDID_DIR environment variable set by perf
+# path to buildid directory, default to $HOME/.debug
+#
+if [ -z $PERF_BUILDID_DIR ]; then
+	PERF_BUILDID_DIR=~/.debug/
+else
+        # append / to make substitutions work
+        PERF_BUILDID_DIR=$PERF_BUILDID_DIR/
+fi
+
 BUILDIDS=$(mktemp /tmp/perf-archive-buildids.XXXXXX)
 NOBUILDID=0000000000000000000000000000000000000000
 
@@ -22,13 +32,13 @@ MANIFEST=$(mktemp /tmp/perf-archive-manifest.XXXXXX)
 
 cut -d ' ' -f 1 $BUILDIDS | \
 while read build_id ; do
-	linkname=$DEBUGDIR.build-id/${build_id:0:2}/${build_id:2}
+	linkname=$PERF_BUILDID_DIR.build-id/${build_id:0:2}/${build_id:2}
 	filename=$(readlink -f $linkname)
-	echo ${linkname#$DEBUGDIR} >> $MANIFEST
-	echo ${filename#$DEBUGDIR} >> $MANIFEST
+	echo ${linkname#$PERF_BUILDID_DIR} >> $MANIFEST
+	echo ${filename#$PERF_BUILDID_DIR} >> $MANIFEST
 done
 
-tar cfj $PERF_DATA.tar.bz2 -C $DEBUGDIR -T $MANIFEST
+tar cfj $PERF_DATA.tar.bz2 -C $PERF_BUILDID_DIR -T $MANIFEST
 rm -f $MANIFEST $BUILDIDS
 echo -e "Now please run:\n"
 echo -e "$ tar xvf $PERF_DATA.tar.bz2 -C ~/.debug\n"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 6e48711..cdd6c03 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -458,6 +458,8 @@ int main(int argc, const char **argv)
 	handle_options(&argv, &argc, NULL);
 	commit_pager_choice();
 	set_debugfs_path();
+	set_buildid_dir();
+
 	if (argc > 0) {
 		if (!prefixcmp(argv[0], "--"))
 			argv[0] += 2;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 70c5cf8..5c26e2d 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -43,19 +43,17 @@ struct perf_event_ops build_id__mark_dso_hit_ops = {
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
-	const char *home;
 
 	if (!self->has_build_id)
 		return NULL;
 
 	build_id__sprintf(self->build_id, sizeof(self->build_id), build_id_hex);
-	home = getenv("HOME");
 	if (bf == NULL) {
-		if (asprintf(&bf, "%s/%s/.build-id/%.2s/%s", home,
-			     DEBUG_CACHE_DIR, build_id_hex, build_id_hex + 2) < 0)
+		if (asprintf(&bf, "%s/.build-id/%.2s/%s", buildid_dir,
+			     build_id_hex, build_id_hex + 2) < 0)
 			return NULL;
 	} else
-		snprintf(bf, size, "%s/%s/.build-id/%.2s/%s", home,
-			 DEBUG_CACHE_DIR, build_id_hex, build_id_hex + 2);
+		snprintf(bf, size, "%s/.build-id/%.2s/%s", buildid_dir,
+			 build_id_hex, build_id_hex + 2);
 	return bf;
 }
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 65fe664..27e9ebe 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -23,6 +23,7 @@ extern int perf_config(config_fn_t fn, void *);
 extern int perf_config_int(const char *, const char *);
 extern int perf_config_bool(const char *, const char *);
 extern int config_error_nonbool(const char *);
+extern const char *perf_config_dirname(const char *, const char *);
 
 /* pager.c */
 extern void setup_pager(void);
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index dabe892..e02d78c 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -11,6 +11,11 @@
 
 #define MAXNAME (256)
 
+#define DEBUG_CACHE_DIR ".debug"
+
+
+char buildid_dir[MAXPATHLEN]; /* root dir for buildid, binary cache */
+
 static FILE *config_file;
 static const char *config_file_name;
 static int config_linenr;
@@ -127,7 +132,7 @@ static int get_value(config_fn_t fn, void *data, char *name, unsigned int len)
 			break;
 		if (!iskeychar(c))
 			break;
-		name[len++] = tolower(c);
+		name[len++] = c;
 		if (len >= MAXNAME)
 			return -1;
 	}
@@ -327,6 +332,13 @@ int perf_config_bool(const char *name, const char *value)
 	return !!perf_config_bool_or_int(name, value, &discard);
 }
 
+const char *perf_config_dirname(const char *name, const char *value)
+{
+	if (!name)
+		return NULL;
+	return value;
+}
+
 static int perf_default_core_config(const char *var __used, const char *value __used)
 {
 	/* Add other config variables here and to Documentation/config.txt. */
@@ -428,3 +440,53 @@ int config_error_nonbool(const char *var)
 {
 	return error("Missing value for '%s'", var);
 }
+
+struct buildid_dir_config {
+	char *dir;
+};
+
+static int buildid_dir_command_config(const char *var, const char *value,
+				      void *data)
+{
+	struct buildid_dir_config *c = data;
+	const char *v;
+
+	/* same dir for all commands */
+	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
+		v = perf_config_dirname(var, value);
+		if (!v)
+			return -1;
+		strncpy(c->dir, v, MAXPATHLEN-1);
+		c->dir[MAXPATHLEN-1] = '\0';
+	}
+	return 0;
+}
+
+static void check_buildid_dir_config(void)
+{
+	struct buildid_dir_config c;
+	c.dir = buildid_dir;
+	perf_config(buildid_dir_command_config, &c);
+}
+
+void set_buildid_dir(void)
+{
+	buildid_dir[0] = '\0';
+
+	/* try config file */
+	check_buildid_dir_config();
+
+	/* default to $HOME/.debug */
+	if (buildid_dir[0] == '\0') {
+		char *v = getenv("HOME");
+		if (v) {
+			snprintf(buildid_dir, MAXPATHLEN-1, "%s/%s",
+				 v, DEBUG_CACHE_DIR);
+		} else {
+			strncpy(buildid_dir, DEBUG_CACHE_DIR, MAXPATHLEN-1);
+		}
+		buildid_dir[MAXPATHLEN-1] = '\0';
+	}
+	/* for communicating with external commands */
+	setenv("PERF_BUILDID_DIR", buildid_dir, 1);
+}
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1f62435..4a6a4b3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -385,8 +385,7 @@ static int perf_session__cache_build_ids(struct perf_session *self)
 	int ret;
 	char debugdir[PATH_MAX];
 
-	snprintf(debugdir, sizeof(debugdir), "%s/%s", getenv("HOME"),
-		 DEBUG_CACHE_DIR);
+	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
 
 	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
 		return -1;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5e02d2c..34760a2 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -9,8 +9,6 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 
-#define DEBUG_CACHE_DIR ".debug"
-
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 4e8b6b0..de61441 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -89,6 +89,7 @@
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
+extern char buildid_dir[];
 
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
@@ -152,6 +153,7 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 extern int prefixcmp(const char *str, const char *prefix);
+extern void set_buildid_dir(void);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
