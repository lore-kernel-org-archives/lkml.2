Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab0ESCIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:08:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:52432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab0ESCIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:08:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/5] perf tools: Remove some unused functions
Date: Tue, 18 May 2010 23:08:17 -0300
Message-Id: <1274234900-12162-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274234900-12162-1-git-send-email-acme@infradead.org>
References: <1274234900-12162-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Without the bloated cplus_demangle from binutils, i.e building with:

$ make NO_DEMANGLE=1 O=~acme/git/build/perf -j3 -C tools/perf/ install

Before:

   text	   data	    bss	    dec	    hex	filename
 471851	  29280	4025056	4526187	 45106b	/home/acme/bin/perf

After:

[acme@doppio linux-2.6-tip]$ size ~/bin/perf
   text	   data	    bss	    dec	    hex	filename
 446886	  29232	4008576	4484694	 446e56	/home/acme/bin/perf

So its a 5.3% size reduction in code, but the interesting part is in the git
diff --stat output:

 19 files changed, 20 insertions(+), 1909 deletions(-)

If we ever need some of the things we got from git but weren't using, we just
have to go to the git repo and get fresh, uptodate source code bits.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c   |    1 +
 tools/perf/util/abspath.c     |   81 -------
 tools/perf/util/cache.h       |   55 +-----
 tools/perf/util/config.c      |  461 +----------------------------------------
 tools/perf/util/exec_cmd.c    |    2 +-
 tools/perf/util/exec_cmd.h    |    1 -
 tools/perf/util/help.c        |   30 +---
 tools/perf/util/path.c        |  202 ------------------
 tools/perf/util/quote.c       |  433 +--------------------------------------
 tools/perf/util/quote.h       |   39 ----
 tools/perf/util/run-command.c |   90 --------
 tools/perf/util/run-command.h |   30 ---
 tools/perf/util/session.c     |    1 +
 tools/perf/util/sigchain.c    |    2 +-
 tools/perf/util/sigchain.h    |    1 -
 tools/perf/util/strbuf.c      |  229 +--------------------
 tools/perf/util/strbuf.h      |   45 ----
 tools/perf/util/util.h        |  154 --------------
 tools/perf/util/wrapper.c     |   72 +-------
 19 files changed, 20 insertions(+), 1909 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cb46c7d..66b8ecd 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -25,6 +25,7 @@
 
 #include <unistd.h>
 #include <sched.h>
