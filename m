Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0KDPjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:39:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42020 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0KDPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:47 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 14/20] perf: Export color.ch and config.ch
Date: Thu,  4 Nov 2010 16:36:50 +0100
Message-Id: <1288885016-18295-15-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Will be needed by stuff exported later, move perf-wide defines to
perf/config.ch temporarily.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/compiler.h        |    2 +
 tools/lib/perf/Makefile        |    5 +
 tools/lib/perf/color.c         |  324 ++++++++++++++++++++++++++
 tools/lib/perf/color.h         |   51 ++++
 tools/lib/perf/config.c        |  502 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/perf/config.h        |   31 +++
 tools/lib/perf/path.c          |  156 +++++++++++++
 tools/lib/trace/Makefile       |    2 +
 tools/lib/trace/parse-events.c |   11 +-
 tools/lib/trace/parse-events.h |    8 +-
 tools/lib/trace/parse-utils.c  |    3 +-
 tools/perf/Makefile            |    8 +-
 tools/perf/builtin-annotate.c  |    2 +-
 tools/perf/builtin-help.c      |    2 +
 tools/perf/builtin-report.c    |    2 +-
 tools/perf/builtin-timechart.c |    2 +-
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/perf.c              |    1 +
 tools/perf/util/abspath.c      |    1 +
 tools/perf/util/alias.c        |    1 +
 tools/perf/util/cache.h        |   19 --
 tools/perf/util/color.c        |  324 --------------------------
 tools/perf/util/color.h        |   46 ----
 tools/perf/util/config.c       |  492 ---------------------------------------
 tools/perf/util/debug.c        |    2 +-
 tools/perf/util/environment.c  |    1 -
 tools/perf/util/exec_cmd.c     |   10 +
 tools/perf/util/help.c         |    2 +
 tools/perf/util/pager.c        |   15 +-
 tools/perf/util/path.c         |  156 -------------
 tools/perf/util/probe-event.c  |    2 +-
 tools/perf/util/sort.h         |    2 +-
 tools/perf/util/ui/browser.c   |    2 +-
 33 files changed, 1110 insertions(+), 1079 deletions(-)
 create mode 100644 tools/lib/perf/color.c
 create mode 100644 tools/lib/perf/color.h
 create mode 100644 tools/lib/perf/config.c
 create mode 100644 tools/lib/perf/config.h
 create mode 100644 tools/lib/perf/path.c
 delete mode 100644 tools/perf/util/color.c
 delete mode 100644 tools/perf/util/color.h
 delete mode 100644 tools/perf/util/config.c
 delete mode 100644 tools/perf/util/path.c

diff --git a/tools/lib/lk/compiler.h b/tools/lib/lk/compiler.h
index 8e8cc91..acf31cd 100644
--- a/tools/lib/lk/compiler.h
+++ b/tools/lib/lk/compiler.h
@@ -1,6 +1,8 @@
 #ifndef __LK_COMPILER_H
 #define __LK_COMPILER_H
 
+#define __weak __attribute__((weak))
+
 #ifndef __always_inline
 #define __always_inline	inline
 #endif
diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
index 5815664..7709a46 100644
--- a/tools/lib/perf/Makefile
+++ b/tools/lib/perf/Makefile
@@ -6,8 +6,13 @@ LIB_OBJS=
 
 LIB_H += mmap.h
 LIB_H += util.h
+LIB_H += color.h
+LIB_H += config.h
 
 LIB_OBJS += mmap.o
+LIB_OBJS += color.o
+LIB_OBJS += config.o
+LIB_OBJS += path.o
 
 LIBFILE = $(LIB_OUTPUT)lkperflib.a
 
