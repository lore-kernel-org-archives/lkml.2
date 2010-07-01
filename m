Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0GAP56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:57:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47060 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab0GAPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/21] perf: rewire generic library stuff, p4
Date: Thu,  1 Jul 2010 17:55:50 +0200
Message-Id: <1277999763-20357-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Split util/config.c and util/color.c into a generic and a perf-specific
parts. As a result, remove unused perf_config_colorbool() and
perf_color_default_config(). Move pager.c elements used in color.c
temporarily into it. Will be moved to tools/perf/perf.c unit later.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/Makefile             |    3 +
 tools/lib/lk/color.c           |  306 ++++++++++++++++++++++++++
 tools/lib/lk/color.h           |   46 ++++
 tools/lib/lk/config.c          |  388 +++++++++++++++++++++++++++++++++
 tools/lib/lk/config.h          |   18 ++
 tools/lib/lk/util.h            |    1 -
 tools/perf/Makefile            |    5 +-
 tools/perf/builtin-annotate.c  |    4 +-
 tools/perf/builtin-help.c      |   13 +-
 tools/perf/builtin-report.c    |    2 +-
 tools/perf/builtin-timechart.c |    2 +-
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/perf.c              |    7 +-
 tools/perf/util/alias.c        |    4 +-
 tools/perf/util/build-id.c     |   51 +++++
 tools/perf/util/build-id.h     |    2 +
 tools/perf/util/cache.h        |   10 -
 tools/perf/util/color.c        |  324 ----------------------------
 tools/perf/util/color.h        |   46 ----
 tools/perf/util/config.c       |  460 ++--------------------------------------
 tools/perf/util/config.h       |    8 +
 tools/perf/util/debug.c        |    4 +-
 tools/perf/util/environment.c  |    3 +-
 tools/perf/util/help.c         |    7 +-
 tools/perf/util/pager.c        |   18 +--
 tools/perf/util/probe-event.c  |    4 +-
 tools/perf/util/sort.h         |    2 +-
 27 files changed, 875 insertions(+), 865 deletions(-)
 create mode 100644 tools/lib/lk/color.c
 create mode 100644 tools/lib/lk/color.h
 create mode 100644 tools/lib/lk/config.c
 create mode 100644 tools/lib/lk/config.h
 delete mode 100644 tools/perf/util/color.c
 delete mode 100644 tools/perf/util/color.h
 create mode 100644 tools/perf/util/config.h

diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index 64c0dbd..7acb91d 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -10,6 +10,7 @@ LIB_H += lk/util.h
 LIB_H += lk/types.h
 LIB_H += lk/pstack.h
 LIB_H += lk/strbuf.h
+LIB_H += lk/color.h
 
 LIB_OBJS += $(OUTPUT)lk/bitmap.o
 LIB_OBJS += $(OUTPUT)lk/cpumap.o
@@ -20,6 +21,8 @@ LIB_OBJS += $(OUTPUT)lk/util.o
 LIB_OBJS += $(OUTPUT)lk/pstack.o
 LIB_OBJS += $(OUTPUT)lk/strbuf.o
 LIB_OBJS += $(OUTPUT)lk/usage.o
+LIB_OBJS += $(OUTPUT)lk/color.o
+LIB_OBJS += $(OUTPUT)lk/config.o
 
 LIBFILE = lklib.a
 