+#include <sys/mman.h>
 
 enum write_mode_t {
 	WRITE_FORCE,
diff --git a/tools/perf/util/abspath.c b/tools/perf/util/abspath.c
index a791dd4..0e76aff 100644
--- a/tools/perf/util/abspath.c
+++ b/tools/perf/util/abspath.c
@@ -1,86 +1,5 @@
 #include "cache.h"
 
-/*
- * Do not use this for inspecting *tracked* content.  When path is a
- * symlink to a directory, we do not want to say it is a directory when
- * dealing with tracked content in the working tree.
- */
-static int is_directory(const char *path)
-{
-	struct stat st;
-	return (!stat(path, &st) && S_ISDIR(st.st_mode));
-}
-
-/* We allow "recursive" symbolic links. Only within reason, though. */
-#define MAXDEPTH 5
-
-const char *make_absolute_path(const char *path)
-{
-	static char bufs[2][PATH_MAX + 1], *buf = bufs[0], *next_buf = bufs[1];
-	char cwd[1024] = "";
-	int buf_index = 1, len;
-
-	int depth = MAXDEPTH;
-	char *last_elem = NULL;
-	struct stat st;
-
-	if (strlcpy(buf, path, PATH_MAX) >= PATH_MAX)
-		die ("Too long path: %.*s", 60, path);
-
-	while (depth--) {
-		if (!is_directory(buf)) {
-			char *last_slash = strrchr(buf, '/');
-			if (last_slash) {
-				*last_slash = '\0';
-				last_elem = xstrdup(last_slash + 1);
-			} else {
-				last_elem = xstrdup(buf);
-				*buf = '\0';
-			}
-		}
-
-		if (*buf) {
-			if (!*cwd && !getcwd(cwd, sizeof(cwd)))
-				die ("Could not get current working directory");
-
-			if (chdir(buf))
-				die ("Could not switch to '%s'", buf);
-		}
-		if (!getcwd(buf, PATH_MAX))
-			die ("Could not get current working directory");
-
-		if (last_elem) {
-			len = strlen(buf);
-
-			if (len + strlen(last_elem) + 2 > PATH_MAX)
-				die ("Too long path name: '%s/%s'",
-						buf, last_elem);
-			buf[len] = '/';
-			strcpy(buf + len + 1, last_elem);
-			free(last_elem);
-			last_elem = NULL;
-		}
-
-		if (!lstat(buf, &st) && S_ISLNK(st.st_mode)) {
-			len = readlink(buf, next_buf, PATH_MAX);
-			if (len < 0)
-				die ("Invalid symlink: %s", buf);
-			if (PATH_MAX <= len)
-				die("symbolic link too long: %s", buf);
-			next_buf[len] = '\0';
-			buf = next_buf;
-			buf_index = 1 - buf_index;
-			next_buf = bufs[buf_index];
-		} else
-			break;
-	}
-
-	if (*cwd && chdir(cwd))
-		die ("Could not change back to '%s'", cwd);
-
-	return buf;
-}
-
 static const char *get_pwd_cwd(void)
 {
 	static char cwd[PATH_MAX + 1];
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 4b9aab7..5eca525 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -13,56 +13,16 @@
 
 #define PERF_DIR_ENVIRONMENT "PERF_DIR"
 #define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
-#define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
-#define DB_ENVIRONMENT "PERF_OBJECT_DIRECTORY"
-#define INDEX_ENVIRONMENT "PERF_INDEX_FILE"
-#define GRAFT_ENVIRONMENT "PERF_GRAFT_FILE"
-#define TEMPLATE_DIR_ENVIRONMENT "PERF_TEMPLATE_DIR"
-#define CONFIG_ENVIRONMENT "PERF_CONFIG"
 #define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
-#define CEILING_DIRECTORIES_ENVIRONMENT "PERF_CEILING_DIRECTORIES"
-#define PERFATTRIBUTES_FILE ".perfattributes"
-#define INFOATTRIBUTES_FILE "info/attributes"
-#define ATTRIBUTE_MACRO_PREFIX "[attr]"
+#define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
 #define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
-extern int perf_config_from_file(config_fn_t fn, const char *, void *);
 extern int perf_config(config_fn_t fn, void *);
-extern int perf_parse_ulong(const char *, unsigned long *);
 extern int perf_config_int(const char *, const char *);
-extern unsigned long perf_config_ulong(const char *, const char *);
-extern int perf_config_bool_or_int(const char *, const char *, int *);
 extern int perf_config_bool(const char *, const char *);
-extern int perf_config_string(const char **, const char *, const char *);
-extern int perf_config_set(const char *, const char *);
-extern int perf_config_set_multivar(const char *, const char *, const char *, int);
-extern int perf_config_rename_section(const char *, const char *);
-extern const char *perf_etc_perfconfig(void);
-extern int check_repository_format_version(const char *var, const char *value, void *cb);
-extern int perf_config_system(void);
-extern int perf_config_global(void);
 extern int config_error_nonbool(const char *);
-extern const char *config_exclusive_filename;
-
-#define MAX_PERFNAME (1000)
-extern char perf_default_email[MAX_PERFNAME];
-extern char perf_default_name[MAX_PERFNAME];
-extern int user_ident_explicitly_given;
-
-extern const char *perf_log_output_encoding;
-extern const char *perf_mailmap_file;
-
-/* IO helper functions */
-extern void maybe_flush_or_die(FILE *, const char *);
-extern int copy_fd(int ifd, int ofd);
-extern int copy_file(const char *dst, const char *src, int mode);
-extern ssize_t write_in_full(int fd, const void *buf, size_t count);
-extern void write_or_die(int fd, const void *buf, size_t count);
-extern int write_or_whine(int fd, const void *buf, size_t count, const char *msg);
-extern int write_or_whine_pipe(int fd, const void *buf, size_t count, const char *msg);
-extern void fsync_or_die(int fd, const char *);
 
 /* pager.c */
 extern void setup_pager(void);
@@ -83,9 +43,6 @@ void setup_browser(void);
 void exit_browser(bool wait_for_ok);
 #endif
 
-extern const char *editor_program;
-extern const char *excludes_file;
-
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
 
@@ -115,22 +72,12 @@ static inline int is_absolute_path(const char *path)
 	return path[0] == '/';
 }
 
-const char *make_absolute_path(const char *path);
 const char *make_nonrelative_path(const char *path);
-const char *make_relative_path(const char *abs, const char *base);
-int normalize_path_copy(char *dst, const char *src);
-int longest_ancestor_length(const char *path, const char *prefix_list);
 char *strip_path_suffix(const char *path, const char *suffix);
 
 extern char *mkpath(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
 extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
-/* perf_mkstemp() - create tmp file honoring TMPDIR variable */
-extern int perf_mkstemp(char *path, size_t len, const char *template);
 
-extern char *mksnpath(char *buf, size_t n, const char *fmt, ...)
-	__attribute__((format (printf, 3, 4)));
-extern char *perf_snpath(char *buf, size_t n, const char *fmt, ...)
-	__attribute__((format (printf, 3, 4)));
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 8784649..dabe892 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -16,7 +16,7 @@ static const char *config_file_name;
 static int config_linenr;
 static int config_file_eof;
 
-const char *config_exclusive_filename = NULL;
+static const char *config_exclusive_filename;
 
 static int get_next_char(void)
 {
@@ -291,19 +291,6 @@ static int perf_parse_long(const char *value, long *ret)
 	return 0;
 }
 
-int perf_parse_ulong(const char *value, unsigned long *ret)
-{
-	if (value && *value) {
-		char *end;
-		unsigned long val = strtoul(value, &end, 0);
-		if (!parse_unit_factor(end, &val))
-			return 0;
-		*ret = val;
-		return 1;
-	}
-	return 0;
-}
-
 static void die_bad_config(const char *name)
 {
 	if (config_file_name)
@@ -319,15 +306,7 @@ int perf_config_int(const char *name, const char *value)
 	return ret;
 }
 
-unsigned long perf_config_ulong(const char *name, const char *value)
-{
-	unsigned long ret;
-	if (!perf_parse_ulong(value, &ret))
-		die_bad_config(name);
-	return ret;
-}
-
-int perf_config_bool_or_int(const char *name, const char *value, int *is_bool)
+static int perf_config_bool_or_int(const char *name, const char *value, int *is_bool)
 {
 	*is_bool = 1;
 	if (!value)
@@ -348,14 +327,6 @@ int perf_config_bool(const char *name, const char *value)
 	return !!perf_config_bool_or_int(name, value, &discard);
 }
 
-int perf_config_string(const char **dest, const char *var, const char *value)
-{
-	if (!value)
-		return config_error_nonbool(var);
-	*dest = strdup(value);
-	return 0;
-}
-
 static int perf_default_core_config(const char *var __used, const char *value __used)
 {
 	/* Add other config variables here and to Documentation/config.txt. */
@@ -371,7 +342,7 @@ int perf_default_config(const char *var, const char *value, void *dummy __used)
 	return 0;
 }
 
-int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
+static int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
 {
 	int ret;
 	FILE *f = fopen(filename, "r");
@@ -389,7 +360,7 @@ int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
 	return ret;
 }
 
-const char *perf_etc_perfconfig(void)
+static const char *perf_etc_perfconfig(void)
 {
 	static const char *system_wide;
 	if (!system_wide)
@@ -403,12 +374,12 @@ static int perf_env_bool(const char *k, int def)
 	return v ? perf_config_bool(k, v) : def;
 }
 
-int perf_config_system(void)
+static int perf_config_system(void)
 {
 	return !perf_env_bool("PERF_CONFIG_NOSYSTEM", 0);
 }
 
-int perf_config_global(void)
+static int perf_config_global(void)
 {
 	return !perf_env_bool("PERF_CONFIG_NOGLOBAL", 0);
 }
@@ -450,426 +421,6 @@ int perf_config(config_fn_t fn, void *data)
 }
 
 /*
- * Find all the stuff for perf_config_set() below.
- */
-
-#define MAX_MATCHES 512
-
-static struct {
-	int baselen;
-	char* key;
-	int do_not_match;
-	regex_t* value_regex;
-	int multi_replace;
-	size_t offset[MAX_MATCHES];
-	enum { START, SECTION_SEEN, SECTION_END_SEEN, KEY_SEEN } state;
-	int seen;
-} store;
-
-static int matches(const char* key, const char* value)
-{
-	return !strcmp(key, store.key) &&
-		(store.value_regex == NULL ||
-		 (store.do_not_match ^
-		  !regexec(store.value_regex, value, 0, NULL, 0)));
-}
-
-static int store_aux(const char* key, const char* value, void *cb __used)
-{
-	int section_len;
-	const char *ep;
-
-	switch (store.state) {
-	case KEY_SEEN:
-		if (matches(key, value)) {
-			if (store.seen == 1 && store.multi_replace == 0) {
-				warning("%s has multiple values", key);
-			} else if (store.seen >= MAX_MATCHES) {
-				error("too many matches for %s", key);
-				return 1;
-			}
-
-			store.offset[store.seen] = ftell(config_file);
-			store.seen++;
-		}
-		break;
-	case SECTION_SEEN:
-		/*
-		 * What we are looking for is in store.key (both
-		 * section and var), and its section part is baselen
-		 * long.  We found key (again, both section and var).
-		 * We would want to know if this key is in the same
-		 * section as what we are looking for.  We already
-		 * know we are in the same section as what should
-		 * hold store.key.
-		 */
-		ep = strrchr(key, '.');
-		section_len = ep - key;
-
-		if ((section_len != store.baselen) ||
-		    memcmp(key, store.key, section_len+1)) {
-			store.state = SECTION_END_SEEN;
-			break;
-		}
-
-		/*
-		 * Do not increment matches: this is no match, but we
-		 * just made sure we are in the desired section.
-		 */
-		store.offset[store.seen] = ftell(config_file);
-		/* fallthru */
-	case SECTION_END_SEEN:
-	case START:
-		if (matches(key, value)) {
-			store.offset[store.seen] = ftell(config_file);
-			store.state = KEY_SEEN;
-			store.seen++;
-		} else {
-			if (strrchr(key, '.') - key == store.baselen &&
-			      !strncmp(key, store.key, store.baselen)) {
-					store.state = SECTION_SEEN;
-					store.offset[store.seen] = ftell(config_file);
-			}
-		}
-	default:
-		break;
-	}
-	return 0;
-}
-
-static int store_write_section(int fd, const char* key)
-{
-	const char *dot;
-	int i, success;
-	struct strbuf sb = STRBUF_INIT;
-
-	dot = memchr(key, '.', store.baselen);
-	if (dot) {
-		strbuf_addf(&sb, "[%.*s \"", (int)(dot - key), key);
-		for (i = dot - key + 1; i < store.baselen; i++) {
-			if (key[i] == '"' || key[i] == '\\')
-				strbuf_addch(&sb, '\\');
-			strbuf_addch(&sb, key[i]);
-		}
-		strbuf_addstr(&sb, "\"]\n");
-	} else {
-		strbuf_addf(&sb, "[%.*s]\n", store.baselen, key);
-	}
-
-	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
-	strbuf_release(&sb);
-
-	return success;
-}
-
-static int store_write_pair(int fd, const char* key, const char* value)
-{
-	int i, success;
-	int length = strlen(key + store.baselen + 1);
-	const char *quote = "";
-	struct strbuf sb = STRBUF_INIT;
-
-	/*
-	 * Check to see if the value needs to be surrounded with a dq pair.
-	 * Note that problematic characters are always backslash-quoted; this
-	 * check is about not losing leading or trailing SP and strings that
-	 * follow beginning-of-comment characters (i.e. ';' and '#') by the
-	 * configuration parser.
-	 */
-	if (value[0] == ' ')
-		quote = "\"";
-	for (i = 0; value[i]; i++)
-		if (value[i] == ';' || value[i] == '#')
-			quote = "\"";
-	if (i && value[i - 1] == ' ')
-		quote = "\"";
-
-	strbuf_addf(&sb, "\t%.*s = %s",
-		    length, key + store.baselen + 1, quote);
-
-	for (i = 0; value[i]; i++)
-		switch (value[i]) {
-		case '\n':
-			strbuf_addstr(&sb, "\\n");
-			break;
-		case '\t':
-			strbuf_addstr(&sb, "\\t");
-			break;
-		case '"':
-		case '\\':
-			strbuf_addch(&sb, '\\');
-		default:
-			strbuf_addch(&sb, value[i]);
-			break;
-		}
-	strbuf_addf(&sb, "%s\n", quote);
-
-	success = (write_in_full(fd, sb.buf, sb.len) == (ssize_t)sb.len);
-	strbuf_release(&sb);
-
-	return success;
-}
-
-static ssize_t find_beginning_of_line(const char* contents, size_t size,
-	size_t offset_, int* found_bracket)
-{
-	size_t equal_offset = size, bracket_offset = size;
-	ssize_t offset;
-
-contline:
-	for (offset = offset_-2; offset > 0
-			&& contents[offset] != '\n'; offset--)
-		switch (contents[offset]) {
-			case '=': equal_offset = offset; break;
-			case ']': bracket_offset = offset; break;
-			default: break;
-		}
-	if (offset > 0 && contents[offset-1] == '\\') {
-		offset_ = offset;
-		goto contline;
-	}
-	if (bracket_offset < equal_offset) {
-		*found_bracket = 1;
-		offset = bracket_offset+1;
-	} else
-		offset++;
-
-	return offset;
-}
-
-int perf_config_set(const char* key, const char* value)
-{
-	return perf_config_set_multivar(key, value, NULL, 0);
-}
-
-/*
- * If value==NULL, unset in (remove from) config,
- * if value_regex!=NULL, disregard key/value pairs where value does not match.
- * if multi_replace==0, nothing, or only one matching key/value is replaced,
- *     else all matching key/values (regardless how many) are removed,
- *     before the new pair is written.
- *
- * Returns 0 on success.
- *
- * This function does this:
- *
- * - it locks the config file by creating ".perf/config.lock"
- *
- * - it then parses the config using store_aux() as validator to find
- *   the position on the key/value pair to replace. If it is to be unset,
- *   it must be found exactly once.
- *
- * - the config file is mmap()ed and the part before the match (if any) is
- *   written to the lock file, then the changed part and the rest.
- *
- * - the config file is removed and the lock file rename()d to it.
- *
- */
-int perf_config_set_multivar(const char* key, const char* value,
-	const char* value_regex, int multi_replace)
-{
-	int i, dot;
-	int fd = -1, in_fd;
-	int ret = 0;
-	char* config_filename;
-	const char* last_dot = strrchr(key, '.');
-
-	if (config_exclusive_filename)
-		config_filename = strdup(config_exclusive_filename);
-	else
-		config_filename = perf_pathdup("config");
-
-	/*
-	 * Since "key" actually contains the section name and the real
-	 * key name separated by a dot, we have to know where the dot is.
-	 */
-
-	if (last_dot == NULL) {
-		error("key does not contain a section: %s", key);
-		ret = 2;
-		goto out_free;
-	}
-	store.baselen = last_dot - key;
-
-	store.multi_replace = multi_replace;
-
-	/*
-	 * Validate the key and while at it, lower case it for matching.
-	 */
-	store.key = malloc(strlen(key) + 1);
-	dot = 0;
-	for (i = 0; key[i]; i++) {
-		unsigned char c = key[i];
-		if (c == '.')
-			dot = 1;
-		/* Leave the extended basename untouched.. */
-		if (!dot || i > store.baselen) {
-			if (!iskeychar(c) || (i == store.baselen+1 && !isalpha(c))) {
-				error("invalid key: %s", key);
-				free(store.key);
-				ret = 1;
-				goto out_free;
-			}
-			c = tolower(c);
-		} else if (c == '\n') {
-			error("invalid key (newline): %s", key);
-			free(store.key);
-			ret = 1;
-			goto out_free;
-		}
-		store.key[i] = c;
-	}
-	store.key[i] = 0;
-
-	/*
-	 * If .perf/config does not exist yet, write a minimal version.
-	 */
-	in_fd = open(config_filename, O_RDONLY);
-	if ( in_fd < 0 ) {
-		free(store.key);
-
-		if ( ENOENT != errno ) {
-			error("opening %s: %s", config_filename,
-			      strerror(errno));
-			ret = 3; /* same as "invalid config file" */
-			goto out_free;
-		}
-		/* if nothing to unset, error out */
-		if (value == NULL) {
-			ret = 5;
-			goto out_free;
-		}
-
-		store.key = (char*)key;
-		if (!store_write_section(fd, key) ||
-		    !store_write_pair(fd, key, value))
-			goto write_err_out;
-	} else {
-		struct stat st;
-		char *contents;
-		ssize_t contents_sz, copy_begin, copy_end;
-		int new_line = 0;
-
-		if (value_regex == NULL)
-			store.value_regex = NULL;
-		else {
-			if (value_regex[0] == '!') {
-				store.do_not_match = 1;
-				value_regex++;
-			} else
-				store.do_not_match = 0;
-
-			store.value_regex = (regex_t*)malloc(sizeof(regex_t));
-			if (regcomp(store.value_regex, value_regex,
-					REG_EXTENDED)) {
-				error("invalid pattern: %s", value_regex);
-				free(store.value_regex);
-				ret = 6;
-				goto out_free;
-			}
-		}
-
-		store.offset[0] = 0;
-		store.state = START;
-		store.seen = 0;
-
-		/*
-		 * After this, store.offset will contain the *end* offset
-		 * of the last match, or remain at 0 if no match was found.
-		 * As a side effect, we make sure to transform only a valid
-		 * existing config file.
-		 */
-		if (perf_config_from_file(store_aux, config_filename, NULL)) {
-			error("invalid config file %s", config_filename);
-			free(store.key);
-			if (store.value_regex != NULL) {
-				regfree(store.value_regex);
-				free(store.value_regex);
-			}
-			ret = 3;
-			goto out_free;
-		}
-
-		free(store.key);
-		if (store.value_regex != NULL) {
-			regfree(store.value_regex);
-			free(store.value_regex);
-		}
-
-		/* if nothing to unset, or too many matches, error out */
-		if ((store.seen == 0 && value == NULL) ||
-				(store.seen > 1 && multi_replace == 0)) {
-			ret = 5;
-			goto out_free;
-		}
-
-		fstat(in_fd, &st);
-		contents_sz = xsize_t(st.st_size);
-		contents = mmap(NULL, contents_sz, PROT_READ,
-			MAP_PRIVATE, in_fd, 0);
-		close(in_fd);
-
-		if (store.seen == 0)
-			store.seen = 1;
-
-		for (i = 0, copy_begin = 0; i < store.seen; i++) {
-			if (store.offset[i] == 0) {
-				store.offset[i] = copy_end = contents_sz;
-			} else if (store.state != KEY_SEEN) {
-				copy_end = store.offset[i];
-			} else
-				copy_end = find_beginning_of_line(
-					contents, contents_sz,
-					store.offset[i]-2, &new_line);
-
-			if (copy_end > 0 && contents[copy_end-1] != '\n')
-				new_line = 1;
-
-			/* write the first part of the config */
-			if (copy_end > copy_begin) {
-				if (write_in_full(fd, contents + copy_begin,
-						  copy_end - copy_begin) <
-				    copy_end - copy_begin)
-					goto write_err_out;
-				if (new_line &&
-				    write_in_full(fd, "\n", 1) != 1)
-					goto write_err_out;
-			}
-			copy_begin = store.offset[i];
-		}
-
-		/* write the pair (value == NULL means unset) */
-		if (value != NULL) {
-			if (store.state == START) {
-				if (!store_write_section(fd, key))
-					goto write_err_out;
-			}
-			if (!store_write_pair(fd, key, value))
-				goto write_err_out;
-		}
-
-		/* write the rest of the config */
-		if (copy_begin < contents_sz)
-			if (write_in_full(fd, contents + copy_begin,
-					  contents_sz - copy_begin) <
-			    contents_sz - copy_begin)
-				goto write_err_out;
-
-		munmap(contents, contents_sz);
-	}
-
-	ret = 0;
-
-out_free:
-	free(config_filename);
-	return ret;
-
-write_err_out:
-	goto out_free;
-
-}
-
-/*
  * Call this to report error for your variable that should not
  * get a boolean value (i.e. "[my] var" means "true").
  */
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 2745605..c1b3d34 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -116,7 +116,7 @@ void setup_path(void)
 	strbuf_release(&new_path);
 }
 