diff --git a/tools/lib/perf/color.c b/tools/lib/perf/color.c
new file mode 100644
index 0000000..b97eedc
--- /dev/null
+++ b/tools/lib/perf/color.c
@@ -0,0 +1,324 @@
+#include "color.h"
+#include "config.h"
+
+int perf_use_color_default = -1;
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
+		strcpy(dst, PERF_COLOR_RESET);
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
+int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty)
+{
+	if (value) {
+		if (!strcasecmp(value, "never"))
+			return 0;
+		if (!strcasecmp(value, "always"))
+			return 1;
+		if (!strcasecmp(value, "auto"))
+			goto auto_color;
+	}
+
+	/* Missing or explicit false to turn off colorization */
+	if (!perf_config_bool(var, value))
+		return 0;
+
+	/* any normal truth value defaults to 'auto' */
+ auto_color:
+	if (stdout_is_tty < 0)
+		stdout_is_tty = isatty(1);
+	if (stdout_is_tty || (pager_in_use() && pager_use_color)) {
+		char *term = getenv("TERM");
+		if (term && strcmp(term, "dumb"))
+			return 1;
+	}
+	return 0;
+}
+
+int perf_color_default_config(const char *var, const char *value, void *cb)
+{
+	if (!strcmp(var, "color.ui")) {
+		perf_use_color_default = perf_config_colorbool(var, value, -1);
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
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
+	if (perf_use_color_default < 0) {
+		if (isatty(1) || pager_in_use())
+			perf_use_color_default = 1;
+		else
+			perf_use_color_default = 0;
+	}
+
+	if (perf_use_color_default && *color)
+		r += snprintf(bf, size, "%s", color);
+	r += vsnprintf(bf + r, size - r, fmt, args);
+	if (perf_use_color_default && *color)
+		r += snprintf(bf + r, size - r, "%s", PERF_COLOR_RESET);
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
+	if (perf_use_color_default < 0) {
+		if (isatty(1) || pager_in_use())
+			perf_use_color_default = 1;
+		else
+			perf_use_color_default = 0;
+	}
+
+	if (perf_use_color_default && *color)
+		r += fprintf(fp, "%s", color);
+	r += vfprintf(fp, fmt, args);
+	if (perf_use_color_default && *color)
+		r += fprintf(fp, "%s", PERF_COLOR_RESET);
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
+				fputs(PERF_COLOR_RESET, fp) < 0))
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
+	const char *color = PERF_COLOR_NORMAL;
+
+	/*
+	 * We color high-overhead entries in red, mid-overhead
+	 * entries in green - and keep the low overhead places
+	 * normal:
+	 */
+	if (percent >= MIN_RED)
+		color = PERF_COLOR_RED;
+	else {
+		if (percent > MIN_GREEN)
+			color = PERF_COLOR_GREEN;
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
diff --git a/tools/lib/perf/color.h b/tools/lib/perf/color.h
new file mode 100644
index 0000000..799447b
--- /dev/null
+++ b/tools/lib/perf/color.h
@@ -0,0 +1,51 @@
+#ifndef __PERF_COLOR_H
+#define __PERF_COLOR_H
+
+#include <lk/util.h>
+
+#include <stdio.h>
+#include <stdarg.h>
+#include <sys/types.h>
+
+/* "\033[1;38;5;2xx;48;5;2xxm\0" is 23 bytes */
+#define COLOR_MAXLEN 24
+
+#define PERF_COLOR_NORMAL	""
+#define PERF_COLOR_RESET	"\033[m"
+#define PERF_COLOR_BOLD		"\033[1m"
+#define PERF_COLOR_RED		"\033[31m"
+#define PERF_COLOR_GREEN	"\033[32m"
+#define PERF_COLOR_YELLOW	"\033[33m"
+#define PERF_COLOR_BLUE		"\033[34m"
+#define PERF_COLOR_MAGENTA	"\033[35m"
+#define PERF_COLOR_CYAN		"\033[36m"
+#define PERF_COLOR_BG_RED	"\033[41m"
+
+#define MIN_GREEN	0.5
+#define MIN_RED		5.0
+
+/*
+ * This variable stores the value of color.ui
+ */
+extern int perf_use_color_default;
+
+/*
+ * Use this instead of perf_default_config if you need the value of color.ui.
+ */
+int perf_color_default_config(const char *var, const char *value, void *cb);
+
+int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty);
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
+#endif /* __PERF_COLOR_H */
diff --git a/tools/lib/perf/config.c b/tools/lib/perf/config.c
new file mode 100644
index 0000000..bb72a55
--- /dev/null
+++ b/tools/lib/perf/config.c
@@ -0,0 +1,502 @@
+/*
+ * GIT - The information manager from hell
+ *
+ * Copyright (C) Linus Torvalds, 2005
+ * Copyright (C) Johannes Schindelin, 2005
+ *
+ */
+#include <lk/util.h>
+#include <lk/compiler.h>
+#include "config.h"
+
+#define MAXNAME (256)
+
+#define DEBUG_CACHE_DIR ".debug"
+
+int spawned_pager;
+int pager_use_color = 1;
+
+char buildid_dir[MAXPATHLEN]; /* root dir for buildid, binary cache */
+
+static FILE *config_file;
+static const char *config_file_name;
+static int config_linenr;
+static int config_file_eof;
+
+static const char *config_exclusive_filename;
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
+static int perf_parse_file(config_fn_t fn, void *data)
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
+static int perf_parse_long(const char *value, long *ret)
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
+int perf_config_int(const char *name, const char *value)
+{
+	long ret = 0;
+	if (!perf_parse_long(value, &ret))
+		die_bad_config(name);
+	return ret;
+}
+
+static int perf_config_bool_or_int(const char *name, const char *value, int *is_bool)
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
+	return perf_config_int(name, value);
+}
+
+int perf_config_bool(const char *name, const char *value)
+{
+	int discard;
+	return !!perf_config_bool_or_int(name, value, &discard);
+}
+
+const char *perf_config_dirname(const char *name, const char *value)
+{
+	if (!name)
+		return NULL;
+	return value;
+}
+
+static int perf_default_core_config(const char *var __used, const char *value __used)
+{
+	/* Add other config variables here and to Documentation/config.txt. */
+	return 0;
+}
+
+int perf_default_config(const char *var, const char *value, void *dummy __used)
+{
+	if (!prefixcmp(var, "core."))
+		return perf_default_core_config(var, value);
+
+	/* Add other config variables here and to Documentation/config.txt. */
+	return 0;
+}
+
+static int perf_config_from_file(config_fn_t fn, const char *filename, void *data)
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
+		ret = perf_parse_file(fn, data);
+		fclose(f);
+		config_file_name = NULL;
+	}
+	return ret;
+}
+
+const char * __weak perf_etc_perfconfig(void)
+{
+	return "";
+}
+
+static int perf_env_bool(const char *k, int def)
+{
+	const char *v = getenv(k);
+	return v ? perf_config_bool(k, v) : def;
+}
+
+static int perf_config_system(void)
+{
+	return !perf_env_bool("PERF_CONFIG_NOSYSTEM", 0);
+}
+
+static int perf_config_global(void)
+{
+	return !perf_env_bool("PERF_CONFIG_NOGLOBAL", 0);
+}
+
+int perf_config(config_fn_t fn, void *data)
+{
+	int ret = 0, found = 0;
+	char *repo_config = NULL;
+	const char *home = NULL;
+
+	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
+	if (config_exclusive_filename)
+		return perf_config_from_file(fn, config_exclusive_filename, data);
+	if (perf_config_system() && !access(perf_etc_perfconfig(), R_OK)) {
+		ret += perf_config_from_file(fn, perf_etc_perfconfig(),
+					    data);
+		found += 1;
+	}
+
+	home = getenv("HOME");
+	if (perf_config_global() && home) {
+		char *user_config = strdup(mkpath("%s/.perfconfig", home));
+		if (!access(user_config, R_OK)) {
+			ret += perf_config_from_file(fn, user_config, data);
+			found += 1;
+		}
+		free(user_config);
+	}
+
+	repo_config = perf_pathdup("config");
+	if (!access(repo_config, R_OK)) {
+		ret += perf_config_from_file(fn, repo_config, data);
+		found += 1;
+	}
+	free(repo_config);
+	if (found == 0)
+		return -1;
+	return ret;
+}
+
+/*
+ * Call this to report error for your variable that should not
+ * get a boolean value (i.e. "[my] var" means "true").
+ */
+int config_error_nonbool(const char *var)
+{
+	return error("Missing value for '%s'", var);
+}
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
+
+int pager_in_use(void)
+{
+	const char *env;
+
+	if (spawned_pager)
+		return 1;
+
+	env = getenv("PERF_PAGER_IN_USE");
+	return env ? perf_config_bool("PERF_PAGER_IN_USE", env) : 0;
+}
diff --git a/tools/lib/perf/config.h b/tools/lib/perf/config.h
new file mode 100644
index 0000000..5ef9c1d
--- /dev/null
+++ b/tools/lib/perf/config.h
@@ -0,0 +1,31 @@
+#ifndef __PERF_CONFIG_H
+#define __PERF_CONFIG_H
+
+#include <string.h>
+#include <sys/types.h>
+
+#include <lk/util.h>
+
+extern int spawned_pager;
+
+typedef int (*config_fn_t)(const char *, const char *, void *);
+extern int perf_default_config(const char *, const char *, void *);
+extern int perf_config(config_fn_t fn, void *);
+extern int perf_config_int(const char *, const char *);
+extern int perf_config_bool(const char *, const char *);
+extern int config_error_nonbool(const char *);
+extern const char *perf_config_dirname(const char *, const char *);
+
+extern int pager_in_use(void);
+extern int pager_use_color;
+
+extern char *mkpath(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
+extern char *perf_pathdup(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
+
+const char *perf_etc_perfconfig(void);
+
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+extern char *strip_path_suffix(const char *path, const char *suffix);
+extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
+
+#endif /* __PERF_CONFIG_H */
diff --git a/tools/lib/perf/path.c b/tools/lib/perf/path.c
new file mode 100644
index 0000000..16c73b7
--- /dev/null
+++ b/tools/lib/perf/path.c
@@ -0,0 +1,156 @@
+/*
+ * I'm tired of doing "vsnprintf()" etc just to open a
+ * file, so here's a "return static buffer with printf"
+ * interface for paths.
+ *
+ * It's obviously not thread-safe. Sue me. But it's quite
+ * useful for doing things like
+ *
+ *   f = open(mkpath("%s/%s.perf", base, name), O_RDONLY);
+ *
+ * which is what it's designed for.
+ */
+#include "config.h"
+
+static char bad_path[] = "/bad-path/";
+/*
+ * Two hacks:
+ */
+
+static const char *get_perf_dir(void)
+{
+	return ".";
+}
+
+size_t strlcpy(char *dest, const char *src, size_t size)
+{
+	size_t ret = strlen(src);
+
+	if (size) {
+		size_t len = (ret >= size) ? size - 1 : ret;
+		memcpy(dest, src, len);
+		dest[len] = '\0';
+	}
+	return ret;
+}
+
+
+static char *get_pathname(void)
+{
+	static char pathname_array[4][PATH_MAX];
+	static int idx;
+
+	return pathname_array[3 & ++idx];
+}
+
+static char *cleanup_path(char *path)
+{
+	/* Clean it up */
+	if (!memcmp(path, "./", 2)) {
+		path += 2;
+		while (*path == '/')
+			path++;
+	}
+	return path;
+}
+
+static char *perf_vsnpath(char *buf, size_t n, const char *fmt, va_list args)
+{
+	const char *perf_dir = get_perf_dir();
+	size_t len;
+
+	len = strlen(perf_dir);
+	if (n < len + 1)
+		goto bad;
+	memcpy(buf, perf_dir, len);
+	if (len && !is_dir_sep(perf_dir[len-1]))
+		buf[len++] = '/';
+	len += vsnprintf(buf + len, n - len, fmt, args);
+	if (len >= n)
+		goto bad;
+	return cleanup_path(buf);
+bad:
+	strlcpy(buf, bad_path, n);
+	return buf;
+}
+
+char *perf_pathdup(const char *fmt, ...)
+{
+	char path[PATH_MAX];
+	va_list args;
+	va_start(args, fmt);
+	(void)perf_vsnpath(path, sizeof(path), fmt, args);
+	va_end(args);
+	return xstrdup(path);
+}
+
+char *mkpath(const char *fmt, ...)
+{
+	va_list args;
+	unsigned len;
+	char *pathname = get_pathname();
+
+	va_start(args, fmt);
+	len = vsnprintf(pathname, PATH_MAX, fmt, args);
+	va_end(args);
+	if (len >= PATH_MAX)
+		return bad_path;
+	return cleanup_path(pathname);
+}
+
+char *perf_path(const char *fmt, ...)
+{
+	const char *perf_dir = get_perf_dir();
+	char *pathname = get_pathname();
+	va_list args;
+	unsigned len;
+
+	len = strlen(perf_dir);
+	if (len > PATH_MAX-100)
+		return bad_path;
+	memcpy(pathname, perf_dir, len);
+	if (len && perf_dir[len-1] != '/')
+		pathname[len++] = '/';
+	va_start(args, fmt);
+	len += vsnprintf(pathname + len, PATH_MAX - len, fmt, args);
+	va_end(args);
+	if (len >= PATH_MAX)
+		return bad_path;
+	return cleanup_path(pathname);
+}
+
+/* strip arbitrary amount of directory separators at end of path */
+static inline int chomp_trailing_dir_sep(const char *path, int len)
+{
+	while (len && is_dir_sep(path[len - 1]))
+		len--;
+	return len;
+}
+
+/*
+ * If path ends with suffix (complete path components), returns the
+ * part before suffix (sans trailing directory separators).
+ * Otherwise returns NULL.
+ */
+char *strip_path_suffix(const char *path, const char *suffix)
+{
+	int path_len = strlen(path), suffix_len = strlen(suffix);
+
+	while (suffix_len) {
+		if (!path_len)
+			return NULL;
+
+		if (is_dir_sep(path[path_len - 1])) {
+			if (!is_dir_sep(suffix[suffix_len - 1]))
+				return NULL;
+			path_len = chomp_trailing_dir_sep(path, path_len);
+			suffix_len = chomp_trailing_dir_sep(suffix, suffix_len);
+		}
+		else if (path[--path_len] != suffix[--suffix_len])
+			return NULL;
+	}
+
+	if (path_len && !is_dir_sep(path[path_len - 1]))
+		return NULL;
+	return strndup(path, chomp_trailing_dir_sep(path, path_len));
+}
diff --git a/tools/lib/trace/Makefile b/tools/lib/trace/Makefile
index 4c625e5..22fa7b6 100644
--- a/tools/lib/trace/Makefile
+++ b/tools/lib/trace/Makefile
@@ -42,6 +42,8 @@ PEVENT_LIB_OBJS += parse-filter.o
 PEVENT_LIB_OBJS += parse-utils.o
 PEVENT_LIB_OBJS += trace-seq.o
 
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+
 $(OUTPUT)%.o: %.c
 	$(QUIET_CC)$(CC) -g -o $@ -c $(ALL_CFLAGS) $<
 
diff --git a/tools/lib/trace/parse-events.c b/tools/lib/trace/parse-events.c
index 5503a18..1f95f87 100644
--- a/tools/lib/trace/parse-events.c
+++ b/tools/lib/trace/parse-events.c
@@ -24,7 +24,6 @@
  *  Frederic Weisbecker gave his permission to relicense the code to
  *  the Lesser General Public License.
  */
-#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -95,13 +94,7 @@ void pevent_buffer_init(const char *buf, unsigned long long size)
 	init_input_buf(buf, size);
 }
 
-void breakpoint(void)
-{
-	static int x;
-	x++;
-}
-
-struct print_arg *alloc_arg(void)
+static struct print_arg *alloc_arg(void)
 {
 	struct print_arg *arg;
 
@@ -164,7 +157,7 @@ static int cmdline_init(struct pevent *pevent)
 	return 0;
 }
 
-static char *find_cmdline(struct pevent *pevent, int pid)
+static const char *find_cmdline(struct pevent *pevent, int pid)
 {
 	const struct cmdline *comm;
 	struct cmdline key;
diff --git a/tools/lib/trace/parse-events.h b/tools/lib/trace/parse-events.h
index 5c10208..31f46f5 100644
--- a/tools/lib/trace/parse-events.h
+++ b/tools/lib/trace/parse-events.h
@@ -24,6 +24,8 @@
 #include <stdarg.h>
 #include <regex.h>
 
+#include <lk/compiler.h>
+
 #ifndef __unused
 #define __unused __attribute__ ((unused))
 #endif
@@ -359,9 +361,9 @@ void __die(const char *fmt, ...);
 void __warning(const char *fmt, ...);
 void __pr_stat(const char *fmt, ...);
 
-void __vdie(const char *fmt, ...);
-void __vwarning(const char *fmt, ...);
-void __vpr_stat(const char *fmt, ...);
+void __vdie(const char *fmt, va_list ap);
+void __vwarning(const char *fmt, va_list ap);
+void __vpr_stat(const char *fmt, va_list ap);
 
 static inline unsigned short
 __data2host2(struct pevent *pevent, unsigned short data)
diff --git a/tools/lib/trace/parse-utils.c b/tools/lib/trace/parse-utils.c
index f023a13..ba6669b 100644
--- a/tools/lib/trace/parse-utils.c
+++ b/tools/lib/trace/parse-utils.c
@@ -3,8 +3,9 @@
 #include <string.h>
 #include <stdarg.h>
 #include <errno.h>
+#include <lk/compiler.h>
 
-#define __weak __attribute__((weak))
+#include "parse-events.h"
 
 void __vdie(const char *fmt, va_list ap)
 {
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2e18b37..9af0817 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -369,7 +369,6 @@ LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
-LIB_H += util/color.h
 LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
@@ -382,7 +381,6 @@ LIB_H += util/pstack.h
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
-LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
@@ -390,7 +388,6 @@ LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
-LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
@@ -399,7 +396,6 @@ LIB_OBJS += $(OUTPUT)util/strlist.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
-LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
 LIB_OBJS += $(OUTPUT)util/callchain.o
@@ -928,14 +924,12 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
 		'-DBINDIR="$(bindir_relative_SQ)"' \
 		'-DPREFIX="$(prefix_SQ)"' \
+		'-DETC_PERFCONFIG="$(ETC_PERFCONFIG_SQ)"' \
 		$<
 
 $(OUTPUT)builtin-init-db.o: builtin-init-db.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DDEFAULT_PERF_TEMPLATE_DIR='"$(template_dir_SQ)"' $<
 
-$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
 $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7f9983b..c246b57 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -9,7 +9,7 @@
 
 #include <lk/util.h>
 
-#include "util/color.h"
+#include <perf/color.h>
 #include <linux/list.h>
 #include "util/cache.h"
 #include <lk/rbtree.h>
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 6d5a8a7..02711d5 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -3,6 +3,8 @@
  *
  * Builtin help command
  */
+#include <perf/config.h>
+
 #include "perf.h"
 #include "util/cache.h"
 #include "builtin.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 76e6967..c4e50e4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -9,7 +9,7 @@
 
 #include <lk/util.h>
 
-#include "util/color.h"
+#include <perf/color.h>
 #include <linux/list.h>
 #include "util/cache.h"
 #include <lk/rbtree.h>
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index aa9e4fc..35678a5 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -16,7 +16,7 @@
 
 #include <lk/util.h>
 
-#include "util/color.h"
+#include <perf/color.h>
 #include <linux/list.h>
 #include "util/cache.h"
 #include <lk/rbtree.h>
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3727a5c..069d53c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -20,7 +20,7 @@
 
 #include "perf.h"
 
-#include "util/color.h"
+#include <perf/color.h>
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 1fa597c..5581794 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -7,6 +7,7 @@
  * perf top, perf record, perf report, etc.) are started.
  */
 #include <lk/debugfs.h>
+#include <perf/config.h>
 
 #include "builtin.h"
 #include "util/exec_cmd.h"
diff --git a/tools/perf/util/abspath.c b/tools/perf/util/abspath.c
index 0e76aff..6c53331 100644
--- a/tools/perf/util/abspath.c
+++ b/tools/perf/util/abspath.c
@@ -1,3 +1,4 @@
+#include <perf/config.h>
 #include "cache.h"
 
 static const char *get_pwd_cwd(void)
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index b8144e8..d076a15 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -1,4 +1,5 @@
 #include "cache.h"
+#include <perf/config.h>
 
 static const char *alias_key;
 static char *alias_val;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 720f2de..8a54465 100644
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
 
@@ -74,14 +64,5 @@ static inline int is_absolute_path(const char *path)
 }
 
 const char *make_nonrelative_path(const char *path);
-char *strip_path_suffix(const char *path, const char *suffix);
-
-extern char *mkpath(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
-extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
-
-extern char *perf_pathdup(const char *fmt, ...)
-	__attribute__((format (printf, 1, 2)));
-
-extern size_t strlcpy(char *dest, const char *src, size_t size);
 
 #endif /* __PERF_CACHE_H */
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
deleted file mode 100644
index bb2f5a0..0000000
--- a/tools/perf/util/config.c
+++ /dev/null
@@ -1,492 +0,0 @@
-/*
- * GIT - The information manager from hell
- *
- * Copyright (C) Linus Torvalds, 2005
- * Copyright (C) Johannes Schindelin, 2005
- *
- */
-#include <lk/util.h>
-#include "cache.h"
-#include "exec_cmd.h"
-
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
-{
-	/* Add other config variables here and to Documentation/config.txt. */
-	return 0;
-}
-
-int perf_default_config(const char *var, const char *value, void *dummy __used)
-{
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
-}
-
-static const char *perf_etc_perfconfig(void)
-{
-	static const char *system_wide;
-	if (!system_wide)
-		system_wide = system_path(ETC_PERFCONFIG);
-	return system_wide;
-}
-
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
-int perf_config(config_fn_t fn, void *data)
-{
-	int ret = 0, found = 0;
-	char *repo_config = NULL;
-	const char *home = NULL;
-
-	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
-	if (config_exclusive_filename)
-		return perf_config_from_file(fn, config_exclusive_filename, data);
-	if (perf_config_system() && !access(perf_etc_perfconfig(), R_OK)) {
-		ret += perf_config_from_file(fn, perf_etc_perfconfig(),
-					    data);
-		found += 1;
-	}
-
-	home = getenv("HOME");
-	if (perf_config_global() && home) {
-		char *user_config = strdup(mkpath("%s/.perfconfig", home));
-		if (!access(user_config, R_OK)) {
-			ret += perf_config_from_file(fn, user_config, data);
-			found += 1;
-		}
-		free(user_config);
-	}
-
-	repo_config = perf_pathdup("config");
-	if (!access(repo_config, R_OK)) {
-		ret += perf_config_from_file(fn, repo_config, data);
-		found += 1;
-	}
-	free(repo_config);
-	if (found == 0)
-		return -1;
-	return ret;
-}
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
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 2b7ce22..a77dd3f 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -7,7 +7,7 @@
 #include <stdio.h>
 
 #include "cache.h"
-#include "color.h"
+#include <perf/color.h>
 #include "event.h"
 #include "debug.h"
 #include <lk/util.h>
diff --git a/tools/perf/util/environment.c b/tools/perf/util/environment.c
index 275b0ee..9b1c819 100644
--- a/tools/perf/util/environment.c
+++ b/tools/perf/util/environment.c
@@ -6,4 +6,3 @@
 #include "cache.h"
 
 const char *pager_program;
-int pager_use_color = 1;
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 67eeff5..21391fa 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -2,6 +2,8 @@
 #include "exec_cmd.h"
 #include "quote.h"
 
+#include <perf/config.h>
+
 #include <string.h>
 
 #define MAX_ARGS	32
@@ -165,3 +167,11 @@ int execl_perf_cmd(const char *cmd,...)
 	argv[argc] = NULL;
 	return execv_perf_cmd(argv);
 }
+
+const char *perf_etc_perfconfig(void)
+{
+	static const char *system_wide;
+	if (!system_wide)
+		system_wide = system_path(ETC_PERFCONFIG);
+	return system_wide;
+}
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..5098358 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -4,6 +4,8 @@
 #include "levenshtein.h"
 #include "help.h"
 
+#include <perf/config.h>
+
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
 	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 1915de2..f0455c3 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -2,13 +2,13 @@
 #include "run-command.h"
 #include "sigchain.h"
 
+#include <perf/config.h>
+
 /*
  * This is split up from the rest of git so that we can do
  * something different on Windows.
  */
 
-static int spawned_pager;
-
 static void pager_preexec(void)
 {
 	/*
@@ -83,14 +83,3 @@ void setup_pager(void)
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
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
deleted file mode 100644
index 58a470d..0000000
--- a/tools/perf/util/path.c
+++ /dev/null
@@ -1,156 +0,0 @@
-/*
- * I'm tired of doing "vsnprintf()" etc just to open a
- * file, so here's a "return static buffer with printf"
- * interface for paths.
- *
- * It's obviously not thread-safe. Sue me. But it's quite
- * useful for doing things like
- *
- *   f = open(mkpath("%s/%s.perf", base, name), O_RDONLY);
- *
- * which is what it's designed for.
- */
-#include "cache.h"
-
-static char bad_path[] = "/bad-path/";
-/*
- * Two hacks:
- */
-
-static const char *get_perf_dir(void)
-{
-	return ".";
-}
-
-size_t strlcpy(char *dest, const char *src, size_t size)
-{
-	size_t ret = strlen(src);
-
-	if (size) {
-		size_t len = (ret >= size) ? size - 1 : ret;
-		memcpy(dest, src, len);
-		dest[len] = '\0';
-	}
-	return ret;
-}
-
-
-static char *get_pathname(void)
-{
-	static char pathname_array[4][PATH_MAX];
-	static int idx;
-
-	return pathname_array[3 & ++idx];
-}
-
-static char *cleanup_path(char *path)
-{
-	/* Clean it up */
-	if (!memcmp(path, "./", 2)) {
-		path += 2;
-		while (*path == '/')
-			path++;
-	}
-	return path;
-}
-
-static char *perf_vsnpath(char *buf, size_t n, const char *fmt, va_list args)
-{
-	const char *perf_dir = get_perf_dir();
-	size_t len;
-
-	len = strlen(perf_dir);
-	if (n < len + 1)
-		goto bad;
-	memcpy(buf, perf_dir, len);
-	if (len && !is_dir_sep(perf_dir[len-1]))
-		buf[len++] = '/';
-	len += vsnprintf(buf + len, n - len, fmt, args);
-	if (len >= n)
-		goto bad;
-	return cleanup_path(buf);
-bad:
-	strlcpy(buf, bad_path, n);
-	return buf;
-}
-
-char *perf_pathdup(const char *fmt, ...)
-{
-	char path[PATH_MAX];
-	va_list args;
-	va_start(args, fmt);
-	(void)perf_vsnpath(path, sizeof(path), fmt, args);
-	va_end(args);
-	return xstrdup(path);
-}
-
-char *mkpath(const char *fmt, ...)
-{
-	va_list args;
-	unsigned len;
-	char *pathname = get_pathname();
-
-	va_start(args, fmt);
-	len = vsnprintf(pathname, PATH_MAX, fmt, args);
-	va_end(args);
-	if (len >= PATH_MAX)
-		return bad_path;
-	return cleanup_path(pathname);
-}
-
-char *perf_path(const char *fmt, ...)
-{
-	const char *perf_dir = get_perf_dir();
-	char *pathname = get_pathname();
-	va_list args;
-	unsigned len;
-
-	len = strlen(perf_dir);
-	if (len > PATH_MAX-100)
-		return bad_path;
-	memcpy(pathname, perf_dir, len);
-	if (len && perf_dir[len-1] != '/')
-		pathname[len++] = '/';
-	va_start(args, fmt);
-	len += vsnprintf(pathname + len, PATH_MAX - len, fmt, args);
-	va_end(args);
-	if (len >= PATH_MAX)
-		return bad_path;
-	return cleanup_path(pathname);
-}
-
-/* strip arbitrary amount of directory separators at end of path */
-static inline int chomp_trailing_dir_sep(const char *path, int len)
-{
-	while (len && is_dir_sep(path[len - 1]))
-		len--;
-	return len;
-}
-
-/*
- * If path ends with suffix (complete path components), returns the
- * part before suffix (sans trailing directory separators).
- * Otherwise returns NULL.
- */
-char *strip_path_suffix(const char *path, const char *suffix)
-{
-	int path_len = strlen(path), suffix_len = strlen(suffix);
-
-	while (suffix_len) {
-		if (!path_len)
-			return NULL;
-
-		if (is_dir_sep(path[path_len - 1])) {
-			if (!is_dir_sep(suffix[suffix_len - 1]))
-				return NULL;
-			path_len = chomp_trailing_dir_sep(path, path_len);
-			suffix_len = chomp_trailing_dir_sep(suffix, suffix_len);
-		}
-		else if (path[--path_len] != suffix[--suffix_len])
-			return NULL;
-	}
-
-	if (path_len && !is_dir_sep(path[path_len - 1]))
-		return NULL;
-	return strndup(path, chomp_trailing_dir_sep(path, path_len));
-}
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 5f97d04..7377dff 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -41,7 +41,7 @@
 #include "strlist.h"
 #include "debug.h"
 #include "cache.h"
-#include "color.h"
+#include <perf/color.h>
 #include "symbol.h"
 #include "thread.h"
 #include "trace-event.h"	/* For __unused */
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 4c015e9..b2c89b4 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -4,7 +4,7 @@
 
 #include <lk/util.h>
 
-#include "color.h"
+#include <perf/color.h>
 #include <linux/list.h>
 #include "cache.h"
 #include <lk/rbtree.h>
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 638a545..cd01eac 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -17,7 +17,7 @@
 #include <sys/ttydefaults.h>
 #include "browser.h"
 #include "helpline.h"
-#include "../color.h"
+#include <perf/color.h>
 #include "../util.h"
 
 #if SLANG_VERSION < 20104
-- 
1.7.3.1