diff --git a/tools/lib/lk/color.c b/tools/lib/lk/color.c
new file mode 100644
index 0000000..93d6381
--- /dev/null
+++ b/tools/lib/lk/color.c
@@ -0,0 +1,306 @@
+#include "config.h"
+#include "color.h"
+
+/*
+ * This variable stores the value of color.ui
+ */
+static int use_color_default = -1;
+
+/*
+ * This is going into tools/perf/perf.c next
+ */
+int spawned_pager, pager_use_color = 1;
+
+int pager_in_use(void)
+{
+	const char *env;
+
+	if (spawned_pager)
+		return 1;
+
+	env = getenv("PERF_PAGER_IN_USE");
+	return env ? lk_config_bool("PERF_PAGER_IN_USE", env) : 0;
+}
+
+static int parse_color(const char *name, int len)
+{
+	static const char * const color_names[] = {
+		"normal", "black", "red", "green", "yellow",
+		"blue", "magenta", "cyan", "white"
+	};
+	char *end;
+	int i;
+
+	for (i = 0; i < (int)ARRAY_SIZE(color_names); i++) {
+		const char *str = color_names[i];
+		if (!strncasecmp(name, str, len) && !str[len])
+			return i - 1;
+	}
+	i = strtol(name, &end, 10);
+	if (end - name == len && i >= -1 && i <= 255)
+		return i;
+	return -2;
+}
+
+static int parse_attr(const char *name, int len)
+{
+	static const int attr_values[] = { 1, 2, 4, 5, 7 };
+	static const char * const attr_names[] = {
+		"bold", "dim", "ul", "blink", "reverse"
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(attr_names); i++) {
+		const char *str = attr_names[i];
+		if (!strncasecmp(name, str, len) && !str[len])
+			return attr_values[i];
+	}
+	return -1;
+}
+
+void color_parse(const char *value, const char *var, char *dst)
+{
+	color_parse_mem(value, strlen(value), var, dst);
+}
+
+void color_parse_mem(const char *value, int value_len, const char *var,
+		char *dst)
+{
+	const char *ptr = value;
+	int len = value_len;
+	int attr = -1;
+	int fg = -2;
+	int bg = -2;
+
+	if (!strncasecmp(value, "reset", len)) {
+		strcpy(dst, LK_COLOR_RESET);
+		return;
+	}
+
+	/* [fg [bg]] [attr] */
+	while (len > 0) {
+		const char *word = ptr;
+		int val, wordlen = 0;
+
+		while (len > 0 && !isspace(word[wordlen])) {
+			wordlen++;
+			len--;
+		}
+
+		ptr = word + wordlen;
+		while (len > 0 && isspace(*ptr)) {
+			ptr++;
+			len--;
+		}
+
+		val = parse_color(word, wordlen);
+		if (val >= -1) {
+			if (fg == -2) {
+				fg = val;
+				continue;
+			}
+			if (bg == -2) {
+				bg = val;
+				continue;
+			}
+			goto bad;
+		}
+		val = parse_attr(word, wordlen);
+		if (val < 0 || attr != -1)
+			goto bad;
+		attr = val;
+	}
+
+	if (attr >= 0 || fg >= 0 || bg >= 0) {
+		int sep = 0;
+
+		*dst++ = '\033';
+		*dst++ = '[';
+		if (attr >= 0) {
+			*dst++ = '0' + attr;
+			sep++;
+		}
+		if (fg >= 0) {
+			if (sep++)
+				*dst++ = ';';
+			if (fg < 8) {
+				*dst++ = '3';
+				*dst++ = '0' + fg;
+			} else {
+				dst += sprintf(dst, "38;5;%d", fg);
+			}
+		}
+		if (bg >= 0) {
+			if (sep++)
+				*dst++ = ';';
+			if (bg < 8) {
+				*dst++ = '4';
+				*dst++ = '0' + bg;
+			} else {
+				dst += sprintf(dst, "48;5;%d", bg);
+			}
+		}
+		*dst++ = 'm';
+	}
+	*dst = 0;
+	return;
+bad:
+	die("bad color value '%.*s' for variable '%s'", value_len, value, var);
+}
+
+static int __color_vsnprintf(char *bf, size_t size, const char *color,
+			     const char *fmt, va_list args, const char *trail)
+{
+	int r = 0;
+
+	/*
+	 * Auto-detect:
+	 */
+	if (use_color_default < 0) {
+		if (isatty(1) || pager_in_use())
+			use_color_default = 1;
+		else
+			use_color_default = 0;
+	}
+
+	if (use_color_default && *color)
+		r += snprintf(bf, size, "%s", color);
+	r += vsnprintf(bf + r, size - r, fmt, args);
+	if (use_color_default && *color)
+		r += snprintf(bf + r, size - r, "%s", LK_COLOR_RESET);
+	if (trail)
+		r += snprintf(bf + r, size - r, "%s", trail);
+	return r;
+}
+
+static int __color_vfprintf(FILE *fp, const char *color, const char *fmt,
+		va_list args, const char *trail)
+{
+	int r = 0;
+
+	/*
+	 * Auto-detect:
+	 */
+	if (use_color_default < 0) {
+		if (isatty(1) || pager_in_use())
+			use_color_default = 1;
+		else
+			use_color_default = 0;
+	}
+
+	if (use_color_default && *color)
+		r += fprintf(fp, "%s", color);
+	r += vfprintf(fp, fmt, args);
+	if (use_color_default && *color)
+		r += fprintf(fp, "%s", LK_COLOR_RESET);
+	if (trail)
+		r += fprintf(fp, "%s", trail);
+	return r;
+}
+
+int color_vsnprintf(char *bf, size_t size, const char *color,
+		    const char *fmt, va_list args)
+{
+	return __color_vsnprintf(bf, size, color, fmt, args, NULL);
+}
+
+int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args)
+{
+	return __color_vfprintf(fp, color, fmt, args, NULL);
+}
+
+int color_snprintf(char *bf, size_t size, const char *color,
+		   const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = color_vsnprintf(bf, size, color, fmt, args);
+	va_end(args);
+	return r;
+}
+
+int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = color_vfprintf(fp, color, fmt, args);
+	va_end(args);
+	return r;
+}
+
+int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+	va_start(args, fmt);
+	r = __color_vfprintf(fp, color, fmt, args, "\n");
+	va_end(args);
+	return r;
+}
+
+/*
+ * This function splits the buffer by newlines and colors the lines individually.
+ *
+ * Returns 0 on success.
+ */
+int color_fwrite_lines(FILE *fp, const char *color,
+		size_t count, const char *buf)
+{
+	if (!*color)
+		return fwrite(buf, count, 1, fp) != 1;
+
+	while (count) {
+		char *p = memchr(buf, '\n', count);
+
+		if (p != buf && (fputs(color, fp) < 0 ||
+				fwrite(buf, p ? (size_t)(p - buf) : count, 1, fp) != 1 ||
+				fputs(LK_COLOR_RESET, fp) < 0))
+			return -1;
+		if (!p)
+			return 0;
+		if (fputc('\n', fp) < 0)
+			return -1;
+		count -= p + 1 - buf;
+		buf = p + 1;
+	}
+	return 0;
+}
+
+const char *get_percent_color(double percent)
+{
+	const char *color = LK_COLOR_NORMAL;
+
+	/*
+	 * We color high-overhead entries in red, mid-overhead
+	 * entries in green - and keep the low overhead places
+	 * normal:
+	 */
+	if (percent >= MIN_RED)
+		color = LK_COLOR_RED;
+	else {
+		if (percent > MIN_GREEN)
+			color = LK_COLOR_GREEN;
+	}
+	return color;
+}
+
+int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
+{
+	int r;
+	const char *color;
+
+	color = get_percent_color(percent);
+	r = color_fprintf(fp, color, fmt, percent);
+
+	return r;
+}
+
+int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent)
+{
+	const char *color = get_percent_color(percent);
+	return color_snprintf(bf, size, color, fmt, percent);
+}
diff --git a/tools/lib/lk/color.h b/tools/lib/lk/color.h
new file mode 100644
index 0000000..c962e1d
--- /dev/null
+++ b/tools/lib/lk/color.h
@@ -0,0 +1,46 @@
+#ifndef __LK_COLOR_H
+#define __LK_COLOR_H
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdarg.h>
+
+#include "util.h"
+
+/* "\033[1;38;5;2xx;48;5;2xxm\0" is 23 bytes */
+#define COLOR_MAXLEN 24
+
+#define LK_COLOR_NORMAL		""
+#define LK_COLOR_RESET		"\033[m"
+#define LK_COLOR_BOLD		"\033[1m"
+#define LK_COLOR_RED		"\033[31m"
+#define LK_COLOR_GREEN		"\033[32m"
+#define LK_COLOR_YELLOW		"\033[33m"
+#define LK_COLOR_BLUE		"\033[34m"
+#define LK_COLOR_MAGENTA	"\033[35m"
+#define LK_COLOR_CYAN		"\033[36m"
+#define LK_COLOR_BG_RED		"\033[41m"
+
+#define MIN_GREEN	0.5
+#define MIN_RED		5.0
+
+extern int spawned_pager, pager_use_color;
+
+extern int pager_in_use(void);
+
+void color_parse(const char *value, const char *var, char *dst);
+void color_parse_mem(const char *value, int len, const char *var, char *dst);
+int color_vsnprintf(char *bf, size_t size, const char *color,
+		    const char *fmt, va_list args);
+int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args);
+int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
+int color_snprintf(char *bf, size_t size, const char *color, const char *fmt, ...);
+int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
+int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
+int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent);
+int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
+const char *get_percent_color(double percent);
+
+#endif /* __LK_COLOR_H */
diff --git a/tools/lib/lk/config.c b/tools/lib/lk/config.c
new file mode 100644
index 0000000..ea8a6c0
--- /dev/null
+++ b/tools/lib/lk/config.c
@@ -0,0 +1,388 @@
+/*
+ * GIT - The information manager from hell
+ *
+ * Copyright (C) Linus Torvalds, 2005
+ * Copyright (C) Johannes Schindelin, 2005
+ *
+ */
+#include <linux/compiler.h>
+#include <lk/util.h>
+#include <lk/strbuf.h>
+#include "config.h"
+
+#define MAXNAME (256)
+
+char buildid_dir[MAXPATHLEN]; /* root dir for buildid, binary cache */
+
+static FILE *config_file;
+static const char *config_file_name;
+static int config_linenr;
+static int config_file_eof;
+
+const char *lk_config_exclusive_filename;
+
+static int get_next_char(void)
+{
+	int c;
+	FILE *f;
+
+	c = '\n';
+	if ((f = config_file) != NULL) {
+		c = fgetc(f);
+		if (c == '\r') {
+			/* DOS like systems */
+			c = fgetc(f);
+			if (c != '\n') {
+				ungetc(c, f);
+				c = '\r';
+			}
+		}
+		if (c == '\n')
+			config_linenr++;
+		if (c == EOF) {
+			config_file_eof = 1;
+			c = '\n';
+		}
+	}
+	return c;
+}
+
+static char *parse_value(void)
+{
+	static char value[1024];
+	int quote = 0, comment = 0, space = 0;
+	size_t len = 0;
+
+	for (;;) {
+		int c = get_next_char();
+
+		if (len >= sizeof(value) - 1)
+			return NULL;
+		if (c == '\n') {
+			if (quote)
+				return NULL;
+			value[len] = 0;
+			return value;
+		}
+		if (comment)
+			continue;
+		if (isspace(c) && !quote) {
+			space = 1;
+			continue;
+		}
+		if (!quote) {
+			if (c == ';' || c == '#') {
+				comment = 1;
+				continue;
+			}
+		}
+		if (space) {
+			if (len)
+				value[len++] = ' ';
+			space = 0;
+		}
+		if (c == '\\') {
+			c = get_next_char();
+			switch (c) {
+			case '\n':
+				continue;
+			case 't':
+				c = '\t';
+				break;
+			case 'b':
+				c = '\b';
+				break;
+			case 'n':
+				c = '\n';
+				break;
+			/* Some characters escape as themselves */
+			case '\\': case '"':
+				break;
+			/* Reject unknown escape sequences */
+			default:
+				return NULL;
+			}
+			value[len++] = c;
+			continue;
+		}
+		if (c == '"') {
+			quote = 1-quote;
+			continue;
+		}
+		value[len++] = c;
+	}
+}
+
+static inline int iskeychar(int c)
+{
+	return isalnum(c) || c == '-';
+}
+
+static int get_value(config_fn_t fn, void *data, char *name, unsigned int len)
+{
+	int c;
+	char *value;
+
+	/* Get the full name */
+	for (;;) {
+		c = get_next_char();
+		if (config_file_eof)
+			break;
+		if (!iskeychar(c))
+			break;
+		name[len++] = c;
+		if (len >= MAXNAME)
+			return -1;
+	}
+	name[len] = 0;
+	while (c == ' ' || c == '\t')
+		c = get_next_char();
+
+	value = NULL;
+	if (c != '\n') {
+		if (c != '=')
+			return -1;
+		value = parse_value();
+		if (!value)
+			return -1;
+	}
+	return fn(name, value, data);
+}
+
+static int get_extended_base_var(char *name, int baselen, int c)
+{
+	do {
+		if (c == '\n')
+			return -1;
+		c = get_next_char();
+	} while (isspace(c));
+
+	/* We require the format to be '[base "extension"]' */
+	if (c != '"')
+		return -1;
+	name[baselen++] = '.';
+
+	for (;;) {
+		int ch = get_next_char();
+
+		if (ch == '\n')
+			return -1;
+		if (ch == '"')
+			break;
+		if (ch == '\\') {
+			ch = get_next_char();
+			if (ch == '\n')
+				return -1;
+		}
+		name[baselen++] = ch;
+		if (baselen > MAXNAME / 2)
+			return -1;
+	}
+
+	/* Final ']' */
+	if (get_next_char() != ']')
+		return -1;
+	return baselen;
+}
+
+static int get_base_var(char *name)
+{
+	int baselen = 0;
+
+	for (;;) {
+		int c = get_next_char();
+		if (config_file_eof)
+			return -1;
+		if (c == ']')
+			return baselen;
+		if (isspace(c))
+			return get_extended_base_var(name, baselen, c);
+		if (!iskeychar(c) && c != '.')
+			return -1;
+		if (baselen > MAXNAME / 2)
+			return -1;
+		name[baselen++] = tolower(c);
+	}
+}
+
+static int parse_file(config_fn_t fn, void *data)
+{
+	int comment = 0;
+	int baselen = 0;
+	static char var[MAXNAME];
+
+	/* U+FEFF Byte Order Mark in UTF8 */
+	static const unsigned char *utf8_bom = (unsigned char *) "\xef\xbb\xbf";
+	const unsigned char *bomptr = utf8_bom;
+
+	for (;;) {
+		int c = get_next_char();
+		if (bomptr && *bomptr) {
+			/* We are at the file beginning; skip UTF8-encoded BOM
+			 * if present. Sane editors won't put this in on their
+			 * own, but e.g. Windows Notepad will do it happily. */
+			if ((unsigned char) c == *bomptr) {
+				bomptr++;
+				continue;
+			} else {
+				/* Do not tolerate partial BOM. */
+				if (bomptr != utf8_bom)
+					break;
+				/* No BOM at file beginning. Cool. */
+				bomptr = NULL;
+			}
+		}
+		if (c == '\n') {
+			if (config_file_eof)
+				return 0;
+			comment = 0;
+			continue;
+		}
+		if (comment || isspace(c))
+			continue;
+		if (c == '#' || c == ';') {
+			comment = 1;
+			continue;
+		}
+		if (c == '[') {
+			baselen = get_base_var(var);
+			if (baselen <= 0)
+				break;
+			var[baselen++] = '.';
+			var[baselen] = 0;
+			continue;
+		}
+		if (!isalpha(c))
+			break;
+		var[baselen] = tolower(c);
+		if (get_value(fn, data, var, baselen+1) < 0)
+			break;
+	}
+	die("bad config file line %d in %s", config_linenr, config_file_name);
+}
+
+static int parse_unit_factor(const char *end, unsigned long *val)
+{
+	if (!*end)
+		return 1;
+	else if (!strcasecmp(end, "k")) {
+		*val *= 1024;
+		return 1;
+	}
+	else if (!strcasecmp(end, "m")) {
+		*val *= 1024 * 1024;
+		return 1;
+	}
+	else if (!strcasecmp(end, "g")) {
+		*val *= 1024 * 1024 * 1024;
+		return 1;
+	}
+	return 0;
+}
+
+static int parse_long(const char *value, long *ret)
+{
+	if (value && *value) {
+		char *end;
+		long val = strtol(value, &end, 0);
+		unsigned long factor = 1;
+		if (!parse_unit_factor(end, &factor))
+			return 0;
+		*ret = val * factor;
+		return 1;
+	}
+	return 0;
+}
+
+static void die_bad_config(const char *name)
+{
+	if (config_file_name)
+		die("bad config value for '%s' in %s", name, config_file_name);
+	die("bad config value for '%s'", name);
+}
+
+int lk_config_int(const char *name, const char *value)
+{
+	long ret = 0;
+	if (!parse_long(value, &ret))
+		die_bad_config(name);
+	return ret;
+}
+
+static int config_bool_or_int(const char *name, const char *value, int *is_bool)
+{
+	*is_bool = 1;
+	if (!value)
+		return 1;
+	if (!*value)
+		return 0;
+	if (!strcasecmp(value, "true") || !strcasecmp(value, "yes") || !strcasecmp(value, "on"))
+		return 1;
+	if (!strcasecmp(value, "false") || !strcasecmp(value, "no") || !strcasecmp(value, "off"))
+		return 0;
+	*is_bool = 0;
+	return lk_config_int(name, value);
+}
+
+int lk_config_bool(const char *name, const char *value)
+{
+	int discard;
+	return !!config_bool_or_int(name, value, &discard);
+}
+
+const char *lk_config_dirname(const char *name, const char *value)
+{
+	if (!name)
+		return NULL;
+	return value;
+}
+
+static int default_core_config(const char *var __used, const char *value __used)
+{
+	/* Add other config variables here and to Documentation/config.txt. */
+	return 0;
+}
+
+int lk_default_config(const char *var, const char *value, void *dummy __used)
+{
+	if (!prefixcmp(var, "core."))
+		return default_core_config(var, value);
+
+	/* Add other config variables here and to Documentation/config.txt. */
+	return 0;
+}
+
+int lk_config_from_file(config_fn_t fn, const char *filename, void *data)
+{
+	int ret;
+	FILE *f = fopen(filename, "r");
+
+	ret = -1;
+	if (f) {
+		config_file = f;
+		config_file_name = filename;
+		config_linenr = 1;
+		config_file_eof = 0;
+		ret = parse_file(fn, data);
+		fclose(f);
+		config_file_name = NULL;
+	}
+	return ret;
+}
+
+int lk_env_bool(const char *k, int def)
+{
+	const char *v = getenv(k);
+	return v ? lk_config_bool(k, v) : def;
+}
+
+/*
+ * Call this to report error for your variable that should not
+ * get a boolean value (i.e. "[my] var" means "true").
+ */
+int lk_config_error_nonbool(const char *var)
+{
+	return error("Missing value for '%s'", var);
+}
+
+
diff --git a/tools/lib/lk/config.h b/tools/lib/lk/config.h
new file mode 100644
index 0000000..6bcce49
--- /dev/null
+++ b/tools/lib/lk/config.h
@@ -0,0 +1,18 @@
+#ifndef __LK_CONFIG_H
+#define __LK_CONFIG_H
+
+#define DEBUG_CACHE_DIR ".debug"
+
+typedef int (*config_fn_t)(const char *, const char *, void *);
+
+extern const char *lk_config_exclusive_filename;
+
+extern int lk_env_bool(const char *k, int def);
+extern int lk_config_int(const char *, const char *);
+extern int lk_config_bool(const char *name, const char *value);
+extern const char *lk_config_dirname(const char *name, const char *value);
+extern int lk_config_from_file(config_fn_t fn, const char *filename, void *data);
+extern int lk_default_config(const char *, const char *, void *);
+extern int lk_config_error_nonbool(const char *var);
+
+#endif /* __LK_CONFIG_H */
diff --git a/tools/lib/lk/util.h b/tools/lib/lk/util.h
index dc88970..4db0f3f 100644
--- a/tools/lib/lk/util.h
+++ b/tools/lib/lk/util.h
@@ -172,7 +172,6 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
-extern void set_buildid_dir(void);
 extern void disable_buildid_cache(void);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6fc4c4a..42a1756 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -371,7 +371,6 @@ LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
