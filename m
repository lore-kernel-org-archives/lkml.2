Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0FNTZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:25:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47594 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0FNTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:25:05 -0400
Date: Mon, 14 Jun 2010 21:25:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@alien8.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100614192514.GA7803@kryptos.osrc.amd.com>
References: <20100523185411.GA5608@liondog.tnic>
 <1274642601.1674.1755.camel@laptop>
 <20100525073246.GA6085@liondog.tnic>
 <1274799588.5882.1572.camel@twins>
 <20100528143311.GB9710@elte.hu>
 <1275059860.27810.9635.camel@twins>
 <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603173242.GD29202@ghostprotocols.net>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, Jun 03, 2010 at 02:32:42PM -0300

> Right, that has to be done, I have sample code I want to put in samples/
> to show how to use the symbol libraries in tools/perf/util/, will take a
> stab at moving things for tools/lib/.
> 
> We'll need a top level Makefile, I guess, so that when asking to build
> tools/perf, it notices that it has to build tools/lib/, etc.
> 
> Probably we'll need tools/lib/symbols/, tools/lib/trace/parser/ things
> like that, I'll start with the symbols part, using a samples/ file I
> already wrote.

Right, so I started playing with this, added a global Makefile to tools/
and from there we descend into lib/ and perf/ in that order to prepare
all the modules for the perflib. I've played with the include paths so
that you can have #include <util/util.h> for all that generic library
stuff.

The patch below carves out the debugfs helpers along with some generic
headers, please take a look and let me know if this is an agreeable
direction I'm going. Yeah, it is big, I think vger won't be able to
swallow it but this is only moving files around so...

Thanks.

--
>From 0f391f0acf39d3b2e85145dce389cbf425cb7cdd Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 14 Jun 2010 21:14:15 +0200
Subject: [PATCH] perf: rewire generic library stuff

---
 tools/Makefile                                     |   74 +++++
 tools/lib/Makefile                                 |   41 +++
 tools/lib/util/cache.h                             |   86 ++++++
 tools/lib/util/debugfs.c                           |  252 +++++++++++++++++
 tools/lib/util/debugfs.h                           |   31 +++
 tools/lib/util/strbuf.c                            |  133 +++++++++
 tools/lib/util/strbuf.h                            |   92 +++++++
 tools/lib/util/types.h                             |   17 ++
 tools/lib/util/util.h                              |  282 ++++++++++++++++++++
 tools/perf/Makefile                                |   64 +----
 tools/perf/bench/bench.h                           |    2 +
 tools/perf/bench/mem-memcpy.c                      |    2 +-
 tools/perf/bench/sched-messaging.c                 |    2 +-
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-bench.c                         |    2 +-
 tools/perf/builtin.h                               |    4 +-
 tools/perf/perf.c                                  |   15 +-
 tools/perf/perf.h                                  |    2 +
 tools/perf/util/abspath.c                          |    2 +-
 tools/perf/util/alias.c                            |    3 +-
 tools/perf/util/build-id.c                         |    2 +-
 tools/perf/util/cache.h                            |   86 ------
 tools/perf/util/callchain.c                        |    2 +-
 tools/perf/util/color.c                            |    2 +-
 tools/perf/util/color.h                            |    2 +
 tools/perf/util/config.c                           |    5 +-
 tools/perf/util/cpumap.c                           |    2 +-
 tools/perf/util/ctype.c                            |    2 +-
 tools/perf/util/debug.c                            |    4 +-
 tools/perf/util/debugfs.c                          |  240 -----------------
 tools/perf/util/debugfs.h                          |   25 --
 tools/perf/util/environment.c                      |    2 +-
 tools/perf/util/exec_cmd.c                         |    2 +-
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/header.h                           |    2 +-
 tools/perf/util/help.c                             |    4 +-
 tools/perf/util/hist.c                             |    2 +-
 tools/perf/util/levenshtein.c                      |    2 +-
 tools/perf/util/map.h                              |    2 +-
 tools/perf/util/newt.c                             |    2 +-
 tools/perf/util/pager.c                            |    2 +-
 tools/perf/util/parse-events.c                     |    8 +-
 tools/perf/util/parse-events.h                     |    4 +-
 tools/perf/util/parse-options.c                    |    5 +-
 tools/perf/util/path.c                             |    2 +-
 tools/perf/util/probe-event.c                      |    6 +-
 tools/perf/util/probe-finder.c                     |    2 +-
 tools/perf/util/probe-finder.h                     |    2 +-
 tools/perf/util/pstack.c                           |    2 +-
 tools/perf/util/quote.c                            |    2 +-
 tools/perf/util/run-command.c                      |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 tools/perf/util/session.c                          |    2 +-
 tools/perf/util/sigchain.c                         |    2 +-
 tools/perf/util/sort.h                             |    4 +-
 tools/perf/util/strbuf.c                           |  133 ---------
 tools/perf/util/strbuf.h                           |   92 -------
 tools/perf/util/string.c                           |    2 +-
 tools/perf/util/svghelper.h                        |    2 +-
 tools/perf/util/thread.c                           |    2 +-
 tools/perf/util/trace-event-info.c                 |    2 +-
 tools/perf/util/trace-event-parse.c                |    2 +-
 tools/perf/util/trace-event-read.c                 |    2 +-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/types.h                            |   17 --
 tools/perf/util/usage.c                            |    2 +-
 tools/perf/util/util.c                             |    2 +-
 tools/perf/util/util.h                             |  282 --------------------
 tools/perf/util/values.c                           |    2 +-
 tools/perf/util/values.h                           |    2 +-
 tools/perf/util/wrapper.c                          |    3 +-
 72 files changed, 1089 insertions(+), 1009 deletions(-)
 create mode 100644 tools/Makefile
 create mode 100644 tools/lib/Makefile
 create mode 100644 tools/lib/util/cache.h
 create mode 100644 tools/lib/util/debugfs.c
 create mode 100644 tools/lib/util/debugfs.h
 create mode 100644 tools/lib/util/strbuf.c
 create mode 100644 tools/lib/util/strbuf.h
 create mode 100644 tools/lib/util/types.h
 create mode 100644 tools/lib/util/util.h
 delete mode 100644 tools/perf/util/cache.h
 delete mode 100644 tools/perf/util/debugfs.c
 delete mode 100644 tools/perf/util/debugfs.h
 delete mode 100644 tools/perf/util/strbuf.c
 delete mode 100644 tools/perf/util/strbuf.h
 delete mode 100644 tools/perf/util/types.h
 delete mode 100644 tools/perf/util/util.h

diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 0000000..34642e6
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,74 @@
+# CFLAGS and LDFLAGS are for the users to override from the command line.
+
+#
+# Include saner warnings here, which can catch bugs:
+#
+
+EXTRA_WARNINGS := -Wformat
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
+
+export EXTRA_WARNINGS
+
+ifeq ("$(origin DEBUG)", "command line")
+  PERF_DEBUG = $(DEBUG)
+endif
+ifndef PERF_DEBUG
+  CFLAGS_OPTIMIZE = -O6
+endif
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_CC       = @echo '   ' CC $@;
+	QUIET_AR       = @echo '   ' AR $@;
+	QUIET_LINK     = @echo '   ' LINK $@;
+	QUIET_BUILT_IN = @echo '   ' BUILTIN $@;
+	QUIET_GEN      = @echo '   ' GEN $@;
+	QUIET_SUBDIR0  = +@subdir=
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+			 $(MAKE) $(PRINT_DIR) -C $$subdir
+	export V
+	export QUIET_CC
+	export QUIET_GEN
+	export QUIET_BUILT_IN
+endif
+endif
+
+#
+# lib includes for submake
+BASIC_CFLAGS = -I$(CURDIR)/lib
+
+export BASIC_CFLAGS
+
+rasd: lib
+
+perf: lib .FORCE
+	$(MAKE) -C perf/
+
+lib: .FORCE
+	$(MAKE) -C lib/
+
+clean:
+	$(MAKE) -C lib/ clean
+	$(MAKE) -C perf/ clean
+
+.PHONY: clean .FORCE
diff --git a/tools/lib/Makefile b/tools/lib/Makefile
new file mode 100644
index 0000000..faa5a0a
--- /dev/null
+++ b/tools/lib/Makefile
@@ -0,0 +1,41 @@
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
+# Guard against environment variables
+LIB_H =
+LIB_OBJS =
+
+LIB_H += util/debugfs.h
+LIB_H += util/util.h
+LIB_H += util/types.h
+LIB_H += util/cache.h
+LIB_H += util/strbuf.h
+
+LIB_OBJS += $(OUTPUT)util/strbuf.o
+LIB_OBJS += $(OUTPUT)util/debugfs.o
+
+RM = rm -f
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+STRIP ?= strip
+
+genlib.a: $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+$(OUTPUT)%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+$(OUTPUT)%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(LIB_OBJS)
+
+.PHONY: clean
diff --git a/tools/lib/util/cache.h b/tools/lib/util/cache.h
new file mode 100644
index 0000000..94939b4
--- /dev/null
+++ b/tools/lib/util/cache.h
@@ -0,0 +1,86 @@
+#ifndef __PERF_CACHE_H
+#define __PERF_CACHE_H
+
+#include <stdbool.h>
+#include "util.h"
+#include "strbuf.h"
+//#include "../../perf/perf.h"
+
+#define CMD_EXEC_PATH "--exec-path"
+#define CMD_PERF_DIR "--perf-dir="
+#define CMD_WORK_TREE "--work-tree="
+#define CMD_DEBUGFS_DIR "--debugfs-dir="
+
+#define PERF_DIR_ENVIRONMENT "PERF_DIR"
+#define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
+#define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
+#define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
+
+typedef int (*config_fn_t)(const char *, const char *, void *);
+extern int perf_default_config(const char *, const char *, void *);
+extern int perf_config(config_fn_t fn, void *);
+extern int perf_config_int(const char *, const char *);
+extern int perf_config_bool(const char *, const char *);
+extern int config_error_nonbool(const char *);
+
+/* pager.c */
+extern void setup_pager(void);
+extern const char *pager_program;
+extern int pager_in_use(void);
+extern int pager_use_color;
+
+extern int use_browser;
+
+#ifdef NO_NEWT_SUPPORT
+static inline void setup_browser(void)
+{
+	setup_pager();
+}
+static inline void exit_browser(bool wait_for_ok __used) {}
+#else
+void setup_browser(void);
+void exit_browser(bool wait_for_ok);
+#endif
+
+char *alias_lookup(const char *alias);
+int split_cmdline(char *cmdline, const char ***argv);
+
+#define alloc_nr(x) (((x)+16)*3/2)
+
+/*
+ * Realloc the buffer pointed at by variable 'x' so that it can hold
+ * at least 'nr' entries; the number of entries currently allocated
+ * is 'alloc', using the standard growing factor alloc_nr() macro.
+ *
+ * DO NOT USE any expression with side-effect for 'x' or 'alloc'.
+ */
+#define ALLOC_GROW(x, nr, alloc) \
+	do { \
+		if ((nr) > alloc) { \
+			if (alloc_nr(alloc) < (nr)) \
+				alloc = (nr); \
+			else \
+				alloc = alloc_nr(alloc); \
+			x = xrealloc((x), alloc * sizeof(*(x))); \
+		} \
+	} while(0)
+
+
+static inline int is_absolute_path(const char *path)
+{
+	return path[0] == '/';
+}
+
+const char *make_nonrelative_path(const char *path);
+char *strip_path_suffix(const char *path, const char *suffix);
+
+extern char *mkpath(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
+extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
+
+extern char *perf_pathdup(const char *fmt, ...)
+	__attribute__((format (printf, 1, 2)));
+
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+
+#endif /* __PERF_CACHE_H */
diff --git a/tools/lib/util/debugfs.c b/tools/lib/util/debugfs.c
new file mode 100644
index 0000000..bb737a5
--- /dev/null
+++ b/tools/lib/util/debugfs.c
@@ -0,0 +1,252 @@
+#include "util.h"
+#include "debugfs.h"
+#include "cache.h"
+
+static int debugfs_premounted;
+static char debugfs_mountpoint[MAX_PATH+1];
+
+char debugfs_path[MAXPATHLEN];
+char debugfs_mntpt[MAXPATHLEN];
+
+static const char *debugfs_known_mountpoints[] = {
+	"/sys/kernel/debug/",
+	"/debug/",
+	0,
+};
+
+/* use this to force a umount */
+void debugfs_force_cleanup(void)
+{
+	debugfs_find_mountpoint();
+	debugfs_premounted = 0;
+	debugfs_umount();
+}
+
+/* construct a full path to a debugfs element */
+int debugfs_make_path(const char *element, char *buffer, int size)
+{
+	int len;
+
+	if (strlen(debugfs_mountpoint) == 0) {
+		buffer[0] = '\0';
+		return -1;
+	}
+
+	len = strlen(debugfs_mountpoint) + strlen(element) + 1;
+	if (len >= size)
+		return len+1;
+
+	snprintf(buffer, size-1, "%s/%s", debugfs_mountpoint, element);
+	return 0;
+}
+
+static int debugfs_found;
+
+/* find the path to the mounted debugfs */
+const char *debugfs_find_mountpoint(void)
+{
+	const char **ptr;
+	char type[100];
+	FILE *fp;
+
+	if (debugfs_found)
+		return (const char *) debugfs_mountpoint;
+
+	ptr = debugfs_known_mountpoints;
+	while (*ptr) {
+		if (debugfs_valid_mountpoint(*ptr) == 0) {
+			debugfs_found = 1;
+			strcpy(debugfs_mountpoint, *ptr);
+			return debugfs_mountpoint;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		die("Can't open /proc/mounts for read");
+
+	while (fscanf(fp, "%*s %"
+		      STR(MAX_PATH)
+		      "s %99s %*s %*d %*d\n",
+		      debugfs_mountpoint, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		return NULL;
+
+	debugfs_found = 1;
+
+	return debugfs_mountpoint;
+}
+
+/* verify that a mountpoint is actually a debugfs instance */
+
+int debugfs_valid_mountpoint(const char *debugfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(debugfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+
+	return 0;
+}
+
+
+int debugfs_valid_entry(const char *path)
+{
+	struct stat st;
+
+	if (stat(path, &st))
+		return -errno;
+
+	return 0;
+}
+
+/* mount the debugfs somewhere if it's not mounted */
+
+char *debugfs_mount(const char *mountpoint)
+{
+	/* see if it's already mounted */
+	if (debugfs_find_mountpoint()) {
+		debugfs_premounted = 1;
+		return debugfs_mountpoint;
+	}
+
+	/* if not mounted and no argument */
+	if (mountpoint == NULL) {
+		/* see if environment variable set */
+		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
+		/* if no environment variable, use default */
+		if (mountpoint == NULL)
+			mountpoint = "/sys/kernel/debug";
+	}
+
+	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
+		return NULL;
+
+	/* save the mountpoint */
+	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+	debugfs_found = 1;
+
+	return debugfs_mountpoint;
+}
+
+/* umount the debugfs */
+
+int debugfs_umount(void)
+{
+	char umountcmd[128];
+	int ret;
+
+	/* if it was already mounted, leave it */
+	if (debugfs_premounted)
+		return 0;
+
+	/* make sure it's a valid mount point */
+	ret = debugfs_valid_mountpoint(debugfs_mountpoint);
+	if (ret)
+		return ret;
+
+	snprintf(umountcmd, sizeof(umountcmd),
+		 "/bin/umount %s", debugfs_mountpoint);
+	return system(umountcmd);
+}
+
+int debugfs_write(const char *entry, const char *value)
+{
+	char path[MAX_PATH+1];
+	int ret, count;
+	int fd;
+
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+
+	/* verify that it exists */
+	ret = debugfs_valid_entry(path);
+	if (ret)
+		return ret;
+
+	/* get how many chars we're going to write */
+	count = strlen(value);
+
+	/* open the debugfs entry */
+	fd = open(path, O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	while (count > 0) {
+		/* write it */
+		ret = write(fd, value, count);
+		if (ret <= 0) {
+			if (ret == EAGAIN)
+				continue;
+			close(fd);
+			return -errno;
+		}
+		count -= ret;
+	}
+
+	/* close it */
+	close(fd);
+
+	/* return success */
+	return 0;
+}
+
+/*
+ * read a debugfs entry
+ * returns the number of chars read or a negative errno
+ */
+int debugfs_read(const char *entry, char *buffer, size_t size)
+{
+	char path[MAX_PATH+1];
+	int ret;
+	int fd;
+
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+
+	/* verify that it exists */
+	ret = debugfs_valid_entry(path);
+	if (ret)
+		return ret;
+
+	/* open the debugfs entry */
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	do {
+		/* read it */
+		ret = read(fd, buffer, size);
+		if (ret == 0) {
+			close(fd);
+			return EOF;
+		}
+	} while (ret < 0 && errno == EAGAIN);
+
+	/* close it */
+	close(fd);
+
+	/* make *sure* there's a null character at the end */
+	buffer[ret] = '\0';
+
+	/* return the number of chars read */
+	return ret;
+}
+
+void set_debugfs_path(void)
+{
+	char *path;
+
+	path = getenv(PERF_DEBUGFS_ENVIRONMENT);
+	snprintf(debugfs_path, MAXPATHLEN, "%s/%s", path ?: debugfs_mntpt,
+		 "tracing/events");
+}
diff --git a/tools/lib/util/debugfs.h b/tools/lib/util/debugfs.h
new file mode 100644
index 0000000..dce74b0
--- /dev/null
+++ b/tools/lib/util/debugfs.h
@@ -0,0 +1,31 @@
+#ifndef __DEBUGFS_H__
+#define __DEBUGFS_H__
+
+#include <sys/mount.h>
+#include <sys/param.h>
+
+#ifndef MAX_PATH
+# define MAX_PATH 256
+#endif
+
+#ifndef STR
+# define _STR(x) #x
+# define STR(x) _STR(x)
+#endif
+
+extern char debugfs_path[MAXPATHLEN];
+extern char debugfs_mntpt[MAXPATHLEN];
+
+
+extern const char *debugfs_find_mountpoint(void);
+extern int debugfs_valid_mountpoint(const char *debugfs);
+extern int debugfs_valid_entry(const char *path);
+extern char *debugfs_mount(const char *mountpoint);
+extern int debugfs_umount(void);
+extern int debugfs_write(const char *entry, const char *value);
+extern int debugfs_read(const char *entry, char *buffer, size_t size);
+extern void debugfs_force_cleanup(void);
+extern int debugfs_make_path(const char *element, char *buffer, int size);
+extern void set_debugfs_path(void);
+
+#endif /* __DEBUGFS_H__ */
diff --git a/tools/lib/util/strbuf.c b/tools/lib/util/strbuf.c
new file mode 100644
index 0000000..92e0685
--- /dev/null
+++ b/tools/lib/util/strbuf.c
@@ -0,0 +1,133 @@
+#include "cache.h"
+
+int prefixcmp(const char *str, const char *prefix)
+{
+	for (; ; str++, prefix++)
+		if (!*prefix)
+			return 0;
+		else if (*str != *prefix)
+			return (unsigned char)*prefix - (unsigned char)*str;
+}
+
+/*
+ * Used as the default ->buf value, so that people can always assume
+ * buf is non NULL and ->buf is NUL terminated even for a freshly
+ * initialized strbuf.
+ */
+char strbuf_slopbuf[1];
+
+void strbuf_init(struct strbuf *sb, ssize_t hint)
+{
+	sb->alloc = sb->len = 0;
+	sb->buf = strbuf_slopbuf;
+	if (hint)
+		strbuf_grow(sb, hint);
+}
+
+void strbuf_release(struct strbuf *sb)
+{
+	if (sb->alloc) {
+		free(sb->buf);
+		strbuf_init(sb, 0);
+	}
+}
+
+char *strbuf_detach(struct strbuf *sb, size_t *sz)
+{
+	char *res = sb->alloc ? sb->buf : NULL;
+	if (sz)
+		*sz = sb->len;
+	strbuf_init(sb, 0);
+	return res;
+}
+
+void strbuf_grow(struct strbuf *sb, size_t extra)
+{
+	if (sb->len + extra + 1 <= sb->len)
+		die("you want to use way too much memory");
+	if (!sb->alloc)
+		sb->buf = NULL;
+	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
+}
+
+static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
+				   const void *data, size_t dlen)
+{
+	if (pos + len < pos)
+		die("you want to use way too much memory");
+	if (pos > sb->len)
+		die("`pos' is too far after the end of the buffer");
+	if (pos + len > sb->len)
+		die("`pos + len' is too far after the end of the buffer");
+
+	if (dlen >= len)
+		strbuf_grow(sb, dlen - len);
+	memmove(sb->buf + pos + dlen,
+			sb->buf + pos + len,
+			sb->len - pos - len);
+	memcpy(sb->buf + pos, data, dlen);
+	strbuf_setlen(sb, sb->len + dlen - len);
+}
+
+void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
+{
+	strbuf_splice(sb, pos, len, NULL, 0);
+}
+
+void strbuf_add(struct strbuf *sb, const void *data, size_t len)
+{
+	strbuf_grow(sb, len);
+	memcpy(sb->buf + sb->len, data, len);
+	strbuf_setlen(sb, sb->len + len);
+}
+
+void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
+{
+	int len;
+	va_list ap;
+
+	if (!strbuf_avail(sb))
+		strbuf_grow(sb, 64);
+	va_start(ap, fmt);
+	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+	va_end(ap);
+	if (len < 0)
+		die("your vsnprintf is broken");
+	if (len > strbuf_avail(sb)) {
+		strbuf_grow(sb, len);
+		va_start(ap, fmt);
+		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+		va_end(ap);
+		if (len > strbuf_avail(sb)) {
+			die("this should not happen, your snprintf is broken");
+		}
+	}
+	strbuf_setlen(sb, sb->len + len);
+}
+
+ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
+{
+	size_t oldlen = sb->len;
+	size_t oldalloc = sb->alloc;
+
+	strbuf_grow(sb, hint ? hint : 8192);
+	for (;;) {
+		ssize_t cnt;
+
+		cnt = read(fd, sb->buf + sb->len, sb->alloc - sb->len - 1);
+		if (cnt < 0) {
+			if (oldalloc == 0)
+				strbuf_release(sb);
+			else
+				strbuf_setlen(sb, oldlen);
+			return -1;
+		}
+		if (!cnt)
+			break;
+		sb->len += cnt;
+		strbuf_grow(sb, 8192);
+	}
+
+	sb->buf[sb->len] = '\0';
+	return sb->len - oldlen;
+}
diff --git a/tools/lib/util/strbuf.h b/tools/lib/util/strbuf.h
new file mode 100644
index 0000000..436ac31
--- /dev/null
+++ b/tools/lib/util/strbuf.h
@@ -0,0 +1,92 @@
+#ifndef __PERF_STRBUF_H
+#define __PERF_STRBUF_H
+
+/*
+ * Strbuf's can be use in many ways: as a byte array, or to store arbitrary
+ * long, overflow safe strings.
+ *
+ * Strbufs has some invariants that are very important to keep in mind:
+ *
+ * 1. the ->buf member is always malloc-ed, hence strbuf's can be used to
+ *    build complex strings/buffers whose final size isn't easily known.
+ *
+ *    It is NOT legal to copy the ->buf pointer away.
+ *    `strbuf_detach' is the operation that detachs a buffer from its shell
+ *    while keeping the shell valid wrt its invariants.
+ *
+ * 2. the ->buf member is a byte array that has at least ->len + 1 bytes
+ *    allocated. The extra byte is used to store a '\0', allowing the ->buf
+ *    member to be a valid C-string. Every strbuf function ensure this
+ *    invariant is preserved.
+ *
+ *    Note that it is OK to "play" with the buffer directly if you work it
+ *    that way:
+ *
+ *    strbuf_grow(sb, SOME_SIZE);
+ *       ... Here, the memory array starting at sb->buf, and of length
+ *       ... strbuf_avail(sb) is all yours, and you are sure that
+ *       ... strbuf_avail(sb) is at least SOME_SIZE.
+ *    strbuf_setlen(sb, sb->len + SOME_OTHER_SIZE);
+ *
+ *    Of course, SOME_OTHER_SIZE must be smaller or equal to strbuf_avail(sb).
+ *
+ *    Doing so is safe, though if it has to be done in many places, adding the
+ *    missing API to the strbuf module is the way to go.
+ *
+ *    XXX: do _not_ assume that the area that is yours is of size ->alloc - 1
+ *         even if it's true in the current implementation. Alloc is somehow a
+ *         "private" member that should not be messed with.
+ */
+
+#include <assert.h>
+
+extern char strbuf_slopbuf[];
+struct strbuf {
+	size_t alloc;
+	size_t len;
+	char *buf;
+};
+
+#define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
+
+/*----- strbuf life cycle -----*/
+extern void strbuf_init(struct strbuf *buf, ssize_t hint);
+extern void strbuf_release(struct strbuf *);
+extern char *strbuf_detach(struct strbuf *, size_t *);
+
+/*----- strbuf size related -----*/
+static inline ssize_t strbuf_avail(const struct strbuf *sb) {
+	return sb->alloc ? sb->alloc - sb->len - 1 : 0;
+}
+
+extern void strbuf_grow(struct strbuf *, size_t);
+
+static inline void strbuf_setlen(struct strbuf *sb, size_t len) {
+	if (!sb->alloc)
+		strbuf_grow(sb, 0);
+	assert(len < sb->alloc);
+	sb->len = len;
+	sb->buf[len] = '\0';
+}
+
+/*----- add data in your buffer -----*/
+static inline void strbuf_addch(struct strbuf *sb, int c) {
+	strbuf_grow(sb, 1);
+	sb->buf[sb->len++] = c;
+	sb->buf[sb->len] = '\0';
+}
+
+extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
+
+extern void strbuf_add(struct strbuf *, const void *, size_t);
+static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
+	strbuf_add(sb, s, strlen(s));
+}
+
+__attribute__((format(printf,2,3)))
+extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
+
+/* XXX: if read fails, any partial read is undone */
+extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
+
+#endif /* __PERF_STRBUF_H */
diff --git a/tools/lib/util/types.h b/tools/lib/util/types.h
new file mode 100644
index 0000000..7d6b833
--- /dev/null
+++ b/tools/lib/util/types.h
@@ -0,0 +1,17 @@
+#ifndef __PERF_TYPES_H
+#define __PERF_TYPES_H
+
+/*
+ * We define u64 as unsigned long long for every architecture
+ * so that we can print it with %Lx without getting warnings.
+ */
+typedef unsigned long long u64;
+typedef signed long long   s64;
+typedef unsigned int	   u32;
+typedef signed int	   s32;
+typedef unsigned short	   u16;
+typedef signed short	   s16;
+typedef unsigned char	   u8;
+typedef signed char	   s8;
+
+#endif /* __PERF_TYPES_H */
diff --git a/tools/lib/util/util.h b/tools/lib/util/util.h
new file mode 100644
index 0000000..4e8b6b0
--- /dev/null
+++ b/tools/lib/util/util.h
@@ -0,0 +1,282 @@
+#ifndef GIT_COMPAT_UTIL_H
+#define GIT_COMPAT_UTIL_H
+
+#define _FILE_OFFSET_BITS 64
+
+#ifndef FLEX_ARRAY
+/*
+ * See if our compiler is known to support flexible array members.
+ */
+#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)
+# define FLEX_ARRAY /* empty */
+#elif defined(__GNUC__)
+# if (__GNUC__ >= 3)
+#  define FLEX_ARRAY /* empty */
+# else
+#  define FLEX_ARRAY 0 /* older GNU extension */
+# endif
+#endif
+
+/*
+ * Otherwise, default to safer but a bit wasteful traditional style
+ */
+#ifndef FLEX_ARRAY
+# define FLEX_ARRAY 1
+#endif
+#endif
+
+#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
+
+#ifdef __GNUC__
+#define TYPEOF(x) (__typeof__(x))
+#else
+#define TYPEOF(x)
+#endif
+
+#define MSB(x, bits) ((x) & TYPEOF(x)(~0ULL << (sizeof(x) * 8 - (bits))))
+#define HAS_MULTI_BITS(i)  ((i) & ((i) - 1))  /* checks if an integer has more than 1 bit set */
+
+/* Approximation of the length of the decimal representation of this type. */
+#define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
+
+#define _ALL_SOURCE 1
+#define _GNU_SOURCE 1
+#define _BSD_SOURCE 1
+#define HAS_BOOL
+
+#include <unistd.h>
+#include <stdio.h>
+#include <sys/stat.h>
+#include <sys/statfs.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <errno.h>
+#include <limits.h>
+#include <sys/param.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/time.h>
+#include <time.h>
+#include <signal.h>
+#include <fnmatch.h>
+#include <assert.h>
+#include <regex.h>
+#include <utime.h>
+#include <sys/wait.h>
+#include <sys/poll.h>
+#include <sys/socket.h>
+#include <sys/ioctl.h>
+#ifndef NO_SYS_SELECT_H
+#include <sys/select.h>
+#endif
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <pwd.h>
+#include <inttypes.h>
+#include "../../../include/linux/magic.h"
+#include "types.h"
+#include <sys/ttydefaults.h>
+
+#ifndef NO_ICONV
+#include <iconv.h>
+#endif
+
+extern const char *graph_line;
+extern const char *graph_dotted_line;
+
+/* On most systems <limits.h> would have given us this, but
+ * not on some systems (e.g. GNU/Hurd).
+ */
+#ifndef PATH_MAX
+#define PATH_MAX 4096
+#endif
+
+#ifndef PRIuMAX
+#define PRIuMAX "llu"
+#endif
+
+#ifndef PRIu32
+#define PRIu32 "u"
+#endif
+
+#ifndef PRIx32
+#define PRIx32 "x"
+#endif
+
+#ifndef PATH_SEP
+#define PATH_SEP ':'
+#endif
+
+#ifndef STRIP_EXTENSION
+#define STRIP_EXTENSION ""
+#endif
+
+#ifndef has_dos_drive_prefix
+#define has_dos_drive_prefix(path) 0
+#endif
+
+#ifndef is_dir_sep
+#define is_dir_sep(c) ((c) == '/')
+#endif
+
+#ifdef __GNUC__
+#define NORETURN __attribute__((__noreturn__))
+#else
+#define NORETURN
+#ifndef __attribute__
+#define __attribute__(x)
+#endif
+#endif
+
+/* General helper functions */
+extern void usage(const char *err) NORETURN;
+extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
+extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
+extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
+
+#include "../../../include/linux/stringify.h"
+
+#define DIE_IF(cnd)	\
+	do { if (cnd)	\
+		die(" at (" __FILE__ ":" __stringify(__LINE__) "): "	\
+		    __stringify(cnd) "\n");				\
+	} while (0)
+
+
+extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
+
+extern int prefixcmp(const char *str, const char *prefix);
+
+static inline const char *skip_prefix(const char *str, const char *prefix)
+{
+	size_t len = strlen(prefix);
+	return strncmp(str, prefix, len) ? NULL : str + len;
+}
+
+#ifdef __GLIBC_PREREQ
+#if __GLIBC_PREREQ(2, 1)
+#define HAVE_STRCHRNUL
+#endif
+#endif
+
+#ifndef HAVE_STRCHRNUL
+#define strchrnul gitstrchrnul
+static inline char *gitstrchrnul(const char *s, int c)
+{
+	while (*s && *s != c)
+		s++;
+	return (char *)s;
+}
+#endif
+
+/*
+ * Wrappers:
+ */
+extern char *xstrdup(const char *str);
+extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
+
+
+static inline void *zalloc(size_t size)
+{
+	return calloc(1, size);
+}
+
+static inline int has_extension(const char *filename, const char *ext)
+{
+	size_t len = strlen(filename);
+	size_t extlen = strlen(ext);
+
+	return len > extlen && !memcmp(filename + len - extlen, ext, extlen);
+}
+
+/* Sane ctype - no locale, and works with signed chars */
+#undef isascii
+#undef isspace
+#undef isdigit
+#undef isxdigit
+#undef isalpha
+#undef isprint
+#undef isalnum
+#undef tolower
+#undef toupper
+
+extern unsigned char sane_ctype[256];
+#define GIT_SPACE		0x01
+#define GIT_DIGIT		0x02
+#define GIT_ALPHA		0x04
+#define GIT_GLOB_SPECIAL	0x08
+#define GIT_REGEX_SPECIAL	0x10
+#define GIT_PRINT_EXTRA		0x20
+#define GIT_PRINT		0x3E
+#define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
+#define isascii(x) (((x) & ~0x7f) == 0)
+#define isspace(x) sane_istest(x,GIT_SPACE)
+#define isdigit(x) sane_istest(x,GIT_DIGIT)
+#define isxdigit(x)	\
+	(sane_istest(toupper(x), GIT_ALPHA | GIT_DIGIT) && toupper(x) < 'G')
+#define isalpha(x) sane_istest(x,GIT_ALPHA)
+#define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
+#define isprint(x) sane_istest(x,GIT_PRINT)
+#define tolower(x) sane_case((unsigned char)(x), 0x20)
+#define toupper(x) sane_case((unsigned char)(x), 0)
+
+static inline int sane_case(int x, int high)
+{
+	if (sane_istest(x, GIT_ALPHA))
+		x = (x & ~0x20) | high;
+	return x;
+}
+
+#ifndef DIR_HAS_BSD_GROUP_SEMANTICS
+# define FORCE_DIR_SET_GID S_ISGID
+#else
+# define FORCE_DIR_SET_GID 0
+#endif
+
+#ifdef NO_NSEC
+#undef USE_NSEC
+#define ST_CTIME_NSEC(st) 0
+#define ST_MTIME_NSEC(st) 0
+#else
+#ifdef USE_ST_TIMESPEC
+#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctimespec.tv_nsec))
+#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtimespec.tv_nsec))
+#else
+#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctim.tv_nsec))
+#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtim.tv_nsec))
+#endif
+#endif
+
+int mkdir_p(char *path, mode_t mode);
+int copyfile(const char *from, const char *to);
+
+s64 perf_atoll(const char *str);
+char **argv_split(const char *str, int *argcp);
+void argv_free(char **argv);
+bool strglobmatch(const char *str, const char *pat);
+bool strlazymatch(const char *str, const char *pat);
+unsigned long convert_unit(unsigned long value, char *unit);
+
+#ifndef ESC
+#define ESC 27
+#endif
+
+static inline bool is_exit_key(int key)
+{
+	char up;
+	if (key == CTRL('c') || key == ESC)
+		return true;
+	up = toupper(key);
+	return up == 'Q';
+}
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+#endif
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3d8f31e..fac008c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -189,42 +189,6 @@ endif
 
 $(shell sh -c 'mkdir -p $(OUTPUT)arch/$(ARCH)/util/' 2> /dev/null)
 
-# CFLAGS and LDFLAGS are for the users to override from the command line.
-
-#
-# Include saner warnings here, which can catch bugs:
-#
-
-EXTRA_WARNINGS := -Wformat
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
-
-ifeq ("$(origin DEBUG)", "command line")
-  PERF_DEBUG = $(DEBUG)
-endif
-ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6
-endif
-
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
@@ -301,7 +265,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS += -Iutil/include -Iarch/$(ARCH)/include
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -385,24 +349,19 @@ LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
 LIB_H += util/include/dwarf-regs.h
 LIB_H += perf.h
-LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/debugfs.h
 LIB_H += util/event.h
 LIB_H += util/exec_cmd.h
-LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/map.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
-LIB_H += util/util.h
 LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
-LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
 LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
@@ -419,12 +378,14 @@ LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
 
+# add generic library modules
+LIB_OBJS := $(wildcard ../lib/util/*.o)
+
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
@@ -438,7 +399,6 @@ LIB_OBJS += $(OUTPUT)util/bitmap.o
 LIB_OBJS += $(OUTPUT)util/hweight.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
-LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
 LIB_OBJS += $(OUTPUT)util/usage.o
@@ -811,22 +771,6 @@ else # "make -w"
 NO_SUBDIR = :
 endif
 
-ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
-	QUIET_CC       = @echo '   ' CC $@;
-	QUIET_AR       = @echo '   ' AR $@;
-	QUIET_LINK     = @echo '   ' LINK $@;
-	QUIET_BUILT_IN = @echo '   ' BUILTIN $@;
-	QUIET_GEN      = @echo '   ' GEN $@;
-	QUIET_SUBDIR0  = +@subdir=
-	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
-			 $(MAKE) $(PRINT_DIR) -C $$subdir
-	export V
-	export QUIET_GEN
-	export QUIET_BUILT_IN
-endif
-endif
-
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..0c7ee07 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,8 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <linux/compiler.h>
+
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 38dae74..e0fec0d 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -8,7 +8,7 @@
 #include <ctype.h>
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <util/util.h>
 #include "../util/parse-options.h"
 #include "../util/header.h"
 #include "bench.h"
diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index d1d1b30..fac36b5 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -10,7 +10,7 @@
  */
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <util/util.h>
 #include "../util/parse-options.h"
 #include "../builtin.h"
 #include "bench.h"
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index d9ab3ce..e7bb3d9 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -11,7 +11,7 @@
  */
 
 #include "../perf.h"
-#include "../util/util.h"
+#include <util/util.h>
 #include "../util/parse-options.h"
 #include "../builtin.h"
 #include "bench.h"
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index fcb9626..a083106 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -17,7 +17,7 @@
  */
 
 #include "perf.h"
-#include "util/util.h"
+#include <util/util.h>
 #include "util/parse-options.h"
 #include "builtin.h"
 #include "bench/bench.h"
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 921245b..0b65de4 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -1,8 +1,8 @@
 #ifndef BUILTIN_H
 #define BUILTIN_H
 
-#include "util/util.h"
-#include "util/strbuf.h"
+#include <util/util.h>
+#include <util/strbuf.h>
 
 extern const char perf_version_string[];
 extern const char perf_usage_string[];
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 6e48711..ee5c28d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -9,11 +9,11 @@
 #include "builtin.h"
 
 #include "util/exec_cmd.h"
-#include "util/cache.h"
+#include <util/cache.h>
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
-#include "util/debugfs.h"
+#include <util/debugfs.h>
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -29,8 +29,6 @@ struct pager_config {
 	int val;
 };
 
-static char debugfs_mntpt[MAXPATHLEN];
-
 static int pager_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
@@ -81,15 +79,6 @@ static void commit_pager_choice(void)
 	}
 }
 
-static void set_debugfs_path(void)
-{
-	char *path;
-
-	path = getenv(PERF_DEBUGFS_ENVIRONMENT);
-	snprintf(debugfs_path, MAXPATHLEN, "%s/%s", path ?: debugfs_mntpt,
-		 "tracing/events");
-}
-
 static int handle_options(const char ***argv, int *argc, int *envchanged)
 {
 	int handled = 0;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ef7aa0a..e235f6a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -1,6 +1,8 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
+#include <linux/compiler.h>
+
 struct winsize;
 
 void get_term_dimensions(struct winsize *ws);
diff --git a/tools/perf/util/abspath.c b/tools/perf/util/abspath.c
index 0e76aff..659125d 100644
--- a/tools/perf/util/abspath.c
+++ b/tools/perf/util/abspath.c
@@ -1,4 +1,4 @@
-#include "cache.h"
+#include <util/cache.h>
 
 static const char *get_pwd_cwd(void)
 {
diff --git a/tools/perf/util/alias.c b/tools/perf/util/alias.c
index b8144e8..1d13065 100644
--- a/tools/perf/util/alias.c
+++ b/tools/perf/util/alias.c
@@ -1,4 +1,5 @@
-#include "cache.h"
+#include <linux/compiler.h>
+#include <util/cache.h>
 
 static const char *alias_key;
 static char *alias_val;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 70c5cf8..d25de52 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2009, 2010 Red Hat Inc.
  * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
-#include "util.h"
+#include <util/util.h>
 #include <stdio.h>
 #include "build-id.h"
 #include "event.h"
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
deleted file mode 100644
index 65fe664..0000000
--- a/tools/perf/util/cache.h
+++ /dev/null
@@ -1,86 +0,0 @@
-#ifndef __PERF_CACHE_H
-#define __PERF_CACHE_H
-
-#include <stdbool.h>
-#include "util.h"
-#include "strbuf.h"
-#include "../perf.h"
-
-#define CMD_EXEC_PATH "--exec-path"
-#define CMD_PERF_DIR "--perf-dir="
-#define CMD_WORK_TREE "--work-tree="
-#define CMD_DEBUGFS_DIR "--debugfs-dir="
-
-#define PERF_DIR_ENVIRONMENT "PERF_DIR"
-#define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
-#define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
-#define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
-#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
-
-typedef int (*config_fn_t)(const char *, const char *, void *);
-extern int perf_default_config(const char *, const char *, void *);
-extern int perf_config(config_fn_t fn, void *);
-extern int perf_config_int(const char *, const char *);
-extern int perf_config_bool(const char *, const char *);
-extern int config_error_nonbool(const char *);
-
-/* pager.c */
-extern void setup_pager(void);
-extern const char *pager_program;
-extern int pager_in_use(void);
-extern int pager_use_color;
-
-extern int use_browser;
-
-#ifdef NO_NEWT_SUPPORT
-static inline void setup_browser(void)
-{
-	setup_pager();
-}
-static inline void exit_browser(bool wait_for_ok __used) {}
-#else
-void setup_browser(void);
-void exit_browser(bool wait_for_ok);
-#endif
-
-char *alias_lookup(const char *alias);
-int split_cmdline(char *cmdline, const char ***argv);
-
-#define alloc_nr(x) (((x)+16)*3/2)
-
-/*
- * Realloc the buffer pointed at by variable 'x' so that it can hold
- * at least 'nr' entries; the number of entries currently allocated
- * is 'alloc', using the standard growing factor alloc_nr() macro.
- *
- * DO NOT USE any expression with side-effect for 'x' or 'alloc'.
- */
-#define ALLOC_GROW(x, nr, alloc) \
-	do { \
-		if ((nr) > alloc) { \
-			if (alloc_nr(alloc) < (nr)) \
-				alloc = (nr); \
-			else \
-				alloc = alloc_nr(alloc); \
-			x = xrealloc((x), alloc * sizeof(*(x))); \
-		} \
-	} while(0)
-
-
-static inline int is_absolute_path(const char *path)
-{
-	return path[0] == '/';
-}
-
-const char *make_nonrelative_path(const char *path);
-char *strip_path_suffix(const char *path, const char *suffix);
-
-extern char *mkpath(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
-extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
-
-extern char *perf_pathdup(const char *fmt, ...)
-	__attribute__((format (printf, 1, 2)));
-
-extern size_t strlcpy(char *dest, const char *src, size_t size);
-
-#endif /* __PERF_CACHE_H */
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 62b69ad..73f8cf0 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -15,7 +15,7 @@
 #include <errno.h>
 #include <math.h>
 
-#include "util.h"
+#include <util/util.h>
 #include "callchain.h"
 
 bool ip_callchain__valid(struct ip_callchain *chain, event_t *event)
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index e191eb9..0e8edc4 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -1,4 +1,4 @@
-#include "cache.h"
+#include <util/cache.h>
 #include "color.h"
 
 int perf_use_color_default = -1;
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index dea082b..9ffab44 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -1,6 +1,8 @@
 #ifndef __PERF_COLOR_H
 #define __PERF_COLOR_H
 
+#include <stddef.h>
+
 /* "\033[1;38;5;2xx;48;5;2xxm\0" is 23 bytes */
 #define COLOR_MAXLEN 24
 
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index dabe892..d199791 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -5,8 +5,9 @@
  * Copyright (C) Johannes Schindelin, 2005
  *
  */
-#include "util.h"
-#include "cache.h"
+#include <util/util.h>
+#include <util/cache.h>
+#include <linux/compiler.h>
 #include "exec_cmd.h"
 
 #define MAXNAME (256)
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 4e01490..47335ce 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <util/util.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/ctype.c b/tools/perf/util/ctype.c
index 3507362..ec47e62 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/perf/util/ctype.c
@@ -3,7 +3,7 @@
  *
  * No surprises, and works with signed and unsigned chars.
  */
-#include "cache.h"
+#include <util/cache.h>
 
 enum {
 	S = GIT_SPACE,
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index dd824cf..b53e41c 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -6,11 +6,11 @@
 #include <stdarg.h>
 #include <stdio.h>
 
-#include "cache.h"
+#include <util/cache.h>
 #include "color.h"
 #include "event.h"
 #include "debug.h"
-#include "util.h"
+#include <util/util.h>
 
 int verbose = 0;
 bool dump_trace = false;
diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
deleted file mode 100644
index a88fefc..0000000
--- a/tools/perf/util/debugfs.c
+++ /dev/null
@@ -1,240 +0,0 @@
-#include "util.h"
-#include "debugfs.h"
-#include "cache.h"
-
-static int debugfs_premounted;
-static char debugfs_mountpoint[MAX_PATH+1];
-
-static const char *debugfs_known_mountpoints[] = {
-	"/sys/kernel/debug/",
-	"/debug/",
-	0,
-};
-
-/* use this to force a umount */
-void debugfs_force_cleanup(void)
-{
-	debugfs_find_mountpoint();
-	debugfs_premounted = 0;
-	debugfs_umount();
-}
-
-/* construct a full path to a debugfs element */
-int debugfs_make_path(const char *element, char *buffer, int size)
-{
-	int len;
-
-	if (strlen(debugfs_mountpoint) == 0) {
-		buffer[0] = '\0';
-		return -1;
-	}
-
-	len = strlen(debugfs_mountpoint) + strlen(element) + 1;
-	if (len >= size)
-		return len+1;
-
-	snprintf(buffer, size-1, "%s/%s", debugfs_mountpoint, element);
-	return 0;
-}
-
-static int debugfs_found;
-
-/* find the path to the mounted debugfs */
-const char *debugfs_find_mountpoint(void)
-{
-	const char **ptr;
-	char type[100];
-	FILE *fp;
-
-	if (debugfs_found)
-		return (const char *) debugfs_mountpoint;
-
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			debugfs_found = 1;
-			strcpy(debugfs_mountpoint, *ptr);
-			return debugfs_mountpoint;
-		}
-		ptr++;
-	}
-
-	/* give up and parse /proc/mounts */
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		die("Can't open /proc/mounts for read");
-
-	while (fscanf(fp, "%*s %"
-		      STR(MAX_PATH)
-		      "s %99s %*s %*d %*d\n",
-		      debugfs_mountpoint, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
-			break;
-	}
-	fclose(fp);
-
-	if (strcmp(type, "debugfs") != 0)
-		return NULL;
-
-	debugfs_found = 1;
-
-	return debugfs_mountpoint;
-}
-
-/* verify that a mountpoint is actually a debugfs instance */
-
-int debugfs_valid_mountpoint(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
-}
-
-
-int debugfs_valid_entry(const char *path)
-{
-	struct stat st;
-
-	if (stat(path, &st))
-		return -errno;
-
-	return 0;
-}
-
-/* mount the debugfs somewhere if it's not mounted */
-
-char *debugfs_mount(const char *mountpoint)
-{
-	/* see if it's already mounted */
-	if (debugfs_find_mountpoint()) {
-		debugfs_premounted = 1;
-		return debugfs_mountpoint;
-	}
-
-	/* if not mounted and no argument */
-	if (mountpoint == NULL) {
-		/* see if environment variable set */
-		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
-		/* if no environment variable, use default */
-		if (mountpoint == NULL)
-			mountpoint = "/sys/kernel/debug";
-	}
-
-	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
-		return NULL;
-
-	/* save the mountpoint */
-	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
-	debugfs_found = 1;
-
-	return debugfs_mountpoint;
-}
-
-/* umount the debugfs */
-
-int debugfs_umount(void)
-{
-	char umountcmd[128];
-	int ret;
-
-	/* if it was already mounted, leave it */
-	if (debugfs_premounted)
-		return 0;
-
-	/* make sure it's a valid mount point */
-	ret = debugfs_valid_mountpoint(debugfs_mountpoint);
-	if (ret)
-		return ret;
-
-	snprintf(umountcmd, sizeof(umountcmd),
-		 "/bin/umount %s", debugfs_mountpoint);
-	return system(umountcmd);
-}
-
-int debugfs_write(const char *entry, const char *value)
-{
-	char path[MAX_PATH+1];
-	int ret, count;
-	int fd;
-
-	/* construct the path */
-	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
-
-	/* verify that it exists */
-	ret = debugfs_valid_entry(path);
-	if (ret)
-		return ret;
-
-	/* get how many chars we're going to write */
-	count = strlen(value);
-
-	/* open the debugfs entry */
-	fd = open(path, O_RDWR);
-	if (fd < 0)
-		return -errno;
-
-	while (count > 0) {
-		/* write it */
-		ret = write(fd, value, count);
-		if (ret <= 0) {
-			if (ret == EAGAIN)
-				continue;
-			close(fd);
-			return -errno;
-		}
-		count -= ret;
-	}
-
-	/* close it */
-	close(fd);
-
-	/* return success */
-	return 0;
-}
-
-/*
- * read a debugfs entry
- * returns the number of chars read or a negative errno
- */
-int debugfs_read(const char *entry, char *buffer, size_t size)
-{
-	char path[MAX_PATH+1];
-	int ret;
-	int fd;
-
-	/* construct the path */
-	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
-
-	/* verify that it exists */
-	ret = debugfs_valid_entry(path);
-	if (ret)
-		return ret;
-
-	/* open the debugfs entry */
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return -errno;
-
-	do {
-		/* read it */
-		ret = read(fd, buffer, size);
-		if (ret == 0) {
-			close(fd);
-			return EOF;
-		}
-	} while (ret < 0 && errno == EAGAIN);
-
-	/* close it */
-	close(fd);
-
-	/* make *sure* there's a null character at the end */
-	buffer[ret] = '\0';
-
-	/* return the number of chars read */
-	return ret;
-}
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
deleted file mode 100644
index 83a0287..0000000
--- a/tools/perf/util/debugfs.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __DEBUGFS_H__
-#define __DEBUGFS_H__
-
-#include <sys/mount.h>
-
-#ifndef MAX_PATH
-# define MAX_PATH 256
-#endif
-
-#ifndef STR
-# define _STR(x) #x
-# define STR(x) _STR(x)
-#endif
-
-extern const char *debugfs_find_mountpoint(void);
-extern int debugfs_valid_mountpoint(const char *debugfs);
-extern int debugfs_valid_entry(const char *path);
-extern char *debugfs_mount(const char *mountpoint);
-extern int debugfs_umount(void);
-extern int debugfs_write(const char *entry, const char *value);
-extern int debugfs_read(const char *entry, char *buffer, size_t size);
-extern void debugfs_force_cleanup(void);
-extern int debugfs_make_path(const char *element, char *buffer, int size);
-
-#endif /* __DEBUGFS_H__ */
diff --git a/tools/perf/util/environment.c b/tools/perf/util/environment.c
index 275b0ee..3acdc7b 100644
--- a/tools/perf/util/environment.c
+++ b/tools/perf/util/environment.c
@@ -3,7 +3,7 @@
  * file, so that programs can link against the config parser
  * without having to link against all the rest of perf.
  */
-#include "cache.h"
+#include <util/cache.h>
 
 const char *pager_program;
 int pager_use_color = 1;
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 67eeff5..10f062c 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -1,4 +1,4 @@
-#include "cache.h"
+#include <util/cache.h>
 #include "exec_cmd.h"
 #include "quote.h"
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1f62435..cd4a00f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,7 +8,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 
-#include "util.h"
+#include <util/util.h>
 #include "header.h"
 #include "../perf.h"
 #include "trace-event.h"
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 402ac24..60325e2 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -4,7 +4,7 @@
 #include "../../../include/linux/perf_event.h"
 #include <sys/types.h>
 #include <stdbool.h>
-#include "types.h"
+#include <util/types.h>
 #include "event.h"
 
 #include <linux/bitmap.h>
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..cbe1c1c 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -1,8 +1,10 @@
-#include "cache.h"
+#include <util/cache.h>
+#include <linux/compiler.h>
 #include "../builtin.h"
 #include "exec_cmd.h"
 #include "levenshtein.h"
 #include "help.h"
+#include "../perf.h"
 
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cbf7eae..4352f43 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <util/util.h>
 #include "build-id.h"
 #include "hist.h"
 #include "session.h"
diff --git a/tools/perf/util/levenshtein.c b/tools/perf/util/levenshtein.c
index e521d15..68383fb 100644
--- a/tools/perf/util/levenshtein.c
+++ b/tools/perf/util/levenshtein.c
@@ -1,4 +1,4 @@
-#include "cache.h"
+#include <util/cache.h>
 #include "levenshtein.h"
 
 /*
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f391345..3082109 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -6,7 +6,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <stdbool.h>
-#include "types.h"
+#include <util/types.h>
 
 enum map_type {
 	MAP__FUNCTION = 0,
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index d54c540..e3cbe3b 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -15,7 +15,7 @@
 #include <newt.h>
 #include <sys/ttydefaults.h>
 
-#include "cache.h"
+#include <util/cache.h>
 #include "hist.h"
 #include "pstack.h"
 #include "session.h"
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 1915de2..2eab6a4 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -1,4 +1,4 @@
-#include "cache.h"
+#include <util/cache.h>
 #include "run-command.h"
 #include "sigchain.h"
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9bf0f40..3a22fa5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,14 +1,14 @@
 #include "../../../include/linux/hw_breakpoint.h"
-#include "util.h"
+#include <util/util.h>
 #include "../perf.h"
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
 #include "string.h"
 #include "symbol.h"
-#include "cache.h"
+#include <util/cache.h>
 #include "header.h"
-#include "debugfs.h"
+#include <util/debugfs.h>
 
 int				nr_counters;
 
@@ -28,7 +28,7 @@ enum event_result {
 	EVT_HANDLED_ALL
 };
 
-char debugfs_path[MAXPATHLEN];
+//char debugfs_path[MAXPATHLEN];
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index fc4ab3f..473c475 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -1,5 +1,8 @@
 #ifndef __PERF_PARSE_EVENTS_H
 #define __PERF_PARSE_EVENTS_H
+
+#include "header.h"
+
 /*
  * Parse symbolic events/counts passed in as options:
  */
@@ -30,7 +33,6 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 extern void print_events(void);
 
-extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
 
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 99d02aa..66e6af0 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -1,6 +1,7 @@
-#include "util.h"
+#include <util/util.h>
+#include <util/cache.h>
+#include <linux/compiler.h>
 #include "parse-options.h"
-#include "cache.h"
 
 #define OPT_SHORT 1
 #define OPT_UNSET 2
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index 58a470d..e452676 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -10,7 +10,7 @@
  *
  * which is what it's designed for.
  */
-#include "cache.h"
+#include <util/cache.h>
 
 static char bad_path[] = "/bad-path/";
 /*
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 914c670..9618d2a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -33,16 +33,16 @@
 #include <limits.h>
 
 #undef _GNU_SOURCE
-#include "util.h"
+#include <util/util.h>
 #include "event.h"
 #include "string.h"
 #include "strlist.h"
 #include "debug.h"
-#include "cache.h"
+#include <util/cache.h>
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
-#include "debugfs.h"
+#include <util/debugfs.h>
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d964cb1..6b1e981 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -36,7 +36,7 @@
 #include "string.h"
 #include "event.h"
 #include "debug.h"
-#include "util.h"
+#include <util/util.h>
 #include "probe-finder.h"
 
 /* Kprobe tracer basic type is up to u64 */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index e1f61dc..df19a72 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -2,7 +2,7 @@
 #define _PROBE_FINDER_H
 
 #include <stdbool.h>
-#include "util.h"
+#include <util/util.h>
 #include "probe-event.h"
 
 #define MAX_PATH_LEN		 256
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index 13d36fa..b735ebf 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -4,7 +4,7 @@
  * (c) 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
  */
 
-#include "util.h"
+#include <util/util.h>
 #include "pstack.h"
 #include <linux/kernel.h>
 #include <stdlib.h>
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index 01f0324..51df6c3 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -1,4 +1,4 @@
-#include "cache.h"
+#include <util/cache.h>
 #include "quote.h"
 
 /* Help to copy the thing properly quoted for the shell safety.
diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
index da8e9b2..a139174 100644
--- a/tools/perf/util/run-command.c
+++ b/tools/perf/util/run-command.c
@@ -1,4 +1,4 @@
-#include "cache.h"
+#include <util/cache.h>
 #include "run-command.h"
 #include "exec_cmd.h"
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b059dc5..d91b9e4 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -26,7 +26,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
-#include "../util.h"
+#include <util/util.h>
 #include "../trace-event.h"
 
 #include <EXTERN.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 81f39ca..78b2749 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -28,7 +28,7 @@
 #include <errno.h>
 
 #include "../../perf.h"
-#include "../util.h"
+#include <util/util.h>
 #include "../trace-event.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8f83a18..e21f759 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -9,7 +9,7 @@
 
 #include "session.h"
 #include "sort.h"
-#include "util.h"
+#include <util/util.h>
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
diff --git a/tools/perf/util/sigchain.c b/tools/perf/util/sigchain.c
index ba785e9..10ca4fb 100644
--- a/tools/perf/util/sigchain.c
+++ b/tools/perf/util/sigchain.c
@@ -1,5 +1,5 @@
 #include "sigchain.h"
-#include "cache.h"
+#include <util/cache.h>
 
 #define SIGCHAIN_MAX_SIGNALS 32
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0d61c40..41b2fc3 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -2,11 +2,11 @@
 #define __PERF_SORT_H
 #include "../builtin.h"
 
-#include "util.h"
+#include <util/util.h>
 
 #include "color.h"
 #include <linux/list.h>
-#include "cache.h"
+#include <util/cache.h>
 #include <linux/rbtree.h>
 #include "symbol.h"
 #include "string.h"
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
deleted file mode 100644
index 92e0685..0000000
--- a/tools/perf/util/strbuf.c
+++ /dev/null
@@ -1,133 +0,0 @@
-#include "cache.h"
-
-int prefixcmp(const char *str, const char *prefix)
-{
-	for (; ; str++, prefix++)
-		if (!*prefix)
-			return 0;
-		else if (*str != *prefix)
-			return (unsigned char)*prefix - (unsigned char)*str;
-}
-
-/*
- * Used as the default ->buf value, so that people can always assume
- * buf is non NULL and ->buf is NUL terminated even for a freshly
- * initialized strbuf.
- */
-char strbuf_slopbuf[1];
-
-void strbuf_init(struct strbuf *sb, ssize_t hint)
-{
-	sb->alloc = sb->len = 0;
-	sb->buf = strbuf_slopbuf;
-	if (hint)
-		strbuf_grow(sb, hint);
-}
-
-void strbuf_release(struct strbuf *sb)
-{
-	if (sb->alloc) {
-		free(sb->buf);
-		strbuf_init(sb, 0);
-	}
-}
-
-char *strbuf_detach(struct strbuf *sb, size_t *sz)
-{
-	char *res = sb->alloc ? sb->buf : NULL;
-	if (sz)
-		*sz = sb->len;
-	strbuf_init(sb, 0);
-	return res;
-}
-
-void strbuf_grow(struct strbuf *sb, size_t extra)
-{
-	if (sb->len + extra + 1 <= sb->len)
-		die("you want to use way too much memory");
-	if (!sb->alloc)
-		sb->buf = NULL;
-	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
-}
-
-static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
-				   const void *data, size_t dlen)
-{
-	if (pos + len < pos)
-		die("you want to use way too much memory");
-	if (pos > sb->len)
-		die("`pos' is too far after the end of the buffer");
-	if (pos + len > sb->len)
-		die("`pos + len' is too far after the end of the buffer");
-
-	if (dlen >= len)
-		strbuf_grow(sb, dlen - len);
-	memmove(sb->buf + pos + dlen,
-			sb->buf + pos + len,
-			sb->len - pos - len);
-	memcpy(sb->buf + pos, data, dlen);
-	strbuf_setlen(sb, sb->len + dlen - len);
-}
-
-void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
-{
-	strbuf_splice(sb, pos, len, NULL, 0);
-}
-
-void strbuf_add(struct strbuf *sb, const void *data, size_t len)
-{
-	strbuf_grow(sb, len);
-	memcpy(sb->buf + sb->len, data, len);
-	strbuf_setlen(sb, sb->len + len);
-}
-
-void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
-{
-	int len;
-	va_list ap;
-
-	if (!strbuf_avail(sb))
-		strbuf_grow(sb, 64);
-	va_start(ap, fmt);
-	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
-	va_end(ap);
-	if (len < 0)
-		die("your vsnprintf is broken");
-	if (len > strbuf_avail(sb)) {
-		strbuf_grow(sb, len);
-		va_start(ap, fmt);
-		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
-		va_end(ap);
-		if (len > strbuf_avail(sb)) {
-			die("this should not happen, your snprintf is broken");
-		}
-	}
-	strbuf_setlen(sb, sb->len + len);
-}
-
-ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
-{
-	size_t oldlen = sb->len;
-	size_t oldalloc = sb->alloc;
-
-	strbuf_grow(sb, hint ? hint : 8192);
-	for (;;) {
-		ssize_t cnt;
-
-		cnt = read(fd, sb->buf + sb->len, sb->alloc - sb->len - 1);
-		if (cnt < 0) {
-			if (oldalloc == 0)
-				strbuf_release(sb);
-			else
-				strbuf_setlen(sb, oldlen);
-			return -1;
-		}
-		if (!cnt)
-			break;
-		sb->len += cnt;
-		strbuf_grow(sb, 8192);
-	}
-
-	sb->buf[sb->len] = '\0';
-	return sb->len - oldlen;
-}
diff --git a/tools/perf/util/strbuf.h b/tools/perf/util/strbuf.h
deleted file mode 100644
index 436ac31..0000000
--- a/tools/perf/util/strbuf.h
+++ /dev/null
@@ -1,92 +0,0 @@
-#ifndef __PERF_STRBUF_H
-#define __PERF_STRBUF_H
-
-/*
- * Strbuf's can be use in many ways: as a byte array, or to store arbitrary
- * long, overflow safe strings.
- *
- * Strbufs has some invariants that are very important to keep in mind:
- *
- * 1. the ->buf member is always malloc-ed, hence strbuf's can be used to
- *    build complex strings/buffers whose final size isn't easily known.
- *
- *    It is NOT legal to copy the ->buf pointer away.
- *    `strbuf_detach' is the operation that detachs a buffer from its shell
- *    while keeping the shell valid wrt its invariants.
- *
- * 2. the ->buf member is a byte array that has at least ->len + 1 bytes
- *    allocated. The extra byte is used to store a '\0', allowing the ->buf
- *    member to be a valid C-string. Every strbuf function ensure this
- *    invariant is preserved.
- *
- *    Note that it is OK to "play" with the buffer directly if you work it
- *    that way:
- *
- *    strbuf_grow(sb, SOME_SIZE);
- *       ... Here, the memory array starting at sb->buf, and of length
- *       ... strbuf_avail(sb) is all yours, and you are sure that
- *       ... strbuf_avail(sb) is at least SOME_SIZE.
- *    strbuf_setlen(sb, sb->len + SOME_OTHER_SIZE);
- *
- *    Of course, SOME_OTHER_SIZE must be smaller or equal to strbuf_avail(sb).
- *
- *    Doing so is safe, though if it has to be done in many places, adding the
- *    missing API to the strbuf module is the way to go.
- *
- *    XXX: do _not_ assume that the area that is yours is of size ->alloc - 1
- *         even if it's true in the current implementation. Alloc is somehow a
- *         "private" member that should not be messed with.
- */
-
-#include <assert.h>
-
-extern char strbuf_slopbuf[];
-struct strbuf {
-	size_t alloc;
-	size_t len;
-	char *buf;
-};
-
-#define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
-
-/*----- strbuf life cycle -----*/
-extern void strbuf_init(struct strbuf *buf, ssize_t hint);
-extern void strbuf_release(struct strbuf *);
-extern char *strbuf_detach(struct strbuf *, size_t *);
-
-/*----- strbuf size related -----*/
-static inline ssize_t strbuf_avail(const struct strbuf *sb) {
-	return sb->alloc ? sb->alloc - sb->len - 1 : 0;
-}
-
-extern void strbuf_grow(struct strbuf *, size_t);
-
-static inline void strbuf_setlen(struct strbuf *sb, size_t len) {
-	if (!sb->alloc)
-		strbuf_grow(sb, 0);
-	assert(len < sb->alloc);
-	sb->len = len;
-	sb->buf[len] = '\0';
-}
-
-/*----- add data in your buffer -----*/
-static inline void strbuf_addch(struct strbuf *sb, int c) {
-	strbuf_grow(sb, 1);
-	sb->buf[sb->len++] = c;
-	sb->buf[sb->len] = '\0';
-}
-
-extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
-
-extern void strbuf_add(struct strbuf *, const void *, size_t);
-static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
-	strbuf_add(sb, s, strlen(s));
-}
-
-__attribute__((format(printf,2,3)))
-extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
-
-/* XXX: if read fails, any partial read is undone */
-extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
-
-#endif /* __PERF_STRBUF_H */
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 0409fc7..b5edba7 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <util/util.h>
 #include "string.h"
 
 #define K 1024LL
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index e078198..278a72d 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_SVGHELPER_H
 #define __PERF_SVGHELPER_H
 
-#include "types.h"
+#include <util/types.h>
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 1f7ecd4..ce885bc 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -4,7 +4,7 @@
 #include <string.h>
 #include "session.h"
 #include "thread.h"
-#include "util.h"
+#include <util/util.h>
 #include "debug.h"
 
 int find_all_tid(int pid, pid_t ** all_tid)
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index b157260..6bdf4a1 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -38,7 +38,7 @@
 
 #include "../perf.h"
 #include "trace-event.h"
-#include "debugfs.h"
+#include <util/debugfs.h>
 
 #define VERSION "0.5"
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 73a0222..dcecf73 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -30,7 +30,7 @@
 
 #undef _GNU_SOURCE
 #include "../perf.h"
-#include "util.h"
+#include <util/util.h>
 #include "trace-event.h"
 
 int header_page_ts_offset;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index f55cc3a..c5c62b1 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -37,7 +37,7 @@
 #include <errno.h>
 
 #include "../perf.h"
-#include "util.h"
+#include <util/util.h>
 #include "trace-event.h"
 
 static int input_fd;
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 7ea983a..d5eaffa 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -26,7 +26,7 @@
 #include <errno.h>
 
 #include "../perf.h"
-#include "util.h"
+#include <util/util.h>
 #include "trace-event.h"
 
 struct scripting_context *scripting_context;
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
deleted file mode 100644
index 7d6b833..0000000
--- a/tools/perf/util/types.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef __PERF_TYPES_H
-#define __PERF_TYPES_H
-
-/*
- * We define u64 as unsigned long long for every architecture
- * so that we can print it with %Lx without getting warnings.
- */
-typedef unsigned long long u64;
-typedef signed long long   s64;
-typedef unsigned int	   u32;
-typedef signed int	   s32;
-typedef unsigned short	   u16;
-typedef signed short	   s16;
-typedef unsigned char	   u8;
-typedef signed char	   s8;
-
-#endif /* __PERF_TYPES_H */
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index e16bf9a..7085b6f 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) Linus Torvalds, 2005
  */
-#include "util.h"
+#include <util/util.h>
 
 static void report(const char *prefix, const char *err, va_list params)
 {
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 2142656..8714309 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,4 +1,4 @@
-#include "util.h"
+#include <util/util.h>
 #include <sys/mman.h>
 
 int mkdir_p(char *path, mode_t mode)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
deleted file mode 100644
index 4e8b6b0..0000000
--- a/tools/perf/util/util.h
+++ /dev/null
@@ -1,282 +0,0 @@
-#ifndef GIT_COMPAT_UTIL_H
-#define GIT_COMPAT_UTIL_H
-
-#define _FILE_OFFSET_BITS 64
-
-#ifndef FLEX_ARRAY
-/*
- * See if our compiler is known to support flexible array members.
- */
-#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)
-# define FLEX_ARRAY /* empty */
-#elif defined(__GNUC__)
-# if (__GNUC__ >= 3)
-#  define FLEX_ARRAY /* empty */
-# else
-#  define FLEX_ARRAY 0 /* older GNU extension */
-# endif
-#endif
-
-/*
- * Otherwise, default to safer but a bit wasteful traditional style
- */
-#ifndef FLEX_ARRAY
-# define FLEX_ARRAY 1
-#endif
-#endif
-
-#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
-
-#ifdef __GNUC__
-#define TYPEOF(x) (__typeof__(x))
-#else
-#define TYPEOF(x)
-#endif
-
-#define MSB(x, bits) ((x) & TYPEOF(x)(~0ULL << (sizeof(x) * 8 - (bits))))
-#define HAS_MULTI_BITS(i)  ((i) & ((i) - 1))  /* checks if an integer has more than 1 bit set */
-
-/* Approximation of the length of the decimal representation of this type. */
-#define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
-
-#define _ALL_SOURCE 1
-#define _GNU_SOURCE 1
-#define _BSD_SOURCE 1
-#define HAS_BOOL
-
-#include <unistd.h>
-#include <stdio.h>
-#include <sys/stat.h>
-#include <sys/statfs.h>
-#include <fcntl.h>
-#include <stdbool.h>
-#include <stddef.h>
-#include <stdlib.h>
-#include <stdarg.h>
-#include <string.h>
-#include <errno.h>
-#include <limits.h>
-#include <sys/param.h>
-#include <sys/types.h>
-#include <dirent.h>
-#include <sys/time.h>
-#include <time.h>
-#include <signal.h>
-#include <fnmatch.h>
-#include <assert.h>
-#include <regex.h>
-#include <utime.h>
-#include <sys/wait.h>
-#include <sys/poll.h>
-#include <sys/socket.h>
-#include <sys/ioctl.h>
-#ifndef NO_SYS_SELECT_H
-#include <sys/select.h>
-#endif
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-#include <arpa/inet.h>
-#include <netdb.h>
-#include <pwd.h>
-#include <inttypes.h>
-#include "../../../include/linux/magic.h"
-#include "types.h"
-#include <sys/ttydefaults.h>
-
-#ifndef NO_ICONV
-#include <iconv.h>
-#endif
-
-extern const char *graph_line;
-extern const char *graph_dotted_line;
-
-/* On most systems <limits.h> would have given us this, but
- * not on some systems (e.g. GNU/Hurd).
- */
-#ifndef PATH_MAX
-#define PATH_MAX 4096
-#endif
-
-#ifndef PRIuMAX
-#define PRIuMAX "llu"
-#endif
-
-#ifndef PRIu32
-#define PRIu32 "u"
-#endif
-
-#ifndef PRIx32
-#define PRIx32 "x"
-#endif
-
-#ifndef PATH_SEP
-#define PATH_SEP ':'
-#endif
-
-#ifndef STRIP_EXTENSION
-#define STRIP_EXTENSION ""
-#endif
-
-#ifndef has_dos_drive_prefix
-#define has_dos_drive_prefix(path) 0
-#endif
-
-#ifndef is_dir_sep
-#define is_dir_sep(c) ((c) == '/')
-#endif
-
-#ifdef __GNUC__
-#define NORETURN __attribute__((__noreturn__))
-#else
-#define NORETURN
-#ifndef __attribute__
-#define __attribute__(x)
-#endif
-#endif
-
-/* General helper functions */
-extern void usage(const char *err) NORETURN;
-extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
-extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
-extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
-
-#include "../../../include/linux/stringify.h"
-
-#define DIE_IF(cnd)	\
-	do { if (cnd)	\
-		die(" at (" __FILE__ ":" __stringify(__LINE__) "): "	\
-		    __stringify(cnd) "\n");				\
-	} while (0)
-
-
-extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
-
-extern int prefixcmp(const char *str, const char *prefix);
-
-static inline const char *skip_prefix(const char *str, const char *prefix)
-{
-	size_t len = strlen(prefix);
-	return strncmp(str, prefix, len) ? NULL : str + len;
-}
-
-#ifdef __GLIBC_PREREQ
-#if __GLIBC_PREREQ(2, 1)
-#define HAVE_STRCHRNUL
-#endif
-#endif
-
-#ifndef HAVE_STRCHRNUL
-#define strchrnul gitstrchrnul
-static inline char *gitstrchrnul(const char *s, int c)
-{
-	while (*s && *s != c)
-		s++;
-	return (char *)s;
-}
-#endif
-
-/*
- * Wrappers:
- */
-extern char *xstrdup(const char *str);
-extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
-
-
-static inline void *zalloc(size_t size)
-{
-	return calloc(1, size);
-}
-
-static inline int has_extension(const char *filename, const char *ext)
-{
-	size_t len = strlen(filename);
-	size_t extlen = strlen(ext);
-
-	return len > extlen && !memcmp(filename + len - extlen, ext, extlen);
-}
-
-/* Sane ctype - no locale, and works with signed chars */
-#undef isascii
-#undef isspace
-#undef isdigit
-#undef isxdigit
-#undef isalpha
-#undef isprint
-#undef isalnum
-#undef tolower
-#undef toupper
-
-extern unsigned char sane_ctype[256];
-#define GIT_SPACE		0x01
-#define GIT_DIGIT		0x02
-#define GIT_ALPHA		0x04
-#define GIT_GLOB_SPECIAL	0x08
-#define GIT_REGEX_SPECIAL	0x10
-#define GIT_PRINT_EXTRA		0x20
-#define GIT_PRINT		0x3E
-#define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
-#define isascii(x) (((x) & ~0x7f) == 0)
-#define isspace(x) sane_istest(x,GIT_SPACE)
-#define isdigit(x) sane_istest(x,GIT_DIGIT)
-#define isxdigit(x)	\
-	(sane_istest(toupper(x), GIT_ALPHA | GIT_DIGIT) && toupper(x) < 'G')
-#define isalpha(x) sane_istest(x,GIT_ALPHA)
-#define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
-#define isprint(x) sane_istest(x,GIT_PRINT)
-#define tolower(x) sane_case((unsigned char)(x), 0x20)
-#define toupper(x) sane_case((unsigned char)(x), 0)
-
-static inline int sane_case(int x, int high)
-{
-	if (sane_istest(x, GIT_ALPHA))
-		x = (x & ~0x20) | high;
-	return x;
-}
-
-#ifndef DIR_HAS_BSD_GROUP_SEMANTICS
-# define FORCE_DIR_SET_GID S_ISGID
-#else
-# define FORCE_DIR_SET_GID 0
-#endif
-
-#ifdef NO_NSEC
-#undef USE_NSEC
-#define ST_CTIME_NSEC(st) 0
-#define ST_MTIME_NSEC(st) 0
-#else
-#ifdef USE_ST_TIMESPEC
-#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctimespec.tv_nsec))
-#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtimespec.tv_nsec))
-#else
-#define ST_CTIME_NSEC(st) ((unsigned int)((st).st_ctim.tv_nsec))
-#define ST_MTIME_NSEC(st) ((unsigned int)((st).st_mtim.tv_nsec))
-#endif
-#endif
-
-int mkdir_p(char *path, mode_t mode);
-int copyfile(const char *from, const char *to);
-
-s64 perf_atoll(const char *str);
-char **argv_split(const char *str, int *argcp);
-void argv_free(char **argv);
-bool strglobmatch(const char *str, const char *pat);
-bool strlazymatch(const char *str, const char *pat);
-unsigned long convert_unit(unsigned long value, char *unit);
-
-#ifndef ESC
-#define ESC 27
-#endif
-
-static inline bool is_exit_key(int key)
-{
-	char up;
-	if (key == CTRL('c') || key == ESC)
-		return true;
-	up = toupper(key);
-	return up == 'Q';
-}
-
-#define _STR(x) #x
-#define STR(x) _STR(x)
-
-#endif
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index cfa55d6..e25c4b4 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -1,6 +1,6 @@
 #include <stdlib.h>
 
-#include "util.h"
+#include <util/util.h>
 #include "values.h"
 
 void perf_read_values_init(struct perf_read_values *values)
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
index 2fa967e..012bc12 100644
--- a/tools/perf/util/values.h
+++ b/tools/perf/util/values.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_VALUES_H
 #define __PERF_VALUES_H
 
-#include "types.h"
+#include <util/types.h>
 
 struct perf_read_values {
 	int threads;
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index 73e900e..3addc76 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -1,7 +1,8 @@
 /*
  * Various trivial helper wrappers around standard functions
  */
-#include "cache.h"
+#include <linux/compiler.h>
+#include <util/cache.h>
 
 /*
  * There's no pack memory to release - but stay close to the Git
-- 
1.6.4.4


-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