-const char **prepare_perf_cmd(const char **argv)
+static const char **prepare_perf_cmd(const char **argv)
 {
 	int argc;
 	const char **nargv;
diff --git a/tools/perf/util/exec_cmd.h b/tools/perf/util/exec_cmd.h
index 31647ac..bc4b915 100644
--- a/tools/perf/util/exec_cmd.h
+++ b/tools/perf/util/exec_cmd.h
@@ -5,7 +5,6 @@ extern void perf_set_argv_exec_path(const char *exec_path);
 extern const char *perf_extract_argv0_path(const char *path);
 extern const char *perf_exec_path(void);
 extern void setup_path(void);
-extern const char **prepare_perf_cmd(const char **argv);
 extern int execv_perf_cmd(const char **argv); /* NULL terminated */
 extern int execl_perf_cmd(const char *cmd, ...);
 extern const char *system_path(const char *path);
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index fbb0097..6f2975a 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -4,28 +4,6 @@
 #include "levenshtein.h"
 #include "help.h"
 
-/* most GUI terminals set COLUMNS (although some don't export it) */
-static int term_columns(void)
-{
-	char *col_string = getenv("COLUMNS");
-	int n_cols;
-
-	if (col_string && (n_cols = atoi(col_string)) > 0)
-		return n_cols;
-
-#ifdef TIOCGWINSZ
-	{
-		struct winsize ws;
-		if (!ioctl(1, TIOCGWINSZ, &ws)) {
-			if (ws.ws_col)
-				return ws.ws_col;
-		}
-	}
-#endif
-
-	return 80;
-}
-
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
 	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);