-LIB_H += util/color.h
 LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
@@ -379,11 +378,11 @@ LIB_H += util/thread.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
+LIB_H += util/config.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
-LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
@@ -400,7 +399,6 @@ LIB_OBJS += $(OUTPUT)util/strlist.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
-LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
 LIB_OBJS += $(OUTPUT)util/callchain.o
@@ -417,6 +415,7 @@ LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
+LIB_OBJS += $(OUTPUT)util/config.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 03f80e9..42caf9c 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -9,7 +9,7 @@
 
 #include <lk/util.h>
 
-#include "util/color.h"
+#include <lk/color.h>
 #include <linux/list.h>
 #include "util/cache.h"
 #include <linux/rbtree.h>
@@ -130,7 +130,7 @@ static int objdump_line__print(struct objdump_line *self,
 
 		color_fprintf(stdout, color, " %7.2f", percent);
 		printf(" :	");
-		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", self->line);
+		color_fprintf(stdout, LK_COLOR_BLUE, "%s\n", self->line);
 	} else {
 		if (!*self->line)
 			printf("         :\n");
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 6d5a8a7..b6b7e1a 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -5,6 +5,7 @@
  */
 #include "perf.h"
 #include "util/cache.h"
+#include "util/config.h"
 #include "builtin.h"
 #include "util/exec_cmd.h"
 #include "common-cmds.h"
@@ -12,6 +13,8 @@
 #include "util/run-command.h"
 #include "util/help.h"
 
+#include <lk/config.h>
+
 static struct man_viewer_list {
 	struct man_viewer_list *next;
 	char name[FLEX_ARRAY];
@@ -240,12 +243,12 @@ static int add_man_viewer_info(const char *var, const char *value)
 
 	if (!strcmp(subkey, ".path")) {
 		if (!value)
-			return config_error_nonbool(var);
+			return lk_config_error_nonbool(var);
 		return add_man_viewer_path(name, subkey - name, value);
 	}
 	if (!strcmp(subkey, ".cmd")) {
 		if (!value)
-			return config_error_nonbool(var);
+			return lk_config_error_nonbool(var);
 		return add_man_viewer_cmd(name, subkey - name, value);
 	}
 
@@ -257,20 +260,20 @@ static int perf_help_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "help.format")) {
 		if (!value)
-			return config_error_nonbool(var);
+			return lk_config_error_nonbool(var);
 		help_format = parse_help_format(value);
 		return 0;
 	}
 	if (!strcmp(var, "man.viewer")) {
 		if (!value)
-			return config_error_nonbool(var);
+			return lk_config_error_nonbool(var);
 		add_man_viewer(value);
 		return 0;
 	}
 	if (!prefixcmp(var, "man."))
 		return add_man_viewer_info(var, value);
 
