Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2INDOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:14:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45255 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2INDOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:14:14 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 11:14:13 +0800
Message-ID: <CADu=CFrGDZ7waQbigcm43_Jm0NE2BAnmr0263iNAm-=A8erwBA@mail.gmail.com>
Subject: [PATCH v3] memory leak fix while calling system_path
From: liang xie <xieliang007@gmail.com>
To: linux-perf-users@vger.kernel.org
Cc: acme@ghostprotocols.net, balbi@ti.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory leak fix while calling system_path

Since v1: Remove an unnecessary null pointer check per Felipe's comments
Since v2: Make system_path&perf_exec_path always return dynamically
allocated string

Signed-off-by: xieliang <xieliang@xiaomi.com>
---
 tools/perf/builtin-help.c   |   12 +++++++++---
 tools/perf/builtin-script.c |   13 ++++++++++---
 tools/perf/perf.c           |    8 ++++++--
 tools/perf/util/config.c    |   16 +++++-----------
 tools/perf/util/exec_cmd.c  |   26 +++++++++++++++-----------
 tools/perf/util/exec_cmd.h  |    4 ++--
 tools/perf/util/help.c      |    6 ++++--
 7 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 6d5a8a7..180a5bd 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -321,12 +321,13 @@ static void setup_man_path(void)
 {
 	struct strbuf new_path = STRBUF_INIT;
 	const char *old_path = getenv("MANPATH");
+	char *man_path = system_path(PERF_MAN_PATH);

 	/* We should always put ':' after our path. If there is no
 	 * old_path, the ':' at the end will let 'man' to try
 	 * system-wide paths after ours to find the manual page. If
 	 * there is old_path, we need ':' as delimiter. */
-	strbuf_addstr(&new_path, system_path(PERF_MAN_PATH));
+	strbuf_addstr(&new_path, man_path);
 	strbuf_addch(&new_path, ':');
 	if (old_path)
 		strbuf_addstr(&new_path, old_path);
@@ -334,6 +335,7 @@ static void setup_man_path(void)
 	setenv("MANPATH", new_path.buf, 1);

 	strbuf_release(&new_path);
+	free(man_path);
 }

 static void exec_viewer(const char *name, const char *page)