@@ -96,9 +74,13 @@ static void pretty_print_string_list(struct cmdnames *cmds, int longest)
 {
 	int cols = 1, rows;
 	int space = longest + 1; /* min 1 SP between words */
-	int max_cols = term_columns() - 1; /* don't print *on* the edge */
+	struct winsize win;
+	int max_cols;
 	int i, j;
 
+	get_term_dimensions(&win);
+	max_cols = win.ws_col - 1; /* don't print *on* the edge */
+
 	if (space < max_cols)
 		cols = max_cols / space;
 	rows = (cmds->cnt + cols - 1) / cols;
@@ -324,7 +306,7 @@ const char *help_unknown_cmd(const char *cmd)
 
 		main_cmds.names[0] = NULL;
 		clean_cmdnames(&main_cmds);
-		fprintf(stderr, "WARNING: You called a Git program named '%s', "
+		fprintf(stderr, "WARNING: You called a perf program named '%s', "
 			"which does not exist.\n"
 			"Continuing under the assumption that you meant '%s'\n",
 			cmd, assumed);
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index fd1f2fa..b276c18 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -54,21 +54,6 @@ static char *cleanup_path(char *path)
 	return path;
 }
 
-char *mksnpath(char *buf, size_t n, const char *fmt, ...)
-{
-	va_list args;
-	unsigned len;
-
-	va_start(args, fmt);
-	len = vsnprintf(buf, n, fmt, args);
-	va_end(args);
-	if (len >= n) {
-		strlcpy(buf, bad_path, n);
-		return buf;
-	}
-	return cleanup_path(buf);
-}
-
 static char *perf_vsnpath(char *buf, size_t n, const char *fmt, va_list args)
 {
 	const char *perf_dir = get_perf_dir();
@@ -89,15 +74,6 @@ bad:
 	return buf;
 }
 
-char *perf_snpath(char *buf, size_t n, const char *fmt, ...)
-{
-	va_list args;
-	va_start(args, fmt);
-	(void)perf_vsnpath(buf, n, fmt, args);
-	va_end(args);
-	return buf;
-}
-
 char *perf_pathdup(const char *fmt, ...)
 {
 	char path[PATH_MAX];
@@ -143,184 +119,6 @@ char *perf_path(const char *fmt, ...)
 	return cleanup_path(pathname);
 }
 
-
-/* perf_mkstemp() - create tmp file honoring TMPDIR variable */
-int perf_mkstemp(char *path, size_t len, const char *template)
-{
-	const char *tmp;
-	size_t n;
-
-	tmp = getenv("TMPDIR");
-	if (!tmp)
-		tmp = "/tmp";
-	n = snprintf(path, len, "%s/%s", tmp, template);
-	if (len <= n) {
-		errno = ENAMETOOLONG;
-		return -1;
-	}
-	return mkstemp(path);
-}
-
-
-const char *make_relative_path(const char *abs_path, const char *base)
-{
-	static char buf[PATH_MAX + 1];
-	int baselen;
-
-	if (!base)
-		return abs_path;
-
-	baselen = strlen(base);
-	if (prefixcmp(abs_path, base))
-		return abs_path;
-	if (abs_path[baselen] == '/')
-		baselen++;
-	else if (base[baselen - 1] != '/')
-		return abs_path;
-
-	strcpy(buf, abs_path + baselen);
-
-	return buf;
-}
-
-/*
- * It is okay if dst == src, but they should not overlap otherwise.
- *
- * Performs the following normalizations on src, storing the result in dst:
- * - Ensures that components are separated by '/' (Windows only)
- * - Squashes sequences of '/'.
- * - Removes "." components.
- * - Removes ".." components, and the components the precede them.
- * Returns failure (non-zero) if a ".." component appears as first path
- * component anytime during the normalization. Otherwise, returns success (0).
- *
- * Note that this function is purely textual.  It does not follow symlinks,
- * verify the existence of the path, or make any system calls.
- */
-int normalize_path_copy(char *dst, const char *src)
-{
-	char *dst0;
-
-	if (has_dos_drive_prefix(src)) {
-		*dst++ = *src++;
-		*dst++ = *src++;
-	}
-	dst0 = dst;
-
-	if (is_dir_sep(*src)) {
-		*dst++ = '/';
-		while (is_dir_sep(*src))
-			src++;
-	}
-
-	for (;;) {
-		char c = *src;
-
-		/*
-		 * A path component that begins with . could be
-		 * special:
-		 * (1) "." and ends   -- ignore and terminate.
-		 * (2) "./"           -- ignore them, eat slash and continue.
-		 * (3) ".." and ends  -- strip one and terminate.
-		 * (4) "../"          -- strip one, eat slash and continue.
-		 */
-		if (c == '.') {
-			if (!src[1]) {
-				/* (1) */
-				src++;
-			} else if (is_dir_sep(src[1])) {
-				/* (2) */
-				src += 2;
-				while (is_dir_sep(*src))
-					src++;
-				continue;
-			} else if (src[1] == '.') {
-				if (!src[2]) {
-					/* (3) */
-					src += 2;
-					goto up_one;
-				} else if (is_dir_sep(src[2])) {
-					/* (4) */
-					src += 3;
-					while (is_dir_sep(*src))
-						src++;
-					goto up_one;
-				}
-			}
-		}
-
-		/* copy up to the next '/', and eat all '/' */
-		while ((c = *src++) != '\0' && !is_dir_sep(c))
-			*dst++ = c;
-		if (is_dir_sep(c)) {
-			*dst++ = '/';
-			while (is_dir_sep(c))
-				c = *src++;
-			src--;
-		} else if (!c)
-			break;
-		continue;
-
-	up_one:
-		/*
-		 * dst0..dst is prefix portion, and dst[-1] is '/';
-		 * go up one level.
-		 */
-		dst--;	/* go to trailing '/' */
-		if (dst <= dst0)
-			return -1;
-		/* Windows: dst[-1] cannot be backslash anymore */
-		while (dst0 < dst && dst[-1] != '/')
-			dst--;
-	}
-	*dst = '\0';
-	return 0;
-}
-
-/*
- * path = Canonical absolute path
- * prefix_list = Colon-separated list of absolute paths
- *
- * Determines, for each path in prefix_list, whether the "prefix" really
- * is an ancestor directory of path.  Returns the length of the longest
- * ancestor directory, excluding any trailing slashes, or -1 if no prefix
- * is an ancestor.  (Note that this means 0 is returned if prefix_list is
- * "/".) "/foo" is not considered an ancestor of "/foobar".  Directories
- * are not considered to be their own ancestors.  path must be in a
- * canonical form: empty components, or "." or ".." components are not
- * allowed.  prefix_list may be null, which is like "".
- */
-int longest_ancestor_length(const char *path, const char *prefix_list)
-{
-	char buf[PATH_MAX+1];
-	const char *ceil, *colon;
-	int len, max_len = -1;
-
-	if (prefix_list == NULL || !strcmp(path, "/"))
-		return -1;
-
-	for (colon = ceil = prefix_list; *colon; ceil = colon+1) {
-		for (colon = ceil; *colon && *colon != PATH_SEP; colon++);
-		len = colon - ceil;
-		if (len == 0 || len > PATH_MAX || !is_absolute_path(ceil))
-			continue;
-		strlcpy(buf, ceil, len+1);
-		if (normalize_path_copy(buf, buf) < 0)
-			continue;
-		len = strlen(buf);
-		if (len > 0 && buf[len-1] == '/')
-			buf[--len] = '\0';
-
-		if (!strncmp(path, buf, len) &&
-		    path[len] == '/' &&
-		    len > max_len) {
-			max_len = len;
-		}
-	}
-
-	return max_len;
-}
-
 /* strip arbitrary amount of directory separators at end of path */
 static inline int chomp_trailing_dir_sep(const char *path, int len)
 {
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index 2726fe4..01f0324 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -1,8 +1,6 @@
 #include "cache.h"
 #include "quote.h"
 
-int quote_path_fully = 1;
-
 /* Help to copy the thing properly quoted for the shell safety.
  * any single quote is replaced with '\'', any exclamation point
  * is replaced with '\!', and the whole thing is enclosed in a
@@ -19,7 +17,7 @@ static inline int need_bs_quote(char c)
 	return (c == '\'' || c == '!');
 }
 
-void sq_quote_buf(struct strbuf *dst, const char *src)
+static void sq_quote_buf(struct strbuf *dst, const char *src)
 {
 	char *to_free = NULL;
 
@@ -41,23 +39,6 @@ void sq_quote_buf(struct strbuf *dst, const char *src)
 	free(to_free);
 }
 
-void sq_quote_print(FILE *stream, const char *src)
-{
-	char c;
-
-	fputc('\'', stream);
-	while ((c = *src++)) {
-		if (need_bs_quote(c)) {
-			fputs("'\\", stream);
-			fputc(c, stream);
-			fputc('\'', stream);
-		} else {
-			fputc(c, stream);
-		}
-	}
-	fputc('\'', stream);
-}
-
 void sq_quote_argv(struct strbuf *dst, const char** argv, size_t maxlen)
 {
 	int i;
@@ -71,415 +52,3 @@ void sq_quote_argv(struct strbuf *dst, const char** argv, size_t maxlen)
 			die("Too many or long arguments");
 	}
 }
-
-char *sq_dequote_step(char *arg, char **next)
-{
-	char *dst = arg;
-	char *src = arg;
-	char c;
-
-	if (*src != '\'')
-		return NULL;
-	for (;;) {
-		c = *++src;
-		if (!c)
-			return NULL;
-		if (c != '\'') {
-			*dst++ = c;
-			continue;
-		}
-		/* We stepped out of sq */
-		switch (*++src) {
-		case '\0':
-			*dst = 0;
-			if (next)
-				*next = NULL;
-			return arg;
-		case '\\':
-			c = *++src;
-			if (need_bs_quote(c) && *++src == '\'') {
-				*dst++ = c;
-				continue;
-			}
-		/* Fallthrough */
-		default:
-			if (!next || !isspace(*src))
-				return NULL;
-			do {
-				c = *++src;
-			} while (isspace(c));
-			*dst = 0;
-			*next = src;
-			return arg;
-		}
-	}
-}
-
-char *sq_dequote(char *arg)
-{
-	return sq_dequote_step(arg, NULL);
-}
-
-int sq_dequote_to_argv(char *arg, const char ***argv, int *nr, int *alloc)
-{
-	char *next = arg;
-
-	if (!*arg)
-		return 0;
-	do {
-		char *dequoted = sq_dequote_step(next, &next);
-		if (!dequoted)
-			return -1;
-		ALLOC_GROW(*argv, *nr + 1, *alloc);
-		(*argv)[(*nr)++] = dequoted;
-	} while (next);
-
-	return 0;
-}
-
-/* 1 means: quote as octal
- * 0 means: quote as octal if (quote_path_fully)
- * -1 means: never quote
- * c: quote as "\\c"
- */
-#define X8(x)   x, x, x, x, x, x, x, x
-#define X16(x)  X8(x), X8(x)
-static signed char const sq_lookup[256] = {
-	/*           0    1    2    3    4    5    6    7 */
-	/* 0x00 */   1,   1,   1,   1,   1,   1,   1, 'a',
-	/* 0x08 */ 'b', 't', 'n', 'v', 'f', 'r',   1,   1,
-	/* 0x10 */ X16(1),
-	/* 0x20 */  -1,  -1, '"',  -1,  -1,  -1,  -1,  -1,
-	/* 0x28 */ X16(-1), X16(-1), X16(-1),
-	/* 0x58 */  -1,  -1,  -1,  -1,'\\',  -1,  -1,  -1,
-	/* 0x60 */ X16(-1), X8(-1),
-	/* 0x78 */  -1,  -1,  -1,  -1,  -1,  -1,  -1,   1,
-	/* 0x80 */ /* set to 0 */
-};
-
-static inline int sq_must_quote(char c)
-{
-	return sq_lookup[(unsigned char)c] + quote_path_fully > 0;
-}
-
-/*
- * Returns the longest prefix not needing a quote up to maxlen if
- * positive.
- * This stops at the first \0 because it's marked as a character
- * needing an escape.
- */
-static ssize_t next_quote_pos(const char *s, ssize_t maxlen)
-{
-	ssize_t len;
-
-	if (maxlen < 0) {
-		for (len = 0; !sq_must_quote(s[len]); len++);
-	} else {
-		for (len = 0; len < maxlen && !sq_must_quote(s[len]); len++);
-	}
-	return len;
-}
-
-/*
- * C-style name quoting.
- *
- * (1) if sb and fp are both NULL, inspect the input name and counts the
- *     number of bytes that are needed to hold c_style quoted version of name,
- *     counting the double quotes around it but not terminating NUL, and
- *     returns it.
- *     However, if name does not need c_style quoting, it returns 0.
- *
- * (2) if sb or fp are not NULL, it emits the c_style quoted version
- *     of name, enclosed with double quotes if asked and needed only.
- *     Return value is the same as in (1).
- */
-static size_t quote_c_style_counted(const char *name, ssize_t maxlen,
-                                    struct strbuf *sb, FILE *fp, int no_dq)
-{
-#define EMIT(c)							\
-	do {							\
-		if (sb) strbuf_addch(sb, (c));			\
-		if (fp) fputc((c), fp);				\
-		count++;					\
-	} while (0)
-
-#define EMITBUF(s, l)						\
-	do {							\
-		int __ret;					\
-		if (sb) strbuf_add(sb, (s), (l));		\
-		if (fp) __ret = fwrite((s), (l), 1, fp);	\
-		count += (l);					\
-	} while (0)
-
-	ssize_t len, count = 0;
-	const char *p = name;
-
-	for (;;) {
-		int ch;
-
-		len = next_quote_pos(p, maxlen);
-		if (len == maxlen || !p[len])
-			break;
-
-		if (!no_dq && p == name)
-			EMIT('"');
-
-		EMITBUF(p, len);
-		EMIT('\\');
-		p += len;
-		ch = (unsigned char)*p++;
-		if (sq_lookup[ch] >= ' ') {
-			EMIT(sq_lookup[ch]);
-		} else {
-			EMIT(((ch >> 6) & 03) + '0');
-			EMIT(((ch >> 3) & 07) + '0');
-			EMIT(((ch >> 0) & 07) + '0');
-		}
-	}
-
-	EMITBUF(p, len);
-	if (p == name)   /* no ending quote needed */
-		return 0;
-
-	if (!no_dq)
-		EMIT('"');
-	return count;
-}
-
-size_t quote_c_style(const char *name, struct strbuf *sb, FILE *fp, int nodq)
-{
-	return quote_c_style_counted(name, -1, sb, fp, nodq);
-}
-
-void quote_two_c_style(struct strbuf *sb, const char *prefix, const char *path, int nodq)
-{
-	if (quote_c_style(prefix, NULL, NULL, 0) ||
-	    quote_c_style(path, NULL, NULL, 0)) {
-		if (!nodq)
-			strbuf_addch(sb, '"');
-		quote_c_style(prefix, sb, NULL, 1);
-		quote_c_style(path, sb, NULL, 1);
-		if (!nodq)
-			strbuf_addch(sb, '"');
-	} else {
-		strbuf_addstr(sb, prefix);
-		strbuf_addstr(sb, path);
-	}
-}
-
-void write_name_quoted(const char *name, FILE *fp, int terminator)
-{
-	if (terminator) {
-		quote_c_style(name, NULL, fp, 0);
-	} else {
-		fputs(name, fp);
-	}
-	fputc(terminator, fp);
-}
-
-void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
-			  const char *name, FILE *fp, int terminator)
-{
-	int needquote = 0;
-
-	if (terminator) {
-		needquote = next_quote_pos(pfx, pfxlen) < pfxlen
-			|| name[next_quote_pos(name, -1)];
-	}
-	if (needquote) {
-		fputc('"', fp);
-		quote_c_style_counted(pfx, pfxlen, NULL, fp, 1);
-		quote_c_style(name, NULL, fp, 1);
-		fputc('"', fp);
-	} else {
-		int ret;
-
-		ret = fwrite(pfx, pfxlen, 1, fp);
-		fputs(name, fp);
-	}
-	fputc(terminator, fp);
-}
-
-/* quote path as relative to the given prefix */
-char *quote_path_relative(const char *in, int len,
-			  struct strbuf *out, const char *prefix)
-{
-	int needquote;
-
-	if (len < 0)
-		len = strlen(in);
-
-	/* "../" prefix itself does not need quoting, but "in" might. */
-	needquote = (next_quote_pos(in, len) < len);
-	strbuf_setlen(out, 0);
-	strbuf_grow(out, len);
-
-	if (needquote)
-		strbuf_addch(out, '"');
-	if (prefix) {
-		int off = 0;
-		while (off < len && prefix[off] && prefix[off] == in[off])
-			if (prefix[off] == '/') {
-				prefix += off + 1;
-				in += off + 1;
-				len -= off + 1;
-				off = 0;
-			} else
-				off++;
-
-		for (; *prefix; prefix++)
-			if (*prefix == '/')
-				strbuf_addstr(out, "../");
-	}
-
-	quote_c_style_counted (in, len, out, NULL, 1);
-
-	if (needquote)
-		strbuf_addch(out, '"');
-	if (!out->len)
-		strbuf_addstr(out, "./");
-
-	return out->buf;
-}
-
-/*
- * C-style name unquoting.
- *
- * Quoted should point at the opening double quote.
- * + Returns 0 if it was able to unquote the string properly, and appends the
- *   result in the strbuf `sb'.
- * + Returns -1 in case of error, and doesn't touch the strbuf. Though note
- *   that this function will allocate memory in the strbuf, so calling
- *   strbuf_release is mandatory whichever result unquote_c_style returns.
- *
- * Updates endp pointer to point at one past the ending double quote if given.
- */
-int unquote_c_style(struct strbuf *sb, const char *quoted, const char **endp)
-{
-	size_t oldlen = sb->len, len;
-	int ch, ac;
-
-	if (*quoted++ != '"')
-		return -1;
-
-	for (;;) {
-		len = strcspn(quoted, "\"\\");
-		strbuf_add(sb, quoted, len);
-		quoted += len;
-
-		switch (*quoted++) {
-		  case '"':
-			if (endp)
-				*endp = quoted;
-			return 0;
-		  case '\\':
-			break;
-		  default:
-			goto error;
-		}
-
-		switch ((ch = *quoted++)) {
-		case 'a': ch = '\a'; break;
-		case 'b': ch = '\b'; break;
-		case 'f': ch = '\f'; break;
-		case 'n': ch = '\n'; break;
-		case 'r': ch = '\r'; break;
-		case 't': ch = '\t'; break;
-		case 'v': ch = '\v'; break;
-
-		case '\\': case '"':
-			break; /* verbatim */
-
-		/* octal values with first digit over 4 overflow */
-		case '0': case '1': case '2': case '3':
-					ac = ((ch - '0') << 6);
-			if ((ch = *quoted++) < '0' || '7' < ch)
-				goto error;
-					ac |= ((ch - '0') << 3);
-			if ((ch = *quoted++) < '0' || '7' < ch)
-				goto error;
-					ac |= (ch - '0');
-					ch = ac;
-					break;
-				default:
-			goto error;
-			}
-		strbuf_addch(sb, ch);
-		}
-
-  error:
-	strbuf_setlen(sb, oldlen);
-	return -1;
-}
-
-/* quoting as a string literal for other languages */
-
-void perl_quote_print(FILE *stream, const char *src)
-{
-	const char sq = '\'';
-	const char bq = '\\';
-	char c;
-
-	fputc(sq, stream);
-	while ((c = *src++)) {
-		if (c == sq || c == bq)
-			fputc(bq, stream);
-		fputc(c, stream);
-	}
-	fputc(sq, stream);
-}
-
-void python_quote_print(FILE *stream, const char *src)
-{
-	const char sq = '\'';
-	const char bq = '\\';
-	const char nl = '\n';
-	char c;
-
-	fputc(sq, stream);
-	while ((c = *src++)) {
-		if (c == nl) {
-			fputc(bq, stream);
-			fputc('n', stream);
-			continue;
-		}
-		if (c == sq || c == bq)
-			fputc(bq, stream);
-		fputc(c, stream);
-	}
-	fputc(sq, stream);
-}
-
-void tcl_quote_print(FILE *stream, const char *src)
-{
-	char c;
-
-	fputc('"', stream);
-	while ((c = *src++)) {
-		switch (c) {
-		case '[': case ']':
-		case '{': case '}':
-		case '$': case '\\': case '"':
-			fputc('\\', stream);
-		default:
-			fputc(c, stream);
-			break;
-		case '\f':
-			fputs("\\f", stream);
-			break;
-		case '\r':
-			fputs("\\r", stream);
-			break;
-		case '\n':
-			fputs("\\n", stream);
-			break;
-		case '\t':
-			fputs("\\t", stream);
-			break;
-		case '\v':
-			fputs("\\v", stream);
-			break;
-		}
-	}
-	fputc('"', stream);
-}
diff --git a/tools/perf/util/quote.h b/tools/perf/util/quote.h
index b6a0197..172889e 100644
--- a/tools/perf/util/quote.h
+++ b/tools/perf/util/quote.h
@@ -22,47 +22,8 @@
  *
  * Note that the above examples leak memory!  Remember to free result from
  * sq_quote() in a real application.