-	return perf_default_config(var, value, cb);
+	return lk_default_config(var, value, cb);
 }
 
 static struct cmdnames main_cmds, other_cmds;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4be3c67..9a618ac 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -9,7 +9,7 @@
 
 #include <lk/util.h>
 
-#include "util/color.h"
+#include <lk/color.h>
 #include <linux/list.h>
 #include "util/cache.h"
 #include <linux/rbtree.h>
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 92f7230..5440b11 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -16,7 +16,7 @@
 
 #include <lk/util.h>
 
-#include "util/color.h"
+#include <lk/color.h>
 #include <linux/list.h>
 #include "util/cache.h"
 #include <linux/rbtree.h>
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9813351..2b4dce1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -20,7 +20,7 @@
 
 #include "perf.h"
 
-#include "util/color.h"
+#include <lk/color.h>
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2fda133..9600a2d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -10,10 +10,13 @@
 
 #include "util/exec_cmd.h"
 #include "util/cache.h"
+#include "util/config.h"
 #include "util/quote.h"
+#include "util/build-id.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include <lk/debugfs.h>
+#include <lk/config.h>
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -35,7 +38,7 @@ static int pager_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
 	if (!prefixcmp(var, "pager.") && !strcmp(var + 6, c->cmd))
-		c->val = perf_config_bool(var, value);
+		c->val = lk_config_bool(var, value);
 	return 0;
 }
 
@@ -53,7 +56,7 @@ static int tui_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
 	if (!prefixcmp(var, "tui.") && !strcmp(var + 4, c->cmd))
-		c->val = perf_config_bool(var, value);
+		c->val = lk_config_bool(var, value);
 	return 0;
 }
 
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index b8144e8..57b303a 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -1,4 +1,6 @@
 #include "cache.h"
+#include <lk/config.h>
+#include "config.h"
 
 static const char *alias_key;
 static char *alias_val;
@@ -7,7 +9,7 @@ static int alias_lookup_cb(const char *k, const char *v, void *cb __used)
 {
 	if (!prefixcmp(k, "alias.") && !strcmp(k+6, alias_key)) {
 		if (!v)
-			return config_error_nonbool(k);
+			return lk_config_error_nonbool(k);
 		alias_val = strdup(v);
 		return 0;
 	}
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 5de09e2..44f2878 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -7,6 +7,8 @@
  * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
 #include <lk/util.h>
+#include <lk/config.h>
+#include <lk/strbuf.h>
 #include <stdio.h>
 #include "build-id.h"
 #include "event.h"
@@ -57,3 +59,52 @@ char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
 			 build_id_hex, build_id_hex + 2);
 	return bf;
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
+		v = lk_config_dirname(var, value);
+		if (!v)
+			return -1;
+		strncpy(c->dir, v, MAXPATHLEN-1);
+		c->dir[MAXPATHLEN-1] = '\0';
+	}
+	return 0;
+}
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
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 5dafb00..e72ed79 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -2,9 +2,11 @@
 #define PERF_BUILD_ID_H_ 1
 
 #include "session.h"