@@ -371,14 +373,16 @@ static void show_man_page(const char *perf_cmd)
 static void show_info_page(const char *perf_cmd)
 {
 	const char *page = cmd_to_page(perf_cmd);
-	setenv("INFOPATH", system_path(PERF_INFO_PATH), 1);
+	char *info_path = system_path(PERF_INFO_PATH);
+	setenv("INFOPATH", info_path, 1);
 	execlp("info", "info", "perfman", page, NULL);
+	free(info_path);
 }

 static void get_html_page_path(struct strbuf *page_path, const char *page)
 {
 	struct stat st;
-	const char *html_path = system_path(PERF_HTML_PATH);
+	char *html_path = system_path(PERF_HTML_PATH);

 	/* Check that we have a perf documentation directory. */
 	if (stat(mkpath("%s/perf.html", html_path), &st)
@@ -387,6 +391,7 @@ static void get_html_page_path(struct strbuf
*page_path, const char *page)

 	strbuf_init(page_path, 0);
 	strbuf_addf(page_path, "%s/%s.html", html_path, page);
+	free(html_path);
 }

 /*
@@ -409,6 +414,7 @@ static void show_html_page(const char *perf_cmd)
 	get_html_page_path(&page_path, page);

 	open_html(page_path.buf);
+	strbuf_release(&page_path);
 }

 int cmd_help(int argc, const char **argv, const char *prefix __used)
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1e60ab7..528b786 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1021,8 +1021,10 @@ static int list_available_scripts(const struct
option *opt __used,
 	struct script_desc *desc;
 	char first_half[BUFSIZ];
 	char *script_root;
+	char *exec_path = perf_exec_path();

-	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
+	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", exec_path);
+	free(exec_path);

 	scripts_dir = opendir(scripts_path);
 	if (!scripts_dir)
@@ -1066,8 +1068,10 @@ static char *get_script_path(const char
*script_root, const char *suffix)
 	DIR *scripts_dir, *lang_dir;
 	char lang_path[MAXPATHLEN];
 	char *__script_root;
+	char *exec_path = perf_exec_path();

-	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
+	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", exec_path);
+	free(exec_path);

 	scripts_dir = opendir(scripts_path);
 	if (!scripts_dir)
@@ -1199,6 +1203,7 @@ int cmd_script(int argc, const char **argv,
const char *prefix __used)
 {
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
+	char *exec_path = NULL;
 	struct perf_session *session;
 	char *script_path = NULL;
 	const char **__argv;
@@ -1226,7 +1231,9 @@ int cmd_script(int argc, const char **argv,
const char *prefix __used)
 	}

 	/* make sure PERF_EXEC_PATH is set for scripts */
-	perf_set_argv_exec_path(perf_exec_path());
+	exec_path = perf_exec_path();
+	perf_set_argv_exec_path(exec_path);
+	free(exec_path);

 	if (argc && !script_name && !rec_script_path && !rep_script_path) {
 		int live_pipe[2];
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2b2e225..2198725 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -104,11 +104,15 @@ static int handle_options(const char ***argv,
int *argc, int *envchanged)
 			if (*cmd == '=')
 				perf_set_argv_exec_path(cmd + 1);
 			else {
-				puts(perf_exec_path());
+				char *exec_path = perf_exec_path();
+				puts(exec_path);
+				free(exec_path);
 				exit(0);
 			}
 		} else if (!strcmp(cmd, "--html-path")) {
-			puts(system_path(PERF_HTML_PATH));
+			char *html_path = system_path(PERF_HTML_PATH);
+			puts(html_path);
+			free(html_path);
 			exit(0);
 		} else if (!strcmp(cmd, "-p") || !strcmp(cmd, "--paginate")) {
 			use_pager = 1;
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 6faa3a1..7fb00e2 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -375,14 +375,6 @@ static int perf_config_from_file(config_fn_t fn,
const char *filename, void *dat
 	return ret;
 }

-static const char *perf_etc_perfconfig(void)
-{
-	static const char *system_wide;
-	if (!system_wide)
-		system_wide = system_path(ETC_PERFCONFIG);
-	return system_wide;
-}
-
 static int perf_env_bool(const char *k, int def)
 {
 	const char *v = getenv(k);
@@ -403,15 +395,17 @@ int perf_config(config_fn_t fn, void *data)
 {
 	int ret = 0, found = 0;
 	const char *home = NULL;
+	char *etc_perfconfig = NULL;

 	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
 	if (config_exclusive_filename)
 		return perf_config_from_file(fn, config_exclusive_filename, data);
-	if (perf_config_system() && !access(perf_etc_perfconfig(), R_OK)) {
-		ret += perf_config_from_file(fn, perf_etc_perfconfig(),
-					    data);
+	etc_perfconfig = system_path(ETC_PERFCONFIG);
+	if (perf_config_system() && !access(etc_perfconfig, R_OK)) {
+		ret += perf_config_from_file(fn, etc_perfconfig, data);
 		found += 1;
 	}
+	free(etc_perfconfig);

 	home = getenv("HOME");
 	if (perf_config_global() && home) {
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 7adf4ad..1ace941 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -9,17 +9,19 @@
 static const char *argv_exec_path;
 static const char *argv0_path;

-const char *system_path(const char *path)
+char *system_path(const char *path)
 {
-	static const char *prefix = PREFIX;
-	struct strbuf d = STRBUF_INIT;
+	char *new_path = NULL;

 	if (is_absolute_path(path))
-		return path;
+		return strdup(path);

-	strbuf_addf(&d, "%s/%s", prefix, path);
-	path = strbuf_detach(&d, NULL);
-	return path;
+	new_path = malloc((strlen(PREFIX) + strlen(path) + 2));
+	if (!new_path)
+		die("malloc");
+
+	sprintf(new_path, "%s/%s", PREFIX, path);
+	return new_path;
 }

 const char *perf_extract_argv0_path(const char *argv0)
@@ -52,16 +54,16 @@ void perf_set_argv_exec_path(const char *exec_path)


 /* Returns the highest-priority, location to look for perf programs. */
-const char *perf_exec_path(void)
+char *perf_exec_path(void)
 {
 	const char *env;

 	if (argv_exec_path)
-		return argv_exec_path;
+		return strdup(argv_exec_path);

 	env = getenv(EXEC_PATH_ENVIRONMENT);
 	if (env && *env) {
-		return env;
+		return strdup(env);
 	}

 	return system_path(PERF_EXEC_PATH);
@@ -83,8 +85,9 @@ void setup_path(void)
 {
 	const char *old_path = getenv("PATH");
 	struct strbuf new_path = STRBUF_INIT;
+	char *exec_path = perf_exec_path();

-	add_path(&new_path, perf_exec_path());
+	add_path(&new_path, exec_path);
 	add_path(&new_path, argv0_path);

 	if (old_path)
@@ -95,6 +98,7 @@ void setup_path(void)
 	setenv("PATH", new_path.buf, 1);

 	strbuf_release(&new_path);
+	free(exec_path);
 }

 static const char **prepare_perf_cmd(const char **argv)
diff --git a/tools/perf/util/exec_cmd.h b/tools/perf/util/exec_cmd.h
index bc4b915..8bfde93 100644
--- a/tools/perf/util/exec_cmd.h
+++ b/tools/perf/util/exec_cmd.h
@@ -3,10 +3,10 @@

 extern void perf_set_argv_exec_path(const char *exec_path);
 extern const char *perf_extract_argv0_path(const char *path);
-extern const char *perf_exec_path(void);
+extern char *perf_exec_path(void);
 extern void setup_path(void);
 extern int execv_perf_cmd(const char **argv); /* NULL terminated */
 extern int execl_perf_cmd(const char *cmd, ...);
-extern const char *system_path(const char *path);
+extern char *system_path(const char *path);

 #endif /* __PERF_EXEC_CMD_H */
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..ba1de76 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -158,7 +158,7 @@ void load_command_list(const char *prefix,
 		struct cmdnames *other_cmds)
 {
 	const char *env_path = getenv("PATH");
-	const char *exec_path = perf_exec_path();
+	char *exec_path = perf_exec_path();

 	if (exec_path) {
 		list_commands_in_dir(main_cmds, exec_path, prefix);
@@ -187,6 +187,7 @@ void load_command_list(const char *prefix,
 		uniq(other_cmds);
 	}
 	exclude_cmds(other_cmds, main_cmds);
+	free(exec_path);
 }

 void list_commands(const char *title, struct cmdnames *main_cmds,
@@ -202,13 +203,14 @@ void list_commands(const char *title, struct
cmdnames *main_cmds,
 			longest = other_cmds->names[i]->len;

 	if (main_cmds->cnt) {
-		const char *exec_path = perf_exec_path();
+		char *exec_path = perf_exec_path();
 		printf("available %s in '%s'\n", title, exec_path);
 		printf("----------------");
 		mput_char('-', strlen(title) + strlen(exec_path));
 		putchar('\n');
 		pretty_print_string_list(main_cmds, longest);
 		putchar('\n');
+		free(exec_path);
 	}

 	if (other_cmds->cnt) {
-- 
1.7.1