- *
- * sq_quote_buf() writes to an existing buffer of specified size; it
- * will return the number of characters that would have been written
- * excluding the final null regardless of the buffer size.
  */
 
-extern void sq_quote_print(FILE *stream, const char *src);
-
-extern void sq_quote_buf(struct strbuf *, const char *src);
 extern void sq_quote_argv(struct strbuf *, const char **argv, size_t maxlen);
 
-/* This unwraps what sq_quote() produces in place, but returns
- * NULL if the input does not look like what sq_quote would have
- * produced.
- */
-extern char *sq_dequote(char *);
-
-/*
- * Same as the above, but can be used to unwrap many arguments in the
- * same string separated by space. "next" is changed to point to the
- * next argument that should be passed as first parameter. When there
- * is no more argument to be dequoted, "next" is updated to point to NULL.
- */
-extern char *sq_dequote_step(char *arg, char **next);
-extern int sq_dequote_to_argv(char *arg, const char ***argv, int *nr, int *alloc);
-
-extern int unquote_c_style(struct strbuf *, const char *quoted, const char **endp);
-extern size_t quote_c_style(const char *name, struct strbuf *, FILE *, int no_dq);
-extern void quote_two_c_style(struct strbuf *, const char *, const char *, int);
-
-extern void write_name_quoted(const char *name, FILE *, int terminator);
-extern void write_name_quotedpfx(const char *pfx, ssize_t pfxlen,
-                                 const char *name, FILE *, int terminator);
-
-/* quote path as relative to the given prefix */
-char *quote_path_relative(const char *in, int len,
-			  struct strbuf *out, const char *prefix);
-
-/* quoting as a string literal for other languages */
-extern void perl_quote_print(FILE *stream, const char *src);
-extern void python_quote_print(FILE *stream, const char *src);
-extern void tcl_quote_print(FILE *stream, const char *src);
-
 #endif /* __PERF_QUOTE_H */
diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
index 2b615ac..da8e9b2 100644
--- a/tools/perf/util/run-command.c
+++ b/tools/perf/util/run-command.c
@@ -212,93 +212,3 @@ int run_command_v_opt(const char **argv, int opt)
 	prepare_run_command_v_opt(&cmd, argv, opt);
 	return run_command(&cmd);
 }
-
-int run_command_v_opt_cd_env(const char **argv, int opt, const char *dir, const char *const *env)
-{
-	struct child_process cmd;
-	prepare_run_command_v_opt(&cmd, argv, opt);
-	cmd.dir = dir;
-	cmd.env = env;
-	return run_command(&cmd);
-}
-
-int start_async(struct async *async)
-{
-	int pipe_out[2];
-
-	if (pipe(pipe_out) < 0)
-		return error("cannot create pipe: %s", strerror(errno));
-	async->out = pipe_out[0];
-
-	/* Flush stdio before fork() to avoid cloning buffers */
-	fflush(NULL);
-
-	async->pid = fork();
-	if (async->pid < 0) {
-		error("fork (async) failed: %s", strerror(errno));
-		close_pair(pipe_out);
-		return -1;
-	}
-	if (!async->pid) {
-		close(pipe_out[0]);
-		exit(!!async->proc(pipe_out[1], async->data));
-	}
-	close(pipe_out[1]);
-
-	return 0;
-}
-
-int finish_async(struct async *async)
-{
-	int ret = 0;
-
-	if (wait_or_whine(async->pid))
-		ret = error("waitpid (async) failed");
-
-	return ret;
-}
-
-int run_hook(const char *index_file, const char *name, ...)
-{
-	struct child_process hook;
-	const char **argv = NULL, *env[2];
-	char idx[PATH_MAX];
-	va_list args;
-	int ret;
-	size_t i = 0, alloc = 0;
-
-	if (access(perf_path("hooks/%s", name), X_OK) < 0)
-		return 0;
-
-	va_start(args, name);
-	ALLOC_GROW(argv, i + 1, alloc);
-	argv[i++] = perf_path("hooks/%s", name);
-	while (argv[i-1]) {
-		ALLOC_GROW(argv, i + 1, alloc);
-		argv[i++] = va_arg(args, const char *);
-	}
-	va_end(args);
-
-	memset(&hook, 0, sizeof(hook));
-	hook.argv = argv;
-	hook.no_stdin = 1;
-	hook.stdout_to_stderr = 1;
-	if (index_file) {
-		snprintf(idx, sizeof(idx), "PERF_INDEX_FILE=%s", index_file);
-		env[0] = idx;
-		env[1] = NULL;
-		hook.env = env;
-	}
-
-	ret = start_command(&hook);
-	free(argv);
-	if (ret) {
-		warning("Could not spawn %s", argv[0]);
-		return ret;
-	}
-	ret = finish_command(&hook);
-	if (ret == -ERR_RUN_COMMAND_WAITPID_SIGNAL)
-		warning("%s exited due to uncaught signal", argv[0]);
-
-	return ret;
-}
diff --git a/tools/perf/util/run-command.h b/tools/perf/util/run-command.h
index d790287..1ef264d 100644
--- a/tools/perf/util/run-command.h
+++ b/tools/perf/util/run-command.h
@@ -50,39 +50,9 @@ int start_command(struct child_process *);
 int finish_command(struct child_process *);
 int run_command(struct child_process *);
 
-extern int run_hook(const char *index_file, const char *name, ...);
-
 #define RUN_COMMAND_NO_STDIN 1
 #define RUN_PERF_CMD	     2	/*If this is to be perf sub-command */
 #define RUN_COMMAND_STDOUT_TO_STDERR 4
 int run_command_v_opt(const char **argv, int opt);
 
-/*
- * env (the environment) is to be formatted like environ: "VAR=VALUE".
- * To unset an environment variable use just "VAR".
- */
-int run_command_v_opt_cd_env(const char **argv, int opt, const char *dir, const char *const *env);
-
-/*
- * The purpose of the following functions is to feed a pipe by running
- * a function asynchronously and providing output that the caller reads.
- *
- * It is expected that no synchronization and mutual exclusion between
- * the caller and the feed function is necessary so that the function
- * can run in a thread without interfering with the caller.
- */
-struct async {
-	/*
-	 * proc writes to fd and closes it;
-	 * returns 0 on success, non-zero on failure
-	 */
-	int (*proc)(int fd, void *data);
-	void *data;
-	int out;	/* caller reads from here and closes it */
-	pid_t pid;
-};
-
-int start_async(struct async *async);
-int finish_async(struct async *async);
-
 #endif /* __PERF_RUN_COMMAND_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 25bfca4..e4eaa6d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -5,6 +5,7 @@
 #include <byteswap.h>
 #include <unistd.h>
 #include <sys/types.h>
+#include <sys/mman.h>
 
 #include "session.h"
 #include "sort.h"
diff --git a/tools/perf/util/sigchain.c b/tools/perf/util/sigchain.c
index 1118b99..ba785e9 100644
--- a/tools/perf/util/sigchain.c
+++ b/tools/perf/util/sigchain.c
@@ -16,7 +16,7 @@ static void check_signum(int sig)
 		die("BUG: signal out of range: %d", sig);
 }
 
-int sigchain_push(int sig, sigchain_fun f)
+static int sigchain_push(int sig, sigchain_fun f)
 {
 	struct sigchain_signal *s = signals + sig;
 	check_signum(sig);
diff --git a/tools/perf/util/sigchain.h b/tools/perf/util/sigchain.h
index 1a53c11..959d64e 100644
--- a/tools/perf/util/sigchain.h
+++ b/tools/perf/util/sigchain.h
@@ -3,7 +3,6 @@
 
 typedef void (*sigchain_fun)(int);
 
-int sigchain_push(int sig, sigchain_fun f);
 int sigchain_pop(int sig);
 
 void sigchain_push_common(sigchain_fun f);
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 5249d5a..92e0685 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -41,16 +41,6 @@ char *strbuf_detach(struct strbuf *sb, size_t *sz)
 	return res;
 }
 
-void strbuf_attach(struct strbuf *sb, void *buf, size_t len, size_t alloc)
-{
-	strbuf_release(sb);
-	sb->buf   = buf;
-	sb->len   = len;
-	sb->alloc = alloc;
-	strbuf_grow(sb, 0);
-	sb->buf[sb->len] = '\0';
-}
-
 void strbuf_grow(struct strbuf *sb, size_t extra)
 {
 	if (sb->len + extra + 1 <= sb->len)
@@ -60,94 +50,7 @@ void strbuf_grow(struct strbuf *sb, size_t extra)
 	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
 }
 