+#include "config.h"
 
 extern struct perf_event_ops build_id__mark_dso_hit_ops;
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
+extern void set_buildid_dir(void);
 
 #endif
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 93570a8..b0902b8 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -17,19 +17,9 @@
 #define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
 #define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
 
-typedef int (*config_fn_t)(const char *, const char *, void *);
-extern int perf_default_config(const char *, const char *, void *);
-extern int perf_config(config_fn_t fn, void *);
-extern int perf_config_int(const char *, const char *);
-extern int perf_config_bool(const char *, const char *);
-extern int config_error_nonbool(const char *);
-extern const char *perf_config_dirname(const char *, const char *);
-
 /* pager.c */
 extern void setup_pager(void);
 extern const char *pager_program;
-extern int pager_in_use(void);
-extern int pager_use_color;
 
 extern int use_browser;
 
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
deleted file mode 100644
index e191eb9..0000000
--- a/tools/perf/util/color.c
+++ /dev/null
@@ -1,324 +0,0 @@
-#include "cache.h"
-#include "color.h"
-
-int perf_use_color_default = -1;
-
-static int parse_color(const char *name, int len)
-{
-	static const char * const color_names[] = {
-		"normal", "black", "red", "green", "yellow",
-		"blue", "magenta", "cyan", "white"
-	};
-	char *end;
-	int i;
-
-	for (i = 0; i < (int)ARRAY_SIZE(color_names); i++) {
-		const char *str = color_names[i];
-		if (!strncasecmp(name, str, len) && !str[len])
-			return i - 1;
-	}
-	i = strtol(name, &end, 10);
-	if (end - name == len && i >= -1 && i <= 255)
-		return i;
-	return -2;
-}
-
-static int parse_attr(const char *name, int len)
-{
-	static const int attr_values[] = { 1, 2, 4, 5, 7 };
-	static const char * const attr_names[] = {
-		"bold", "dim", "ul", "blink", "reverse"
-	};
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(attr_names); i++) {
-		const char *str = attr_names[i];
-		if (!strncasecmp(name, str, len) && !str[len])
-			return attr_values[i];
-	}
-	return -1;
-}
-
-void color_parse(const char *value, const char *var, char *dst)
-{
-	color_parse_mem(value, strlen(value), var, dst);
-}
-
-void color_parse_mem(const char *value, int value_len, const char *var,
-		char *dst)
-{
-	const char *ptr = value;
-	int len = value_len;
-	int attr = -1;
-	int fg = -2;
-	int bg = -2;
-
-	if (!strncasecmp(value, "reset", len)) {
-		strcpy(dst, PERF_COLOR_RESET);
-		return;
-	}
-
-	/* [fg [bg]] [attr] */
-	while (len > 0) {
-		const char *word = ptr;
-		int val, wordlen = 0;
-
-		while (len > 0 && !isspace(word[wordlen])) {
-			wordlen++;
-			len--;
-		}
-
-		ptr = word + wordlen;
-		while (len > 0 && isspace(*ptr)) {
-			ptr++;
-			len--;
-		}
-
-		val = parse_color(word, wordlen);
-		if (val >= -1) {
-			if (fg == -2) {
-				fg = val;
-				continue;
-			}
-			if (bg == -2) {
-				bg = val;
-				continue;
-			}
-			goto bad;
-		}
-		val = parse_attr(word, wordlen);
-		if (val < 0 || attr != -1)
-			goto bad;
-		attr = val;
-	}
-
-	if (attr >= 0 || fg >= 0 || bg >= 0) {
-		int sep = 0;
-
-		*dst++ = '\033';
-		*dst++ = '[';
-		if (attr >= 0) {
-			*dst++ = '0' + attr;
-			sep++;
-		}
-		if (fg >= 0) {
-			if (sep++)
-				*dst++ = ';';
-			if (fg < 8) {
-				*dst++ = '3';
-				*dst++ = '0' + fg;
-			} else {
-				dst += sprintf(dst, "38;5;%d", fg);
-			}
-		}
-		if (bg >= 0) {
-			if (sep++)
-				*dst++ = ';';
-			if (bg < 8) {
-				*dst++ = '4';
-				*dst++ = '0' + bg;
-			} else {
-				dst += sprintf(dst, "48;5;%d", bg);
-			}
-		}
-		*dst++ = 'm';
-	}
-	*dst = 0;
-	return;
-bad:
-	die("bad color value '%.*s' for variable '%s'", value_len, value, var);
-}
-
-int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty)
-{
-	if (value) {
-		if (!strcasecmp(value, "never"))
-			return 0;
-		if (!strcasecmp(value, "always"))
-			return 1;
-		if (!strcasecmp(value, "auto"))
-			goto auto_color;
-	}
-
-	/* Missing or explicit false to turn off colorization */
-	if (!perf_config_bool(var, value))
-		return 0;
-
-	/* any normal truth value defaults to 'auto' */
- auto_color:
-	if (stdout_is_tty < 0)
-		stdout_is_tty = isatty(1);
-	if (stdout_is_tty || (pager_in_use() && pager_use_color)) {
-		char *term = getenv("TERM");
-		if (term && strcmp(term, "dumb"))
-			return 1;
-	}
-	return 0;
-}
-
-int perf_color_default_config(const char *var, const char *value, void *cb)
-{
-	if (!strcmp(var, "color.ui")) {
-		perf_use_color_default = perf_config_colorbool(var, value, -1);
-		return 0;
-	}
-
-	return perf_default_config(var, value, cb);
-}
-
-static int __color_vsnprintf(char *bf, size_t size, const char *color,
-			     const char *fmt, va_list args, const char *trail)
-{
-	int r = 0;
-
-	/*
-	 * Auto-detect:
-	 */
-	if (perf_use_color_default < 0) {
-		if (isatty(1) || pager_in_use())
-			perf_use_color_default = 1;
-		else
-			perf_use_color_default = 0;
-	}
-
-	if (perf_use_color_default && *color)
-		r += snprintf(bf, size, "%s", color);
-	r += vsnprintf(bf + r, size - r, fmt, args);
-	if (perf_use_color_default && *color)
-		r += snprintf(bf + r, size - r, "%s", PERF_COLOR_RESET);
-	if (trail)
-		r += snprintf(bf + r, size - r, "%s", trail);
-	return r;
-}
-
-static int __color_vfprintf(FILE *fp, const char *color, const char *fmt,
-		va_list args, const char *trail)
-{
-	int r = 0;
-
-	/*
-	 * Auto-detect:
-	 */
-	if (perf_use_color_default < 0) {
-		if (isatty(1) || pager_in_use())
-			perf_use_color_default = 1;
-		else
-			perf_use_color_default = 0;
-	}
-
-	if (perf_use_color_default && *color)
-		r += fprintf(fp, "%s", color);
-	r += vfprintf(fp, fmt, args);
-	if (perf_use_color_default && *color)
-		r += fprintf(fp, "%s", PERF_COLOR_RESET);
-	if (trail)
-		r += fprintf(fp, "%s", trail);
-	return r;
-}
-
-int color_vsnprintf(char *bf, size_t size, const char *color,
-		    const char *fmt, va_list args)
-{
-	return __color_vsnprintf(bf, size, color, fmt, args, NULL);
-}
-
-int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args)
-{
-	return __color_vfprintf(fp, color, fmt, args, NULL);
-}
-
-int color_snprintf(char *bf, size_t size, const char *color,
-		   const char *fmt, ...)
-{
-	va_list args;
-	int r;
-
-	va_start(args, fmt);
-	r = color_vsnprintf(bf, size, color, fmt, args);
-	va_end(args);
-	return r;
-}
-
-int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
-{
-	va_list args;
-	int r;
-
-	va_start(args, fmt);
-	r = color_vfprintf(fp, color, fmt, args);
-	va_end(args);
-	return r;
-}
-
-int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...)
-{
-	va_list args;
-	int r;
-	va_start(args, fmt);
-	r = __color_vfprintf(fp, color, fmt, args, "\n");
-	va_end(args);
-	return r;
-}
-
-/*
- * This function splits the buffer by newlines and colors the lines individually.
- *
- * Returns 0 on success.
- */
-int color_fwrite_lines(FILE *fp, const char *color,
-		size_t count, const char *buf)
-{
-	if (!*color)
-		return fwrite(buf, count, 1, fp) != 1;
-
-	while (count) {
-		char *p = memchr(buf, '\n', count);
-
-		if (p != buf && (fputs(color, fp) < 0 ||
-				fwrite(buf, p ? (size_t)(p - buf) : count, 1, fp) != 1 ||
-				fputs(PERF_COLOR_RESET, fp) < 0))
-			return -1;
-		if (!p)
-			return 0;
-		if (fputc('\n', fp) < 0)
-			return -1;
-		count -= p + 1 - buf;
-		buf = p + 1;
-	}
-	return 0;
-}
-
-const char *get_percent_color(double percent)
-{
-	const char *color = PERF_COLOR_NORMAL;
-
-	/*
-	 * We color high-overhead entries in red, mid-overhead
-	 * entries in green - and keep the low overhead places
-	 * normal:
-	 */
-	if (percent >= MIN_RED)
-		color = PERF_COLOR_RED;
-	else {
-		if (percent > MIN_GREEN)
-			color = PERF_COLOR_GREEN;
-	}
-	return color;
-}
-
-int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
-{
-	int r;
-	const char *color;
-
-	color = get_percent_color(percent);
-	r = color_fprintf(fp, color, fmt, percent);
-
-	return r;
-}
-
-int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent)
-{
-	const char *color = get_percent_color(percent);
-	return color_snprintf(bf, size, color, fmt, percent);
-}
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
deleted file mode 100644
index dea082b..0000000
--- a/tools/perf/util/color.h
+++ /dev/null
@@ -1,46 +0,0 @@
-#ifndef __PERF_COLOR_H
-#define __PERF_COLOR_H
-
-/* "\033[1;38;5;2xx;48;5;2xxm\0" is 23 bytes */
-#define COLOR_MAXLEN 24
-
-#define PERF_COLOR_NORMAL	""
-#define PERF_COLOR_RESET	"\033[m"
-#define PERF_COLOR_BOLD		"\033[1m"
-#define PERF_COLOR_RED		"\033[31m"
-#define PERF_COLOR_GREEN	"\033[32m"
-#define PERF_COLOR_YELLOW	"\033[33m"
-#define PERF_COLOR_BLUE		"\033[34m"
-#define PERF_COLOR_MAGENTA	"\033[35m"
-#define PERF_COLOR_CYAN		"\033[36m"
-#define PERF_COLOR_BG_RED	"\033[41m"
-
-#define MIN_GREEN	0.5
-#define MIN_RED		5.0
-
-/*
- * This variable stores the value of color.ui
- */
-extern int perf_use_color_default;
-
-
-/*
- * Use this instead of perf_default_config if you need the value of color.ui.
- */
-int perf_color_default_config(const char *var, const char *value, void *cb);
-
-int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty);
-void color_parse(const char *value, const char *var, char *dst);
-void color_parse_mem(const char *value, int len, const char *var, char *dst);
-int color_vsnprintf(char *bf, size_t size, const char *color,
-		    const char *fmt, va_list args);
-int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args);
-int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
-int color_snprintf(char *bf, size_t size, const char *color, const char *fmt, ...);
-int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
-int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
-int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent);
-int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
-const char *get_percent_color(double percent);
-
-#endif /* __PERF_COLOR_H */
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index bb2f5a0..73e6421 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -1,375 +1,19 @@
-/*
- * GIT - The information manager from hell
- *
- * Copyright (C) Linus Torvalds, 2005
- * Copyright (C) Johannes Schindelin, 2005
- *
- */
-#include <lk/util.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
 #include "cache.h"
+#include "config.h"
 #include "exec_cmd.h"
 
-#define MAXNAME (256)
-
-#define DEBUG_CACHE_DIR ".debug"
-
-
-char buildid_dir[MAXPATHLEN]; /* root dir for buildid, binary cache */
-
-static FILE *config_file;
-static const char *config_file_name;
-static int config_linenr;
-static int config_file_eof;
-
-static const char *config_exclusive_filename;
-
-static int get_next_char(void)
-{
-	int c;
-	FILE *f;
-
-	c = '\n';
-	if ((f = config_file) != NULL) {
-		c = fgetc(f);
-		if (c == '\r') {
-			/* DOS like systems */
-			c = fgetc(f);
-			if (c != '\n') {
-				ungetc(c, f);
-				c = '\r';
-			}
-		}
-		if (c == '\n')
-			config_linenr++;
-		if (c == EOF) {
-			config_file_eof = 1;
-			c = '\n';
-		}
-	}
-	return c;
-}
-
-static char *parse_value(void)
-{
-	static char value[1024];
-	int quote = 0, comment = 0, space = 0;
-	size_t len = 0;
-
-	for (;;) {
-		int c = get_next_char();
-
-		if (len >= sizeof(value) - 1)
-			return NULL;
-		if (c == '\n') {
-			if (quote)
-				return NULL;
-			value[len] = 0;
-			return value;
-		}
-		if (comment)
-			continue;
-		if (isspace(c) && !quote) {
-			space = 1;
-			continue;
-		}
-		if (!quote) {
-			if (c == ';' || c == '#') {
-				comment = 1;
-				continue;
-			}
-		}
-		if (space) {
-			if (len)
-				value[len++] = ' ';
-			space = 0;
-		}
-		if (c == '\\') {
-			c = get_next_char();
-			switch (c) {
-			case '\n':
-				continue;
-			case 't':
-				c = '\t';
-				break;
-			case 'b':
-				c = '\b';
-				break;
-			case 'n':
-				c = '\n';
-				break;
-			/* Some characters escape as themselves */
-			case '\\': case '"':
-				break;
-			/* Reject unknown escape sequences */
-			default:
-				return NULL;
-			}
-			value[len++] = c;
-			continue;
-		}
-		if (c == '"') {
-			quote = 1-quote;
-			continue;
-		}
-		value[len++] = c;
-	}
-}
-
-static inline int iskeychar(int c)
-{
-	return isalnum(c) || c == '-';
-}
-
-static int get_value(config_fn_t fn, void *data, char *name, unsigned int len)
-{
-	int c;
-	char *value;
-
-	/* Get the full name */
-	for (;;) {
-		c = get_next_char();
-		if (config_file_eof)
-			break;
-		if (!iskeychar(c))
-			break;
-		name[len++] = c;
-		if (len >= MAXNAME)
-			return -1;
-	}
-	name[len] = 0;
-	while (c == ' ' || c == '\t')
-		c = get_next_char();
-
-	value = NULL;
-	if (c != '\n') {
-		if (c != '=')
-			return -1;
-		value = parse_value();
-		if (!value)
-			return -1;
-	}
-	return fn(name, value, data);
-}
-
-static int get_extended_base_var(char *name, int baselen, int c)
-{
-	do {
-		if (c == '\n')
-			return -1;
-		c = get_next_char();
-	} while (isspace(c));
-
-	/* We require the format to be '[base "extension"]' */
-	if (c != '"')
-		return -1;
-	name[baselen++] = '.';
-
-	for (;;) {
-		int ch = get_next_char();
-
-		if (ch == '\n')
-			return -1;
-		if (ch == '"')
-			break;
-		if (ch == '\\') {
-			ch = get_next_char();
-			if (ch == '\n')
-				return -1;
-		}
-		name[baselen++] = ch;
-		if (baselen > MAXNAME / 2)
-			return -1;
-	}
-
-	/* Final ']' */
-	if (get_next_char() != ']')
-		return -1;
-	return baselen;
-}
-
-static int get_base_var(char *name)
-{
-	int baselen = 0;
-
-	for (;;) {
-		int c = get_next_char();
-		if (config_file_eof)
-			return -1;
-		if (c == ']')
-			return baselen;
-		if (isspace(c))
-			return get_extended_base_var(name, baselen, c);
-		if (!iskeychar(c) && c != '.')
-			return -1;
-		if (baselen > MAXNAME / 2)
-			return -1;
-		name[baselen++] = tolower(c);
-	}
-}
-
-static int perf_parse_file(config_fn_t fn, void *data)
-{
-	int comment = 0;
-	int baselen = 0;
-	static char var[MAXNAME];
-
-	/* U+FEFF Byte Order Mark in UTF8 */
-	static const unsigned char *utf8_bom = (unsigned char *) "\xef\xbb\xbf";
-	const unsigned char *bomptr = utf8_bom;
-
-	for (;;) {
-		int c = get_next_char();
-		if (bomptr && *bomptr) {
-			/* We are at the file beginning; skip UTF8-encoded BOM
-			 * if present. Sane editors won't put this in on their
-			 * own, but e.g. Windows Notepad will do it happily. */
-			if ((unsigned char) c == *bomptr) {
-				bomptr++;
-				continue;
-			} else {
-				/* Do not tolerate partial BOM. */
-				if (bomptr != utf8_bom)
-					break;
-				/* No BOM at file beginning. Cool. */
-				bomptr = NULL;
-			}
-		}
-		if (c == '\n') {
-			if (config_file_eof)
-				return 0;
-			comment = 0;
-			continue;
-		}
-		if (comment || isspace(c))
-			continue;
-		if (c == '#' || c == ';') {
-			comment = 1;
-			continue;
-		}
-		if (c == '[') {
-			baselen = get_base_var(var);
-			if (baselen <= 0)
-				break;
-			var[baselen++] = '.';
-			var[baselen] = 0;
-			continue;
-		}
-		if (!isalpha(c))
-			break;
-		var[baselen] = tolower(c);
-		if (get_value(fn, data, var, baselen+1) < 0)
-			break;
-	}
-	die("bad config file line %d in %s", config_linenr, config_file_name);
-}
-
-static int parse_unit_factor(const char *end, unsigned long *val)
-{
-	if (!*end)
-		return 1;
-	else if (!strcasecmp(end, "k")) {
-		*val *= 1024;
-		return 1;
-	}
-	else if (!strcasecmp(end, "m")) {
-		*val *= 1024 * 1024;
-		return 1;
-	}
-	else if (!strcasecmp(end, "g")) {
-		*val *= 1024 * 1024 * 1024;
-		return 1;
-	}
-	return 0;
-}
-
-static int perf_parse_long(const char *value, long *ret)
-{
-	if (value && *value) {
-		char *end;
-		long val = strtol(value, &end, 0);
-		unsigned long factor = 1;
-		if (!parse_unit_factor(end, &factor))
-			return 0;
-		*ret = val * factor;
-		return 1;
-	}
-	return 0;
-}
-
-static void die_bad_config(const char *name)
-{
-	if (config_file_name)
-		die("bad config value for '%s' in %s", name, config_file_name);
-	die("bad config value for '%s'", name);
-}
-
-int perf_config_int(const char *name, const char *value)
-{
-	long ret = 0;
-	if (!perf_parse_long(value, &ret))
-		die_bad_config(name);
-	return ret;
-}
-
-static int perf_config_bool_or_int(const char *name, const char *value, int *is_bool)
-{
-	*is_bool = 1;
-	if (!value)
-		return 1;
-	if (!*value)
-		return 0;
-	if (!strcasecmp(value, "true") || !strcasecmp(value, "yes") || !strcasecmp(value, "on"))
-		return 1;
-	if (!strcasecmp(value, "false") || !strcasecmp(value, "no") || !strcasecmp(value, "off"))
-		return 0;
-	*is_bool = 0;
-	return perf_config_int(name, value);
-}
-
-int perf_config_bool(const char *name, const char *value)
-{
-	int discard;
-	return !!perf_config_bool_or_int(name, value, &discard);
-}
-
-const char *perf_config_dirname(const char *name, const char *value)
-{
-	if (!name)
-		return NULL;
-	return value;
-}
-
-static int perf_default_core_config(const char *var __used, const char *value __used)
+static int perf_config_system(void)
 {
-	/* Add other config variables here and to Documentation/config.txt. */
-	return 0;
+	return !lk_env_bool("PERF_CONFIG_NOSYSTEM", 0);
 }
 