-void strbuf_trim(struct strbuf *sb)
-{
-	char *b = sb->buf;
-	while (sb->len > 0 && isspace((unsigned char)sb->buf[sb->len - 1]))
-		sb->len--;
-	while (sb->len > 0 && isspace(*b)) {
-		b++;
-		sb->len--;
-	}
-	memmove(sb->buf, b, sb->len);
-	sb->buf[sb->len] = '\0';
-}
-void strbuf_rtrim(struct strbuf *sb)
-{
-	while (sb->len > 0 && isspace((unsigned char)sb->buf[sb->len - 1]))
-		sb->len--;
-	sb->buf[sb->len] = '\0';
-}
-
-void strbuf_ltrim(struct strbuf *sb)
-{
-	char *b = sb->buf;
-	while (sb->len > 0 && isspace(*b)) {
-		b++;
-		sb->len--;
-	}
-	memmove(sb->buf, b, sb->len);
-	sb->buf[sb->len] = '\0';
-}
-
-void strbuf_tolower(struct strbuf *sb)
-{
-	unsigned int i;
-
-	for (i = 0; i < sb->len; i++)
-		sb->buf[i] = tolower(sb->buf[i]);
-}
-
-struct strbuf **strbuf_split(const struct strbuf *sb, int delim)
-{
-	int alloc = 2, pos = 0;
-	char *n, *p;
-	struct strbuf **ret;
-	struct strbuf *t;
-
-	ret = calloc(alloc, sizeof(struct strbuf *));
-	p = n = sb->buf;
-	while (n < sb->buf + sb->len) {
-		int len;
-		n = memchr(n, delim, sb->len - (n - sb->buf));
-		if (pos + 1 >= alloc) {
-			alloc = alloc * 2;
-			ret = realloc(ret, sizeof(struct strbuf *) * alloc);
-		}
-		if (!n)
-			n = sb->buf + sb->len - 1;
-		len = n - p + 1;
-		t = malloc(sizeof(struct strbuf));
-		strbuf_init(t, len);
-		strbuf_add(t, p, len);
-		ret[pos] = t;
-		ret[++pos] = NULL;
-		p = ++n;
-	}
-	return ret;
-}
-
-void strbuf_list_free(struct strbuf **sbs)
-{
-	struct strbuf **s = sbs;
-
-	while (*s) {
-		strbuf_release(*s);
-		free(*s++);
-	}
-	free(sbs);
-}
-
-int strbuf_cmp(const struct strbuf *a, const struct strbuf *b)
-{
-	int len = a->len < b->len ? a->len: b->len;
-	int cmp = memcmp(a->buf, b->buf, len);
-	if (cmp)
-		return cmp;
-	return a->len < b->len ? -1: a->len != b->len;
-}
-
-void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
+static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
 				   const void *data, size_t dlen)
 {
 	if (pos + len < pos)
@@ -166,11 +69,6 @@ void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
 	strbuf_setlen(sb, sb->len + dlen - len);
 }
 
-void strbuf_insert(struct strbuf *sb, size_t pos, const void *data, size_t len)
-{
-	strbuf_splice(sb, pos, 0, data, len);
-}
-
 void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
 {
 	strbuf_splice(sb, pos, len, NULL, 0);
@@ -183,13 +81,6 @@ void strbuf_add(struct strbuf *sb, const void *data, size_t len)
 	strbuf_setlen(sb, sb->len + len);
 }
 
-void strbuf_adddup(struct strbuf *sb, size_t pos, size_t len)
-{
-	strbuf_grow(sb, len);
-	memcpy(sb->buf + sb->len, sb->buf + pos, len);
-	strbuf_setlen(sb, sb->len + len);
-}
-
 void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 {
 	int len;
@@ -214,57 +105,6 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 	strbuf_setlen(sb, sb->len + len);
 }
 
-void strbuf_expand(struct strbuf *sb, const char *format, expand_fn_t fn,
-		   void *context)
-{
-	for (;;) {
-		const char *percent;
-		size_t consumed;
-
-		percent = strchrnul(format, '%');
-		strbuf_add(sb, format, percent - format);
-		if (!*percent)
-			break;
-		format = percent + 1;
-
-		consumed = fn(sb, format, context);
-		if (consumed)
-			format += consumed;
-		else
-			strbuf_addch(sb, '%');
-	}
-}
-
-size_t strbuf_expand_dict_cb(struct strbuf *sb, const char *placeholder,
-		void *context)
-{
-	struct strbuf_expand_dict_entry *e = context;
-	size_t len;
-
-	for (; e->placeholder && (len = strlen(e->placeholder)); e++) {
-		if (!strncmp(placeholder, e->placeholder, len)) {
-			if (e->value)
-				strbuf_addstr(sb, e->value);
-			return len;
-		}
-	}
-	return 0;
-}
-
-size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
-{
-	size_t res;
-	size_t oldalloc = sb->alloc;
-
-	strbuf_grow(sb, size);
-	res = fread(sb->buf + sb->len, 1, size, f);
-	if (res > 0)
-		strbuf_setlen(sb, sb->len + res);
-	else if (oldalloc == 0)
-		strbuf_release(sb);
-	return res;
-}
-
 ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
 {
 	size_t oldlen = sb->len;
@@ -291,70 +131,3 @@ ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
 	sb->buf[sb->len] = '\0';
 	return sb->len - oldlen;
 }