-int perf_default_config(const char *var, const char *value, void *dummy __used)
+static int perf_config_global(void)
 {
-	if (!prefixcmp(var, "core."))
-		return perf_default_core_config(var, value);
-
-	/* Add other config variables here and to Documentation/config.txt. */
-	return 0;
-}
-
-static int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
-{
-	int ret;
-	FILE *f = fopen(filename, "r");
-
-	ret = -1;
-	if (f) {
-		config_file = f;
-		config_file_name = filename;
-		config_linenr = 1;
-		config_file_eof = 0;
-		ret = perf_parse_file(fn, data);
-		fclose(f);
-		config_file_name = NULL;
-	}
-	return ret;
+	return !lk_env_bool("PERF_CONFIG_NOGLOBAL", 0);
 }
 
 static const char *perf_etc_perfconfig(void)
@@ -380,22 +24,6 @@ static const char *perf_etc_perfconfig(void)
 	return system_wide;
 }
 
-static int perf_env_bool(const char *k, int def)
-{
-	const char *v = getenv(k);
-	return v ? perf_config_bool(k, v) : def;
-}
-
-static int perf_config_system(void)
-{
-	return !perf_env_bool("PERF_CONFIG_NOSYSTEM", 0);
-}
-
-static int perf_config_global(void)
-{
-	return !perf_env_bool("PERF_CONFIG_NOGLOBAL", 0);
-}
-
 int perf_config(config_fn_t fn, void *data)
 {
 	int ret = 0, found = 0;
@@ -403,11 +31,10 @@ int perf_config(config_fn_t fn, void *data)
 	const char *home = NULL;
 
 	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
-	if (config_exclusive_filename)
-		return perf_config_from_file(fn, config_exclusive_filename, data);
+	if (lk_config_exclusive_filename)
+		return lk_config_from_file(fn, lk_config_exclusive_filename, data);
 	if (perf_config_system() && !access(perf_etc_perfconfig(), R_OK)) {
-		ret += perf_config_from_file(fn, perf_etc_perfconfig(),
-					    data);
+		ret += lk_config_from_file(fn, perf_etc_perfconfig(), data);
 		found += 1;
 	}
 
@@ -415,7 +42,7 @@ int perf_config(config_fn_t fn, void *data)
 	if (perf_config_global() && home) {
 		char *user_config = strdup(mkpath("%s/.perfconfig", home));
 		if (!access(user_config, R_OK)) {
-			ret += perf_config_from_file(fn, user_config, data);
+			ret += lk_config_from_file(fn, user_config, data);
 			found += 1;
 		}
 		free(user_config);
@@ -423,7 +50,7 @@ int perf_config(config_fn_t fn, void *data)
 
 	repo_config = perf_pathdup("config");
 	if (!access(repo_config, R_OK)) {
-		ret += perf_config_from_file(fn, repo_config, data);
+		ret += lk_config_from_file(fn, repo_config, data);
 		found += 1;
 	}
 	free(repo_config);
@@ -431,62 +58,3 @@ int perf_config(config_fn_t fn, void *data)
 		return -1;
 	return ret;
 }
-
-/*
- * Call this to report error for your variable that should not
- * get a boolean value (i.e. "[my] var" means "true").
- */
-int config_error_nonbool(const char *var)
-{
-	return error("Missing value for '%s'", var);
-}
-
-struct buildid_dir_config {
-	char *dir;
-};
-
-static int buildid_dir_command_config(const char *var, const char *value,
-				      void *data)
-{
-	struct buildid_dir_config *c = data;
-	const char *v;
-
-	/* same dir for all commands */
-	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
-		v = perf_config_dirname(var, value);
-		if (!v)
-			return -1;
-		strncpy(c->dir, v, MAXPATHLEN-1);
-		c->dir[MAXPATHLEN-1] = '\0';
-	}
-	return 0;
-}
-
-static void check_buildid_dir_config(void)
-{
-	struct buildid_dir_config c;
-	c.dir = buildid_dir;
-	perf_config(buildid_dir_command_config, &c);
-}
-
-void set_buildid_dir(void)
-{
-	buildid_dir[0] = '\0';
-
-	/* try config file */
-	check_buildid_dir_config();
-
-	/* default to $HOME/.debug */
-	if (buildid_dir[0] == '\0') {
-		char *v = getenv("HOME");
-		if (v) {
-			snprintf(buildid_dir, MAXPATHLEN-1, "%s/%s",
-				 v, DEBUG_CACHE_DIR);
-		} else {
-			strncpy(buildid_dir, DEBUG_CACHE_DIR, MAXPATHLEN-1);
-		}
-		buildid_dir[MAXPATHLEN-1] = '\0';
-	}
-	/* for communicating with external commands */
-	setenv("PERF_BUILDID_DIR", buildid_dir, 1);
-}
diff --git a/tools/perf/util/config.h b/tools/perf/util/config.h
new file mode 100644
index 0000000..120ad69
--- /dev/null
+++ b/tools/perf/util/config.h
@@ -0,0 +1,8 @@
+#ifndef __PERF_CONFIG_H
+#define __PERF_CONFIG_H
+
+#include <lk/config.h>
+
+extern int perf_config(config_fn_t fn, void *data);
+
+#endif /* __PERF_CONFIG_H */
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 96cb72a..56635de 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -7,10 +7,10 @@
 #include <stdio.h>
 
 #include "cache.h"