-
-#define STRBUF_MAXLINK (2*PATH_MAX)
-
-int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint)
-{
-	size_t oldalloc = sb->alloc;
-
-	if (hint < 32)
-		hint = 32;
-
-	while (hint < STRBUF_MAXLINK) {
-		ssize_t len;
-
-		strbuf_grow(sb, hint);
-		len = readlink(path, sb->buf, hint);
-		if (len < 0) {
-			if (errno != ERANGE)
-				break;
-		} else if (len < hint) {
-			strbuf_setlen(sb, len);
-			return 0;
-		}
-
-		/* .. the buffer was too small - try again */
-		hint *= 2;
-	}
-	if (oldalloc == 0)
-		strbuf_release(sb);
-	return -1;
-}
-
-int strbuf_getline(struct strbuf *sb, FILE *fp, int term)
-{
-	int ch;
-
-	strbuf_grow(sb, 0);
-	if (feof(fp))
-		return EOF;
-
-	strbuf_reset(sb);
-	while ((ch = fgetc(fp)) != EOF) {
-		if (ch == term)
-			break;
-		strbuf_grow(sb, 1);
-		sb->buf[sb->len++] = ch;
-	}
-	if (ch == EOF && sb->len == 0)
-		return EOF;
-
-	sb->buf[sb->len] = '\0';
-	return 0;
-}
-
-int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint)
-{
-	int fd, len;
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return -1;
-	len = strbuf_read(sb, fd, hint);
-	close(fd);
-	if (len < 0)
-		return -1;
-
-	return len;
-}
diff --git a/tools/perf/util/strbuf.h b/tools/perf/util/strbuf.h
index a3d121d..436ac31 100644
--- a/tools/perf/util/strbuf.h
+++ b/tools/perf/util/strbuf.h
@@ -53,12 +53,6 @@ struct strbuf {
 extern void strbuf_init(struct strbuf *buf, ssize_t hint);
 extern void strbuf_release(struct strbuf *);
 extern char *strbuf_detach(struct strbuf *, size_t *);
-extern void strbuf_attach(struct strbuf *, void *, size_t, size_t);
-static inline void strbuf_swap(struct strbuf *a, struct strbuf *b) {
-	struct strbuf tmp = *a;
-	*a = *b;
-	*b = tmp;
-}
 
 /*----- strbuf size related -----*/
 static inline ssize_t strbuf_avail(const struct strbuf *sb) {
@@ -74,17 +68,6 @@ static inline void strbuf_setlen(struct strbuf *sb, size_t len) {
 	sb->len = len;
 	sb->buf[len] = '\0';
 }
-#define strbuf_reset(sb)  strbuf_setlen(sb, 0)
-
-/*----- content related -----*/
-extern void strbuf_trim(struct strbuf *);
-extern void strbuf_rtrim(struct strbuf *);
-extern void strbuf_ltrim(struct strbuf *);
-extern int strbuf_cmp(const struct strbuf *, const struct strbuf *);
-extern void strbuf_tolower(struct strbuf *);
-
-extern struct strbuf **strbuf_split(const struct strbuf *, int delim);
-extern void strbuf_list_free(struct strbuf **);
 
 /*----- add data in your buffer -----*/
 static inline void strbuf_addch(struct strbuf *sb, int c) {
@@ -93,45 +76,17 @@ static inline void strbuf_addch(struct strbuf *sb, int c) {
 	sb->buf[sb->len] = '\0';
 }
 
-extern void strbuf_insert(struct strbuf *, size_t pos, const void *, size_t);
 extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
 
-/* splice pos..pos+len with given data */
-extern void strbuf_splice(struct strbuf *, size_t pos, size_t len,
-                          const void *, size_t);
-
 extern void strbuf_add(struct strbuf *, const void *, size_t);
 static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
 	strbuf_add(sb, s, strlen(s));
 }
-static inline void strbuf_addbuf(struct strbuf *sb, const struct strbuf *sb2) {
-	strbuf_add(sb, sb2->buf, sb2->len);
-}
-extern void strbuf_adddup(struct strbuf *sb, size_t pos, size_t len);
-
-typedef size_t (*expand_fn_t) (struct strbuf *sb, const char *placeholder, void *context);
-extern void strbuf_expand(struct strbuf *sb, const char *format, expand_fn_t fn, void *context);
-struct strbuf_expand_dict_entry {
-	const char *placeholder;
-	const char *value;
-};
-extern size_t strbuf_expand_dict_cb(struct strbuf *sb, const char *placeholder, void *context);
 
 __attribute__((format(printf,2,3)))
 extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
 
-extern size_t strbuf_fread(struct strbuf *, size_t, FILE *);
 /* XXX: if read fails, any partial read is undone */
 extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
-extern int strbuf_read_file(struct strbuf *sb, const char *path, ssize_t hint);
-extern int strbuf_readlink(struct strbuf *sb, const char *path, ssize_t hint);
-
-extern int strbuf_getline(struct strbuf *, FILE *, int);
-
-extern void stripspace(struct strbuf *buf, int skip_comments);
-extern int launch_editor(const char *path, struct strbuf *buffer, const char *const *env);
-
-extern int strbuf_branchname(struct strbuf *sb, const char *name);
-extern int strbuf_check_branch_ref(struct strbuf *sb, const char *name);
 
 #endif /* __PERF_STRBUF_H */
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0795bf3..52118a0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -152,7 +152,6 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 extern int prefixcmp(const char *str, const char *prefix);
-extern time_t tm_to_time_t(const struct tm *tm);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
@@ -160,119 +159,6 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
 	return strncmp(str, prefix, len) ? NULL : str + len;
 }
 
-#if defined(NO_MMAP) || defined(USE_WIN32_MMAP)
-
-#ifndef PROT_READ
-#define PROT_READ 1
-#define PROT_WRITE 2
-#define MAP_PRIVATE 1
-#define MAP_FAILED ((void*)-1)
-#endif
-
-#define mmap git_mmap
-#define munmap git_munmap
-extern void *git_mmap(void *start, size_t length, int prot, int flags, int fd, off_t offset);
-extern int git_munmap(void *start, size_t length);
-
-#else /* NO_MMAP || USE_WIN32_MMAP */
-
-#include <sys/mman.h>
-
-#endif /* NO_MMAP || USE_WIN32_MMAP */
-
-#ifdef NO_MMAP
-
-/* This value must be multiple of (pagesize * 2) */
-#define DEFAULT_PACKED_GIT_WINDOW_SIZE (1 * 1024 * 1024)
-
-#else /* NO_MMAP */
-
-/* This value must be multiple of (pagesize * 2) */
-#define DEFAULT_PACKED_GIT_WINDOW_SIZE \
-	(sizeof(void*) >= 8 \
-		?  1 * 1024 * 1024 * 1024 \
-		: 32 * 1024 * 1024)
-
-#endif /* NO_MMAP */
-
-#ifdef NO_ST_BLOCKS_IN_STRUCT_STAT
-#define on_disk_bytes(st) ((st).st_size)
-#else
-#define on_disk_bytes(st) ((st).st_blocks * 512)
-#endif
-
-#define DEFAULT_PACKED_GIT_LIMIT \
-	((1024L * 1024L) * (sizeof(void*) >= 8 ? 8192 : 256))
-
-#ifdef NO_PREAD
-#define pread git_pread
-extern ssize_t git_pread(int fd, void *buf, size_t count, off_t offset);
-#endif
-/*
- * Forward decl that will remind us if its twin in cache.h changes.
- * This function is used in compat/pread.c.  But we can't include
- * cache.h there.
- */
-extern ssize_t read_in_full(int fd, void *buf, size_t count);
-
-#ifdef NO_SETENV
-#define setenv gitsetenv
-extern int gitsetenv(const char *, const char *, int);
-#endif
-
-#ifdef NO_MKDTEMP
-#define mkdtemp gitmkdtemp
-extern char *gitmkdtemp(char *);
-#endif
-
-#ifdef NO_UNSETENV
-#define unsetenv gitunsetenv
-extern void gitunsetenv(const char *);
-#endif
-
-#ifdef NO_STRCASESTR
-#define strcasestr gitstrcasestr
-extern char *gitstrcasestr(const char *haystack, const char *needle);
-#endif
-
-#ifdef NO_STRLCPY
-#define strlcpy gitstrlcpy
-extern size_t gitstrlcpy(char *, const char *, size_t);
-#endif
-
-#ifdef NO_STRTOUMAX
-#define strtoumax gitstrtoumax
-extern uintmax_t gitstrtoumax(const char *, char **, int);
-#endif
-
-#ifdef NO_HSTRERROR
-#define hstrerror githstrerror
-extern const char *githstrerror(int herror);
-#endif
-
-#ifdef NO_MEMMEM
-#define memmem gitmemmem
-void *gitmemmem(const void *haystack, size_t haystacklen,
-                const void *needle, size_t needlelen);
-#endif
-
-#ifdef FREAD_READS_DIRECTORIES
-#ifdef fopen
-#undef fopen
-#endif
-#define fopen(a,b) git_fopen(a,b)
-extern FILE *git_fopen(const char*, const char*);
-#endif
-
-#ifdef SNPRINTF_RETURNS_BOGUS
-#define snprintf git_snprintf
-extern int git_snprintf(char *str, size_t maxsize,
-			const char *format, ...);
-#define vsnprintf git_vsnprintf
-extern int git_vsnprintf(char *str, size_t maxsize,
-			 const char *format, va_list ap);
-#endif
-
 #ifdef __GLIBC_PREREQ
 #if __GLIBC_PREREQ(2, 1)
 #define HAVE_STRCHRNUL
@@ -294,7 +180,6 @@ static inline char *gitstrchrnul(const char *s, int c)
  */
 extern char *xstrdup(const char *str);
 extern void *xmalloc(size_t size) __attribute__((weak));
-extern void *xmemdupz(const void *data, size_t len);
 extern char *xstrndup(const char *str, size_t len);
 extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
 
@@ -310,11 +195,6 @@ static inline void *zalloc(size_t size)
 	return calloc(1, size);
 }
 
-static inline size_t xsize_t(off_t len)
-{
-	return (size_t)len;
-}
-
 static inline int has_extension(const char *filename, const char *ext)
 {
 	size_t len = strlen(filename);
@@ -351,8 +231,6 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
-#define is_glob_special(x) sane_istest(x,GIT_GLOB_SPECIAL)
-#define is_regex_special(x) sane_istest(x,GIT_GLOB_SPECIAL | GIT_REGEX_SPECIAL)
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
@@ -363,38 +241,6 @@ static inline int sane_case(int x, int high)
 	return x;
 }
 
-static inline int strtoul_ui(char const *s, int base, unsigned int *result)
-{
-	unsigned long ul;
-	char *p;
-
-	errno = 0;
-	ul = strtoul(s, &p, base);
-	if (errno || *p || p == s || (unsigned int) ul != ul)
-		return -1;
-	*result = ul;
-	return 0;
-}
-
-static inline int strtol_i(char const *s, int base, int *result)
-{
-	long ul;
-	char *p;
-
-	errno = 0;
-	ul = strtol(s, &p, base);
-	if (errno || *p || p == s || (int) ul != ul)
-		return -1;
-	*result = ul;
-	return 0;
-}
-
-#ifdef INTERNAL_QSORT
-void git_qsort(void *base, size_t nmemb, size_t size,
-	       int(*compar)(const void *, const void *));
-#define qsort git_qsort
-#endif
-
 #ifndef DIR_HAS_BSD_GROUP_SEMANTICS
 # define FORCE_DIR_SET_GID S_ISGID
 #else
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index bf44ca8..c4ced7c 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -48,7 +48,7 @@ void *xmalloc(size_t size)
  * and returns a pointer to the allocated memory. If the allocation fails,
  * the program dies.
  */
-void *xmemdupz(const void *data, size_t len)
+static void *xmemdupz(const void *data, size_t len)
 {
 	char *p = xmalloc(len + 1);
 	memcpy(p, data, len);
@@ -78,73 +78,3 @@ void *xrealloc(void *ptr, size_t size)
 	}
 	return ret;
 }
-
-/*
- * xread() is the same a read(), but it automatically restarts read()
- * operations with a recoverable error (EAGAIN and EINTR). xread()
- * DOES NOT GUARANTEE that "len" bytes is read even if the data is available.
- */
-static ssize_t xread(int fd, void *buf, size_t len)
-{
-	ssize_t nr;
-	while (1) {
-		nr = read(fd, buf, len);
-		if ((nr < 0) && (errno == EAGAIN || errno == EINTR))
-			continue;
-		return nr;
-	}
-}
-
-/*
- * xwrite() is the same a write(), but it automatically restarts write()
- * operations with a recoverable error (EAGAIN and EINTR). xwrite() DOES NOT
- * GUARANTEE that "len" bytes is written even if the operation is successful.
- */
-static ssize_t xwrite(int fd, const void *buf, size_t len)
-{
-	ssize_t nr;
-	while (1) {
-		nr = write(fd, buf, len);
-		if ((nr < 0) && (errno == EAGAIN || errno == EINTR))
-			continue;
-		return nr;
-	}
-}
-
-ssize_t read_in_full(int fd, void *buf, size_t count)
-{
-	char *p = buf;
-	ssize_t total = 0;
-
-	while (count > 0) {
-		ssize_t loaded = xread(fd, p, count);
-		if (loaded <= 0)
-			return total ? total : loaded;
-		count -= loaded;
-		p += loaded;
-		total += loaded;
-	}
-
-	return total;
-}
-
-ssize_t write_in_full(int fd, const void *buf, size_t count)
-{
-	const char *p = buf;
-	ssize_t total = 0;
-
-	while (count > 0) {
-		ssize_t written = xwrite(fd, p, count);
-		if (written < 0)
-			return -1;
-		if (!written) {
-			errno = ENOSPC;
-			return -1;
-		}
-		count -= written;
-		p += written;
-		total += written;
-	}
-
-	return total;
-}
-- 
1.6.2.5