-#include "color.h"
 #include "event.h"
 #include "debug.h"
 #include <lk/util.h>
+#include <lk/color.h>
 
 int verbose = 0;
 bool dump_trace = false;
@@ -64,7 +64,7 @@ static int dump_printf_color(const char *fmt, const char *color, ...)
 void trace_event(event_t *event)
 {
 	unsigned char *raw_event = (void *)event;
-	const char *color = PERF_COLOR_BLUE;
+	const char *color = LK_COLOR_BLUE;
 	int i, j;
 
 	if (!dump_trace)
diff --git a/tools/perf/util/environment.c b/tools/perf/util/environment.c
index 275b0ee..bd61953 100644
--- a/tools/perf/util/environment.c
+++ b/tools/perf/util/environment.c
@@ -3,7 +3,6 @@
  * file, so that programs can link against the config parser
  * without having to link against all the rest of perf.
  */
-#include "cache.h"
+#include <lk/color.h>
 
 const char *pager_program;
-int pager_use_color = 1;
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..109ebc8 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -3,6 +3,9 @@
 #include "exec_cmd.h"
 #include "levenshtein.h"
 #include "help.h"
+#include "config.h"
+
+#include <lk/config.h>
 
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
@@ -237,12 +240,12 @@ static struct cmdnames aliases;
 static int perf_unknown_cmd_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "help.autocorrect"))
-		autocorrect = perf_config_int(var,value);
+		autocorrect = lk_config_int(var,value);
 	/* Also use aliases for command lookup */
 	if (!prefixcmp(var, "alias."))
 		add_cmdname(&aliases, var + 6, strlen(var + 6));
 
-	return perf_default_config(var, value, cb);
+	return lk_default_config(var, value, cb);
 }
 
 static int levenshtein_compare(const void *p1, const void *p2)
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 1915de2..7afdad7 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -1,4 +1,8 @@
+#include <lk/config.h>
+#include <lk/color.h>
+
 #include "cache.h"
+#include "config.h"
 #include "run-command.h"
 #include "sigchain.h"
 
@@ -7,7 +11,6 @@
  * something different on Windows.
  */
 
-static int spawned_pager;
 
 static void pager_preexec(void)
 {
@@ -52,7 +55,7 @@ void setup_pager(void)
 		return;
 	if (!pager) {
 		if (!pager_program)
-			perf_config(perf_default_config, NULL);
+			perf_config(lk_default_config, NULL);
 		pager = pager_program;
 	}
 	if (!pager)
@@ -83,14 +86,3 @@ void setup_pager(void)
 	sigchain_push_common(wait_for_pager_signal);
 	atexit(wait_for_pager);
 }
-
-int pager_in_use(void)
-{
-	const char *env;
-
-	if (spawned_pager)
-		return 1;
-
-	env = getenv("PERF_PAGER_IN_USE");
-	return env ? perf_config_bool("PERF_PAGER_IN_USE", env) : 0;
-}
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 723b10d..74efa4a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -39,7 +39,7 @@
 #include "strlist.h"
 #include "debug.h"
 #include "cache.h"
-#include "color.h"
+#include <lk/color.h>
 #include "symbol.h"
 #include "thread.h"
 #include <lk/debugfs.h>
@@ -201,7 +201,7 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
 {
 	char buf[LINEBUF_SIZE];
-	const char *color = PERF_COLOR_BLUE;
+	const char *color = LK_COLOR_BLUE;
 
 	if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
 		goto error;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 8ead949..4dd264a 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -4,7 +4,7 @@
 
 #include <lk/util.h>
 
-#include "color.h"
+#include <lk/color.h>
 #include <linux/list.h>
 #include "cache.h"
 #include <linux/rbtree.h>
-- 
1.7.1

