Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0KDPjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:39:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41942 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0KDPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:13 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/20] perf: Move trace stuff into tools/lib/trace
Date: Thu,  4 Nov 2010 16:36:42 +0100
Message-Id: <1288885016-18295-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move tracing stuff into tools/lib/trace and rewire it back into perf.
Add a top-level Makefile which selects between targets depending
on the tool we want to build.

Also, add a Makefile.lib for common facilities used by all the
Makefiles. While at it, make sure objects output directory using O=
exists.

Finally, rename trace/util.h to trace/trace-util.h so as not to conflict
with perf's util.h.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile                 |   47 +
 tools/lib/Makefile             |   49 -
 tools/lib/parse-events.c       | 4655 ----------------------------------------
 tools/lib/parse-events.h       |  719 -------
 tools/lib/parse-filter.c       | 2085 ------------------
 tools/lib/parse-utils.c        |  110 -
 tools/lib/trace-seq.c          |  153 --
 tools/lib/trace/Makefile       |   54 +
 tools/lib/trace/parse-events.c | 4655 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/trace/parse-events.h |  719 +++++++
 tools/lib/trace/parse-filter.c | 2085 ++++++++++++++++++
 tools/lib/trace/parse-utils.c  |  110 +
 tools/lib/trace/trace-seq.c    |  153 ++
 tools/lib/trace/trace-util.h   |   64 +
 tools/lib/util.h               |   64 -
 tools/perf/Makefile            |   41 +-
 tools/perf/util/trace-event.h  |    2 +-
 tools/scripts/Makefile.lib     |   33 +
 18 files changed, 7923 insertions(+), 7875 deletions(-)
 create mode 100644 tools/Makefile
 delete mode 100644 tools/lib/Makefile
 delete mode 100644 tools/lib/parse-events.c
 delete mode 100644 tools/lib/parse-events.h
 delete mode 100644 tools/lib/parse-filter.c
 delete mode 100644 tools/lib/parse-utils.c
 delete mode 100644 tools/lib/trace-seq.c
 create mode 100644 tools/lib/trace/Makefile
 create mode 100644 tools/lib/trace/parse-events.c
 create mode 100644 tools/lib/trace/parse-events.h
 create mode 100644 tools/lib/trace/parse-filter.c
 create mode 100644 tools/lib/trace/parse-utils.c
 create mode 100644 tools/lib/trace/trace-seq.c
 create mode 100644 tools/lib/trace/trace-util.h
 delete mode 100644 tools/lib/util.h
 create mode 100644 tools/scripts/Makefile.lib

diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 0000000..430b25e
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,47 @@
+include scripts/Makefile.lib
+
+# Include saner warnings here, which can catch bugs:
+#
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
+# lib includes for submake
+BASIC_CFLAGS = -I$(CURDIR)/lib/trace -I$(CURDIR)/perf -I$(CURDIR)/perf/util/include
+export BASIC_CFLAGS
+
+PERF_TOP_DIR := $(CURDIR)
+export PERF_TOP_DIR
+
+perf: libparsevent .FORCE
+	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
+
+libparsevent: .FORCE
+	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1)
+
+clean:
+	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
+
+.PHONY: clean .FORCE
diff --git a/tools/lib/Makefile b/tools/lib/Makefile
deleted file mode 100644
index 206078b..0000000
--- a/tools/lib/Makefile
+++ /dev/null
@@ -1,49 +0,0 @@
-
-# Make the path relative to DESTDIR, not to prefix
-ifndef DESTDIR
-prefix = $(HOME)
-endif
-bindir_relative = bin
-bindir = $(prefix)/$(bindir_relative)
-mandir = share/man
-infodir = share/info
-sharedir = $(prefix)/share
-ifeq ($(prefix),/usr)
-sysconfdir = /etc
-else
-sysconfdir = $(prefix)/etc
-endif
-
-export prefix bindir sharedir sysconfdir
-
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
-RM = rm -f
-TAR = tar
-FIND = find
-INSTALL = install
-RPMBUILD = rpmbuild
-PTHREAD_LIBS = -lpthread
-
-ifeq ("$(origin V)", "command line")
-  VERBOSE = $(V)
-endif
-ifndef VERBOSE
-  VERBOSE = 0
-endif
-
-all: libparsevent.a
-
-PEVENT_LIB_OBJS += parse-events.o
-PEVENT_LIB_OBJS += parse-filter.o
-PEVENT_LIB_OBJS += parse-utils.o
-PEVENT_LIB_OBJS += trace-seq.o
-
-$(OUTPUT)%.o: %.c
-	$(QUIET_CC)$(CC) -g -o $@ -c $(ALL_CFLAGS) $<
-
-libparsevent.a: $(PEVENT_LIB_OBJS)
-	$(RM) $@;  $(AR) rcs $@ $^
-
-clean:
-	$(RM) *.a *.o *~ *.so
\ No newline at end of file
diff --git a/tools/lib/parse-events.c b/tools/lib/parse-events.c
deleted file mode 100644
index 5503a18..0000000
--- a/tools/lib/parse-events.c
+++ /dev/null
@@ -1,4655 +0,0 @@
-/*
- * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- *  The parts for function graph printing was taken and modified from the
- *  Linux Kernel that were written by
- *    - Copyright (C) 2009  Frederic Weisbecker,
- *  Frederic Weisbecker gave his permission to relicense the code to
- *  the Lesser General Public License.
- */
-#define _GNU_SOURCE
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdarg.h>
-#include <ctype.h>
-#include <errno.h>
-
-#include "parse-events.h"
-
-static const char *input_buf;
-static unsigned long long input_buf_ptr;
-static unsigned long long input_buf_siz;
-
-static int show_warning = 1;
-
-#define do_warning(fmt, ...)				\
-	do {						\
-		if (show_warning)			\
-			warning(fmt, ##__VA_ARGS__);	\
-	} while (0)
-
-static void init_input_buf(const char *buf, unsigned long long size)
-{
-	input_buf = buf;
-	input_buf_siz = size;
-	input_buf_ptr = 0;
-}
-
-struct event_handler {
-	struct event_handler		*next;
-	int				id;
-	const char			*sys_name;
-	const char			*event_name;
-	pevent_event_handler_func	func;
-	void				*context;
-};
-
-struct pevent_func_params {
-	struct pevent_func_params	*next;
-	enum pevent_func_arg_type	type;
-};
-
-struct pevent_function_handler {
-	struct pevent_function_handler	*next;
-	enum pevent_func_arg_type	ret_type;
-	char				*name;
-	pevent_func_handler		func;
-	struct pevent_func_params	*params;
-	int				nr_args;
-};
-
-static unsigned long long
-process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct event_format *event, struct print_arg *arg);
-
-static void free_func_handle(struct pevent_function_handler *func);
-
-/**
- * pevent_buffer_init - init buffer for parsing
- * @buf: buffer to parse
- * @size: the size of the buffer
- *
- * For use with pevent_read_token(), this initializes the internal
- * buffer that pevent_read_token() will parse.
- */
-void pevent_buffer_init(const char *buf, unsigned long long size)
-{
-	init_input_buf(buf, size);
-}
-
-void breakpoint(void)
-{
-	static int x;
-	x++;
-}
-
-struct print_arg *alloc_arg(void)
-{
-	struct print_arg *arg;
-
-	arg = malloc_or_die(sizeof(*arg));
-	if (!arg)
-		return NULL;
-	memset(arg, 0, sizeof(*arg));
-
-	return arg;
-}
-
-struct cmdline {
-	char *comm;
-	int pid;
-};
-
-static int cmdline_cmp(const void *a, const void *b)
-{
-	const struct cmdline *ca = a;
-	const struct cmdline *cb = b;
-
-	if (ca->pid < cb->pid)
-		return -1;
-	if (ca->pid > cb->pid)
-		return 1;
-
-	return 0;
-}
-
-struct cmdline_list {
-	struct cmdline_list	*next;
-	char			*comm;
-	int			pid;
-};
-
-static int cmdline_init(struct pevent *pevent)
-{
-	struct cmdline_list *cmdlist = pevent->cmdlist;
-	struct cmdline_list *item;
-	struct cmdline *cmdlines;
-	int i;
-
-	cmdlines = malloc_or_die(sizeof(*cmdlines) * pevent->cmdline_count);
-
-	i = 0;
-	while (cmdlist) {
-		cmdlines[i].pid = cmdlist->pid;
-		cmdlines[i].comm = cmdlist->comm;
-		i++;
-		item = cmdlist;
-		cmdlist = cmdlist->next;
-		free(item);
-	}
-
-	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-
-	pevent->cmdlines = cmdlines;
-	pevent->cmdlist = NULL;
-
-	return 0;
-}
-
-static char *find_cmdline(struct pevent *pevent, int pid)
-{
-	const struct cmdline *comm;
-	struct cmdline key;
-
-	if (!pid)
-		return "<idle>";
-
-	if (!pevent->cmdlines)
-		cmdline_init(pevent);
-
-	key.pid = pid;
-
-	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
-		       sizeof(*pevent->cmdlines), cmdline_cmp);
-
-	if (comm)
-		return comm->comm;
-	return "<...>";
-}
-
-/**
- * pevent_pid_is_registered - return if a pid has a cmdline registered
- * @pevent: handle for the pevent
- * @pid: The pid to check if it has a cmdline registered with.
- *
- * Returns 1 if the pid has a cmdline mapped to it
- * 0 otherwise.
- */
-int pevent_pid_is_registered(struct pevent *pevent, int pid)
-{
-	const struct cmdline *comm;
-	struct cmdline key;
-
-	if (!pid)
-		return 1;
-
-	if (!pevent->cmdlines)
-		cmdline_init(pevent);
-
-	key.pid = pid;
-
-	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
-		       sizeof(*pevent->cmdlines), cmdline_cmp);
-
-	if (comm)
-		return 1;
-	return 0;
-}
-
-/*
- * If the command lines have been converted to an array, then
- * we must add this pid. This is much slower than when cmdlines
- * are added before the array is initialized.
- */
-static int add_new_comm(struct pevent *pevent, char *comm, int pid)
-{
-	struct cmdline *cmdlines = pevent->cmdlines;
-	const struct cmdline *cmdline;
-	struct cmdline key;
-
-	if (!pid)
-		return 0;
-
-	/* avoid duplicates */
-	key.pid = pid;
-
-	cmdline = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
-		       sizeof(*pevent->cmdlines), cmdline_cmp);
-	if (cmdline) {
-		errno = EEXIST;
-		return -1;
-	}
-
-	cmdlines = realloc(cmdlines, sizeof(*cmdlines) * (pevent->cmdline_count + 1));
-	if (!cmdlines) {
-		errno = ENOMEM;
-		return -1;
-	}
-
-	cmdlines[pevent->cmdline_count].pid = pid;
-	cmdlines[pevent->cmdline_count].comm = comm;
-	pevent->cmdline_count++;
-
-	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-	pevent->cmdlines = cmdlines;
-
-	return 0;
-}
-
-/**
- * pevent_register_comm - register a pid / comm mapping
- * @pevent: handle for the pevent
- * @comm: the command line to register
- * @pid: the pid to map the command line to
- *
- * This adds a mapping to search for command line names with
- * a given pid. The comm is duplicated.
- */
-int pevent_register_comm(struct pevent *pevent, char *comm, int pid)
-{
-	struct cmdline_list *item;
-
-	if (pevent->cmdlines)
-		return add_new_comm(pevent, comm, pid);
-
-	item = malloc_or_die(sizeof(*item));
-	item->comm = strdup(comm);
-	item->pid = pid;
-	item->next = pevent->cmdlist;
-
-	pevent->cmdlist = item;
-	pevent->cmdline_count++;
-
-	return 0;
-}
-
-struct func_map {
-	unsigned long long		addr;
-	char				*func;
-	char				*mod;
-};
-
-struct func_list {
-	struct func_list	*next;
-	unsigned long long	addr;
-	char			*func;
-	char			*mod;
-};
-
-static int func_cmp(const void *a, const void *b)
-{
-	const struct func_map *fa = a;
-	const struct func_map *fb = b;
-
-	if (fa->addr < fb->addr)
-		return -1;
-	if (fa->addr > fb->addr)
-		return 1;
-
-	return 0;
-}
-
-/*
- * We are searching for a record in between, not an exact
- * match.
- */
-static int func_bcmp(const void *a, const void *b)
-{
-	const struct func_map *fa = a;
-	const struct func_map *fb = b;
-
-	if ((fa->addr == fb->addr) ||
-
-	    (fa->addr > fb->addr &&
-	     fa->addr < (fb+1)->addr))
-		return 0;
-
-	if (fa->addr < fb->addr)
-		return -1;
-
-	return 1;
-}
-
-static int func_map_init(struct pevent *pevent)
-{
-	struct func_list *funclist;
-	struct func_list *item;
-	struct func_map *func_map;
-	int i;
-
-	func_map = malloc_or_die(sizeof(*func_map) * (pevent->func_count + 1));
-	funclist = pevent->funclist;
-
-	i = 0;
-	while (funclist) {
-		func_map[i].func = funclist->func;
-		func_map[i].addr = funclist->addr;
-		func_map[i].mod = funclist->mod;
-		i++;
-		item = funclist;
-		funclist = funclist->next;
-		free(item);
-	}
-
-	qsort(func_map, pevent->func_count, sizeof(*func_map), func_cmp);
-
-	/*
-	 * Add a special record at the end.
-	 */
-	func_map[pevent->func_count].func = NULL;
-	func_map[pevent->func_count].addr = 0;
-	func_map[pevent->func_count].mod = NULL;
-
-	pevent->func_map = func_map;
-	pevent->funclist = NULL;
-
-	return 0;
-}
-
-static struct func_map *
-find_func(struct pevent *pevent, unsigned long long addr)
-{
-	struct func_map *func;
-	struct func_map key;
-
-	if (!pevent->func_map)
-		func_map_init(pevent);
-
-	key.addr = addr;
-
-	func = bsearch(&key, pevent->func_map, pevent->func_count,
-		       sizeof(*pevent->func_map), func_bcmp);
-
-	return func;
-}
-
-/**
- * pevent_find_function - find a function by a given address
- * @pevent: handle for the pevent
- * @addr: the address to find the function with
- *
- * Returns a pointer to the function stored that has the given
- * address. Note, the address does not have to be exact, it
- * will select the function that would contain the address.
- */
-const char *pevent_find_function(struct pevent *pevent, unsigned long long addr)
-{
-	struct func_map *map;
-
-	map = find_func(pevent, addr);
-	if (!map)
-		return NULL;
-
-	return map->func;
-}
-
-/**
- * pevent_find_function_address - find a function address by a given address
- * @pevent: handle for the pevent
- * @addr: the address to find the function with
- *
- * Returns the address the function starts at. This can be used in
- * conjunction with pevent_find_function to print both the function
- * name and the function offset.
- */
-unsigned long long
-pevent_find_function_address(struct pevent *pevent, unsigned long long addr)
-{
-	struct func_map *map;
-
-	map = find_func(pevent, addr);
-	if (!map)
-		return 0;
-
-	return map->addr;
-}
-
-/**
- * pevent_register_function - register a function with a given address
- * @pevent: handle for the pevent
- * @function: the function name to register
- * @addr: the address the function starts at
- * @mod: the kernel module the function may be in (NULL for none)
- *
- * This registers a function name with an address and module.
- * The @func passed in is duplicated.
- */
-int pevent_register_function(struct pevent *pevent, char *func,
-			     unsigned long long addr, char *mod)
-{
-	struct func_list *item;
-
-	item = malloc_or_die(sizeof(*item));
-
-	item->next = pevent->funclist;
-	item->func = strdup(func);
-	if (mod)
-		item->mod = strdup(mod);
-	else
-		item->mod = NULL;
-	item->addr = addr;
-
-	pevent->funclist = item;
-
-	pevent->func_count++;
-
-	return 0;
-}
-
-/**
- * pevent_print_funcs - print out the stored functions
- * @pevent: handle for the pevent
- *
- * This prints out the stored functions.
- */
-void pevent_print_funcs(struct pevent *pevent)
-{
-	int i;
-
-	if (!pevent->func_map)
-		func_map_init(pevent);
-
-	for (i = 0; i < (int)pevent->func_count; i++) {
-		printf("%016llx %s",
-		       pevent->func_map[i].addr,
-		       pevent->func_map[i].func);
-		if (pevent->func_map[i].mod)
-			printf(" [%s]\n", pevent->func_map[i].mod);
-		else
-			printf("\n");
-	}
-}
-
-struct printk_map {
-	unsigned long long		addr;
-	char				*printk;
-};
-
-struct printk_list {
-	struct printk_list	*next;
-	unsigned long long	addr;
-	char			*printk;
-};
-
-static int printk_cmp(const void *a, const void *b)
-{
-	const struct func_map *fa = a;
-	const struct func_map *fb = b;
-
-	if (fa->addr < fb->addr)
-		return -1;
-	if (fa->addr > fb->addr)
-		return 1;
-
-	return 0;
-}
-
-static void printk_map_init(struct pevent *pevent)
-{
-	struct printk_list *printklist;
-	struct printk_list *item;
-	struct printk_map *printk_map;
-	int i;
-
-	printk_map = malloc_or_die(sizeof(*printk_map) * (pevent->printk_count + 1));
-
-	printklist = pevent->printklist;
-
-	i = 0;
-	while (printklist) {
-		printk_map[i].printk = printklist->printk;
-		printk_map[i].addr = printklist->addr;
-		i++;
-		item = printklist;
-		printklist = printklist->next;
-		free(item);
-	}
-
-	qsort(printk_map, pevent->printk_count, sizeof(*printk_map), printk_cmp);
-
-	pevent->printk_map = printk_map;
-	pevent->printklist = NULL;
-}
-
-static struct printk_map *
-find_printk(struct pevent *pevent, unsigned long long addr)
-{
-	struct printk_map *printk;
-	struct printk_map key;
-
-	if (!pevent->printk_map)
-		printk_map_init(pevent);
-
-	key.addr = addr;
-
-	printk = bsearch(&key, pevent->printk_map, pevent->printk_count,
-			 sizeof(*pevent->printk_map), printk_cmp);
-
-	return printk;
-}
-
-/**
- * pevent_register_print_string - register a string by its address
- * @pevent: handle for the pevent
- * @fmt: the string format to register
- * @addr: the address the string was located at
- *
- * This registers a string by the address it was stored in the kernel.
- * The @fmt passed in is duplicated.
- */
-int pevent_register_print_string(struct pevent *pevent, char *fmt,
-				 unsigned long long addr)
-{
-	struct printk_list *item;
-
-	item = malloc_or_die(sizeof(*item));
-
-	item->next = pevent->printklist;
-	pevent->printklist = item;
-	item->printk = strdup(fmt);
-	item->addr = addr;
-
-	pevent->printk_count++;
-
-	return 0;
-}
-
-/**
- * pevent_print_printk - print out the stored strings
- * @pevent: handle for the pevent
- *
- * This prints the string formats that were stored.
- */
-void pevent_print_printk(struct pevent *pevent)
-{
-	int i;
-
-	if (!pevent->printk_map)
-		printk_map_init(pevent);
-
-	for (i = 0; i < (int)pevent->printk_count; i++) {
-		printf("%016llx %s\n",
-		       pevent->printk_map[i].addr,
-		       pevent->printk_map[i].printk);
-	}
-}
-
-static struct event_format *alloc_event(void)
-{
-	struct event_format *event;
-
-	event = malloc_or_die(sizeof(*event));
-	memset(event, 0, sizeof(*event));
-
-	return event;
-}
-
-static void add_event(struct pevent *pevent, struct event_format *event)
-{
-	int i;
-
-	if (!pevent->events)
-		pevent->events = malloc_or_die(sizeof(event));
-	else
-		pevent->events =
-			realloc(pevent->events, sizeof(event) *
-				(pevent->nr_events + 1));
-	if (!pevent->events)
-		die("Can not allocate events");
-
-	for (i = 0; i < pevent->nr_events; i++) {
-		if (pevent->events[i]->id > event->id)
-			break;
-	}
-	if (i < pevent->nr_events)
-		memmove(&pevent->events[i + 1],
-			&pevent->events[i],
-			sizeof(event) * (pevent->nr_events - i));
-
-	pevent->events[i] = event;
-	pevent->nr_events++;
-
-	event->pevent = pevent;
-}
-
-static int event_item_type(enum event_type type)
-{
-	switch (type) {
-	case EVENT_ITEM ... EVENT_SQUOTE:
-		return 1;
-	case EVENT_ERROR ... EVENT_DELIM:
-	default:
-		return 0;
-	}
-}
-
-static void free_flag_sym(struct print_flag_sym *fsym)
-{
-	struct print_flag_sym *next;
-
-	while (fsym) {
-		next = fsym->next;
-		free(fsym->value);
-		free(fsym->str);
-		free(fsym);
-		fsym = next;
-	}
-}
-
-static void free_arg(struct print_arg *arg)
-{
-	struct print_arg *farg;
-
-	if (!arg)
-		return;
-
-	switch (arg->type) {
-	case PRINT_ATOM:
-		free(arg->atom.atom);
-		break;
-	case PRINT_FIELD:
-		free(arg->field.name);
-		break;
-	case PRINT_FLAGS:
-		free_arg(arg->flags.field);
-		free(arg->flags.delim);
-		free_flag_sym(arg->flags.flags);
-		break;
-	case PRINT_SYMBOL:
-		free_arg(arg->symbol.field);
-		free_flag_sym(arg->symbol.symbols);
-		break;
-	case PRINT_TYPE:
-		free(arg->typecast.type);
-		free_arg(arg->typecast.item);
-		break;
-	case PRINT_STRING:
-		free(arg->string.string);
-		break;
-	case PRINT_DYNAMIC_ARRAY:
-		free(arg->dynarray.index);
-		break;
-	case PRINT_OP:
-		free(arg->op.op);
-		free_arg(arg->op.left);
-		free_arg(arg->op.right);
-		break;
-	case PRINT_FUNC:
-		while (arg->func.args) {
-			farg = arg->func.args;
-			arg->func.args = farg->next;
-			free_arg(farg);
-		}
-		break;
-
-	case PRINT_NULL:
-	default:
-		break;
-	}
-
-	free(arg);
-}
-
-static enum event_type get_type(int ch)
-{
-	if (ch == '\n')
-		return EVENT_NEWLINE;
-	if (isspace(ch))
-		return EVENT_SPACE;
-	if (isalnum(ch) || ch == '_')
-		return EVENT_ITEM;
-	if (ch == '\'')
-		return EVENT_SQUOTE;
-	if (ch == '"')
-		return EVENT_DQUOTE;
-	if (!isprint(ch))
-		return EVENT_NONE;
-	if (ch == '(' || ch == ')' || ch == ',')
-		return EVENT_DELIM;
-
-	return EVENT_OP;
-}
-
-static int __read_char(void)
-{
-	if (input_buf_ptr >= input_buf_siz)
-		return -1;
-
-	return input_buf[input_buf_ptr++];
-}
-
-static int __peek_char(void)
-{
-	if (input_buf_ptr >= input_buf_siz)
-		return -1;
-
-	return input_buf[input_buf_ptr];
-}
-
-/**
- * pevent_peek_char - peek at the next character that will be read
- *
- * Returns the next character read, or -1 if end of buffer.
- */
-int pevent_peek_char(void)
-{
-	return __peek_char();
-}
-
-static enum event_type force_token(const char *str, char **tok);
-
-static enum event_type __read_token(char **tok)
-{
-	char buf[BUFSIZ];
-	int ch, last_ch, quote_ch, next_ch;
-	int i = 0;
-	int tok_size = 0;
-	enum event_type type;
-
-	*tok = NULL;
-
-
-	ch = __read_char();
-	if (ch < 0)
-		return EVENT_NONE;
-
-	type = get_type(ch);
-	if (type == EVENT_NONE)
-		return type;
-
-	buf[i++] = ch;
-
-	switch (type) {
-	case EVENT_NEWLINE:
-	case EVENT_DELIM:
-		*tok = malloc_or_die(2);
-		(*tok)[0] = ch;
-		(*tok)[1] = 0;
-		return type;
-
-	case EVENT_OP:
-		switch (ch) {
-		case '-':
-			next_ch = __peek_char();
-			if (next_ch == '>') {
-				buf[i++] = __read_char();
-				break;
-			}
-			/* fall through */
-		case '+':
-		case '|':
-		case '&':
-		case '>':
-		case '<':
-			last_ch = ch;
-			ch = __peek_char();
-			if (ch != last_ch)
-				goto test_equal;
-			buf[i++] = __read_char();
-			switch (last_ch) {
-			case '>':
-			case '<':
-				goto test_equal;
-			default:
-				break;
-			}
-			break;
-		case '!':
-		case '=':
-			goto test_equal;
-		default: /* what should we do instead? */
-			break;
-		}
-		buf[i] = 0;
-		*tok = strdup(buf);
-		return type;
-
- test_equal:
-		ch = __peek_char();
-		if (ch == '=')
-			buf[i++] = __read_char();
-		goto out;
-
-	case EVENT_DQUOTE:
-	case EVENT_SQUOTE:
-		/* don't keep quotes */
-		i--;
-		quote_ch = ch;
-		last_ch = 0;
-		do {
-			if (i == (BUFSIZ - 1)) {
-				buf[i] = 0;
-				if (*tok) {
-					*tok = realloc(*tok, tok_size + BUFSIZ);
-					if (!*tok)
-						return EVENT_NONE;
-					strcat(*tok, buf);
-				} else
-					*tok = strdup(buf);
-
-				if (!*tok)
-					return EVENT_NONE;
-				tok_size += BUFSIZ;
-				i = 0;
-			}
-			last_ch = ch;
-			ch = __read_char();
-			buf[i++] = ch;
-			/* the '\' '\' will cancel itself */
-			if (ch == '\\' && last_ch == '\\')
-				last_ch = 0;
-		} while (ch != quote_ch || last_ch == '\\');
-		/* remove the last quote */
-		i--;
-		goto out;
-
-	case EVENT_ERROR ... EVENT_SPACE:
-	case EVENT_ITEM:
-	default:
-		break;
-	}
-
-	while (get_type(__peek_char()) == type) {
-		if (i == (BUFSIZ - 1)) {
-			buf[i] = 0;
-			if (*tok) {
-				*tok = realloc(*tok, tok_size + BUFSIZ);
-				if (!*tok)
-					return EVENT_NONE;
-				strcat(*tok, buf);
-			} else
-				*tok = strdup(buf);
-
-			if (!*tok)
-				return EVENT_NONE;
-			tok_size += BUFSIZ;
-			i = 0;
-		}
-		ch = __read_char();
-		buf[i++] = ch;
-	}
-
- out:
-	buf[i] = 0;
-	if (*tok) {
-		*tok = realloc(*tok, tok_size + i);
-		if (!*tok)
-			return EVENT_NONE;
-		strcat(*tok, buf);
-	} else
-		*tok = strdup(buf);
-	if (!*tok)
-		return EVENT_NONE;
-
-	if (type == EVENT_ITEM) {
-		/*
-		 * Older versions of the kernel has a bug that
-		 * creates invalid symbols and will break the mac80211
-		 * parsing. This is a work around to that bug.
-		 *
-		 * See Linux kernel commit:
-		 *  811cb50baf63461ce0bdb234927046131fc7fa8b
-		 */
-		if (strcmp(*tok, "LOCAL_PR_FMT") == 0) {
-			free(*tok);
-			*tok = NULL;
-			return force_token("\"\%s\" ", tok);
-		} else if (strcmp(*tok, "STA_PR_FMT") == 0) {
-			free(*tok);
-			*tok = NULL;
-			return force_token("\" sta:%pM\" ", tok);
-		} else if (strcmp(*tok, "VIF_PR_FMT") == 0) {
-			free(*tok);
-			*tok = NULL;
-			return force_token("\" vif:%p(%d)\" ", tok);
-		}
-	}
-
-	return type;
-}
-
-static enum event_type force_token(const char *str, char **tok)
-{
-	const char *save_input_buf;
-	unsigned long long save_input_buf_ptr;
-	unsigned long long save_input_buf_siz;
-	enum event_type type;
-	
-	/* save off the current input pointers */
-	save_input_buf = input_buf;
-	save_input_buf_ptr = input_buf_ptr;
-	save_input_buf_siz = input_buf_siz;
-
-	init_input_buf(str, strlen(str));
-
-	type = __read_token(tok);
-
-	/* reset back to original token */
-	input_buf = save_input_buf;
-	input_buf_ptr = save_input_buf_ptr;
-	input_buf_siz = save_input_buf_siz;
-
-	return type;
-}
-
-static void free_token(char *tok)
-{
-	if (tok)
-		free(tok);
-}
-
-static enum event_type read_token(char **tok)
-{
-	enum event_type type;
-
-	for (;;) {
-		type = __read_token(tok);
-		if (type != EVENT_SPACE)
-			return type;
-
-		free_token(*tok);
-	}
-
-	/* not reached */
-	*tok = NULL;
-	return EVENT_NONE;
-}
-
-/**
- * pevent_read_token - access to utilites to use the pevent parser
- * @tok: The token to return
- *
- * This will parse tokens from the string given by
- * pevent_init_data().
- *
- * Returns the token type.
- */
-enum event_type pevent_read_token(char **tok)
-{
-	return read_token(tok);
-}
-
-/**
- * pevent_free_token - free a token returned by pevent_read_token
- * @token: the token to free
- */
-void pevent_free_token(char *token)
-{
-	free_token(token);
-}
-
-/* no newline */
-static enum event_type read_token_item(char **tok)
-{
-	enum event_type type;
-
-	for (;;) {
-		type = __read_token(tok);
-		if (type != EVENT_SPACE && type != EVENT_NEWLINE)
-			return type;
-		free_token(*tok);
-		*tok = NULL;
-	}
-
-	/* not reached */
-	*tok = NULL;
-	return EVENT_NONE;
-}
-
-static int test_type(enum event_type type, enum event_type expect)
-{
-	if (type != expect) {
-		do_warning("Error: expected type %d but read %d",
-		    expect, type);
-		return -1;
-	}
-	return 0;
-}
-
-static int test_type_token(enum event_type type, const char *token,
-		    enum event_type expect, const char *expect_tok)
-{
-	if (type != expect) {
-		do_warning("Error: expected type %d but read %d",
-		    expect, type);
-		return -1;
-	}
-
-	if (strcmp(token, expect_tok) != 0) {
-		do_warning("Error: expected '%s' but read '%s'",
-		    expect_tok, token);
-		return -1;
-	}
-	return 0;
-}
-
-static int __read_expect_type(enum event_type expect, char **tok, int newline_ok)
-{
-	enum event_type type;
-
-	if (newline_ok)
-		type = read_token(tok);
-	else
-		type = read_token_item(tok);
-	return test_type(type, expect);
-}
-
-static int read_expect_type(enum event_type expect, char **tok)
-{
-	return __read_expect_type(expect, tok, 1);
-}
-
-static int __read_expected(enum event_type expect, const char *str,
-			   int newline_ok)
-{
-	enum event_type type;
-	char *token;
-	int ret;
-
-	if (newline_ok)
-		type = read_token(&token);
-	else
-		type = read_token_item(&token);
-
-	ret = test_type_token(type, token, expect, str);
-
-	free_token(token);
-
-	return ret;
-}
-
-static int read_expected(enum event_type expect, const char *str)
-{
-	return __read_expected(expect, str, 1);
-}
-
-static int read_expected_item(enum event_type expect, const char *str)
-{
-	return __read_expected(expect, str, 0);
-}
-
-static char *event_read_name(void)
-{
-	char *token;
-
-	if (read_expected(EVENT_ITEM, "name") < 0)
-		return NULL;
-
-	if (read_expected(EVENT_OP, ":") < 0)
-		return NULL;
-
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-
-	return token;
-
- fail:
-	free_token(token);
-	return NULL;
-}
-
-static int event_read_id(void)
-{
-	char *token;
-	int id;
-
-	if (read_expected_item(EVENT_ITEM, "ID") < 0)
-		return -1;
-
-	if (read_expected(EVENT_OP, ":") < 0)
-		return -1;
-
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-
-	id = strtoul(token, NULL, 0);
-	free_token(token);
-	return id;
-
- fail:
-	free_token(token);
-	return -1;
-}
-
-static int field_is_string(struct format_field *field)
-{
-	if ((field->flags & FIELD_IS_ARRAY) &&
-	    (strstr(field->type, "char") || strstr(field->type, "u8") ||
-	     strstr(field->type, "s8")))
-		return 1;
-
-	return 0;
-}
-
-static int field_is_dynamic(struct format_field *field)
-{
-	if (strncmp(field->type, "__data_loc", 10) == 0)
-		return 1;
-
-	return 0;
-}
-
-static int field_is_long(struct format_field *field)
-{
-	/* includes long long */
-	if (strstr(field->type, "long"))
-		return 1;
-
-	return 0;
-}
-
-static int event_read_fields(struct event_format *event, struct format_field **fields)
-{
-	struct format_field *field = NULL;
-	enum event_type type;
-	char *token;
-	char *last_token;
-	int count = 0;
-
-	do {
-		type = read_token(&token);
-		if (type == EVENT_NEWLINE) {
-			free_token(token);
-			return count;
-		}
-
-		count++;
-
-		if (test_type_token(type, token, EVENT_ITEM, "field"))
-			goto fail;
-		free_token(token);
-
-		type = read_token(&token);
-		/*
-		 * The ftrace fields may still use the "special" name.
-		 * Just ignore it.
-		 */
-		if (event->flags & EVENT_FL_ISFTRACE &&
-		    type == EVENT_ITEM && strcmp(token, "special") == 0) {
-			free_token(token);
-			type = read_token(&token);
-		}
-
-		if (test_type_token(type, token, EVENT_OP, ":") < 0)
-			goto fail;
-
-		free_token(token);
-		if (read_expect_type(EVENT_ITEM, &token) < 0)
-			goto fail;
-
-		last_token = token;
-
-		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(*field));
-		field->event = event;
-
-		/* read the rest of the type */
-		for (;;) {
-			type = read_token(&token);
-			if (type == EVENT_ITEM ||
-			    (type == EVENT_OP && strcmp(token, "*") == 0) ||
-			    /*
-			     * Some of the ftrace fields are broken and have
-			     * an illegal "." in them.
-			     */
-			    (event->flags & EVENT_FL_ISFTRACE &&
-			     type == EVENT_OP && strcmp(token, ".") == 0)) {
-
-				if (strcmp(token, "*") == 0)
-					field->flags |= FIELD_IS_POINTER;
-
-				if (field->type) {
-					field->type = realloc(field->type,
-							      strlen(field->type) +
-							      strlen(last_token) + 2);
-					strcat(field->type, " ");
-					strcat(field->type, last_token);
-					free(last_token);
-				} else
-					field->type = last_token;
-				last_token = token;
-				continue;
-			}
-
-			break;
-		}
-
-		if (!field->type) {
-			die("no type found");
-			goto fail;
-		}
-		field->name = last_token;
-
-		if (test_type(type, EVENT_OP))
-			goto fail;
-
-		if (strcmp(token, "[") == 0) {
-			enum event_type last_type = type;
-			char *brackets = token;
-			int len;
-
-			field->flags |= FIELD_IS_ARRAY;
-
-			type = read_token(&token);
-
-			if (type == EVENT_ITEM)
-				field->arraylen = strtoul(token, NULL, 0);
-			else
-				field->arraylen = 0;
-
-		        while (strcmp(token, "]") != 0) {
-				if (last_type == EVENT_ITEM &&
-				    type == EVENT_ITEM)
-					len = 2;
-				else
-					len = 1;
-				last_type = type;
-
-				brackets = realloc(brackets,
-						   strlen(brackets) +
-						   strlen(token) + len);
-				if (len == 2)
-					strcat(brackets, " ");
-				strcat(brackets, token);
-				/* We only care about the last token */
-				field->arraylen = strtoul(token, NULL, 0);
-				free_token(token);
-				type = read_token(&token);
-				if (type == EVENT_NONE) {
-					die("failed to find token");
-					goto fail;
-				}
-			}
-
-			free_token(token);
-
-			brackets = realloc(brackets, strlen(brackets) + 2);
-			strcat(brackets, "]");
-
-			/* add brackets to type */
-
-			type = read_token(&token);
-			/*
-			 * If the next token is not an OP, then it is of
-			 * the format: type [] item;
-			 */
-			if (type == EVENT_ITEM) {
-				field->type = realloc(field->type,
-						      strlen(field->type) +
-						      strlen(field->name) +
-						      strlen(brackets) + 2);
-				strcat(field->type, " ");
-				strcat(field->type, field->name);
-				free_token(field->name);
-				strcat(field->type, brackets);
-				field->name = token;
-				type = read_token(&token);
-			} else {
-				field->type = realloc(field->type,
-						      strlen(field->type) +
-						      strlen(brackets) + 1);
-				strcat(field->type, brackets);
-			}
-			free(brackets);
-		}
-
-		if (field_is_string(field))
-			field->flags |= FIELD_IS_STRING;
-		if (field_is_dynamic(field))
-			field->flags |= FIELD_IS_DYNAMIC;
-		if (field_is_long(field))
-			field->flags |= FIELD_IS_LONG;
-
-		if (test_type_token(type, token,  EVENT_OP, ";"))
-			goto fail;
-		free_token(token);
-
-		if (read_expected(EVENT_ITEM, "offset") < 0)
-			goto fail_expect;
-
-		if (read_expected(EVENT_OP, ":") < 0)
-			goto fail_expect;
-
-		if (read_expect_type(EVENT_ITEM, &token))
-			goto fail;
-		field->offset = strtoul(token, NULL, 0);
-		free_token(token);
-
-		if (read_expected(EVENT_OP, ";") < 0)
-			goto fail_expect;
-
-		if (read_expected(EVENT_ITEM, "size") < 0)
-			goto fail_expect;
-
-		if (read_expected(EVENT_OP, ":") < 0)
-			goto fail_expect;
-
-		if (read_expect_type(EVENT_ITEM, &token))
-			goto fail;
-		field->size = strtoul(token, NULL, 0);
-		free_token(token);
-
-		if (read_expected(EVENT_OP, ";") < 0)
-			goto fail_expect;
-
-		type = read_token(&token);
-		if (type != EVENT_NEWLINE) {
-			/* newer versions of the kernel have a "signed" type */
-			if (test_type_token(type, token, EVENT_ITEM, "signed"))
-				goto fail;
-
-			free_token(token);
-
-			if (read_expected(EVENT_OP, ":") < 0)
-				goto fail_expect;
-
-			if (read_expect_type(EVENT_ITEM, &token))
-				goto fail;
-
-			/* add signed type */
-
-			free_token(token);
-			if (read_expected(EVENT_OP, ";") < 0)
-				goto fail_expect;
-
-			if (read_expect_type(EVENT_NEWLINE, &token))
-				goto fail;
-		}
-
-		free_token(token);
-
-		if (field->flags & FIELD_IS_ARRAY) {
-			if (field->arraylen)
-				field->elementsize = field->size / field->arraylen;
-			else if (field->flags & FIELD_IS_STRING)
-				field->elementsize = 1;
-			else
-				field->elementsize = event->pevent->long_size;
-		} else
-			field->elementsize = field->size;
-
-		*fields = field;
-		fields = &field->next;
-
-	} while (1);
-
-	return 0;
-
-fail:
-	free_token(token);
-fail_expect:
-	if (field)
-		free(field);
-	return -1;
-}
-
-static int event_read_format(struct event_format *event)
-{
-	char *token;
-	int ret;
-
-	if (read_expected_item(EVENT_ITEM, "format") < 0)
-		return -1;
-
-	if (read_expected(EVENT_OP, ":") < 0)
-		return -1;
-
-	if (read_expect_type(EVENT_NEWLINE, &token))
-		goto fail;
-	free_token(token);
-
-	ret = event_read_fields(event, &event->format.common_fields);
-	if (ret < 0)
-		return ret;
-	event->format.nr_common = ret;
-
-	ret = event_read_fields(event, &event->format.fields);
-	if (ret < 0)
-		return ret;
-	event->format.nr_fields = ret;
-
-	return 0;
-
- fail:
-	free_token(token);
-	return -1;
-}
-
-static enum event_type
-process_arg_token(struct event_format *event, struct print_arg *arg,
-		  char **tok, enum event_type type);
-
-static enum event_type
-process_arg(struct event_format *event, struct print_arg *arg, char **tok)
-{
-	enum event_type type;
-	char *token;
-
-	type = read_token(&token);
-	*tok = token;
-
-	return process_arg_token(event, arg, tok, type);
-}
-
-static enum event_type
-process_op(struct event_format *event, struct print_arg *arg, char **tok);
-
-static enum event_type
-process_cond(struct event_format *event, struct print_arg *top, char **tok)
-{
-	struct print_arg *arg, *left, *right;
-	enum event_type type;
-	char *token = NULL;
-
-	arg = alloc_arg();
-	left = alloc_arg();
-	right = alloc_arg();
-
-	arg->type = PRINT_OP;
-	arg->op.left = left;
-	arg->op.right = right;
-
-	*tok = NULL;
-	type = process_arg(event, left, &token);
-
- again:
-	/* Handle other operations in the arguments */
-	if (type == EVENT_OP && strcmp(token, ":") != 0) {
-		type = process_op(event, left, &token);
-		goto again;
-	}
-
-	if (test_type_token(type, token, EVENT_OP, ":"))
-		goto out_free;
-
-	arg->op.op = token;
-
-	type = process_arg(event, right, &token);
-
-	top->op.right = arg;
-
-	*tok = token;
-	return type;
-
-out_free:
-	/* Top may point to itself */
-	top->op.right = NULL;
-	free_token(token);
-	free_arg(arg);
-	return EVENT_ERROR;
-}
-
-static enum event_type
-process_array(struct event_format *event, struct print_arg *top, char **tok)
-{
-	struct print_arg *arg;
-	enum event_type type;
-	char *token = NULL;
-
-	arg = alloc_arg();
-
-	*tok = NULL;
-	type = process_arg(event, arg, &token);
-	if (test_type_token(type, token, EVENT_OP, "]"))
-		goto out_free;
-
-	top->op.right = arg;
-
-	free_token(token);
-	type = read_token_item(&token);
-	*tok = token;
-
-	return type;
-
-out_free:
-	free_token(*tok);
-	*tok = NULL;
-	free_arg(arg);
-	return EVENT_ERROR;
-}
-
-static int get_op_prio(char *op)
-{
-	if (!op[1]) {
-		switch (op[0]) {
-		case '*':
-		case '/':
-		case '%':
-			return 6;
-		case '+':
-		case '-':
-			return 7;
-			/* '>>' and '<<' are 8 */
-		case '<':
-		case '>':
-			return 9;
-			/* '==' and '!=' are 10 */
-		case '&':
-			return 11;
-		case '^':
-			return 12;
-		case '|':
-			return 13;
-		case '?':
-			return 16;
-		default:
-			die("unknown op '%c'", op[0]);
-			return -1;
-		}
-	} else {
-		if (strcmp(op, "++") == 0 ||
-		    strcmp(op, "--") == 0) {
-			return 3;
-		} else if (strcmp(op, ">>") == 0 ||
-			   strcmp(op, "<<") == 0) {
-			return 8;
-		} else if (strcmp(op, ">=") == 0 ||
-			   strcmp(op, "<=") == 0) {
-			return 9;
-		} else if (strcmp(op, "==") == 0 ||
-			   strcmp(op, "!=") == 0) {
-			return 10;
-		} else if (strcmp(op, "&&") == 0) {
-			return 14;
-		} else if (strcmp(op, "||") == 0) {
-			return 15;
-		} else {
-			die("unknown op '%s'", op);
-			return -1;
-		}
-	}
-}
-
-static void set_op_prio(struct print_arg *arg)
-{
-
-	/* single ops are the greatest */
-	if (!arg->op.left || arg->op.left->type == PRINT_NULL) {
-		arg->op.prio = 0;
-		return;
-	}
-
-	arg->op.prio = get_op_prio(arg->op.op);
-}
-
-/* Note, *tok does not get freed, but will most likely be saved */
-static enum event_type
-process_op(struct event_format *event, struct print_arg *arg, char **tok)
-{
-	struct print_arg *left, *right = NULL;
-	enum event_type type;
-	char *token;
-
-	/* the op is passed in via tok */
-	token = *tok;
-
-	if (arg->type == PRINT_OP && !arg->op.left) {
-		/* handle single op */
-		if (token[1]) {
-			die("bad op token %s", token);
-			goto out_free;
-		}
-		switch (token[0]) {
-		case '!':
-		case '+':
-		case '-':
-			break;
-		default:
-			do_warning("bad op token %s", token);
-			goto out_free;
-
-		}
-
-		/* make an empty left */
-		left = alloc_arg();
-		left->type = PRINT_NULL;
-		arg->op.left = left;
-
-		right = alloc_arg();
-		arg->op.right = right;
-
-		/* do not free the token, it belongs to an op */
-		*tok = NULL;
-		type = process_arg(event, right, tok);
-
-	} else if (strcmp(token, "?") == 0) {
-
-		left = alloc_arg();
-		/* copy the top arg to the left */
-		*left = *arg;
-
-		arg->type = PRINT_OP;
-		arg->op.op = token;
-		arg->op.left = left;
-		arg->op.prio = 0;
-
-		type = process_cond(event, arg, tok);
-
-	} else if (strcmp(token, ">>") == 0 ||
-		   strcmp(token, "<<") == 0 ||
-		   strcmp(token, "&") == 0 ||
-		   strcmp(token, "|") == 0 ||
-		   strcmp(token, "&&") == 0 ||
-		   strcmp(token, "||") == 0 ||
-		   strcmp(token, "-") == 0 ||
-		   strcmp(token, "+") == 0 ||
-		   strcmp(token, "*") == 0 ||
-		   strcmp(token, "^") == 0 ||
-		   strcmp(token, "/") == 0 ||
-		   strcmp(token, "<") == 0 ||
-		   strcmp(token, ">") == 0 ||
-		   strcmp(token, "==") == 0 ||
-		   strcmp(token, "!=") == 0) {
-
-		left = alloc_arg();
-
-		/* copy the top arg to the left */
-		*left = *arg;
-
-		arg->type = PRINT_OP;
-		arg->op.op = token;
-		arg->op.left = left;
-
-		set_op_prio(arg);
-
-		type = read_token_item(&token);
-		*tok = token;
-
-		/* could just be a type pointer */
-		if ((strcmp(arg->op.op, "*") == 0) &&
-		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
-			if (left->type != PRINT_ATOM)
-				die("bad pointer type");
-			left->atom.atom = realloc(left->atom.atom,
-					    strlen(left->atom.atom) + 3);
-			strcat(left->atom.atom, " *");
-			free(arg->op.op);
-			*arg = *left;
-			free(left);
-
-			return type;
-		}
-
-		right = alloc_arg();
-		type = process_arg_token(event, right, tok, type);
-		arg->op.right = right;
-
-	} else if (strcmp(token, "[") == 0) {
-
-		left = alloc_arg();
-		*left = *arg;
-
-		arg->type = PRINT_OP;
-		arg->op.op = token;
-		arg->op.left = left;
-
-		arg->op.prio = 0;
-
-		type = process_array(event, arg, tok);
-
-	} else {
-		do_warning("unknown op '%s'", token);
-		event->flags |= EVENT_FL_FAILED;
-		/* the arg is now the left side */
-		goto out_free;
-	}
-
-	if (type == EVENT_OP && strcmp(*tok, ":") != 0) {
-		int prio;
-
-		/* higher prios need to be closer to the root */
-		prio = get_op_prio(*tok);
-
-		if (prio > arg->op.prio)
-			return process_op(event, arg, tok);
-
-		return process_op(event, right, tok);
-	}
-
-	return type;
-
- out_free:
-	free_token(token);
-	*tok = NULL;
-	return EVENT_ERROR;
-}
-
-static enum event_type
-process_entry(struct event_format *event __unused, struct print_arg *arg,
-	      char **tok)
-{
-	enum event_type type;
-	char *field;
-	char *token;
-
-	if (read_expected(EVENT_OP, "->") < 0)
-		goto out_err;
-
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto out_free;
-	field = token;
-
-	arg->type = PRINT_FIELD;
-	arg->field.name = field;
-
-	type = read_token(&token);
-	*tok = token;
-
-	return type;
-
- out_free:
-	free_token(token);
- out_err:
-	*tok = NULL;
-	return EVENT_ERROR;
-}
-
-static char *arg_eval (struct print_arg *arg);
-
-static unsigned long long
-eval_type_str(unsigned long long val, const char *type, int pointer)
-{
-	int sign = 0;
-	char *ref;
-	int len;
-
-	len = strlen(type);
-
-	if (pointer) {
-
-		if (type[len-1] != '*') {
-			do_warning("pointer expected with non pointer type");
-			return val;
-		}
-
-		ref = malloc_or_die(len);
-		memcpy(ref, type, len);
-
-		/* chop off the " *" */
-		ref[len - 2] = 0;
-
-		val = eval_type_str(val, ref, 0);
-		free(ref);
-		return val;
-	}
-
-	/* check if this is a pointer */
-	if (type[len - 1] == '*')
-		return val;
-
-	/* Try to figure out the arg size*/
-	if (strncmp(type, "struct", 6) == 0)
-		/* all bets off */
-		return val;
-
-	if (strcmp(type, "u8") == 0)
-		return val & 0xff;
-
-	if (strcmp(type, "u16") == 0)
-		return val & 0xffff;
-
-	if (strcmp(type, "u32") == 0)
-		return val & 0xffffffff;
-
-	if (strcmp(type, "u64") == 0 ||
-	    strcmp(type, "s64"))
-		return val;
-
-	if (strcmp(type, "s8") == 0)
-		return (unsigned long long)(char)val & 0xff;
-
-	if (strcmp(type, "s16") == 0)
-		return (unsigned long long)(short)val & 0xffff;
-
-	if (strcmp(type, "s32") == 0)
-		return (unsigned long long)(int)val & 0xffffffff;
-
-	if (strncmp(type, "unsigned ", 9) == 0) {
-		sign = 0;
-		type += 9;
-	}
-
-	if (strcmp(type, "char") == 0) {
-		if (sign)
-			return (unsigned long long)(char)val & 0xff;
-		else
-			return val & 0xff;
-	}
-
-	if (strcmp(type, "short") == 0) {
-		if (sign)
-			return (unsigned long long)(short)val & 0xffff;
-		else
-			return val & 0xffff;
-	}
-
-	if (strcmp(type, "int") == 0) {
-		if (sign)
-			return (unsigned long long)(int)val & 0xffffffff;
-		else
-			return val & 0xffffffff;
-	}
-
-	return val;
-}
-
-/*
- * Try to figure out the type.
- */
-static unsigned long long
-eval_type(unsigned long long val, struct print_arg *arg, int pointer)
-{
-	if (arg->type != PRINT_TYPE)
-		die("expected type argument");
-
-	return eval_type_str(val, arg->typecast.type, pointer);
-}
-
-static long long arg_num_eval(struct print_arg *arg)
-{
-	long long left, right;
-	long long val = 0;
-
-	switch (arg->type) {
-	case PRINT_ATOM:
-		val = strtoll(arg->atom.atom, NULL, 0);
-		break;
-	case PRINT_TYPE:
-		val = arg_num_eval(arg->typecast.item);
-		val = eval_type(val, arg, 0);
-		break;
-	case PRINT_OP:
-		switch (arg->op.op[0]) {
-		case '|':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-			if (arg->op.op[1])
-				val = left || right;
-			else
-				val = left | right;
-			break;
-		case '&':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-			if (arg->op.op[1])
-				val = left && right;
-			else
-				val = left & right;
-			break;
-		case '<':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-			switch (arg->op.op[1]) {
-			case 0:
-				val = left < right;
-				break;
-			case '<':
-				val = left << right;
-				break;
-			case '=':
-				val = left <= right;
-				break;
-			default:
-				die("unknown op '%s'", arg->op.op);
-			}
-			break;
-		case '>':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-			switch (arg->op.op[1]) {
-			case 0:
-				val = left > right;
-				break;
-			case '>':
-				val = left >> right;
-				break;
-			case '=':
-				val = left >= right;
-				break;
-			default:
-				die("unknown op '%s'", arg->op.op);
-			}
-			break;
-		case '=':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-
-			if (arg->op.op[1] != '=')
-				die("unknown op '%s'", arg->op.op);
-
-			val = left == right;
-			break;
-		case '!':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-
-			switch (arg->op.op[1]) {
-			case '=':
-				val = left != right;
-				break;
-			default:
-				die("unknown op '%s'", arg->op.op);
-			}
-			break;
-		case '-':
-			/* check for negative */
-			if (arg->op.left->type == PRINT_NULL)
-				left = 0;
-			else
-				left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-			val = left - right;
-			break;
-		default:
-			die("unknown op '%s'", arg->op.op);
-		}
-		break;
-
-	case PRINT_NULL:
-	case PRINT_FIELD ... PRINT_SYMBOL:
-	case PRINT_STRING:
-	default:
-		die("invalid eval type %d", arg->type);
-
-	}
-	return val;
-}
-
-static char *arg_eval (struct print_arg *arg)
-{
-	long long val;
-	static char buf[20];
-
-	switch (arg->type) {
-	case PRINT_ATOM:
-		return arg->atom.atom;
-	case PRINT_TYPE:
-		return arg_eval(arg->typecast.item);
-	case PRINT_OP:
-		val = arg_num_eval(arg);
-		sprintf(buf, "%lld", val);
-		return buf;
-
-	case PRINT_NULL:
-	case PRINT_FIELD ... PRINT_SYMBOL:
-	case PRINT_STRING:
-	default:
-		die("invalid eval type %d", arg->type);
-		break;
-	}
-
-	return NULL;
-}
-
-static enum event_type
-process_fields(struct event_format *event, struct print_flag_sym **list, char **tok)
-{
-	enum event_type type;
-	struct print_arg *arg = NULL;
-	struct print_flag_sym *field;
-	char *token = *tok;
-	char *value;
-
-	do {
-		free_token(token);
-		type = read_token_item(&token);
-		if (test_type_token(type, token, EVENT_OP, "{"))
-			break;
-
-		arg = alloc_arg();
-
-		free_token(token);
-		type = process_arg(event, arg, &token);
-		if (test_type_token(type, token, EVENT_DELIM, ","))
-			goto out_free;
-
-		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(field));
-
-		value = arg_eval(arg);
-		field->value = strdup(value);
-
-		free_arg(arg);
-		arg = alloc_arg();
-
-		free_token(token);
-		type = process_arg(event, arg, &token);
-		if (test_type_token(type, token, EVENT_OP, "}"))
-			goto out_free;
-
-		value = arg_eval(arg);
-		field->str = strdup(value);
-		free_arg(arg);
-		arg = NULL;
-
-		*list = field;
-		list = &field->next;
-
-		free_token(token);
-		type = read_token_item(&token);
-	} while (type == EVENT_DELIM && strcmp(token, ",") == 0);
-
-	*tok = token;
-	return type;
-
-out_free:
-	free_arg(arg);
-	free_token(token);
-	*tok = NULL;
-
-	return EVENT_ERROR;
-}
-
-static enum event_type
-process_flags(struct event_format *event, struct print_arg *arg, char **tok)
-{
-	struct print_arg *field;
-	enum event_type type;
-	char *token;
-
-	memset(arg, 0, sizeof(*arg));
-	arg->type = PRINT_FLAGS;
-
-	field = alloc_arg();
-
-	type = process_arg(event, field, &token);
-	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
-	free_token(token);
-
-	arg->flags.field = field;
-
-	type = read_token_item(&token);
-	if (event_item_type(type)) {
-		arg->flags.delim = token;
-		type = read_token_item(&token);
-	}
-
-	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
-
-	type = process_fields(event, &arg->flags.flags, &token);
-	if (test_type_token(type, token, EVENT_DELIM, ")"))
-		goto out_free;
-
-	free_token(token);
-	type = read_token_item(tok);
-	return type;
-
- out_free:
-	free_token(token);
-	*tok = NULL;
-	return EVENT_ERROR;
-}
-
-static enum event_type
-process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
-{
-	struct print_arg *field;
-	enum event_type type;
-	char *token;
-
-	memset(arg, 0, sizeof(*arg));
-	arg->type = PRINT_SYMBOL;
-
-	field = alloc_arg();
-
-	type = process_arg(event, field, &token);
-	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
-
-	arg->symbol.field = field;
-
-	type = process_fields(event, &arg->symbol.symbols, &token);
-	if (test_type_token(type, token, EVENT_DELIM, ")"))
-		goto out_free;
-
-	free_token(token);
-	type = read_token_item(tok);
-	return type;
-
- out_free:
-	free_token(token);
-	*tok = NULL;
-	return EVENT_ERROR;
-}
-
-static enum event_type
-process_dynamic_array(struct event_format *event, struct print_arg *arg, char **tok)
-{
-	struct format_field *field;
-	enum event_type type;
-	char *token;
-
-	memset(arg, 0, sizeof(*arg));
-	arg->type = PRINT_DYNAMIC_ARRAY;
-
-	/*
-	 * The item within the parenthesis is another field that holds
-	 * the index into where the array starts.
-	 */
-	type = read_token(&token);
-	*tok = token;
-	if (type != EVENT_ITEM)
-		goto out_free;
-
-	/* Find the field */
-
-	field = pevent_find_field(event, token);
-	if (!field)
-		goto out_free;
-
-	arg->dynarray.field = field;
-	arg->dynarray.index = 0;
-
-	if (read_expected(EVENT_DELIM, ")") < 0)
-		goto out_free;
-
-	type = read_token_item(&token);
-	*tok = token;
-	if (type != EVENT_OP || strcmp(token, "[") != 0)
-		return type;
-
-	free_token(token);
-	arg = alloc_arg();
-	type = process_arg(event, arg, &token);
-	if (type == EVENT_ERROR)
-		goto out_free;
-
-	if (!test_type_token(type, token, EVENT_OP, "]"))
-		goto out_free;
-
-	free_token(token);
-	type = read_token_item(tok);
-	return type;
-
- out_free:
-	free(arg);
-	free_token(token);
-	*tok = NULL;
-	return EVENT_ERROR;
-}
-
-static enum event_type
-process_paren(struct event_format *event, struct print_arg *arg, char **tok)
-{
-	struct print_arg *item_arg;
-	enum event_type type;
-	char *token;
-
-	type = process_arg(event, arg, &token);
-
-	if (type == EVENT_ERROR)
-		goto out_free;
-
-	if (type == EVENT_OP)
-		type = process_op(event, arg, &token);
-
-	if (type == EVENT_ERROR)
-		goto out_free;
-
-	if (test_type_token(type, token, EVENT_DELIM, ")"))
-		goto out_free;
-
-	free_token(token);
-	type = read_token_item(&token);
-
-	/*
-	 * If the next token is an item or another open paren, then
-	 * this was a typecast.
-	 */
-	if (event_item_type(type) ||
-	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
-
-		/* make this a typecast and contine */
-
-		/* prevous must be an atom */
-		if (arg->type != PRINT_ATOM)
-			die("previous needed to be PRINT_ATOM");
-
-		item_arg = alloc_arg();
-
-		arg->type = PRINT_TYPE;
-		arg->typecast.type = arg->atom.atom;
-		arg->typecast.item = item_arg;
-		type = process_arg_token(event, item_arg, &token, type);
-
-	}
-
-	*tok = token;
-	return type;
-
- out_free:
-	free_token(token);
-	*tok = NULL;
-	return EVENT_ERROR;
-}
-
-
-static enum event_type
-process_str(struct event_format *event __unused, struct print_arg *arg, char **tok)
-{
-	enum event_type type;
-	char *token;
-
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto out_free;
-
-	arg->type = PRINT_STRING;
-	arg->string.string = token;
-	arg->string.offset = -1;
-
-	if (read_expected(EVENT_DELIM, ")") < 0)
-		goto out_err;
-
-	type = read_token(&token);
-	*tok = token;
-
-	return type;
-
- out_free:
-	free_token(token);
- out_err:
-	*tok = NULL;
-	return EVENT_ERROR;
-}
-
-static struct pevent_function_handler *
-find_func_handler(struct pevent *pevent, char *func_name)
-{
-	struct pevent_function_handler *func;
-
-	for (func = pevent->func_handlers; func; func = func->next) {
-		if (strcmp(func->name, func_name) == 0)
-			break;
-	}
-
-	return func;
-}
-
-static void remove_func_handler(struct pevent *pevent, char *func_name)
-{
-	struct pevent_function_handler *func;
-	struct pevent_function_handler **next;
-
-	next = &pevent->func_handlers;
-	while ((func = *next)) {
-		if (strcmp(func->name, func_name) == 0) {
-			*next = func->next;
-			free_func_handle(func);
-			break;
-		}
-		next = &func->next;
-	}
-}
-
-static enum event_type
-process_func_handler(struct event_format *event, struct pevent_function_handler *func,
-		     struct print_arg *arg, char **tok)
-{
-	struct print_arg **next_arg;
-	struct print_arg *farg;
-	enum event_type type;
-	char *token;
-	char *test;
-	int i;
-
-	arg->type = PRINT_FUNC;
-	arg->func.func = func;
-
-	*tok = NULL;
-
-	next_arg = &(arg->func.args);
-	for (i = 0; i < func->nr_args; i++) {
-		farg = alloc_arg();
-		type = process_arg(event, farg, &token);
-		if (i < (func->nr_args - 1))
-			test = ",";
-		else
-			test = ")";
-
-		if (test_type_token(type, token, EVENT_DELIM, test)) {
-			free_arg(farg);
-			free_token(token);
-			return EVENT_ERROR;
-		}
-
-		*next_arg = farg;
-		next_arg = &(farg->next);
-	}
-
-	type = read_token(&token);
-	*tok = token;
-
-	return type;
-}
-
-static enum event_type
-process_function(struct event_format *event, struct print_arg *arg,
-		 char *token, char **tok)
-{
-	struct pevent_function_handler *func;
-
-	if (strcmp(token, "__print_flags") == 0) {
-		free_token(token);
-		return process_flags(event, arg, tok);
-	}
-	if (strcmp(token, "__print_symbolic") == 0) {
-		free_token(token);
-		return process_symbols(event, arg, tok);
-	}
-	if (strcmp(token, "__get_str") == 0) {
-		free_token(token);
-		return process_str(event, arg, tok);
-	}
-	if (strcmp(token, "__get_dynamic_array") == 0) {
-		free_token(token);
-		return process_dynamic_array(event, arg, tok);
-	}
-
-	func = find_func_handler(event->pevent, token);
-	if (func) {
-		free_token(token);
-		return process_func_handler(event, func, arg, tok);
-	}
-
-	do_warning("function %s not defined", token);
-	free_token(token);
-	return EVENT_ERROR;
-}
-
-static enum event_type
-process_arg_token(struct event_format *event, struct print_arg *arg,
-		  char **tok, enum event_type type)
-{
-	char *token;
-	char *atom;
-
-	token = *tok;
-
-	switch (type) {
-	case EVENT_ITEM:
-		if (strcmp(token, "REC") == 0) {
-			free_token(token);
-			type = process_entry(event, arg, &token);
-			break;
-		}
-		atom = token;
-		/* test the next token */
-		type = read_token_item(&token);
-
-		/*
-		 * If the next token is a parenthesis, then this
-		 * is a function.
-		 */
-		if (type == EVENT_DELIM && strcmp(token, "(") == 0) {
-			free_token(token);
-			token = NULL;
-			/* this will free atom. */
-			type = process_function(event, arg, atom, &token);
-			break;
-		}
-		/* atoms can be more than one token long */
-		while (type == EVENT_ITEM) {
-			atom = realloc(atom, strlen(atom) + strlen(token) + 2);
-			strcat(atom, " ");
-			strcat(atom, token);
-			free_token(token);
-			type = read_token_item(&token);
-		}
-
-		arg->type = PRINT_ATOM;
-		arg->atom.atom = atom;
-		break;
-
-	case EVENT_DQUOTE:
-	case EVENT_SQUOTE:
-		arg->type = PRINT_ATOM;
-		arg->atom.atom = token;
-		type = read_token_item(&token);
-		break;
-	case EVENT_DELIM:
-		if (strcmp(token, "(") == 0) {
-			free_token(token);
-			type = process_paren(event, arg, &token);
-			break;
-		}
-	case EVENT_OP:
-		/* handle single ops */
-		arg->type = PRINT_OP;
-		arg->op.op = token;
-		arg->op.left = NULL;
-		type = process_op(event, arg, &token);
-
-		/* On error, the op is freed */
-		if (type == EVENT_ERROR)
-			arg->op.op = NULL;
-
-		/* return error type if errored */
-		break;
-
-	case EVENT_ERROR ... EVENT_NEWLINE:
-	default:
-		die("unexpected type %d", type);
-	}
-	*tok = token;
-
-	return type;
-}
-
-static int event_read_print_args(struct event_format *event, struct print_arg **list)
-{
-	enum event_type type = EVENT_ERROR;
-	struct print_arg *arg;
-	char *token;
-	int args = 0;
-
-	do {
-		if (type == EVENT_NEWLINE) {
-			type = read_token_item(&token);
-			continue;
-		}
-
-		arg = alloc_arg();
-
-		type = process_arg(event, arg, &token);
-
-		if (type == EVENT_ERROR) {
-			free_token(token);
-			free_arg(arg);
-			return -1;
-		}
-
-		*list = arg;
-		args++;
-
-		if (type == EVENT_OP) {
-			type = process_op(event, arg, &token);
-			free_token(token);
-			if (type == EVENT_ERROR) {
-				*list = NULL;
-				free_arg(arg);
-				return -1;
-			}
-			list = &arg->next;
-			continue;
-		}
-
-		if (type == EVENT_DELIM && strcmp(token, ",") == 0) {
-			free_token(token);
-			*list = arg;
-			list = &arg->next;
-			continue;
-		}
-		break;
-	} while (type != EVENT_NONE);
-
-	if (type != EVENT_NONE && type != EVENT_ERROR)
-		free_token(token);
-
-	return args;
-}
-
-static int event_read_print(struct event_format *event)
-{
-	enum event_type type;
-	char *token;
-	int ret;
-
-	if (read_expected_item(EVENT_ITEM, "print") < 0)
-		return -1;
-
-	if (read_expected(EVENT_ITEM, "fmt") < 0)
-		return -1;
-
-	if (read_expected(EVENT_OP, ":") < 0)
-		return -1;
-
-	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
-		goto fail;
-
- concat:
-	event->print_fmt.format = token;
-	event->print_fmt.args = NULL;
-
-	/* ok to have no arg */
-	type = read_token_item(&token);
-
-	if (type == EVENT_NONE)
-		return 0;
-
-	/* Handle concatenation of print lines */
-	if (type == EVENT_DQUOTE) {
-		char *cat;
-
-		cat = malloc_or_die(strlen(event->print_fmt.format) +
-				    strlen(token) + 1);
-		strcpy(cat, event->print_fmt.format);
-		strcat(cat, token);
-		free_token(token);
-		free_token(event->print_fmt.format);
-		event->print_fmt.format = NULL;
-		token = cat;
-		goto concat;
-	}
-			     
-	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto fail;
-
-	free_token(token);
-
-	ret = event_read_print_args(event, &event->print_fmt.args);
-	if (ret < 0)
-		return -1;
-
-	return ret;
-
- fail:
-	free_token(token);
-	return -1;
-}
-
-/**
- * pevent_find_common_field - return a common field by event
- * @event: handle for the event
- * @name: the name of the common field to return
- *
- * Returns a common field from the event by the given @name.
- * This only searchs the common fields and not all field.
- */
-struct format_field *
-pevent_find_common_field(struct event_format *event, const char *name)
-{
-	struct format_field *format;
-
-	for (format = event->format.common_fields;
-	     format; format = format->next) {
-		if (strcmp(format->name, name) == 0)
-			break;
-	}
-
-	return format;
-}
-
-/**
- * pevent_find_field - find a non-common field
- * @event: handle for the event
- * @name: the name of the non-common field
- *
- * Returns a non-common field by the given @name.
- * This does not search common fields.
- */
-struct format_field *
-pevent_find_field(struct event_format *event, const char *name)
-{
-	struct format_field *format;
-
-	for (format = event->format.fields;
-	     format; format = format->next) {
-		if (strcmp(format->name, name) == 0)
-			break;
-	}
-
-	return format;
-}
-
-/**
- * pevent_find_any_field - find any field by name
- * @event: handle for the event
- * @name: the name of the field
- *
- * Returns a field by the given @name.
- * This searchs the common field names first, then
- * the non-common ones if a common one was not found.
- */
-struct format_field *
-pevent_find_any_field(struct event_format *event, const char *name)
-{
-	struct format_field *format;
-
-	format = pevent_find_common_field(event, name);
-	if (format)
-		return format;
-	return pevent_find_field(event, name);
-}
-
-/**
- * pevent_read_number - read a number from data
- * @pevent: handle for the pevent
- * @ptr: the raw data
- * @size: the size of the data that holds the number
- *
- * Returns the number (converted to host) from the
- * raw data.
- */
-unsigned long long pevent_read_number(struct pevent *pevent,
-				      const void *ptr, int size)
-{
-	switch (size) {
-	case 1:
-		return *(unsigned char *)ptr;
-	case 2:
-		return data2host2(pevent, ptr);
-	case 4:
-		return data2host4(pevent, ptr);
-	case 8:
-		return data2host8(pevent, ptr);
-	default:
-		/* BUG! */
-		return 0;
-	}
-}
-
-/**
- * pevent_read_number_field - read a number from data
- * @field: a handle to the field
- * @data: the raw data to read
- * @value: the value to place the number in
- *
- * Reads raw data according to a field offset and size,
- * and translates it into @value.
- *
- * Returns 0 on success, -1 otherwise.
- */
-int pevent_read_number_field(struct format_field *field, const void *data,
-			     unsigned long long *value)
-{
-	switch (field->size) {
-	case 1:
-	case 2:
-	case 4:
-	case 8:
-		*value = pevent_read_number(field->event->pevent,
-					    data + field->offset, field->size);
-		return 0;
-	default:
-		return -1;
-	}
-}
-
-static int get_common_info(struct pevent *pevent,
-			   const char *type, int *offset, int *size)
-{
-	struct event_format *event;
-	struct format_field *field;
-
-	/*
-	 * All events should have the same common elements.
-	 * Pick any event to find where the type is;
-	 */
-	if (!pevent->events)
-		die("no event_list!");
-
-	event = pevent->events[0];
-	field = pevent_find_common_field(event, type);
-	if (!field)
-		die("field '%s' not found", type);
-
-	*offset = field->offset;
-	*size = field->size;
-
-	return 0;
-}
-
-static int __parse_common(struct pevent *pevent, void *data,
-			  int *size, int *offset, const char *name)
-{
-	int ret;
-
-	if (!*size) {
-		ret = get_common_info(pevent, name, offset, size);
-		if (ret < 0)
-			return ret;
-	}
-	return pevent_read_number(pevent, data + *offset, *size);
-}
-
-static int trace_parse_common_type(struct pevent *pevent, void *data)
-{
-	return __parse_common(pevent, data,
-			      &pevent->type_size, &pevent->type_offset,
-			      "common_type");
-}
-
-static int parse_common_pid(struct pevent *pevent, void *data)
-{
-	return __parse_common(pevent, data,
-			      &pevent->pid_size, &pevent->pid_offset,
-			      "common_pid");
-}
-
-static int parse_common_pc(struct pevent *pevent, void *data)
-{
-	return __parse_common(pevent, data,
-			      &pevent->pc_size, &pevent->pc_offset,
-			      "common_preempt_count");
-}
-
-static int parse_common_flags(struct pevent *pevent, void *data)
-{
-	return __parse_common(pevent, data,
-			      &pevent->flags_size, &pevent->flags_offset,
-			      "common_flags");
-}
-
-static int parse_common_lock_depth(struct pevent *pevent, void *data)
-{
-	int ret;
-
-	ret = __parse_common(pevent, data,
-			     &pevent->ld_size, &pevent->ld_offset,
-			     "common_lock_depth");
-	if (ret < 0)
-		return -1;
-
-	return ret;
-}
-
-static int events_id_cmp(const void *a, const void *b);
-
-/**
- * pevent_find_event - find an event by given id
- * @pevent: a handle to the pevent
- * @id: the id of the event
- *
- * Returns an event that has a given @id.
- */
-struct event_format *pevent_find_event(struct pevent *pevent, int id)
-{
-	struct event_format **eventptr;
-	struct event_format key;
-	struct event_format *pkey = &key;
-
-	/* Check cache first */
-	if (pevent->last_event && pevent->last_event->id == id)
-		return pevent->last_event;
-
-	key.id = id;
-
-	eventptr = bsearch(&pkey, pevent->events, pevent->nr_events,
-			   sizeof(*pevent->events), events_id_cmp);
-
-	if (eventptr) {
-		pevent->last_event = *eventptr;
-		return *eventptr;
-	}
-
-	return NULL;
-}
-
-/**
- * pevent_find_event_by_name - find an event by given name
- * @pevent: a handle to the pevent
- * @sys: the system name to search for
- * @name: the name of the event to search for
- *
- * This returns an event with a given @name and under the system
- * @sys. If @sys is NULL the first event with @name is returned.
- */
-struct event_format *
-pevent_find_event_by_name(struct pevent *pevent,
-			  const char *sys, const char *name)
-{
-	struct event_format *event;
-	int i;
-
-	if (pevent->last_event &&
-	    strcmp(pevent->last_event->name, name) == 0 &&
-	    (!sys || strcmp(pevent->last_event->system, sys) == 0))
-		return pevent->last_event;
-
-	for (i = 0; i < pevent->nr_events; i++) {
-		event = pevent->events[i];
-		if (strcmp(event->name, name) == 0) {
-			if (!sys)
-				break;
-			if (strcmp(event->system, sys) == 0)
-				break;
-		}
-	}
-	if (i == pevent->nr_events)
-		event = NULL;
-
-	pevent->last_event = event;
-	return event;
-}
-
-static unsigned long long
-eval_num_arg(void *data, int size, struct event_format *event, struct print_arg *arg)
-{
-	struct pevent *pevent = event->pevent;
-	unsigned long long val = 0;
-	unsigned long long left, right;
-	struct print_arg *typearg = NULL;
-	struct print_arg *larg;
-	unsigned long offset;
-	unsigned int field_size;
-
-	switch (arg->type) {
-	case PRINT_NULL:
-		/* ?? */
-		return 0;
-	case PRINT_ATOM:
-		return strtoull(arg->atom.atom, NULL, 0);
-	case PRINT_FIELD:
-		if (!arg->field.field) {
-			arg->field.field = pevent_find_any_field(event, arg->field.name);
-			if (!arg->field.field)
-				die("field %s not found", arg->field.name);
-		}
-		/* must be a number */
-		val = pevent_read_number(pevent, data + arg->field.field->offset,
-				arg->field.field->size);
-		break;
-	case PRINT_FLAGS:
-	case PRINT_SYMBOL:
-		break;
-	case PRINT_TYPE:
-		val = eval_num_arg(data, size, event, arg->typecast.item);
-		return eval_type(val, arg, 0);
-	case PRINT_STRING:
-		return 0;
-	case PRINT_FUNC: {
-		struct trace_seq s;
-		trace_seq_init(&s);
-		return process_defined_func(&s, data, size, event, arg);
-	}
-	case PRINT_OP:
-		if (strcmp(arg->op.op, "[") == 0) {
-			/*
-			 * Arrays are special, since we don't want
-			 * to read the arg as is.
-			 */
-			right = eval_num_arg(data, size, event, arg->op.right);
-
-			/* handle typecasts */
-			larg = arg->op.left;
-			while (larg->type == PRINT_TYPE) {
-				if (!typearg)
-					typearg = larg;
-				larg = larg->typecast.item;
-			}
-
-			/* Default to long size */
-			field_size = pevent->long_size;
-
-			switch (larg->type) {
-			case PRINT_DYNAMIC_ARRAY:
-				offset = pevent_read_number(pevent,
-						   data + larg->dynarray.field->offset,
-						   larg->dynarray.field->size);
-				if (larg->dynarray.field->elementsize)
-					field_size = larg->dynarray.field->elementsize;
-				/*
-				 * The actual length of the dynamic array is stored
-				 * in the top half of the field, and the offset
-				 * is in the bottom half of the 32 bit field.
-				 */
-				offset &= 0xffff;
-				offset += right;
-				break;
-			case PRINT_FIELD:
-				if (!larg->field.field) {
-					larg->field.field =
-						pevent_find_any_field(event, larg->field.name);
-					if (!larg->field.field)
-						die("field %s not found", larg->field.name);
-				}
-				field_size = larg->field.field->elementsize;
-				offset = larg->field.field->offset +
-					right * larg->field.field->elementsize;
-				break;
-			default:
-				goto default_op; /* oops, all bets off */
-			}
-			val = pevent_read_number(pevent,
-						 data + offset, field_size);
-			if (typearg)
-				val = eval_type(val, typearg, 1);
-			break;
-		} else if (strcmp(arg->op.op, "?") == 0) {
-			left = eval_num_arg(data, size, event, arg->op.left);
-			arg = arg->op.right;
-			if (left)
-				val = eval_num_arg(data, size, event, arg->op.left);
-			else
-				val = eval_num_arg(data, size, event, arg->op.right);
-			break;
-		}
- default_op:
-		left = eval_num_arg(data, size, event, arg->op.left);
-		right = eval_num_arg(data, size, event, arg->op.right);
-		switch (arg->op.op[0]) {
-		case '|':
-			if (arg->op.op[1])
-				val = left || right;
-			else
-				val = left | right;
-			break;
-		case '&':
-			if (arg->op.op[1])
-				val = left && right;
-			else
-				val = left & right;
-			break;
-		case '<':
-			switch (arg->op.op[1]) {
-			case 0:
-				val = left < right;
-				break;
-			case '<':
-				val = left << right;
-				break;
-			case '=':
-				val = left <= right;
-				break;
-			default:
-				die("unknown op '%s'", arg->op.op);
-			}
-			break;
-		case '>':
-			switch (arg->op.op[1]) {
-			case 0:
-				val = left > right;
-				break;
-			case '>':
-				val = left >> right;
-				break;
-			case '=':
-				val = left >= right;
-				break;
-			default:
-				die("unknown op '%s'", arg->op.op);
-			}
-			break;
-		case '=':
-			if (arg->op.op[1] != '=')
-				die("unknown op '%s'", arg->op.op);
-			val = left == right;
-			break;
-		case '-':
-			val = left - right;
-			break;
-		case '+':
-			val = left + right;
-			break;
-		default:
-			die("unknown op '%s'", arg->op.op);
-		}
-		break;
-	default: /* not sure what to do there */
-		return 0;
-	}
-	return val;
-}
-
-struct flag {
-	const char *name;
-	unsigned long long value;
-};
-
-static const struct flag flags[] = {
-	{ "HI_SOFTIRQ", 0 },
-	{ "TIMER_SOFTIRQ", 1 },
-	{ "NET_TX_SOFTIRQ", 2 },
-	{ "NET_RX_SOFTIRQ", 3 },
-	{ "BLOCK_SOFTIRQ", 4 },
-	{ "BLOCK_IOPOLL_SOFTIRQ", 5 },
-	{ "TASKLET_SOFTIRQ", 6 },
-	{ "SCHED_SOFTIRQ", 7 },
-	{ "HRTIMER_SOFTIRQ", 8 },
-	{ "RCU_SOFTIRQ", 9 },
-
-	{ "HRTIMER_NORESTART", 0 },
-	{ "HRTIMER_RESTART", 1 },
-};
-
-static unsigned long long eval_flag(const char *flag)
-{
-	int i;
-
-	/*
-	 * Some flags in the format files do not get converted.
-	 * If the flag is not numeric, see if it is something that
-	 * we already know about.
-	 */
-	if (isdigit(flag[0]))
-		return strtoull(flag, NULL, 0);
-
-	for (i = 0; i < (int)(sizeof(flags)/sizeof(flags[0])); i++)
-		if (strcmp(flags[i].name, flag) == 0)
-			return flags[i].value;
-
-	return 0;
-}
-
-static void print_str_arg(struct trace_seq *s, void *data, int size,
-			  struct event_format *event, struct print_arg *arg)
-{
-	struct pevent *pevent = event->pevent;
-	struct print_flag_sym *flag;
-	unsigned long long val, fval;
-	unsigned long addr;
-	char *str;
-	int print;
-	int len;
-
-	switch (arg->type) {
-	case PRINT_NULL:
-		/* ?? */
-		return;
-	case PRINT_ATOM:
-		trace_seq_puts(s, arg->atom.atom);
-		return;
-	case PRINT_FIELD:
-		if (!arg->field.field) {
-			arg->field.field = pevent_find_any_field(event, arg->field.name);
-			if (!arg->field.field)
-				die("field %s not found", arg->field.name);
-		}
-		/* Zero sized fields, mean the rest of the data */
-		len = arg->field.field->size ? : size;
-
-		/*
-		 * Some events pass in pointers. If this is not an array
-		 * and the size is the same as long_size, assume that it
-		 * is a pointer.
-		 */
-		if (!(arg->field.field->flags & FIELD_IS_ARRAY) &&
-		    len == pevent->long_size) {
-			addr = *(unsigned long *)(data + arg->field.field->offset);
-			trace_seq_printf(s, "%lx", addr);
-			break;
-		}
-		str = malloc_or_die(len + 1);
-		memcpy(str, data + arg->field.field->offset, len);
-		str[len] = 0;
-		trace_seq_puts(s, str);
-		free(str);
-		break;
-	case PRINT_FLAGS:
-		val = eval_num_arg(data, size, event, arg->flags.field);
-		print = 0;
-		for (flag = arg->flags.flags; flag; flag = flag->next) {
-			fval = eval_flag(flag->value);
-			if (!val && !fval) {
-				trace_seq_puts(s, flag->str);
-				break;
-			}
-			if (fval && (val & fval) == fval) {
-				if (print && arg->flags.delim)
-					trace_seq_puts(s, arg->flags.delim);
-				trace_seq_puts(s, flag->str);
-				print = 1;
-				val &= ~fval;
-			}
-		}
-		break;
-	case PRINT_SYMBOL:
-		val = eval_num_arg(data, size, event, arg->symbol.field);
-		for (flag = arg->symbol.symbols; flag; flag = flag->next) {
-			fval = eval_flag(flag->value);
-			if (val == fval) {
-				trace_seq_puts(s, flag->str);
-				break;
-			}
-		}
-		break;
-
-	case PRINT_TYPE:
-		break;
-	case PRINT_STRING: {
-		int str_offset;
-
-		if (arg->string.offset == -1) {
-			struct format_field *f;
-
-			f = pevent_find_any_field(event, arg->string.string);
-			arg->string.offset = f->offset;
-		}
-		str_offset = data2host4(pevent, data + arg->string.offset);
-		str_offset &= 0xffff;
-		trace_seq_puts(s, ((char *)data) + str_offset);
-		break;
-	}
-	case PRINT_OP:
-		/*
-		 * The only op for string should be ? :
-		 */
-		if (arg->op.op[0] != '?')
-			return;
-		val = eval_num_arg(data, size, event, arg->op.left);
-		if (val)
-			print_str_arg(s, data, size, event, arg->op.right->op.left);
-		else
-			print_str_arg(s, data, size, event, arg->op.right->op.right);
-		break;
-	case PRINT_FUNC:
-		process_defined_func(s, data, size, event, arg);
-		break;
-	default:
-		/* well... */
-		break;
-	}
-}
-
-static unsigned long long
-process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct event_format *event, struct print_arg *arg)
-{
-	struct pevent_function_handler *func_handle = arg->func.func;
-	struct pevent_func_params *param;
-	unsigned long long *args;
-	unsigned long long ret;
-	struct print_arg *farg;
-	struct trace_seq str;
-	struct save_str {
-		struct save_str *next;
-		char *str;
-	} *strings = NULL, *string;
-	int i;
-
-	if (!func_handle->nr_args) {
-		ret = (*func_handle->func)(s, NULL);
-		goto out;
-	}
-
-	farg = arg->func.args;
-	param = func_handle->params;
-
-	args = malloc_or_die(sizeof(*args) * func_handle->nr_args);
-	for (i = 0; i < func_handle->nr_args; i++) {
-		switch (param->type) {
-		case PEVENT_FUNC_ARG_INT:
-		case PEVENT_FUNC_ARG_LONG:
-		case PEVENT_FUNC_ARG_PTR:
-			args[i] = eval_num_arg(data, size, event, farg);
-			break;
-		case PEVENT_FUNC_ARG_STRING:
-			trace_seq_init(&str);
-			print_str_arg(&str, data, size, event, farg);
-			trace_seq_terminate(&str);
-			string = malloc_or_die(sizeof(*string));
-			string->next = strings;
-			string->str = strdup(str.buffer);
-			strings = string;
-			break;
-		default:
-			/*
-			 * Something went totally wrong, this is not
-			 * an input error, something in this code broke.
-			 */
-			die("Unexpected end of arguments\n");
-			break;
-		}
-		farg = farg->next;
-	}
-
-	ret = (*func_handle->func)(s, args);
-	free(args);
-	while (strings) {
-		string = strings;
-		strings = string->next;
-		free(string->str);
-		free(string);
-	}
-
- out:
-	/* TBD : handle return type here */
-	return ret;
-}
-
-static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event_format *event)
-{
-	struct pevent *pevent = event->pevent;
-	struct format_field *field, *ip_field;
-	struct print_arg *args, *arg, **next;
-	unsigned long long ip, val;
-	char *ptr;
-	void *bptr;
-
-	field = pevent->bprint_buf_field;
-	ip_field = pevent->bprint_ip_field;
-
-	if (!field) {
-		field = pevent_find_field(event, "buf");
-		if (!field)
-			die("can't find buffer field for binary printk");
-		ip_field = pevent_find_field(event, "ip");
-		if (!ip_field)
-			die("can't find ip field for binary printk");
-		pevent->bprint_buf_field = field;
-		pevent->bprint_ip_field = ip_field;
-	}
-
-	ip = pevent_read_number(pevent, data + ip_field->offset, ip_field->size);
-
-	/*
-	 * The first arg is the IP pointer.
-	 */
-	args = alloc_arg();
-	arg = args;
-	arg->next = NULL;
-	next = &arg->next;
-
-	arg->type = PRINT_ATOM;
-	arg->atom.atom = malloc_or_die(32);
-	sprintf(arg->atom.atom, "%lld", ip);
-
-	/* skip the first "%pf : " */
-	for (ptr = fmt + 6, bptr = data + field->offset;
-	     bptr < data + size && *ptr; ptr++) {
-		int ls = 0;
-
-		if (*ptr == '%') {
- process_again:
-			ptr++;
-			switch (*ptr) {
-			case '%':
-				break;
-			case 'l':
-				ls++;
-				goto process_again;
-			case 'L':
-				ls = 2;
-				goto process_again;
-			case '0' ... '9':
-				goto process_again;
-			case 'p':
-				ls = 1;
-				/* fall through */
-			case 'd':
-			case 'u':
-			case 'x':
-			case 'i':
-				/* the pointers are always 4 bytes aligned */
-				bptr = (void *)(((unsigned long)bptr + 3) &
-						~3);
-				switch (ls) {
-				case 0:
-				case 1:
-					ls = pevent->long_size;
-					break;
-				case 2:
-					ls = 8;
-				default:
-					break;
-				}
-				val = pevent_read_number(pevent, bptr, ls);
-				bptr += ls;
-				arg = alloc_arg();
-				arg->next = NULL;
-				arg->type = PRINT_ATOM;
-				arg->atom.atom = malloc_or_die(32);
-				sprintf(arg->atom.atom, "%lld", val);
-				*next = arg;
-				next = &arg->next;
-				break;
-			case 's':
-				arg = alloc_arg();
-				arg->next = NULL;
-				arg->type = PRINT_STRING;
-				arg->string.string = strdup(bptr);
-				bptr += strlen(bptr) + 1;
-				*next = arg;
-				next = &arg->next;
-			default:
-				break;
-			}
-		}
-	}
-
-	return args;
-}
-
-static void free_args(struct print_arg *args)
-{
-	struct print_arg *next;
-
-	while (args) {
-		next = args->next;
-
-		free_arg(args);
-		args = next;
-	}
-}
-
-static char *
-get_bprint_format(void *data, int size __unused, struct event_format *event)
-{
-	struct pevent *pevent = event->pevent;
-	unsigned long long addr;
-	struct format_field *field;
-	struct printk_map *printk;
-	char *format;
-	char *p;
-
-	field = pevent->bprint_fmt_field;
-
-	if (!field) {
-		field = pevent_find_field(event, "fmt");
-		if (!field)
-			die("can't find format field for binary printk");
-		printf("field->offset = %d size=%d\n", field->offset, field->size);
-		pevent->bprint_fmt_field = field;
-	}
-
-	addr = pevent_read_number(pevent, data + field->offset, field->size);
-
-	printk = find_printk(pevent, addr);
-	if (!printk) {
-		format = malloc_or_die(45);
-		sprintf(format, "%%pf : (NO FORMAT FOUND at %llx)\n",
-			addr);
-		return format;
-	}
-
-	p = printk->printk;
-	/* Remove any quotes. */
-	if (*p == '"')
-		p++;
-	format = malloc_or_die(strlen(p) + 10);
-	sprintf(format, "%s : %s", "%pf", p);
-	/* remove ending quotes and new line since we will add one too */
-	p = format + strlen(format) - 1;
-	if (*p == '"')
-		*p = 0;
-
-	p -= 2;
-	if (strcmp(p, "\\n") == 0)
-		*p = 0;
-
-	return format;
-}
-
-static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
-			  struct event_format *event, struct print_arg *arg)
-{
-	unsigned char *buf;
-	char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
-
-	if (arg->type == PRINT_FUNC) {
-		process_defined_func(s, data, size, event, arg);
-		return;
-	}
-
-	if (arg->type != PRINT_FIELD) {
-		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d",
-				 arg->type);
-		return;
-	}
-
-	if (mac == 'm')
-		fmt = "%.2x%.2x%.2x%.2x%.2x%.2x";
-	if (!arg->field.field) {
-		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
-		if (!arg->field.field)
-			die("field %s not found", arg->field.name);
-	}
-	if (arg->field.field->size != 6) {
-		trace_seq_printf(s, "INVALIDMAC");
-		return;
-	}
-	buf = data + arg->field.field->offset;
-	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
-}
-
-static void print_event_fields(struct trace_seq *s, void *data, int size,
-			       struct event_format *event)
-{
-	struct format_field *field;
-	unsigned long long val;
-	unsigned int offset, len, i;
-
-	field = event->format.fields;
-	while (field) {
-		trace_seq_printf(s, " %s=", field->name);
-		if (field->flags & FIELD_IS_ARRAY) {
-			offset = field->offset;
-			len = field->size;
-			if (field->flags & FIELD_IS_DYNAMIC) {
-				val = pevent_read_number(event->pevent, data + offset, len);
-				offset = val;
-				len = offset >> 16;
-				offset &= 0xffff;
-			}
-			if (field->flags & FIELD_IS_STRING) {
-				trace_seq_printf(s, "%s", (char *)data + offset);
-			} else {
-				trace_seq_puts(s, "ARRAY[");
-				for (i = 0; i < len; i++) {
-					if (i)
-						trace_seq_puts(s, ", ");
-					trace_seq_printf(s, "%02x",
-							 *((unsigned char *)data + offset + i));
-				}
-				trace_seq_putc(s, ']');
-			}
-		} else {
-			val = pevent_read_number(event->pevent, data + field->offset,
-						 field->size);
-			if (field->flags & FIELD_IS_POINTER) {
-				trace_seq_printf(s, "0x%llx", val);
-			} else if (field->flags & FIELD_IS_SIGNED) {
-				switch (field->size) {
-				case 4:
-					/*
-					 * If field is long then print it in hex.
-					 * A long usually stores pointers.
-					 */
-					if (field->flags & FIELD_IS_LONG)
-						trace_seq_printf(s, "0x%x", (int)val);
-					else
-						trace_seq_printf(s, "%d", (int)val);
-					break;
-				case 2:
-					trace_seq_printf(s, "%2d", (short)val);
-					break;
-				case 1:
-					trace_seq_printf(s, "%1d", (char)val);
-					break;
-				default:
-					trace_seq_printf(s, "%lld", val);
-				}
-			} else {
-				if (field->flags & FIELD_IS_LONG)
-					trace_seq_printf(s, "0x%llx", val);
-				else
-					trace_seq_printf(s, "%llu", val);
-			}
-		}
-		field = field->next;
-	}
-}
-
-static void pretty_print(struct trace_seq *s, void *data, int size, struct event_format *event)
-{
-	struct pevent *pevent = event->pevent;
-	struct print_fmt *print_fmt = &event->print_fmt;
-	struct print_arg *arg = print_fmt->args;
-	struct print_arg *args = NULL;
-	const char *ptr = print_fmt->format;
-	unsigned long long val;
-	struct func_map *func;
-	const char *saveptr;
-	char *bprint_fmt = NULL;
-	char format[32];
-	int show_func;
-	int len;
-	int ls;
-
-	if (event->flags & EVENT_FL_FAILED) {
-		trace_seq_printf(s, "[FAILED TO PARSE]");
-		print_event_fields(s, data, size, event);
-		return;
-	}
-
-	if (event->flags & EVENT_FL_ISBPRINT) {
-		bprint_fmt = get_bprint_format(data, size, event);
-		args = make_bprint_args(bprint_fmt, data, size, event);
-		arg = args;
-		ptr = bprint_fmt;
-	}
-
-	for (; *ptr; ptr++) {
-		ls = 0;
-		if (*ptr == '\\') {
-			ptr++;
-			switch (*ptr) {
-			case 'n':
-				trace_seq_putc(s, '\n');
-				break;
-			case 't':
-				trace_seq_putc(s, '\t');
-				break;
-			case 'r':
-				trace_seq_putc(s, '\r');
-				break;
-			case '\\':
-				trace_seq_putc(s, '\\');
-				break;
-			default:
-				trace_seq_putc(s, *ptr);
-				break;
-			}
-
-		} else if (*ptr == '%') {
-			saveptr = ptr;
-			show_func = 0;
- cont_process:
-			ptr++;
-			switch (*ptr) {
-			case '%':
-				trace_seq_putc(s, '%');
-				break;
-			case '#':
-				/* FIXME: need to handle properly */
-				goto cont_process;
-			case 'l':
-				ls++;
-				goto cont_process;
-			case 'L':
-				ls = 2;
-				goto cont_process;
-			case '.':
-			case 'z':
-			case 'Z':
-			case '0' ... '9':
-				goto cont_process;
-			case 'p':
-				if (pevent->long_size == 4)
-					ls = 1;
-				else
-					ls = 2;
-
-				if (*(ptr+1) == 'F' ||
-				    *(ptr+1) == 'f') {
-					ptr++;
-					show_func = *ptr;
-				} else if (*(ptr+1) == 'M' || *(ptr+1) == 'm') {
-					print_mac_arg(s, *(ptr+1), data, size, event, arg);
-					ptr++;
-					break;
-				}
-
-				/* fall through */
-			case 'd':
-			case 'i':
-			case 'x':
-			case 'X':
-			case 'u':
-				if (!arg)
-					die("no argument match");
-
-				len = ((unsigned long)ptr + 1) -
-					(unsigned long)saveptr;
-
-				/* should never happen */
-				if (len > 32)
-					die("bad format!");
-
-				memcpy(format, saveptr, len);
-				format[len] = 0;
-
-				val = eval_num_arg(data, size, event, arg);
-				arg = arg->next;
-
-				if (show_func) {
-					func = find_func(pevent, val);
-					if (func) {
-						trace_seq_puts(s, func->func);
-						if (show_func == 'F')
-							trace_seq_printf(s,
-							       "+0x%llx",
-							       val - func->addr);
-						break;
-					}
-				}
-				if (pevent->long_size == 8 && ls) {
-					char *p;
-
-					ls = 2;
-					/* make %l into %ll */
-					p = strchr(format, 'l');
-					if (p)
-						memmove(p, p+1, strlen(p)+1);
-					else if (strcmp(format, "%p") == 0)
-						strcpy(format, "0x%llx");
-				}
-				switch (ls) {
-				case 0:
-					trace_seq_printf(s, format, (int)val);
-					break;
-				case 1:
-					trace_seq_printf(s, format, (long)val);
-					break;
-				case 2:
-					trace_seq_printf(s, format, (long long)val);
-					break;
-				default:
-					die("bad count (%d)", ls);
-				}
-				break;
-			case 's':
-				if (!arg)
-					die("no matching argument");
-
-				print_str_arg(s, data, size, event, arg);
-				arg = arg->next;
-				break;
-			default:
-				trace_seq_printf(s, ">%c<", *ptr);
-
-			}
-		} else
-			trace_seq_putc(s, *ptr);
-	}
-
-	if (args) {
-		free_args(args);
-		free(bprint_fmt);
-	}
-}
-
-/**
- * pevent_data_lat_fmt - parse the data for the latency format
- * @pevent: a handle to the pevent
- * @s: the trace_seq to write to
- * @data: the raw data to read from
- * @size: currently unused.
- *
- * This parses out the Latency format (interrupts disabled,
- * need rescheduling, in hard/soft interrupt, preempt count
- * and lock depth) and places it into the trace_seq.
- */
-void pevent_data_lat_fmt(struct pevent *pevent,
-			 struct trace_seq *s, struct record *record)
-{
-	static int check_lock_depth = 1;
-	static int lock_depth_exists;
-	unsigned int lat_flags;
-	unsigned int pc;
-	int lock_depth;
-	int hardirq;
-	int softirq;
-	void *data = record->data;
-
-	lat_flags = parse_common_flags(pevent, data);
-	pc = parse_common_pc(pevent, data);
-	/* lock_depth may not always exist */
-	if (check_lock_depth) {
-		struct format_field *field;
-		struct event_format *event;
-
-		check_lock_depth = 0;
-		event = pevent->events[0];
-		field = pevent_find_common_field(event, "common_lock_depth");
-		if (field)
-			lock_depth_exists = 1;
-	}
-	if (lock_depth_exists)
-		lock_depth = parse_common_lock_depth(pevent, data);
-
-	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
-	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
-
-	trace_seq_printf(s, "%c%c%c",
-	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
-	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
-	       'X' : '.',
-	       (lat_flags & TRACE_FLAG_NEED_RESCHED) ?
-	       'N' : '.',
-	       (hardirq && softirq) ? 'H' :
-	       hardirq ? 'h' : softirq ? 's' : '.');
-
-	if (pc)
-		trace_seq_printf(s, "%x", pc);
-	else
-		trace_seq_putc(s, '.');
-
-	if (lock_depth_exists) {
-		if (lock_depth < 0)
-			trace_seq_putc(s, '.');
-		else
-			trace_seq_printf(s, "%d", lock_depth);
-	}
-
-	trace_seq_terminate(s);
-}
-
-/**
- * pevent_data_type - parse out the given event type
- * @pevent: a handle to the pevent
- * @rec: the record to read from
- *
- * This returns the event id from the @rec.
- */
-int pevent_data_type(struct pevent *pevent, struct record *rec)
-{
-	return trace_parse_common_type(pevent, rec->data);
-}
-
-/**
- * pevent_data_event_from_type - find the event by a given type
- * @pevent: a handle to the pevent
- * @type: the type of the event.
- *
- * This returns the event form a given @type;
- */
-struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type)
-{
-	return pevent_find_event(pevent, type);
-}
-
-/**
- * pevent_data_pid - parse the PID from raw data
- * @pevent: a handle to the pevent
- * @rec: the record to parse
- *
- * This returns the PID from a raw data.
- */
-int pevent_data_pid(struct pevent *pevent, struct record *rec)
-{
-	return parse_common_pid(pevent, rec->data);
-}
-
-/**
- * pevent_data_comm_from_pid - return the command line from PID
- * @pevent: a handle to the pevent
- * @pid: the PID of the task to search for
- *
- * This returns a pointer to the command line that has the given
- * @pid.
- */
-const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid)
-{
-	const char *comm;
-
-	comm = find_cmdline(pevent, pid);
-	return comm;
-}
-
-/**
- * pevent_data_comm_from_pid - parse the data into the print format
- * @s: the trace_seq to write to
- * @event: the handle to the event
- * @cpu: the cpu the event was recorded on
- * @data: the raw data
- * @size: the size of the raw data
- * @nsecs: the timestamp of the event
- *
- * This parses the raw @data using the given @event information and
- * writes the print format into the trace_seq.
- */
-void pevent_event_info(struct trace_seq *s, struct event_format *event,
-		       struct record *record)
-{
-	int print_pretty = 1;
-
-	if (event->pevent->print_raw)
-		print_event_fields(s, record->data, record->size, event);
-	else {
-
-		if (event->handler)
-			print_pretty = event->handler(s, record, event,
-						      event->context);
-
-		if (print_pretty)
-			pretty_print(s, record->data, record->size, event);
-	}
-
-	trace_seq_terminate(s);
-}
-
-void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
-			struct record *record)
-{
-	static char *spaces = "                    "; /* 20 spaces */
-	struct event_format *event;
-	unsigned long secs;
-	unsigned long usecs;
-	const char *comm;
-	void *data = record->data;
-	int type;
-	int pid;
-	int len;
-
-	secs = record->ts / NSECS_PER_SEC;
-	usecs = record->ts - secs * NSECS_PER_SEC;
-	usecs = (usecs + 500) / NSECS_PER_USEC;
-
-	type = trace_parse_common_type(pevent, data);
-
-	event = pevent_find_event(pevent, type);
-	if (!event) {
-		do_warning("ug! no event found for type %d", type);
-		return;
-	}
-
-	pid = parse_common_pid(pevent, data);
-	comm = find_cmdline(pevent, pid);
-
-	if (pevent->latency_format) {
-		trace_seq_printf(s, "%8.8s-%-5d %3d",
-		       comm, pid, record->cpu);
-		pevent_data_lat_fmt(pevent, s, record);
-	} else
-		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
-
-	trace_seq_printf(s, " %5lu.%06lu: %s: ", secs, usecs, event->name);
-
-	/* Space out the event names evenly. */
-	len = strlen(event->name);
-	if (len < 20)
-		trace_seq_printf(s, "%.*s", 20 - len, spaces);
-
-	pevent_event_info(s, event, record);
-}
-
-static int events_id_cmp(const void *a, const void *b)
-{
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
-
-	if ((*ea)->id < (*eb)->id)
-		return -1;
-
-	if ((*ea)->id > (*eb)->id)
-		return 1;
-
-	return 0;
-}
-
-static int events_name_cmp(const void *a, const void *b)
-{
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
-	int res;
-
-	res = strcmp((*ea)->name, (*eb)->name);
-	if (res)
-		return res;
-
-	res = strcmp((*ea)->system, (*eb)->system);
-	if (res)
-		return res;
-
-	return events_id_cmp(a, b);
-}
-
-static int events_system_cmp(const void *a, const void *b)
-{
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
-	int res;
-
-	res = strcmp((*ea)->system, (*eb)->system);
-	if (res)
-		return res;
-
-	res = strcmp((*ea)->name, (*eb)->name);
-	if (res)
-		return res;
-
-	return events_id_cmp(a, b);
-}
-
-struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type sort_type)
-{
-	struct event_format **events;
-	int (*sort)(const void *a, const void *b);
-
-	events = pevent->sort_events;
-
-	if (events && pevent->last_type == sort_type)
-		return events;
-
-	if (!events) {
-		events = malloc(sizeof(*events) * (pevent->nr_events + 1));
-		if (!events)
-			return NULL;
-
-		memcpy(events, pevent->events, sizeof(*events) * pevent->nr_events);
-		events[pevent->nr_events] = NULL;
-
-		pevent->sort_events = events;
-
-		/* the internal events are sorted by id */
-		if (sort_type == EVENT_SORT_ID) {
-			pevent->last_type = sort_type;
-			return events;
-		}
-	}
-
-	switch (sort_type) {
-	case EVENT_SORT_ID:
-		sort = events_id_cmp;
-		break;
-	case EVENT_SORT_NAME:
-		sort = events_name_cmp;
-		break;
-	case EVENT_SORT_SYSTEM:
-		sort = events_system_cmp;
-		break;
-	default:
-		return events;
-	}
-
-	qsort(events, pevent->nr_events, sizeof(*events), sort);
-	pevent->last_type = sort_type;
-
-	return events;
-}
-
-static struct format_field **
-get_event_fields(const char *type, const char *name,
-		 int count, struct format_field *list)
-{
-	struct format_field **fields;
-	struct format_field *field;
-	int i = 0;
-
-	fields = malloc_or_die(sizeof(*fields) * (count + 1));
-	for (field = list; field; field = field->next) {
-		fields[i++] = field;
-		if (i == count + 1) {
-			do_warning("event %s has more %s fields than specified",
-				name, type);
-			i--;
-			break;
-		}
-	}
-
-	if (i != count)
-		do_warning("event %s has less %s fields than specified",
-			name, type);
-
-	fields[i] = NULL;
-
-	return fields;
-}
-
-/**
- * pevent_event_common_fields - return a list of common fields for an event
- * @event: the event to return the common fields of.
- *
- * Returns an allocated array of fields. The last item in the array is NULL.
- * The array must be freed with free().
- */
-struct format_field **pevent_event_common_fields(struct event_format *event)
-{
-	return get_event_fields("common", event->name,
-				event->format.nr_common,
-				event->format.common_fields);
-}
-
-/**
- * pevent_event_fields - return a list of event specific fields for an event
- * @event: the event to return the fields of.
- *
- * Returns an allocated array of fields. The last item in the array is NULL.
- * The array must be freed with free().
- */
-struct format_field **pevent_event_fields(struct event_format *event)
-{
-	return get_event_fields("event", event->name,
-				event->format.nr_fields,
-				event->format.fields);
-}
-
-static void print_fields(struct trace_seq *s, struct print_flag_sym *field)
-{
-	trace_seq_printf(s, "{ %s, %s }", field->value, field->str);
-	if (field->next) {
-		trace_seq_puts(s, ", ");
-		print_fields(s, field->next);
-	}
-}
-
-/* for debugging */
-static void print_args(struct print_arg *args)
-{
-	int print_paren = 1;
-	struct trace_seq s;
-
-	switch (args->type) {
-	case PRINT_NULL:
-		printf("null");
-		break;
-	case PRINT_ATOM:
-		printf("%s", args->atom.atom);
-		break;
-	case PRINT_FIELD:
-		printf("REC->%s", args->field.name);
-		break;
-	case PRINT_FLAGS:
-		printf("__print_flags(");
-		print_args(args->flags.field);
-		printf(", %s, ", args->flags.delim);
-		trace_seq_init(&s);
-		print_fields(&s, args->flags.flags);
-		trace_seq_do_printf(&s);
-		printf(")");
-		break;
-	case PRINT_SYMBOL:
-		printf("__print_symbolic(");
-		print_args(args->symbol.field);
-		printf(", ");
-		trace_seq_init(&s);
-		print_fields(&s, args->symbol.symbols);
-		trace_seq_do_printf(&s);
-		printf(")");
-		break;
-	case PRINT_STRING:
-		printf("__get_str(%s)", args->string.string);
-		break;
-	case PRINT_TYPE:
-		printf("(%s)", args->typecast.type);
-		print_args(args->typecast.item);
-		break;
-	case PRINT_OP:
-		if (strcmp(args->op.op, ":") == 0)
-			print_paren = 0;
-		if (print_paren)
-			printf("(");
-		print_args(args->op.left);
-		printf(" %s ", args->op.op);
-		print_args(args->op.right);
-		if (print_paren)
-			printf(")");
-		break;
-	default:
-		/* we should warn... */
-		return;
-	}
-	if (args->next) {
-		printf("\n");
-		print_args(args->next);
-	}
-}
-
-static void parse_header_field(const char *field,
-			       int *offset, int *size, int mandatory)
-{
-	unsigned long long save_input_buf_ptr;
-	unsigned long long save_input_buf_siz;
-	char *token;
-	int type;
-
-	save_input_buf_ptr = input_buf_ptr;
-	save_input_buf_siz = input_buf_siz;
-
-	if (read_expected(EVENT_ITEM, "field") < 0)
-		return;
-	if (read_expected(EVENT_OP, ":") < 0)
-		return;
-
-	/* type */
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-	free_token(token);
-
-	/*
-	 * If this is not a mandatory field, then test it first.
-	 */
-	if (mandatory) {
-		if (read_expected(EVENT_ITEM, field) < 0)
-			return;
-	} else {
-		if (read_expect_type(EVENT_ITEM, &token) < 0)
-			goto fail;
-		if (strcmp(token, field) != 0)
-			goto discard;
-		free_token(token);
-	}
-
-	if (read_expected(EVENT_OP, ";") < 0)
-		return;
-	if (read_expected(EVENT_ITEM, "offset") < 0)
-		return;
-	if (read_expected(EVENT_OP, ":") < 0)
-		return;
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-	*offset = atoi(token);
-	free_token(token);
-	if (read_expected(EVENT_OP, ";") < 0)
-		return;
-	if (read_expected(EVENT_ITEM, "size") < 0)
-		return;
-	if (read_expected(EVENT_OP, ":") < 0)
-		return;
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-	*size = atoi(token);
-	free_token(token);
-	if (read_expected(EVENT_OP, ";") < 0)
-		return;
-	type = read_token(&token);
-	if (type != EVENT_NEWLINE) {
-		/* newer versions of the kernel have a "signed" type */
-		if (type != EVENT_ITEM)
-			goto fail;
-
-		if (strcmp(token, "signed") != 0)
-			goto fail;
-
-		free_token(token);
-
-		if (read_expected(EVENT_OP, ":") < 0)
-			return;
-
-		if (read_expect_type(EVENT_ITEM, &token))
-			goto fail;
-
-		free_token(token);
-		if (read_expected(EVENT_OP, ";") < 0)
-			return;
-
-		if (read_expect_type(EVENT_NEWLINE, &token))
-			goto fail;
-	}
- fail:
-	free_token(token);
-	return;
-
- discard:
-	input_buf_ptr = save_input_buf_ptr;
-	input_buf_siz = save_input_buf_siz;
-	*offset = 0;
-	*size = 0;
-	free_token(token);
-}
-
-/**
- * pevent_parse_header_page - parse the data stored in the header page
- * @pevent: the handle to the pevent
- * @buf: the buffer storing the header page format string
- * @size: the size of @buf
- * @long_size: the long size to use if there is no header
- *
- * This parses the header page format for information on the
- * ring buffer used. The @buf should be copied from
- *
- * /sys/kernel/debug/tracing/events/header_page
- */
-int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
-			     int long_size)
-{
-	int ignore;
-
-	if (!size) {
-		/*
-		 * Old kernels did not have header page info.
-		 * Sorry but we just use what we find here in user space.
-		 */
-		pevent->header_page_ts_size = sizeof(long long);
-		pevent->header_page_size_size = long_size;
-		pevent->header_page_data_offset = sizeof(long long) + long_size;
-		pevent->old_format = 1;
-		return -1;
-	}
-	init_input_buf(buf, size);
-
-	parse_header_field("timestamp", &pevent->header_page_ts_offset,
-			   &pevent->header_page_ts_size, 1);
-	parse_header_field("commit", &pevent->header_page_size_offset,
-			   &pevent->header_page_size_size, 1);
-	parse_header_field("overwrite", &pevent->header_page_overwrite,
-			   &ignore, 0);
-	parse_header_field("data", &pevent->header_page_data_offset,
-			   &pevent->header_page_data_size, 1);
-
-	return 0;
-}
-
-static int event_matches(struct event_format *event,
-			 int id, const char *sys_name,
-			 const char *event_name)
-{
-	if (id >= 0 && id != event->id)
-		return 0;
-
-	if (event_name && (strcmp(event_name, event->name) != 0))
-		return 0;
-
-	if (sys_name && (strcmp(sys_name, event->system) != 0))
-		return 0;
-
-	return 1;
-}
-
-static void free_handler(struct event_handler *handle)
-{
-	free((void *)handle->sys_name);
-	free((void *)handle->event_name);
-	free(handle);
-}
-
-static int find_event_handle(struct pevent *pevent, struct event_format *event)
-{
-	struct event_handler *handle, **next;
-
-	for (next = &pevent->handlers; *next;
-	     next = &(*next)->next) {
-		handle = *next;
-		if (event_matches(event, handle->id,
-				  handle->sys_name,
-				  handle->event_name))
-			break;
-	}
-
-	if (!(*next))
-		return 0;
-
-	pr_stat("overriding event (%d) %s:%s with new print handler",
-		event->id, event->system, event->name);
-
-	event->handler = handle->func;
-	event->context = handle->context;
-
-	*next = handle->next;
-	free_handler(handle);
-
-	return 1;
-}
-
-/**
- * pevent_parse_event - parse the event format
- * @pevent: the handle to the pevent
- * @buf: the buffer storing the event format string
- * @size: the size of @buf
- * @sys: the system the event belongs to
- *
- * This parses the event format and creates an event structure
- * to quickly parse raw data for a given event.
- *
- * These files currently come from:
- *
- * /sys/kernel/debug/tracing/events/.../.../format
- */
-int pevent_parse_event(struct pevent *pevent,
-		       const char *buf, unsigned long size,
-		       const char *sys)
-{
-	struct event_format *event;
-	int ret;
-
-	init_input_buf(buf, size);
-
-	event = alloc_event();
-	if (!event)
-		return -ENOMEM;
-
-	event->name = event_read_name();
-	if (!event->name) {
-		/* Bad event? */
-		free(event);
-		return -1;
-	}
-
-	if (strcmp(sys, "ftrace") == 0) {
-
-		event->flags |= EVENT_FL_ISFTRACE;
-
-		if (strcmp(event->name, "bprint") == 0)
-			event->flags |= EVENT_FL_ISBPRINT;
-	}
-		
-	event->id = event_read_id();
-	if (event->id < 0)
-		die("failed to read event id");
-
-	event->system = strdup(sys);
-
-	/* Add pevent to event so that it can be referenced */
-	event->pevent = pevent;
-
-	ret = event_read_format(event);
-	if (ret < 0) {
-		do_warning("failed to read event format for %s", event->name);
-		goto event_failed;
-	}
-
-	/*
-	 * If the event has an override, don't print warnings if the event
-	 * print format fails to parse.
-	 */
-	if (find_event_handle(pevent, event))
-		show_warning = 0;
-
-	ret = event_read_print(event);
-	if (ret < 0) {
-		do_warning("failed to read event print fmt for %s",
-			   event->name);
-		show_warning = 1;
-		goto event_failed;
-	}
-	show_warning = 1;
-
-	add_event(pevent, event);
-
-	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
-		struct format_field *field;
-		struct print_arg *arg, **list;
-
-		/* old ftrace had no args */
-
-		list = &event->print_fmt.args;
-		for (field = event->format.fields; field; field = field->next) {
-			arg = alloc_arg();
-			*list = arg;
-			list = &arg->next;
-			arg->type = PRINT_FIELD;
-			arg->field.name = strdup(field->name);
-			arg->field.field = field;
-		}
-		return 0;
-	}
-
-#define PRINT_ARGS 0
-	if (PRINT_ARGS && event->print_fmt.args)
-		print_args(event->print_fmt.args);
-
-	return 0;
-
- event_failed:
-	event->flags |= EVENT_FL_FAILED;
-	/* still add it even if it failed */
-	add_event(pevent, event);
-	return -1;
-}
-
-static void free_func_handle(struct pevent_function_handler *func)
-{
-	struct pevent_func_params *params;
-
-	free(func->name);
-
-	while (func->params) {
-		params = func->params;
-		func->params = params->next;
-		free(params);
-	}
-
-	free(func);
-}
-
-/**
- * pevent_register_print_function - register a helper function
- * @pevent: the handle to the pevent
- * @func: the function to process the helper function
- * @name: the name of the helper function
- * @parameters: A list of enum pevent_func_arg_type
- *
- * Some events may have helper functions in the print format arguments.
- * This allows a plugin to dynmically create a way to process one
- * of these functions.
- *
- * The @parameters is a variable list of pevent_func_arg_type enums that
- * must end with PEVENT_FUNC_ARG_VOID.
- */
-int pevent_register_print_function(struct pevent *pevent,
-				   pevent_func_handler func,
-				   enum pevent_func_arg_type ret_type,
-				   char *name, ...)
-{
-	struct pevent_function_handler *func_handle;
-	struct pevent_func_params **next_param;
-	struct pevent_func_params *param;
-	enum pevent_func_arg_type type;
-	va_list ap;
-
-	func_handle = find_func_handler(pevent, name);
-	if (func_handle) {
-		/*
-		 * This is most like caused by the users own
-		 * plugins updating the function. This overrides the
-		 * system defaults.
-		 */
-		pr_stat("override of function helper '%s'", name);
-		remove_func_handler(pevent, name);
-	}
-
-	func_handle = malloc_or_die(sizeof(*func_handle));
-	memset(func_handle, 0, sizeof(*func_handle));
-
-	func_handle->ret_type = ret_type;
-	func_handle->name = strdup(name);
-	func_handle->func = func;
-	if (!func_handle->name)
-		die("Failed to allocate function name");
-
-	next_param = &(func_handle->params);
-	va_start(ap, name);
-	for (;;) {
-		type = va_arg(ap, enum pevent_func_arg_type);
-		if (type == PEVENT_FUNC_ARG_VOID)
-			break;
-
-		if (type < 0 || type >= PEVENT_FUNC_ARG_MAX_TYPES) {
-			warning("Invalid argument type %d", type);
-			goto out_free;
-		}
-
-		param = malloc_or_die(sizeof(*param));
-		param->type = type;
-		param->next = NULL;
-
-		*next_param = param;
-		next_param = &(param->next);
-
-		func_handle->nr_args++;
-	}
-	va_end(ap);
-
-	func_handle->next = pevent->func_handlers;
-	pevent->func_handlers = func_handle;
-
-	return 0;
- out_free:
-	va_end(ap);
-	free_func_handle(func_handle);
-	return -1;
-}
-
-/**
- * pevent_register_event_handle - register a way to parse an event
- * @pevent: the handle to the pevent
- * @id: the id of the event to register
- * @sys_name: the system name the event belongs to
- * @event_name: the name of the event
- * @func: the function to call to parse the event information
- *
- * This function allows a developer to override the parsing of
- * a given event. If for some reason the default print format
- * is not sufficient, this function will register a function
- * for an event to be used to parse the data instead.
- *
- * If @id is >= 0, then it is used to find the event.
- * else @sys_name and @event_name are used.
- */
-int pevent_register_event_handler(struct pevent *pevent,
-				  int id, char *sys_name, char *event_name,
-				  pevent_event_handler_func func,
-				  void *context)
-{
-	struct event_format *event;
-	struct event_handler *handle;
-
-	if (id >= 0) {
-		/* search by id */
-		event = pevent_find_event(pevent, id);
-		if (!event)
-			goto not_found;
-		if (event_name && (strcmp(event_name, event->name) != 0))
-			goto not_found;
-		if (sys_name && (strcmp(sys_name, event->system) != 0))
-			goto not_found;
-	} else {
-		event = pevent_find_event_by_name(pevent, sys_name, event_name);
-		if (!event)
-			goto not_found;
-	}
-
-	pr_stat("overriding event (%d) %s:%s with new print handler",
-		event->id, event->system, event->name);
-
-	event->handler = func;
-	event->context = context;
-	return 0;
-
- not_found:
-	/* Save for later use. */
-	handle = malloc_or_die(sizeof(*handle));
-	memset(handle, 0, sizeof(handle));
-	handle->id = id;
-	if (event_name)
-		handle->event_name = strdup(event_name);
-	if (sys_name)
-		handle->sys_name = strdup(sys_name);
-
-	handle->func = func;
-	handle->next = pevent->handlers;
-	pevent->handlers = handle;
-	handle->context = context;
-
-	return -1;
-}
-
-/**
- * pevent_alloc - create a pevent handle
- */
-struct pevent *pevent_alloc(void)
-{
-	struct pevent *pevent;
-
-	pevent = malloc(sizeof(*pevent));
-	if (!pevent)
-		return NULL;
-	memset(pevent, 0, sizeof(*pevent));
-	pevent->ref_count = 1;
-
-	return pevent;
-}
-
-void pevent_ref(struct pevent *pevent)
-{
-	pevent->ref_count++;
-}
-
-static void free_format_fields(struct format_field *field)
-{
-	struct format_field *next;
-
-	while (field) {
-		next = field->next;
-		free(field->type);
-		free(field->name);
-		free(field);
-		field = next;
-	}
-}
-
-static void free_formats(struct format *format)
-{
-	free_format_fields(format->common_fields);
-	free_format_fields(format->fields);
-}
-
-static void free_event(struct event_format *event)
-{
-	free(event->name);
-	free(event->system);
-
-	free_formats(&event->format);
-
-	free(event->print_fmt.format);
-	free_args(event->print_fmt.args);
-
-	free(event);
-}
-
-/**
- * pevent_free - free a pevent handle
- * @pevent: the pevent handle to free
- */
-void pevent_free(struct pevent *pevent)
-{
-	struct cmdline_list *cmdlist = pevent->cmdlist, *cmdnext;
-	struct func_list *funclist = pevent->funclist, *funcnext;
-	struct printk_list *printklist = pevent->printklist, *printknext;
-	struct pevent_function_handler *func_handler;
-	struct event_handler *handle;
-	int i;
-
-	pevent->ref_count--;
-	if (pevent->ref_count)
-		return;
-
-	if (pevent->cmdlines) {
-		for (i = 0; i < pevent->cmdline_count; i++)
-			free(pevent->cmdlines[i].comm);
-		free(pevent->cmdlines);
-	}
-
-	while (cmdlist) {
-		cmdnext = cmdlist->next;
-		free(cmdlist->comm);
-		free(cmdlist);
-		cmdlist = cmdnext;
-	}
-
-	if (pevent->func_map) {
-		for (i = 0; i < pevent->func_count; i++) {
-			free(pevent->func_map[i].func);
-			free(pevent->func_map[i].mod);
-		}
-		free(pevent->func_map);
-	}
-
-	while (funclist) {
-		funcnext = funclist->next;
-		free(funclist->func);
-		free(funclist->mod);
-		free(funclist);
-		funclist = funcnext;
-	}
-
-	while (pevent->func_handlers) {
-		func_handler = pevent->func_handlers;
-		pevent->func_handlers = func_handler->next;
-		free_func_handle(func_handler);
-	}
-
-	if (pevent->printk_map) {
-		for (i = 0; i < pevent->printk_count; i++)
-			free(pevent->printk_map[i].printk);
-		free(pevent->printk_map);
-	}
-
-	while (printklist) {
-		printknext = printklist->next;
-		free(printklist->printk);
-		free(printklist);
-		printklist = printknext;
-	}
-
-	for (i = 0; i < pevent->nr_events; i++)
-		free_event(pevent->events[i]);
-
-	while (pevent->handlers) {
-		handle = pevent->handlers;
-		pevent->handlers = handle->next;
-		free_handler(handle);
-	}
-
-	free(pevent->events);
-	free(pevent->sort_events);
-
-	free(pevent);
-}
-
-void pevent_unref(struct pevent *pevent)
-{
-	pevent_free(pevent);
-}
diff --git a/tools/lib/parse-events.h b/tools/lib/parse-events.h
deleted file mode 100644
index 5c10208..0000000
--- a/tools/lib/parse-events.h
+++ /dev/null
@@ -1,719 +0,0 @@
-/*
- * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-#ifndef _PARSE_EVENTS_H
-#define _PARSE_EVENTS_H
-
-#include <stdarg.h>
-#include <regex.h>
-
-#ifndef __unused
-#define __unused __attribute__ ((unused))
-#endif
-
-/* ----------------------- trace_seq ----------------------- */
-
-
-#ifndef TRACE_SEQ_SIZE
-#define TRACE_SEQ_SIZE 4096
-#endif
-
-struct record {
-	unsigned long long	ts;
-	unsigned long long	offset;
-	long long		missed_events;	/* buffer dropped events before */
-	int			record_size;	/* size of binary record */
-	int			size;		/* size of data */
-	void			*data;
-	int			cpu;
-	int			ref_count;
-	int			locked;		/* Do not free, even if ref_count is zero */
-	void			*private;
-};
-
-/*
- * Trace sequences are used to allow a function to call several other functions
- * to create a string of data to use (up to a max of PAGE_SIZE).
- */
-
-struct trace_seq {
-	char			buffer[TRACE_SEQ_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
-	int			full;
-};
-
-static inline void
-trace_seq_init(struct trace_seq *s)
-{
-	s->len = 0;
-	s->readpos = 0;
-	s->full = 0;
-}
-
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 2, 0)));
-
-extern int trace_seq_puts(struct trace_seq *s, const char *str);
-extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-
-extern void trace_seq_terminate(struct trace_seq *s);
-
-extern int trace_seq_do_printf(struct trace_seq *s);
-
-
-/* ----------------------- pevent ----------------------- */
-
-struct pevent;
-struct event_format;
-
-typedef int (*pevent_event_handler_func)(struct trace_seq *s,
-					 struct record *record,
-					 struct event_format *event,
-					 void *context);
-
-typedef int (*pevent_plugin_load_func)(struct pevent *pevent);
-typedef int (*pevent_plugin_unload_func)(void);
-
-#define PEVENT_PLUGIN_LOADER pevent_plugin_loader
-#define PEVENT_PLUGIN_UNLOADER pevent_plugin_unloader
-#define _MAKE_STR(x)	#x
-#define MAKE_STR(x)	_MAKE_STR(x)
-#define PEVENT_PLUGIN_LOADER_NAME MAKE_STR(PEVENT_PLUGIN_LOADER)
-#define PEVENT_PLUGIN_UNLOADER_NAME MAKE_STR(PEVENT_PLUGIN_UNLOADER)
-
-#define NSECS_PER_SEC		1000000000ULL
-#define NSECS_PER_USEC		1000ULL
-
-enum format_flags {
-	FIELD_IS_ARRAY		= 1,
-	FIELD_IS_POINTER	= 2,
-	FIELD_IS_SIGNED		= 4,
-	FIELD_IS_STRING		= 8,
-	FIELD_IS_DYNAMIC	= 16,
-	FIELD_IS_LONG		= 32,
-	FIELD_IS_FLAG		= 64,
-	FIELD_IS_SYMBOLIC	= 128,
-};
-
-struct format_field {
-	struct format_field	*next;
-	struct event_format	*event;
-	char			*type;
-	char			*name;
-	int			offset;
-	int			size;
-	unsigned int		arraylen;
-	unsigned int		elementsize;
-	unsigned long		flags;
-};
-
-struct format {
-	int			nr_common;
-	int			nr_fields;
-	struct format_field	*common_fields;
-	struct format_field	*fields;
-};
-
-struct print_arg_atom {
-	char			*atom;
-};
-
-struct print_arg_string {
-	char			*string;
-	int			offset;
-};
-
-struct print_arg_field {
-	char			*name;
-	struct format_field	*field;
-};
-
-struct print_flag_sym {
-	struct print_flag_sym	*next;
-	char			*value;
-	char			*str;
-};
-
-struct print_arg_typecast {
-	char 			*type;
-	struct print_arg	*item;
-};
-
-struct print_arg_flags {
-	struct print_arg	*field;
-	char			*delim;
-	struct print_flag_sym	*flags;
-};
-
-struct print_arg_symbol {
-	struct print_arg	*field;
-	struct print_flag_sym	*symbols;
-};
-
-struct print_arg_dynarray {
-	struct format_field	*field;
-	struct print_arg	*index;
-};
-
-struct print_arg;
-
-struct print_arg_op {
-	char			*op;
-	int			prio;
-	struct print_arg	*left;
-	struct print_arg	*right;
-};
-
-struct pevent_function_handler;
-
-struct print_arg_func {
-	struct pevent_function_handler	*func;
-	struct print_arg		*args;
-};
-
-enum print_arg_type {
-	PRINT_NULL,
-	PRINT_ATOM,
-	PRINT_FIELD,
-	PRINT_FLAGS,
-	PRINT_SYMBOL,
-	PRINT_TYPE,
-	PRINT_STRING,
-	PRINT_DYNAMIC_ARRAY,
-	PRINT_OP,
-	PRINT_FUNC,
-};
-
-struct print_arg {
-	struct print_arg		*next;
-	enum print_arg_type		type;
-	union {
-		struct print_arg_atom		atom;
-		struct print_arg_field		field;
-		struct print_arg_typecast	typecast;
-		struct print_arg_flags		flags;
-		struct print_arg_symbol		symbol;
-		struct print_arg_func		func;
-		struct print_arg_string		string;
-		struct print_arg_op		op;
-		struct print_arg_dynarray	dynarray;
-	};
-};
-
-struct print_fmt {
-	char			*format;
-	struct print_arg	*args;
-};
-
-struct event_format {
-	struct pevent		*pevent;
-	char			*name;
-	int			id;
-	int			flags;
-	struct format		format;
-	struct print_fmt	print_fmt;
-	char			*system;
-	pevent_event_handler_func handler;
-	void			*context;
-};
-
-enum {
-	EVENT_FL_ISFTRACE	= 0x01,
-	EVENT_FL_ISPRINT	= 0x02,
-	EVENT_FL_ISBPRINT	= 0x04,
-	EVENT_FL_ISFUNCENT	= 0x10,
-	EVENT_FL_ISFUNCRET	= 0x20,
-
-	EVENT_FL_FAILED		= 0x80000000
-};
-
-enum event_sort_type {
-	EVENT_SORT_ID,
-	EVENT_SORT_NAME,
-	EVENT_SORT_SYSTEM,
-};
-
-enum event_type {
-	EVENT_ERROR,
-	EVENT_NONE,
-	EVENT_SPACE,
-	EVENT_NEWLINE,
-	EVENT_OP,
-	EVENT_DELIM,
-	EVENT_ITEM,
-	EVENT_DQUOTE,
-	EVENT_SQUOTE,
-};
-
-typedef unsigned long long (*pevent_func_handler)(struct trace_seq *s,
-					     unsigned long long *args);
-
-enum pevent_func_arg_type {
-	PEVENT_FUNC_ARG_VOID,
-	PEVENT_FUNC_ARG_INT,
-	PEVENT_FUNC_ARG_LONG,
-	PEVENT_FUNC_ARG_STRING,
-	PEVENT_FUNC_ARG_PTR,
-	PEVENT_FUNC_ARG_MAX_TYPES
-};
-
-struct cmdline;
-struct cmdline_list;
-struct func_map;
-struct func_list;
-struct event_handler;
-
-struct pevent {
-	int ref_count;
-
-	int header_page_ts_offset;
-	int header_page_ts_size;
-	int header_page_size_offset;
-	int header_page_size_size;
-	int header_page_data_offset;
-	int header_page_data_size;
-	int header_page_overwrite;
-
-	int file_bigendian;
-	int host_bigendian;
-
-	int latency_format;
-
-	int old_format;
-
-	int cpus;
-	int long_size;
-
-	struct cmdline *cmdlines;
-	struct cmdline_list *cmdlist;
-	int cmdline_count;
-
-	struct func_map *func_map;
-	struct func_list *funclist;
-	unsigned int func_count;
-
-	struct printk_map *printk_map;
-	struct printk_list *printklist;
-	unsigned int printk_count;
-
-	struct event_format **events;
-	int nr_events;
-	struct event_format **sort_events;
-	enum event_sort_type last_type;
-
-	int type_offset;
-	int type_size;
-
-	int pid_offset;
-	int pid_size;
-
- 	int pc_offset;
-	int pc_size;
-
-	int flags_offset;
-	int flags_size;
-
-	int ld_offset;
-	int ld_size;
-
-	int print_raw;
-
-	struct format_field *bprint_ip_field;
-	struct format_field *bprint_fmt_field;
-	struct format_field *bprint_buf_field;
-
-	struct event_handler *handlers;
-	struct pevent_function_handler *func_handlers;
-
-	/* cache */
-	struct event_format *last_event;
-};
-
-/* Can be overridden */
-void *malloc_or_die(unsigned int size);
-void pr_stat(const char *fmt, ...);
-void vpr_stat(const char *fmt, va_list ap);
-
-/* Always available */
-void __die(const char *fmt, ...);
-void __warning(const char *fmt, ...);
-void __pr_stat(const char *fmt, ...);
-
-void __vdie(const char *fmt, ...);
-void __vwarning(const char *fmt, ...);
-void __vpr_stat(const char *fmt, ...);
-
-static inline unsigned short
-__data2host2(struct pevent *pevent, unsigned short data)
-{
-	unsigned short swap;
-
-	if (pevent->host_bigendian == pevent->file_bigendian)
-		return data;
-
-	swap = ((data & 0xffULL) << 8) |
-		((data & (0xffULL << 8)) >> 8);
-
-	return swap;
-}
-
-static inline unsigned int
-__data2host4(struct pevent *pevent, unsigned int data)
-{
-	unsigned int swap;
-
-	if (pevent->host_bigendian == pevent->file_bigendian)
-		return data;
-
-	swap = ((data & 0xffULL) << 24) |
-		((data & (0xffULL << 8)) << 8) |
-		((data & (0xffULL << 16)) >> 8) |
-		((data & (0xffULL << 24)) >> 24);
-
-	return swap;
-}
-
-static inline unsigned long long
-__data2host8(struct pevent *pevent, unsigned long long data)
-{
-	unsigned long long swap;
-
-	if (pevent->host_bigendian == pevent->file_bigendian)
-		return data;
-
-	swap = ((data & 0xffULL) << 56) |
-		((data & (0xffULL << 8)) << 40) |
-		((data & (0xffULL << 16)) << 24) |
-		((data & (0xffULL << 24)) << 8) |
-		((data & (0xffULL << 32)) >> 8) |
-		((data & (0xffULL << 40)) >> 24) |
-		((data & (0xffULL << 48)) >> 40) |
-		((data & (0xffULL << 56)) >> 56);
-
-	return swap;
-}
-
-#define data2host2(pevent, ptr)		__data2host2(pevent, *(unsigned short *)(ptr))
-#define data2host4(pevent, ptr)		__data2host4(pevent, *(unsigned int *)(ptr))
-#define data2host8(pevent, ptr)					\
-({								\
-	unsigned long long __val;				\
-								\
-	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
-	__data2host8(pevent, __val);				\
-})
-
-/* taken from kernel/trace/trace.h */
-enum trace_flag_type {
-	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
-	TRACE_FLAG_NEED_RESCHED		= 0x04,
-	TRACE_FLAG_HARDIRQ		= 0x08,
-	TRACE_FLAG_SOFTIRQ		= 0x10,
-};
-
-int pevent_register_comm(struct pevent *pevent, char *comm, int pid);
-int pevent_register_function(struct pevent *pevent, char *name,
-			     unsigned long long addr, char *mod);
-int pevent_register_print_string(struct pevent *pevent, char *fmt,
-				 unsigned long long addr);
-int pevent_pid_is_registered(struct pevent *pevent, int pid);
-
-void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
-			struct record *record);
-
-int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
-			     int long_size);
-
-int pevent_parse_event(struct pevent *pevent, const char *buf,
-		       unsigned long size, const char *sys);
-
-int pevent_register_event_handler(struct pevent *pevent, int id, char *sys_name, char *event_name,
-				  pevent_event_handler_func func, void *context);
-int pevent_register_print_function(struct pevent *pevent,
-				   pevent_func_handler func,
-				   enum pevent_func_arg_type ret_type,
-				   char *name, ...);
-
-struct format_field *pevent_find_common_field(struct event_format *event, const char *name);
-struct format_field *pevent_find_field(struct event_format *event, const char *name);
-struct format_field *pevent_find_any_field(struct event_format *event, const char *name);
-
-const char *pevent_find_function(struct pevent *pevent, unsigned long long addr);
-unsigned long long
-pevent_find_function_address(struct pevent *pevent, unsigned long long addr);
-unsigned long long pevent_read_number(struct pevent *pevent, const void *ptr, int size);
-int pevent_read_number_field(struct format_field *field, const void *data,
-			     unsigned long long *value);
-
-struct event_format *pevent_find_event(struct pevent *pevent, int id);
-
-struct event_format *
-pevent_find_event_by_name(struct pevent *pevent, const char *sys, const char *name);
-
-void pevent_data_lat_fmt(struct pevent *pevent,
-			 struct trace_seq *s, struct record *record);
-int pevent_data_type(struct pevent *pevent, struct record *rec);
-struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type);
-int pevent_data_pid(struct pevent *pevent, struct record *rec);
-const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
-void pevent_event_info(struct trace_seq *s, struct event_format *event,
-		       struct record *record);
-
-struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
-struct format_field **pevent_event_common_fields(struct event_format *event);
-struct format_field **pevent_event_fields(struct event_format *event);
-
-static inline int pevent_get_cpus(struct pevent *pevent)
-{
-	return pevent->cpus;
-}
-
-static inline void pevent_set_cpus(struct pevent *pevent, int cpus)
-{
-	pevent->cpus = cpus;
-}
-
-static inline int pevent_get_long_size(struct pevent *pevent)
-{
-	return pevent->long_size;
-}
-
-static inline void pevent_set_long_size(struct pevent *pevent, int long_size)
-{
-	pevent->long_size = long_size;
-}
-
-static inline int pevent_is_file_bigendian(struct pevent *pevent)
-{
-	return pevent->file_bigendian;
-}
-
-static inline void pevent_set_file_bigendian(struct pevent *pevent, int endian)
-{
-	pevent->file_bigendian = endian;
-}
-
-static inline int pevent_is_host_bigendian(struct pevent *pevent)
-{
-	return pevent->host_bigendian;
-}
-
-static inline void pevent_set_host_bigendian(struct pevent *pevent, int endian)
-{
-	pevent->host_bigendian = endian;
-}
-
-static inline int pevent_is_latency_format(struct pevent *pevent)
-{
-	return pevent->latency_format;
-}
-
-static inline void pevent_set_latency_format(struct pevent *pevent, int lat)
-{
-	pevent->latency_format = lat;
-}
-
-struct pevent *pevent_alloc(void);
-void pevent_free(struct pevent *pevent);
-void pevent_ref(struct pevent *pevent);
-void pevent_unref(struct pevent *pevent);
-
-/* access to the internal parser */
-void pevent_buffer_init(const char *buf, unsigned long long size);
-enum event_type pevent_read_token(char **tok);
-void pevent_free_token(char *token);
-int pevent_peek_char(void);
-
-/* for debugging */
-void pevent_print_funcs(struct pevent *pevent);
-void pevent_print_printk(struct pevent *pevent);
-
-/* ----------------------- filtering ----------------------- */
-
-enum filter_boolean_type {
-	FILTER_FALSE,
-	FILTER_TRUE,
-};
-
-enum filter_op_type {
-	FILTER_OP_AND = 1,
-	FILTER_OP_OR,
-	FILTER_OP_NOT,
-};
-
-enum filter_cmp_type {
-	FILTER_CMP_NONE,
-	FILTER_CMP_EQ,
-	FILTER_CMP_NE,
-	FILTER_CMP_GT,
-	FILTER_CMP_LT,
-	FILTER_CMP_GE,
-	FILTER_CMP_LE,
-	FILTER_CMP_MATCH,
-	FILTER_CMP_NOT_MATCH,
-	FILTER_CMP_REGEX,
-	FILTER_CMP_NOT_REGEX,
-};
-
-enum filter_exp_type {
-	FILTER_EXP_NONE,
-	FILTER_EXP_ADD,
-	FILTER_EXP_SUB,
-	FILTER_EXP_MUL,
-	FILTER_EXP_DIV,
-	FILTER_EXP_MOD,
-	FILTER_EXP_RSHIFT,
-	FILTER_EXP_LSHIFT,
-	FILTER_EXP_AND,
-	FILTER_EXP_OR,
-	FILTER_EXP_XOR,
-	FILTER_EXP_NOT,
-};
-
-enum filter_arg_type {
-	FILTER_ARG_NONE,
-	FILTER_ARG_BOOLEAN,
-	FILTER_ARG_VALUE,
-	FILTER_ARG_FIELD,
-	FILTER_ARG_EXP,
-	FILTER_ARG_OP,
-	FILTER_ARG_NUM,
-	FILTER_ARG_STR,
-};
-
-enum filter_value_type {
-	FILTER_NUMBER,
-	FILTER_STRING
-};
-
-struct fliter_arg;
-
-struct filter_arg_boolean {
-	enum filter_boolean_type	value;
-};
-
-struct filter_arg_field {
-	struct format_field	*field;
-};
-
-struct filter_arg_value {
-	enum filter_value_type	type;
-	union {
-		char			*str;
-		unsigned long long	val;
-	};
-};
-
-struct filter_arg_op {
-	enum filter_op_type	type;
-	struct filter_arg	*left;
-	struct filter_arg	*right;
-};
-
-struct filter_arg_num {
-	enum filter_cmp_type	type;
-	struct filter_arg	*left;
-	struct filter_arg	*right;
-};
-
-struct filter_arg_str {
-	enum filter_cmp_type	type;
-	struct format_field	*field;
-	char			*val;
-	char			*buffer;
-	regex_t			reg;
-};
-
-struct filter_arg {
-	enum filter_arg_type	type;
-	union {
-		struct filter_arg_boolean	boolean;
-		struct filter_arg_field		field;
-		struct filter_arg_value		value;
-		struct filter_arg_op		op;
-		struct filter_arg_num		num;
-		struct filter_arg_str		str;
-	};
-};
-
-struct filter_type {
-	int			event_id;
-	struct event_format	*event;
-	struct filter_arg	*filter;
-};
-
-struct event_filter {
-	struct pevent		*pevent;
-	int			filters;
-	struct filter_type	*event_filters;
-};
-
-struct event_filter *pevent_filter_alloc(struct pevent *pevent);
-
-#define FILTER_NONE		-2
-#define FILTER_NOEXIST		-1
-#define FILTER_MISS		0
-#define FILTER_MATCH		1
-
-enum filter_trivial_type {
-	FILTER_TRIVIAL_FALSE,
-	FILTER_TRIVIAL_TRUE,
-	FILTER_TRIVIAL_BOTH,
-};
-
-int pevent_filter_add_filter_str(struct event_filter *filter,
-				 const char *filter_str,
-				 char **error_str);
-
-
-int pevent_filter_match(struct event_filter *filter,
-			struct record *record);
-
-int pevent_event_filtered(struct event_filter *filter,
-			  int event_id);
-
-void pevent_filter_reset(struct event_filter *filter);
-
-void pevent_filter_clear_trivial(struct event_filter *filter,
-				 enum filter_trivial_type type);
-
-void pevent_filter_free(struct event_filter *filter);
-
-char *pevent_filter_make_string(struct event_filter *filter, int event_id);
-
-int pevent_filter_remove_event(struct event_filter *filter,
-			       int event_id);
-
-int pevent_filter_event_has_trivial(struct event_filter *filter,
-				    int event_id,
-				    enum filter_trivial_type type);
-
-int pevent_filter_copy(struct event_filter *dest, struct event_filter *source);
-
-int pevent_update_trivial(struct event_filter *dest, struct event_filter *source,
-			  enum filter_trivial_type type);
-
-int pevent_filter_compare(struct event_filter *filter1, struct event_filter *filter2);
-
-#endif /* _PARSE_EVENTS_H */
diff --git a/tools/lib/parse-filter.c b/tools/lib/parse-filter.c
deleted file mode 100644
index dead050..0000000
--- a/tools/lib/parse-filter.c
+++ /dev/null
@@ -1,2085 +0,0 @@
-/*
- * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdarg.h>
-#include <errno.h>
-#include <sys/types.h>
-
-#include "parse-events.h"
-#include "util.h"
-
-struct event_list {
-	struct event_list	*next;
-	struct event_format	*event;
-};
-
-#define MAX_ERR_STR_SIZE 256
-
-static void show_error(char **error_str, const char *fmt, ...)
-{
-	va_list ap;
-
-	if (!error_str)
-		return;
-
-	*error_str = malloc_or_die(MAX_ERR_STR_SIZE);
-
-	va_start(ap, fmt);
-	vsnprintf(*error_str, MAX_ERR_STR_SIZE, fmt, ap);
-	va_end(ap);
-}
-
-static void free_token(char *token)
-{
-	pevent_free_token(token);
-}
-
-static enum event_type read_token(char **tok)
-{
-	enum event_type type;
-	char *token = NULL;
-
-	do {
-		free_token(token);
-		type = pevent_read_token(&token);
-	} while (type == EVENT_NEWLINE || type == EVENT_SPACE);
-
-	/* If token is = or ! check to see if the next char is ~ */
-	if (token &&
-	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
-	    pevent_peek_char() == '~') {
-		/* append it */
-		*tok = malloc(3);
-		sprintf(*tok, "%c%c", *token, '~');
-		free_token(token);
-		/* Now remove the '~' from the buffer */
-		pevent_read_token(&token);
-		free_token(token);
-	} else
-		*tok = token;
-
-	return type;
-}
-
-static int filter_cmp(const void *a, const void *b)
-{
-	const struct filter_type *ea = a;
-	const struct filter_type *eb = b;
-
-	if (ea->event_id < eb->event_id)
-		return -1;
-
-	if (ea->event_id > eb->event_id)
-		return 1;
-
-	return 0;
-}
-
-static struct filter_type *
-find_filter_type(struct event_filter *filter, int id)
-{
-	struct filter_type *filter_type;
-	struct filter_type key;
-
-	key.event_id = id;
-
-	filter_type = bsearch(&key, filter->event_filters,
-			      filter->filters,
-			      sizeof(*filter->event_filters),
-			      filter_cmp);
-
-	return filter_type;
-}
-
-static struct filter_type *
-add_filter_type(struct event_filter *filter, int id)
-{
-	struct filter_type *filter_type;
-	int i;
-
-	filter_type = find_filter_type(filter, id);
-	if (filter_type)
-		return filter_type;
-
-	if (!filter->filters)
-		filter->event_filters =
-			malloc_or_die(sizeof(*filter->event_filters));
-	else {
-		filter->event_filters =
-			realloc(filter->event_filters,
-				sizeof(*filter->event_filters) *
-				(filter->filters + 1));
-		if (!filter->event_filters)
-			die("Could not allocate filter");
-	}
-
-	for (i = 0; i < filter->filters; i++) {
-		if (filter->event_filters[i].event_id > id)
-			break;
-	}
-
-	if (i < filter->filters)
-		memmove(&filter->event_filters[i+1],
-			&filter->event_filters[i],
-			sizeof(*filter->event_filters) *
-			(filter->filters - i));
-
-	filter_type = &filter->event_filters[i];
-	filter_type->event_id = id;
-	filter_type->event = pevent_find_event(filter->pevent, id);
-	filter_type->filter = NULL;
-
-	filter->filters++;
-
-	return filter_type;
-}
-
-/**
- * pevent_filter_alloc - create a new event filter
- * @pevent: The pevent that this filter is associated with
- */
-struct event_filter *pevent_filter_alloc(struct pevent *pevent)
-{
-	struct event_filter *filter;
-
-	filter = malloc_or_die(sizeof(*filter));
-	memset(filter, 0, sizeof(*filter));
-	filter->pevent = pevent;
-	pevent_ref(pevent);
-
-	return filter;
-}
-
-static struct filter_arg *allocate_arg(void)
-{
-	struct filter_arg *arg;
-
-	arg = malloc_or_die(sizeof(*arg));
-	memset(arg, 0, sizeof(*arg));
-
-	return arg;
-}
-
-static void free_arg(struct filter_arg *arg)
-{
-	if (!arg)
-		return;
-
-	switch (arg->type) {
-	case FILTER_ARG_NONE:
-	case FILTER_ARG_BOOLEAN:
-	case FILTER_ARG_NUM:
-		break;
-
-	case FILTER_ARG_STR:
-		free(arg->str.val);
-		regfree(&arg->str.reg);
-		free(arg->str.buffer);
-		break;
-
-	case FILTER_ARG_OP:
-		free_arg(arg->op.left);
-		free_arg(arg->op.right);
-	default:
-		break;
-	}
-
-	free(arg);
-}
-
-static void add_event(struct event_list **events,
-		      struct event_format *event)
-{
-	struct event_list *list;
-
-	list = malloc_or_die(sizeof(*list));
-	list->next = *events;
-	*events = list;
-	list->event = event;
-}
-
-static int event_match(struct event_format *event,
-		       regex_t *sreg, regex_t *ereg)
-{
-	if (sreg) {
-		return !regexec(sreg, event->system, 0, NULL, 0) &&
-			!regexec(ereg, event->name, 0, NULL, 0);
-	}
-
-	return !regexec(ereg, event->system, 0, NULL, 0) ||
-		!regexec(ereg, event->name, 0, NULL, 0);
-}
-
-static int
-find_event(struct pevent *pevent, struct event_list **events,
-	   char *sys_name, char *event_name)
-{
-	struct event_format *event;
-	regex_t ereg;
-	regex_t sreg;
-	int match = 0;
-	char *reg;
-	int ret;
-	int i;
-
-	if (!event_name) {
-		/* if no name is given, then swap sys and name */
-		event_name = sys_name;
-		sys_name = NULL;
-	}
-
-	reg = malloc_or_die(strlen(event_name) + 3);
-	sprintf(reg, "^%s$", event_name);
-
-	ret = regcomp(&ereg, reg, REG_ICASE|REG_NOSUB);
-	free(reg);
-
-	if (ret)
-		return -1;
-
-	if (sys_name) {
-		reg = malloc_or_die(strlen(sys_name) + 3);
-		sprintf(reg, "^%s$", sys_name);
-		ret = regcomp(&sreg, reg, REG_ICASE|REG_NOSUB);
-		free(reg);
-		if (ret) {
-			regfree(&ereg);
-			return -1;
-		}
-	}
-
-	for (i = 0; i < pevent->nr_events; i++) {
-		event = pevent->events[i];
-		if (event_match(event, sys_name ? &sreg : NULL, &ereg)) {
-			match = 1;
-			add_event(events, event);
-		}
-	}
-
-	regfree(&ereg);
-	if (sys_name)
-		regfree(&sreg);
-
-	if (!match)
-		return -1;
-
-	return 0;
-}
-
-static void free_events(struct event_list *events)
-{
-	struct event_list *event;
-
-	while (events) {
-		event = events;
-		events = events->next;
-		free(event);
-	}
-}
-
-static enum event_type
-process_paren(struct event_format *event, struct filter_arg **parg,
-	      char **tok, char **error_str);
-
-static enum event_type
-process_not(struct event_format *event, struct filter_arg **parg,
-	    char **tok, char **error_str);
-
-static enum event_type
-process_value_token(struct event_format *event, struct filter_arg **parg,
-		    enum event_type type, char **tok, char **error_str);
-
-static enum event_type
-process_op_token(struct event_format *event, struct filter_arg *larg,
-		 struct filter_arg **parg, enum event_type type, char **tok,
-		 char **error_str);
-
-/*
- * process_token
- *  Called when a new expression is found. Processes an op, or
- *  ends early if a ')' is found.
- *
- * Output: tok, parg
- */
-static enum event_type
-process_token(struct event_format *event, struct filter_arg **parg,
-	      char **tok, char **error_str)
-{
-	struct filter_arg *arg = NULL;
-	enum event_type type;
-	char *token;
-
-	*tok = NULL;
-	*parg = NULL;
-
-	type = read_token(&token);
-
-	/*
-	 * This is a start of a new expresion. We expect to find
-	 * a item or a parenthesis.
-	 */
-	switch (type) {
-	case EVENT_SQUOTE:
-	case EVENT_DQUOTE:
-	case EVENT_ITEM:
-		type = process_value_token(event, &arg, type, &token, error_str);
-		if (type == EVENT_ERROR) {
-			free_token(token);
-			return type;
-		}
-		type = read_token(&token);
-		break;
-	case EVENT_DELIM:
-		if (strcmp(token, "(") != 0)
-			break;
-
-		free_token(token);
-		type = process_paren(event, &arg, &token, error_str);
-		if (type == EVENT_NONE) {
-			*tok = token;
-			*parg = arg;
-			return type;
-		}
-		if (arg) {
-			/*
-			 * If the parenthesis was a full expression,
-			 * then just return it. Otherwise, we may still
-			 * need to find an op.
-			 */
-			switch (arg->type) {
-			case FILTER_ARG_OP:
-			case FILTER_ARG_NUM:
-			case FILTER_ARG_STR:
-				*tok = token;
-				*parg = arg;
-				return type;
-			default:
-				break;
-			}
-		}
-		break;
-
-	case EVENT_OP:
-		if (strcmp(token, "!") != 0)
-			break;
-
-		/*
-		 * A not is its own filter, it just negates,
-		 * process it by itself.
-		 */
-		*tok = token;
-		type = process_not(event, parg, tok, error_str);
-		return type;
-
-	default:
-		break;
-	}
-
-	for (;;) {
-		if (type == EVENT_NONE) {
-			show_error(error_str, "unexpected end of filter");
-			type = EVENT_ERROR;
-
-		} else if (type == EVENT_DELIM && strcmp(token, ")") == 0) {
-			/* Parenthesis call this and may return at anytime. */
-			*tok = token;
-			*parg = arg;
-			return type;
-
-		} else if (type != EVENT_OP) {
-			show_error(error_str, "Expected an OP but found %s", token);
-			type = EVENT_ERROR;
-		}
-
-		if (type == EVENT_ERROR) {
-			free_token(token);
-			return type;
-		}
-
-		*tok = token;
-		*parg = NULL;
-		type = process_op_token(event, arg, parg, type, tok, error_str);
-
-		if (type == EVENT_ERROR) {
-			free_arg(*parg);
-			*parg = NULL;
-			return EVENT_ERROR;
-		}
-
-		if (!(*parg) || (*parg)->type != FILTER_ARG_EXP)
-			break;
-
-		/*
-		 * This op was an expression (value return)
-		 * It's not fine by itself, there had better be an OP
-		 * after it.
-		 */
-		token = *tok;
-		*tok = NULL;
-		arg = *parg;
-	}
-
-	return type;
-}
-
-/*
- * Input: tok
- * Output: parg, tok
- */
-static enum event_type
-process_bool(struct event_format *event, struct filter_arg *larg,
-	     struct filter_arg **parg, char **tok, char **error_str)
-{
-	struct filter_arg *rarg;
-	struct filter_arg *arg;
-	enum event_type type;
-	enum filter_op_type btype;
-
-	/* Can only be called with '&&' or '||' */
-	btype = strcmp(*tok, "&&") == 0 ?
-		FILTER_OP_AND : FILTER_OP_OR;
-
-	type = process_token(event, &rarg, tok, error_str);
-	if (type == EVENT_ERROR) {
-		free_arg(larg);
-		*parg = NULL;
-		return type;
-	}
-
-	/*
-	 * If larg or rarg is null then if this is AND, the whole expression
-	 * becomes NULL, else if this is an OR, then we use the non NULL
-	 * condition.
-	 */
-	if (!larg || !rarg) {
-		if (btype == FILTER_OP_AND ||
-		    (!larg && !rarg)) {
-			free_arg(larg);
-			free_arg(rarg);
-			*parg = NULL;
-			return type;
-		}
-		*parg = larg ? larg : rarg;
-		return type;
-	}
-
-	arg = allocate_arg();
-	arg->type = FILTER_ARG_OP;
-	arg->op.type = btype;
-	arg->op.left = larg;
-	arg->op.right = rarg;
-
-
-	/*
-	 * If the next token is also a boolean expression, then
-	 * make the next boolean the parent..
-	 */
-	if (type != EVENT_OP ||
-	    (strcmp(*tok, "&&") != 0 && strcmp(*tok, "||") != 0)) {
-		*parg = arg;
-		return type;
-	}
-
-	return process_bool(event, arg, parg, tok, error_str);
-}
-
-/*
- * Input: tok
- * Output: parg
- */
-static enum event_type
-process_value_token(struct event_format *event, struct filter_arg **parg,
-		    enum event_type type, char **tok, char **error_str)
-{
-	struct format_field *field;
-	struct filter_arg *arg;
-	char *token;
-
-	token = *tok;
-	*tok = NULL;
-
-	arg = allocate_arg();
-
-	switch (type) {
-
-	case EVENT_SQUOTE:
-	case EVENT_DQUOTE:
-		arg->type = FILTER_ARG_VALUE;
-		arg->value.type = FILTER_STRING;
-		arg->value.str = token;
-		break;
-	case EVENT_ITEM:
-		/* if it is a number, then convert it */
-		if (isdigit(token[0])) {
-			arg->type = FILTER_ARG_VALUE;
-			arg->value.type = FILTER_NUMBER;
-			arg->value.val = strtoll(token, NULL, 0);
-			free_token(token);
-			break;
-		}
-		/* Consider this a field */
-		field = pevent_find_any_field(event, token);
-		free_token(token);
-		if (!field) {
-			/* not a field, so NULL it up */
-			free_arg(arg);
-			arg = NULL;
-			break;
-		}
-
-		arg->type = FILTER_ARG_FIELD;
-		arg->field.field = field;
-		break;
-	default:
-		free_arg(arg);
-		show_error(error_str, "expected a value but found %s",
-			   token);
-		free_token(token);
-		return EVENT_ERROR;
-	}
-
-	*parg = arg;
-	return type;
-}
-
-/*
- * Output: parg, tok
- */
-static enum event_type
-process_value(struct event_format *event, struct filter_arg **parg,
-	      enum event_type *orig_type, char **tok, char **error_str)
-{
-	enum event_type type;
-	char *token;
-
-	*tok = NULL;
-	type = read_token(&token);
-	*orig_type = type;
-	if (type == EVENT_DELIM && strcmp(token, "(") == 0) {
-		type = process_paren(event, parg, &token, error_str);
-		/* Must be a expression or value */
-		if (type == EVENT_ERROR || !(*parg)) {
-			free_token(token);
-			return type;
-		}
-		switch ((*parg)->type) {
-		case FILTER_ARG_BOOLEAN:
-		case FILTER_ARG_VALUE:
-		case FILTER_ARG_FIELD:
-		case FILTER_ARG_EXP:
-			break;
-		default:
-			show_error(error_str, "expected a value");
-			free_token(token);
-			return EVENT_ERROR;
-		}
-	} else {
-		type = process_value_token(event, parg, type, &token, error_str);
-		free_token(token);
-		if (type == EVENT_ERROR)
-			return type;
-		type = read_token(&token);
-	}
-
-	*tok = token;
-	return type;
-}
-
-/*
- * Input: larg
- * Output: parg, tok
- */
-static enum event_type
-process_cmp(struct event_format *event, enum filter_cmp_type op_type,
-	    struct filter_arg *larg, struct filter_arg **parg,
-	    char **tok, char **error_str)
-{
-	struct filter_arg *arg;
-	struct filter_arg *rarg = NULL;
-	enum event_type orig_type;
-	enum event_type type;
-	int ret;
-
-	*parg = NULL;
-
-	type = process_value(event, &rarg, &orig_type, tok, error_str);
-	if (type == EVENT_ERROR) {
-		free_arg(rarg);
-		return type;
-	}
-
-	arg = allocate_arg();
-	/*
-	 * If either arg is NULL or right was field not found.
-	 * Then make the entire expression NULL. (will turn to FALSE)
-	 */
-	if (!larg || !rarg) {
-		free_arg(larg);
-		free_arg(rarg);
-		free_arg(arg);
-		arg = NULL;
-		goto cont;
-	}
-
-	switch (orig_type) {
-	case EVENT_SQUOTE:
-		/* treat this as a character if string is of length 1? */
-		if (strlen(rarg->str.val) == 1) {
-			switch (op_type) {
-			case FILTER_CMP_REGEX:
-			case FILTER_CMP_NOT_REGEX:
-				/* regex can't be used with ints */
-				break;
-			default:
-				goto as_int;
-			}
-		}
-		/* fall through */
-	case EVENT_DQUOTE:
-		arg->type = FILTER_ARG_STR;
-
-		if (larg->type != FILTER_ARG_FIELD) {
-			free(larg);
-			free(rarg);
-			show_error(error_str,
-				   "Illegal lval for string comparison");
-			free_arg(arg);
-			return EVENT_ERROR;
-		}
-
-		arg->str.field = larg->field.field;
-		free_arg(larg);
-
-		/* free the rarg, and use its token */
-		arg->str.val = rarg->value.str;
-		rarg->value.str = NULL;
-		free_arg(rarg);
-
-		/* Make sure this is a valid string compare */
-		switch (op_type) {
-		case FILTER_CMP_EQ:
-			op_type = FILTER_CMP_MATCH;
-			break;
-		case FILTER_CMP_NE:
-			op_type = FILTER_CMP_NOT_MATCH;
-			break;
-
-		case FILTER_CMP_REGEX:
-		case FILTER_CMP_NOT_REGEX:
-			ret = regcomp(&arg->str.reg, arg->str.val, REG_ICASE|REG_NOSUB);
-			if (ret) {
-				show_error(error_str,
-					   "RegEx '%s' did not compute",
-					   arg->str.val);
-				free_arg(arg);
-				return EVENT_ERROR;
-			}
-			break;
-		default:
-			show_error(error_str,
-				   "Illegal comparison for string");
-			free_arg(arg);
-			return EVENT_ERROR;
-		}
-
-		arg->str.type = op_type;
-
-		/*
-		 * Need a buffer to copy data int for tests		 */
-		arg->str.buffer = malloc_or_die(arg->str.field->size + 1);
-		/* Null terminate this buffer */
-		arg->str.buffer[arg->str.field->size] = 0;
-
-		break;
-	default:
- as_int:
-		switch (op_type) {
-		case FILTER_CMP_REGEX:
-		case FILTER_CMP_NOT_REGEX:
-			show_error(error_str,
-				   "Op not allowed with integers");
-			free_arg(arg);
-			return EVENT_ERROR;
-		default:
-			break;
-		}
-		/* numeric compare */
-		arg->type = FILTER_ARG_NUM;
-		arg->num.type = op_type;
-		arg->num.left = larg;
-		arg->num.right = rarg;
-		break;
-	}
- cont:
-	*parg = arg;
-	return type;
-}
-
-/*
- * Input: larg
- * Output: parg, tok
- */
-static enum event_type
-process_exp(struct event_format *event, enum filter_exp_type etype,
-	    struct filter_arg *larg, struct filter_arg **parg,
-	    char **tok, char **error_str)
-{
-	struct filter_arg *rarg = NULL;
-	struct filter_arg *arg;
-	enum event_type orig_type;
-	enum event_type type;
-
-	type = process_value(event, &rarg, &orig_type, tok, error_str);
-	if (type == EVENT_ERROR) {
-		free_arg(rarg);
-		return type;
-	}
-
-	/* larg can be NULL if a field did not match */
-	if (!larg) {
-		/* syntax is correct, just return NULL */
-		arg = NULL;
-		free_arg(rarg);
-		goto cont;
-	}
-
-	arg = allocate_arg();
-	arg->type = FILTER_ARG_EXP;
-	arg->op.type = etype;
-	arg->op.left = larg;
-	arg->op.right = rarg;
-
- cont:
-	/* still need a cmp */
-	type = process_op_token(event, arg, parg, type, tok, error_str);
-	return type;
-}
-
-/*
- * Input: tok
- * Output: parg, tok
- */
-static enum event_type
-process_op_token(struct event_format *event, struct filter_arg *larg,
-		 struct filter_arg **parg, enum event_type type, char **tok,
-		 char **error_str)
-{
-	enum filter_cmp_type ctype;
-	enum filter_exp_type etype = FILTER_EXP_NONE;
-	char *token;
-
-	token = *tok;
-	*parg = NULL;
-
-	if (type != EVENT_OP) {
-		*parg = larg;
-		return type;
-	}
-
-	if (strcmp(token, "&&") == 0 || strcmp(token, "||") == 0) {
-		/* handle boolean cases */
-		return process_bool(event, larg, parg, tok, error_str);
-	}
-
-	/* Check for value expressions */
-	if (strcmp(token, "+") == 0) {
-		etype = FILTER_EXP_ADD;
-	} else if (strcmp(token, "-") == 0) {
-		etype = FILTER_EXP_SUB;
-	} else if (strcmp(token, "*") == 0) {
-		etype = FILTER_EXP_MUL;
-	} else if (strcmp(token, "/") == 0) {
-		etype = FILTER_EXP_DIV;
-	} else if (strcmp(token, "%") == 0) {
-		etype = FILTER_EXP_MOD;
-	} else if (strcmp(token, ">>") == 0) {
-		etype = FILTER_EXP_RSHIFT;
-	} else if (strcmp(token, "<<") == 0) {
-		etype = FILTER_EXP_LSHIFT;
-	} else if (strcmp(token, "&") == 0) {
-		etype = FILTER_EXP_AND;
-	} else if (strcmp(token, "|") == 0) {
-		etype = FILTER_EXP_OR;
-	} else if (strcmp(token, "^") == 0) {
-		etype = FILTER_EXP_XOR;
-	} else if (strcmp(token, "~") == 0)
-		etype = FILTER_EXP_NOT;
-
-	if (etype != FILTER_EXP_NONE) {
-		free_token(token);
-		return process_exp(event, etype, larg, parg, tok, error_str);
-	}
-
-	if (strcmp(token, "==") == 0) {
-		ctype = FILTER_CMP_EQ;
-	} else if (strcmp(token, "!=") == 0) {
-		ctype = FILTER_CMP_NE;
-	} else if (strcmp(token, "<") == 0) {
-		ctype = FILTER_CMP_LT;
-	} else if (strcmp(token, ">") == 0) {
-		ctype = FILTER_CMP_GT;
-	} else if (strcmp(token, "<=") == 0) {
-		ctype = FILTER_CMP_LE;
-	} else if (strcmp(token, ">=") == 0) {
-		ctype = FILTER_CMP_GE;
-	} else if (strcmp(token, "=~") == 0) {
-		ctype = FILTER_CMP_REGEX;
-	} else if (strcmp(token, "!~") == 0) {
-		ctype = FILTER_CMP_NOT_REGEX;
-	} else {
-		show_error(error_str,
-			   "Unknown op '%s'", token);
-		free_token(token);
-		return EVENT_ERROR;
-	}
-
-	free_token(token);
-	*tok = NULL;
-	return process_cmp(event, ctype, larg, parg, tok, error_str);
-}
-
-static enum event_type
-process_filter(struct event_format *event, struct filter_arg **parg,
-	       char **tok, char **error_str)
-{
-	struct filter_arg *larg = NULL;
-	enum event_type type;
-
-	*parg = NULL;
-	*tok = NULL;
-
-	type = process_token(event, parg, tok, error_str);
-
-	if (type == EVENT_OP &&
-	    (strcmp(*tok, "&&") == 0 || strcmp(*tok, "||") == 0)) {
-		larg = *parg;
-		*parg = NULL;
-		type = process_bool(event, larg, parg, tok, error_str);
-	}
-
-	return type;
-}
-
-static enum event_type
-process_paren(struct event_format *event, struct filter_arg **parg,
-	      char **tok, char **error_str)
-{
-	struct filter_arg *arg;
-	enum event_type type;
-
-	*parg = NULL;
-
-	type = process_token(event, &arg, tok, error_str);
-	if (type == EVENT_ERROR) {
-		free_arg(arg);
-		return type;
-	}
-
-	if (type == EVENT_OP &&
-	    (strcmp(*tok, "&&") == 0 || strcmp(*tok, "||") == 0)) {
-		type = process_bool(event, arg, parg, tok, error_str);
-	}
-
-	if (type != EVENT_DELIM || strcmp(*tok, ")") != 0) {
-		if (*tok)
-			show_error(error_str,
-				   "Expected ')' but found %s", *tok);
-		else
-			show_error(error_str,
-				   "Unexpected end of filter; Expected ')'");
-		free_token(*tok);
-		*tok = NULL;
-		free_arg(arg);
-		return EVENT_ERROR;
-	}
-	free_token(*tok);
-	*tok = NULL;
-
-	*parg = arg;
-
-	return read_token(tok);
-}
-
-static enum event_type
-process_not(struct event_format *event, struct filter_arg **parg,
-	    char **tok, char **error_str)
-{
-	struct filter_arg *arg;
-	enum event_type type;
-
-	arg = allocate_arg();
-	arg->type = FILTER_ARG_OP;
-	arg->op.type = FILTER_OP_NOT;
-
-	arg->op.left = NULL;
-	type = process_token(event, &arg->op.right, tok, error_str);
-	if (type == EVENT_ERROR) {
-		free_arg(arg);
-		*parg = NULL;
-		free_token(*tok);
-		*tok = NULL;
-		return EVENT_ERROR;
-	}
-	/* If the bool value is NULL, then make this into TRUE */
-	if (!arg->op.right) {
-		arg->type = FILTER_ARG_BOOLEAN;
-		arg->boolean.value = FILTER_TRUE;
-	}
-
-	*parg = arg;
-	free_token(*tok);
-	*tok = NULL;
-
-	return type;
-}
-
-static int
-process_event(struct event_format *event, const char *filter_str,
-	      struct filter_arg **parg, char **error_str)
-{
-	enum event_type type;
-	char *token;
-
-	pevent_buffer_init(filter_str, strlen(filter_str));
-
-	type = process_filter(event, parg, &token, error_str);
-
-	if (type == EVENT_ERROR)
-		return -1;
-
-	if (type != EVENT_NONE) {
-		show_error(error_str,
-			   "Expected end where %s was found",
-			   token);
-		free_token(token);
-		free_arg(*parg);
-		*parg = NULL;
-		return -1;
-	}
-
-	/* If parg is NULL, then make it into FALSE */
-	if (!*parg) {
-		*parg = allocate_arg();
-		(*parg)->type = FILTER_ARG_BOOLEAN;
-		(*parg)->boolean.value = FILTER_FALSE;
-	}
-
-	return 0;
-}
-
-static int filter_event(struct event_filter *filter,
-			struct event_format *event,
-			const char *filter_str, char **error_str)
-{
-	struct filter_type *filter_type;
-	struct filter_arg *arg;
-	int ret;
-
-	if (filter_str) {
-		ret = process_event(event, filter_str, &arg, error_str);
-		if (ret < 0)
-			return ret;
-	} else {
-		/* just add a TRUE arg */
-		arg = allocate_arg();
-		arg->type = FILTER_ARG_BOOLEAN;
-		arg->boolean.value = FILTER_TRUE;
-	}
-
-	filter_type = add_filter_type(filter, event->id);
-	if (filter_type->filter)
-		free_arg(filter_type->filter);
-	filter_type->filter = arg;
-
-	return 0;
-}
-
-/**
- * pevent_filter_add_filter_str - add a new filter
- * @filter: the event filter to add to
- * @filter_str: the filter string that contains the filter
- * @error_str: string containing reason for failed filter
- *
- * Returns 0 if the filter was successfully added
- *   -1 if there was an error.
- *
- * On error, if @error_str points to a string pointer,
- * it is set to the reason that the filter failed.
- * This string must be freed with "free".
- */
-int pevent_filter_add_filter_str(struct event_filter *filter,
-				 const char *filter_str,
-				 char **error_str)
-{
-	struct pevent *pevent = filter->pevent;
-	struct event_list *event;
-	struct event_list *events = NULL;
-	const char *filter_start;
-	const char *next_event;
-	char *this_event;
-	char *event_name = NULL;
-	char *sys_name = NULL;
-	char *sp;
-	int rtn = 0;
-	int len;
-	int ret;
-
-	if (error_str)
-		*error_str = NULL;
-
-	filter_start = strchr(filter_str, ':');
-	if (filter_start)
-		len = filter_start - filter_str;
-	else
-		len = strlen(filter_str);
-
-
-	do {
-		next_event = strchr(filter_str, ',');
-		if (next_event &&
-		    (!filter_start || next_event < filter_start))
-			len = next_event - filter_str;
-		else if (filter_start)
-			len = filter_start - filter_str;
-		else
-			len = strlen(filter_str);
-
-		this_event = malloc_or_die(len + 1);
-		memcpy(this_event, filter_str, len);
-		this_event[len] = 0;
-
-		if (next_event)
-			next_event++;
-
-		filter_str = next_event;
-
-		sys_name = strtok_r(this_event, "/", &sp);
-		event_name = strtok_r(NULL, "/", &sp);
-
-		if (!sys_name) {
-			show_error(error_str, "No filter found");
-			/* This can only happen when events is NULL, but still */
-			free_events(events);
-			free(this_event);
-			return -1;
-		}
-
-		/* Find this event */
-		ret = find_event(pevent, &events, strim(sys_name), strim(event_name));
-		if (ret < 0) {
-			if (event_name)
-				show_error(error_str,
-					   "No event found under '%s.%s'",
-					   sys_name, event_name);
-			else
-				show_error(error_str,
-					   "No event found under '%s'",
-					   sys_name);
-			free_events(events);
-			free(this_event);
-			return -1;
-		}
-		free(this_event);
-	} while (filter_str);
-
-	/* Skip the ':' */
-	if (filter_start)
-		filter_start++;
-
-	/* filter starts here */
-	for (event = events; event; event = event->next) {
-		ret = filter_event(filter, event->event, filter_start,
-				   error_str);
-		/* Failures are returned if a parse error happened */
-		if (ret < 0)
-			rtn = ret;
-	}
-
-	free_events(events);
-
-	return rtn;
-}
-
-static void free_filter_type(struct filter_type *filter_type)
-{
-	free_arg(filter_type->filter);
-}
-
-/**
- * pevent_filter_remove_event - remove a filter for an event
- * @filter: the event filter to remove from
- * @event_id: the event to remove a filter for
- *
- * Removes the filter saved for an event defined by @event_id
- * from the @filter.
- *
- * Returns 1: if an event was removed
- *   0: if the event was not found
- */
-int pevent_filter_remove_event(struct event_filter *filter,
-			       int event_id)
-{
-	struct filter_type *filter_type;
-	unsigned long len;
-
-	if (!filter->filters)
-		return 0;
-
-	filter_type = find_filter_type(filter, event_id);
-
-	if (!filter_type)
-		return 0;
-
-	free_filter_type(filter_type);
-
-	/* The filter_type points into the event_filters array */
-	len = (unsigned long)(filter->event_filters + filter->filters) -
-		(unsigned long)(filter_type + 1);
-
-	memmove(filter_type, filter_type + 1, len);
-	filter->filters--;
-
-	memset(&filter->event_filters[filter->filters], 0,
-	       sizeof(*filter_type));
-
-	return 1;
-}
-
-/**
- * pevent_filter_reset - clear all filters in a filter
- * @filter: the event filter to reset
- *
- * Removes all filters from a filter and resets it.
- */
-void pevent_filter_reset(struct event_filter *filter)
-{
-	int i;
-
-	for (i = 0; i < filter->filters; i++)
-		free_filter_type(&filter->event_filters[i]);
-
-	free(filter->event_filters);
-	filter->filters = 0;
-	filter->event_filters = NULL;
-}
-
-void pevent_filter_free(struct event_filter *filter)
-{
-	pevent_unref(filter->pevent);
-
-	pevent_filter_reset(filter);
-
-	free(filter);
-}
-
-static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg);
-
-static int copy_filter_type(struct event_filter *filter,
-			     struct event_filter *source,
-			     struct filter_type *filter_type)
-{
-	struct filter_arg *arg;
-	struct event_format *event;
-	const char *sys;
-	const char *name;
-	char *str;
-
-	/* Can't assume that the pevent's are the same */
-	sys = filter_type->event->system;
-	name = filter_type->event->name;
-	event = pevent_find_event_by_name(filter->pevent, sys, name);
-	if (!event)
-		return -1;
-
-	str = arg_to_str(source, filter_type->filter);
-	if (!str)
-		return -1;
-
-	if (strcmp(str, "TRUE") == 0 || strcmp(str, "FALSE") == 0) {
-		/* Add trivial event */
-		arg = allocate_arg();
-		arg->type = FILTER_ARG_BOOLEAN;
-		if (strcmp(str, "TRUE") == 0)
-			arg->boolean.value = 1;
-		else
-			arg->boolean.value = 0;
-
-		filter_type = add_filter_type(filter, event->id);
-		filter_type->filter = arg;
-
-		free(str);
-		return 0;
-	}
-
-	filter_event(filter, event, str, NULL);
-	free(str);
-
-	return 0;
-}
-
-/**
- * pevent_filter_copy - copy a filter using another filter
- * @dest - the filter to copy to
- * @source - the filter to copy from
- *
- * Returns 0 on success and -1 if not all filters were copied
- */
-int pevent_filter_copy(struct event_filter *dest, struct event_filter *source)
-{
-	int ret = 0;
-	int i;
-
-	pevent_filter_reset(dest);
-
-	for (i = 0; i < source->filters; i++) {
-		if (copy_filter_type(dest, source, &source->event_filters[i]))
-			ret = -1;
-	}
-	return ret;
-}
-
-
-/**
- * pevent_update_trivial - update the trivial filters with the given filter
- * @dest - the filter to update
- * @source - the filter as the source of the update
- * @type - the type of trivial filter to update.
- *
- * Scan dest for trivial events matching @type to replace with the source.
- *
- * Returns 0 on success and -1 if there was a problem updating, but
- *   events may have still been updated on error.
- */
-int pevent_update_trivial(struct event_filter *dest, struct event_filter *source,
-			  enum filter_trivial_type type)
-{
-	struct pevent *src_pevent;
-	struct pevent *dest_pevent;
-	struct event_format *event;
-	struct filter_type *filter_type;
-	struct filter_arg *arg;
-	char *str;
-	int i;
-
-	src_pevent = source->pevent;
-	dest_pevent = dest->pevent;
-
-	/* Do nothing if either of the filters has nothing to filter */
-	if (!dest->filters || !source->filters)
-		return 0;
-
-	for (i = 0; i < dest->filters; i++) {
-		filter_type = &dest->event_filters[i];
-		arg = filter_type->filter;
-		if (arg->type != FILTER_ARG_BOOLEAN)
-			continue;
-		if ((arg->boolean.value && type == FILTER_TRIVIAL_FALSE) ||
-		    (!arg->boolean.value && type == FILTER_TRIVIAL_TRUE))
-			continue;
-
-		event = filter_type->event;
-
-		if (src_pevent != dest_pevent) {
-			/* do a look up */
-			event = pevent_find_event_by_name(src_pevent,
-							  event->system,
-							  event->name);
-			if (!event)
-				return -1;
-		}
-
-		str = pevent_filter_make_string(source, event->id);
-		if (!str)
-			continue;
-
-		/* Don't bother if the filter is trivial too */
-		if (strcmp(str, "TRUE") != 0 && strcmp(str, "FALSE") != 0)
-			filter_event(dest, event, str, NULL);
-		free(str);
-	}
-	return 0;
-}
-
-/**
- * pevent_filter_clear_trivial - clear TRUE and FALSE filters
- * @filter: the filter to remove trivial filters from
- * @type: remove only true, false, or both
- *
- * Removes filters that only contain a TRUE or FALES boolean arg.
- */
-void pevent_filter_clear_trivial(struct event_filter *filter,
-				 enum filter_trivial_type type)
-{
-	struct filter_type *filter_type;
-	int count = 0;
-	int *ids;
-	int i;
-
-	if (!filter->filters)
-		return;
-
-	/*
-	 * Two steps, first get all ids with trivial filters.
-	 *  then remove those ids.
-	 */
-	for (i = 0; i < filter->filters; i++) {
-		filter_type = &filter->event_filters[i];
-		if (filter_type->filter->type != FILTER_ARG_BOOLEAN)
-			continue;
-		switch (type) {
-		case FILTER_TRIVIAL_FALSE:
-			if (filter_type->filter->boolean.value)
-				continue;
-		case FILTER_TRIVIAL_TRUE:
-			if (!filter_type->filter->boolean.value)
-				continue;
-		default:
-			break;
-		}
-		if (count)
-			ids = realloc(ids, sizeof(*ids) * (count + 1));
-		else
-			ids = malloc(sizeof(*ids));
-		if (!ids)
-			die("Can't allocate ids");
-		ids[count++] = filter_type->event_id;
-	}
-
-	if (!count)
-		return;
-
-	for (i = 0; i < count; i++)
-		pevent_filter_remove_event(filter, ids[i]);
-
-	free(ids);
-}
-
-/**
- * pevent_filter_event_has_trivial - return true event contains trivial filter
- * @filter: the filter with the information
- * @event_id: the id of the event to test
- * @type: trivial type to test for (TRUE, FALSE, EITHER)
- *
- * Returns 1 if the event contains a matching trivial type
- *  otherwise 0.
- */
-int pevent_filter_event_has_trivial(struct event_filter *filter,
-				    int event_id,
-				    enum filter_trivial_type type)
-{
-	struct filter_type *filter_type;
-
-	if (!filter->filters)
-		return 0;
-
-	filter_type = find_filter_type(filter, event_id);
-
-	if (!filter_type)
-		return 0;
-
-	if (filter_type->filter->type != FILTER_ARG_BOOLEAN)
-		return 0;
-
-	switch (type) {
-	case FILTER_TRIVIAL_FALSE:
-		return !filter_type->filter->boolean.value;
-
-	case FILTER_TRIVIAL_TRUE:
-		return filter_type->filter->boolean.value;
-	default:
-		return 1;
-	}
-}
-
-static int test_filter(struct event_format *event,
-		       struct filter_arg *arg, struct record *record);
-
-static unsigned long long
-get_value(struct format_field *field, struct record *record)
-{
-	unsigned long long val;
-
-	pevent_read_number_field(field, record->data, &val);
-
-	if (!(field->flags & FIELD_IS_SIGNED))
-		return val;
-
-	switch (field->size) {
-	case 1:
-		return (char)val;
-	case 2:
-		return (short)val;
-	case 4:
-		return (int)val;
-	case 8:
-		return (long long)val;
-	}
-	return val;
-}
-
-static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg, struct record *record);
-
-static unsigned long long
-get_exp_value(struct event_format *event, struct filter_arg *arg, struct record *record)
-{
-	unsigned long long lval, rval;
-
-	lval = get_arg_value(event, arg->op.left, record);
-	rval = get_arg_value(event, arg->op.right, record);
-
-	switch (arg->op.type) {
-	case FILTER_EXP_ADD:
-		return lval + rval;
-
-	case FILTER_EXP_SUB:
-		return lval - rval;
-
-	case FILTER_EXP_MUL:
-		return lval * rval;
-
-	case FILTER_EXP_DIV:
-		return lval / rval;
-
-	case FILTER_EXP_MOD:
-		return lval % rval;
-
-	case FILTER_EXP_RSHIFT:
-		return lval >> rval;
-
-	case FILTER_EXP_LSHIFT:
-		return lval << rval;
-
-	case FILTER_EXP_AND:
-		return lval & rval;
-
-	case FILTER_EXP_OR:
-		return lval | rval;
-
-	case FILTER_EXP_XOR:
-		return lval ^ rval;
-
-	case FILTER_EXP_NOT:
-	default:
-		die("error in exp");
-	}
-	return 0;
-}
-
-static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg, struct record *record)
-{
-	switch (arg->type) {
-	case FILTER_ARG_FIELD:
-		return get_value(arg->field.field, record);
-
-	case FILTER_ARG_VALUE:
-		if (arg->value.type != FILTER_NUMBER)
-			die("must have number field!");
-		return arg->value.val;
-
-	case FILTER_ARG_EXP:
-		return get_exp_value(event, arg, record);
-
-	default:
-		die("oops in filter");
-	}
-	return 0;
-}
-
-static int test_num(struct event_format *event,
-		    struct filter_arg *arg, struct record *record)
-{
-	unsigned long long lval, rval;
-
-	lval = get_arg_value(event, arg->num.left, record);
-	rval = get_arg_value(event, arg->num.right, record);
-
-	switch (arg->num.type) {
-	case FILTER_CMP_EQ:
-		return lval == rval;
-
-	case FILTER_CMP_NE:
-		return lval != rval;
-
-	case FILTER_CMP_GT:
-		return lval > rval;
-
-	case FILTER_CMP_LT:
-		return lval < rval;
-
-	case FILTER_CMP_GE:
-		return lval >= rval;
-
-	case FILTER_CMP_LE:
-		return lval <= rval;
-
-	default:
-		/* ?? */
-		return 0;
-	}
-}
-
-static int test_str(struct event_format *event,
-		    struct filter_arg *arg, struct record *record)
-{
-	const char *val = record->data + arg->str.field->offset;
-	const char *buffer;
-
-	/*
-	 * We need to copy the data since we can't be sure the field
-	 * is null terminated.
-	 */
-	if (*(val + arg->str.field->size - 1)) {
-		/* copy it */
-		memcpy(arg->str.buffer, val, arg->str.field->size);
-		/* the buffer is already NULL terminated */
-		buffer = arg->str.buffer;
-	} else
-		/* OK, it's NULL terminated */
-		buffer = val;
-
-	switch (arg->str.type) {
-	case FILTER_CMP_MATCH:
-		return strcmp(buffer, arg->str.val) == 0;
-
-	case FILTER_CMP_NOT_MATCH:
-		return strcmp(buffer, arg->str.val) != 0;
-
-	case FILTER_CMP_REGEX:
-		/* Returns zero on match */
-		return !regexec(&arg->str.reg, buffer, 0, NULL, 0);
-
-	case FILTER_CMP_NOT_REGEX:
-		return regexec(&arg->str.reg, buffer, 0, NULL, 0);
-
-	default:
-		/* ?? */
-		return 0;
-	}
-}
-
-static int test_op(struct event_format *event,
-		   struct filter_arg *arg, struct record *record)
-{
-	switch (arg->op.type) {
-	case FILTER_OP_AND:
-		return test_filter(event, arg->op.left, record) &&
-			test_filter(event, arg->op.right, record);
-
-	case FILTER_OP_OR:
-		return test_filter(event, arg->op.left, record) ||
-			test_filter(event, arg->op.right, record);
-
-	case FILTER_OP_NOT:
-		return !test_filter(event, arg->op.right, record);
-
-	default:
-		/* ?? */
-		return 0;
-	}
-}
-
-static int test_filter(struct event_format *event,
-		       struct filter_arg *arg, struct record *record)
-{
-	switch (arg->type) {
-	case FILTER_ARG_BOOLEAN:
-		/* easy case */
-		return arg->boolean.value;
-
-	case FILTER_ARG_OP:
-		return test_op(event, arg, record);
-
-	case FILTER_ARG_NUM:
-		return test_num(event, arg, record);
-
-	case FILTER_ARG_STR:
-		return test_str(event, arg, record);
-
-	case FILTER_ARG_EXP:
-	case FILTER_ARG_VALUE:
-	case FILTER_ARG_FIELD:
-		/*
-		 * Expressions, fields and values evaluate
-		 * to true if they return non zero
-		 */
-		return !!get_arg_value(event, arg, record);
-
-	default:
-		die("oops!");
-		/* ?? */
-		return 0;
-	}
-}
-
-/**
- * pevent_event_filtered - return true if event has filter
- * @filter: filter struct with filter information
- * @event_id: event id to test if filter exists
- *
- * Returns 1 if filter found for @event_id
- *   otherwise 0;
- */
-int pevent_event_filtered(struct event_filter *filter,
-			  int event_id)
-{
-	struct filter_type *filter_type;
-
-	if (!filter->filters)
-		return 0;
-
-	filter_type = find_filter_type(filter, event_id);
-
-	return filter_type ? 1 : 0;
-}
-
-/**
- * pevent_filter_match - test if a record matches a filter
- * @filter: filter struct with filter information
- * @record: the record to test against the filter
- *
- * Returns:
- *  1 - filter found for event and @record matches
- *  0 - filter found for event and @record does not match
- * -1 - no filter found for @record's event
- * -2 - if no filters exist
- */
-int pevent_filter_match(struct event_filter *filter,
-			struct record *record)
-{
-	struct pevent *pevent = filter->pevent;
-	struct filter_type *filter_type;
-	int event_id;
-
-	if (!filter->filters)
-		return FILTER_NONE;
-
-	event_id = pevent_data_type(pevent, record);
-
-	filter_type = find_filter_type(filter, event_id);
-
-	if (!filter_type)
-		return FILTER_NOEXIST;
-
-	return test_filter(filter_type->event, filter_type->filter, record) ?
-		FILTER_MATCH : FILTER_MISS;
-}
-
-static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
-{
-	char *str = NULL;
-	char *left = NULL;
-	char *right = NULL;
-	char *op = NULL;
-	int left_val = -1;
-	int right_val = -1;
-	int val;
-	int len;
-
-	switch (arg->op.type) {
-	case FILTER_OP_AND:
-		op = "&&";
-		/* fall through */
-	case FILTER_OP_OR:
-		if (!op)
-			op = "||";
-
-		left = arg_to_str(filter, arg->op.left);
-		right = arg_to_str(filter, arg->op.right);
-		if (!left || !right)
-			break;
-
-		/* Try to consolidate boolean values */
-		if (strcmp(left, "TRUE") == 0)
-			left_val = 1;
-		else if (strcmp(left, "FALSE") == 0)
-			left_val = 0;
-
-		if (strcmp(right, "TRUE") == 0)
-			right_val = 1;
-		else if (strcmp(right, "FALSE") == 0)
-			right_val = 0;
-
-		if (left_val >= 0) {
-			if ((arg->op.type == FILTER_OP_AND && !left_val) ||
-			    (arg->op.type == FILTER_OP_OR && left_val)) {
-				/* Just return left value */
-				str = left;
-				left = NULL;
-				break;
-			}
-			if (right_val >= 0) {
-				/* just evaluate this. */
-				val = 0;
-				switch (arg->op.type) {
-				case FILTER_OP_AND:
-					val = left_val && right_val;
-					break;
-				case FILTER_OP_OR:
-					val = left_val || right_val;
-					break;
-				default:
-					break;
-				}
-				str = malloc_or_die(6);
-				if (val)
-					strcpy(str, "TRUE");
-				else
-					strcpy(str, "FALSE");
-				break;
-			}
-		}
-		if (right_val >= 0) {
-			if ((arg->op.type == FILTER_OP_AND && !right_val) ||
-			    (arg->op.type == FILTER_OP_OR && right_val)) {
-				/* Just return right value */
-				str = right;
-				right = NULL;
-				break;
-			}
-			/* The right value is meaningless */
-			str = left;
-			left = NULL;
-			break;
-		}
-
-		len = strlen(left) + strlen(right) + strlen(op) + 10;
-		str = malloc_or_die(len);
-		snprintf(str, len, "(%s) %s (%s)",
-			 left, op, right);
-		break;
-
-	case FILTER_OP_NOT:
-		op = "!";
-		right = arg_to_str(filter, arg->op.right);
-		if (!right)
-			break;
-
-		/* See if we can consolidate */
-		if (strcmp(right, "TRUE") == 0)
-			right_val = 1;
-		else if (strcmp(right, "FALSE") == 0)
-			right_val = 0;
-		if (right_val >= 0) {
-			/* just return the opposite */
-			str = malloc_or_die(6);
-			if (right_val)
-				strcpy(str, "FALSE");
-			else
-				strcpy(str, "TRUE");
-			break;
-		}
-		len = strlen(right) + strlen(op) + 3;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s(%s)", op, right);
-		break;
-
-	default:
-		/* ?? */
-		break;
-	}
-	free(left);
-	free(right);
-	return str;
-}
-
-static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
-{
-	char *str;
-
-	str = malloc_or_die(30);
-
-	snprintf(str, 30, "%lld", arg->value.val);
-
-	return str;
-}
-
-static char *field_to_str(struct event_filter *filter, struct filter_arg *arg)
-{
-	return strdup(arg->field.field->name);
-}
-
-static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
-{
-	char *lstr;
-	char *rstr;
-	char *op;
-	char *str;
-	int len;
-
-	lstr = arg_to_str(filter, arg->op.left);
-	rstr = arg_to_str(filter, arg->op.right);
-
-	switch (arg->op.type) {
-	case FILTER_EXP_ADD:
-		op = "+";
-		break;
-	case FILTER_EXP_SUB:
-		op = "-";
-		break;
-	case FILTER_EXP_MUL:
-		op = "*";
-		break;
-	case FILTER_EXP_DIV:
-		op = "/";
-		break;
-	case FILTER_EXP_MOD:
-		op = "%";
-		break;
-	case FILTER_EXP_RSHIFT:
-		op = ">>";
-		break;
-	case FILTER_EXP_LSHIFT:
-		op = "<<";
-		break;
-	case FILTER_EXP_AND:
-		op = "&";
-		break;
-	case FILTER_EXP_OR:
-		op = "|";
-		break;
-	case FILTER_EXP_XOR:
-		op = "^";
-		break;
-	default:
-		die("oops in exp");
-	}
-
-	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
-	str = malloc_or_die(len);
-	snprintf(str, len, "%s %s %s", lstr, op, rstr);
-	free(lstr);
-	free(rstr);
-
-	return str;
-}
-
-static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
-{
-	char *lstr;
-	char *rstr;
-	char *str = NULL;
-	char *op = NULL;
-	int len;
-
-	lstr = arg_to_str(filter, arg->num.left);
-	rstr = arg_to_str(filter, arg->num.right);
-
-	switch (arg->num.type) {
-	case FILTER_CMP_EQ:
-		op = "==";
-		/* fall through */
-	case FILTER_CMP_NE:
-		if (!op)
-			op = "!=";
-		/* fall through */
-	case FILTER_CMP_GT:
-		if (!op)
-			op = ">";
-		/* fall through */
-	case FILTER_CMP_LT:
-		if (!op)
-			op = "<";
-		/* fall through */
-	case FILTER_CMP_GE:
-		if (!op)
-			op = ">=";
-		/* fall through */
-	case FILTER_CMP_LE:
-		if (!op)
-			op = "<=";
-
-		len = strlen(lstr) + strlen(op) + strlen(rstr) + 4;
-		str = malloc_or_die(len);
-		sprintf(str, "%s %s %s", lstr, op, rstr);
-
-		break;
-
-	default:
-		/* ?? */
-		break;
-	}
-
-	free(lstr);
-	free(rstr);
-	return str;
-}
-
-static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
-{
-	char *str = NULL;
-	char *op = NULL;
-	int len;
-
-	switch (arg->str.type) {
-	case FILTER_CMP_MATCH:
-		op = "==";
-		/* fall through */
-	case FILTER_CMP_NOT_MATCH:
-		if (!op)
-			op = "!=";
-		/* fall through */
-	case FILTER_CMP_REGEX:
-		if (!op)
-			op = "=~";
-		/* fall through */
-	case FILTER_CMP_NOT_REGEX:
-		if (!op)
-			op = "!~";
-
-		len = strlen(arg->str.field->name) + strlen(op) +
-			strlen(arg->str.val) + 6;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s %s \"%s\"",
-			 arg->str.field->name,
-			 op, arg->str.val);
-		break;
-
-	default:
-		/* ?? */
-		break;
-	}
-	return str;
-}
-
-static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
-{
-	char *str;
-
-	switch (arg->type) {
-	case FILTER_ARG_BOOLEAN:
-		str = malloc_or_die(6);
-		if (arg->boolean.value)
-			strcpy(str, "TRUE");
-		else
-			strcpy(str, "FALSE");
-		return str;
-
-	case FILTER_ARG_OP:
-		return op_to_str(filter, arg);
-
-	case FILTER_ARG_NUM:
-		return num_to_str(filter, arg);
-
-	case FILTER_ARG_STR:
-		return str_to_str(filter, arg);
-
-	case FILTER_ARG_VALUE:
-		return val_to_str(filter, arg);
-
-	case FILTER_ARG_FIELD:
-		return field_to_str(filter, arg);
-
-	case FILTER_ARG_EXP:
-		return exp_to_str(filter, arg);
-
-	default:
-		/* ?? */
-		return NULL;
-	}
-
-}
-
-/**
- * pevent_filter_make_string - return a string showing the filter
- * @filter: filter struct with filter information
- * @event_id: the event id to return the filter string with
- *
- * Returns a string that displays the filter contents.
- *  This string must be freed with free(str).
- *  NULL is returned if no filter is found.
- */
-char *
-pevent_filter_make_string(struct event_filter *filter, int event_id)
-{
-	struct filter_type *filter_type;
-
-	if (!filter->filters)
-		return NULL;
-
-	filter_type = find_filter_type(filter, event_id);
-
-	if (!filter_type)
-		return NULL;
-
-	return arg_to_str(filter, filter_type->filter);
-}
-
-/**
- * pevent_filter_compare - compare two filters and return if they are the same
- * @filter1: Filter to compare with @filter2
- * @filter2: Filter to compare with @filter1
- *
- * Returns:
- *  1 if the two filters hold the same content.
- *  0 if they do not.
- */
-int pevent_filter_compare(struct event_filter *filter1, struct event_filter *filter2)
-{
-	struct filter_type *filter_type1;
-	struct filter_type *filter_type2;
-	char *str1, *str2;
-	int result;
-	int i;
-
-	/* Do the easy checks first */
-	if (filter1->filters != filter2->filters)
-		return 0;
-	if (!filter1->filters && !filter2->filters)
-		return 1;
-
-	/*
-	 * Now take a look at each of the events to see if they have the same
-	 * filters to them.
-	 */
-	for (i = 0; i < filter1->filters; i++) {
-		filter_type1 = &filter1->event_filters[i];
-		filter_type2 = find_filter_type(filter2, filter_type1->event_id);
-		if (!filter_type2)
-			break;
-		if (filter_type1->filter->type != filter_type2->filter->type)
-			break;
-		switch (filter_type1->filter->type) {
-		case FILTER_TRIVIAL_FALSE:
-		case FILTER_TRIVIAL_TRUE:
-			/* trivial types just need the type compared */
-			continue;
-		default:
-			break;
-		}
-		/* The best way to compare complex filters is with strings */
-		str1 = arg_to_str(filter1, filter_type1->filter);
-		str2 = arg_to_str(filter2, filter_type2->filter);
-		result = strcmp(str1, str2) != 0;
-		free(str1);
-		free(str2);
-		if (result)
-			break;
-	}
-
-	if (i < filter1->filters)
-		return 0;
-	return 1;
-}
-
diff --git a/tools/lib/parse-utils.c b/tools/lib/parse-utils.c
deleted file mode 100644
index f023a13..0000000
--- a/tools/lib/parse-utils.c
+++ /dev/null
@@ -1,110 +0,0 @@
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdarg.h>
-#include <errno.h>
-
-#define __weak __attribute__((weak))
-
-void __vdie(const char *fmt, va_list ap)
-{
-	int ret = errno;
-
-	if (errno)
-		perror("trace-cmd");
-	else
-		ret = -1;
-
-	fprintf(stderr, "  ");
-	vfprintf(stderr, fmt, ap);
-
-	fprintf(stderr, "\n");
-	exit(ret);
-}
-
-void __die(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vdie(fmt, ap);
-	va_end(ap);
-}
-
-void __weak die(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vdie(fmt, ap);
-	va_end(ap);
-}
-
-void __vwarning(const char *fmt, va_list ap)
-{
-	if (errno)
-		perror("trace-cmd");
-	errno = 0;
-
-	fprintf(stderr, "  ");
-	vfprintf(stderr, fmt, ap);
-
-	fprintf(stderr, "\n");
-}
-
-void __warning(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vwarning(fmt, ap);
-	va_end(ap);
-}
-
-void __weak warning(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vwarning(fmt, ap);
-	va_end(ap);
-}
-
-void __vpr_stat(const char *fmt, va_list ap)
-{
-	vprintf(fmt, ap);
-	printf("\n");
-}
-
-void __pr_stat(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vpr_stat(fmt, ap);
-	va_end(ap);
-}
-
-void __weak vpr_stat(const char *fmt, va_list ap)
-{
-	__vpr_stat(fmt, ap);
-}
-
-void __weak pr_stat(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vpr_stat(fmt, ap);
-	va_end(ap);
-}
-
-void __weak *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
diff --git a/tools/lib/trace-seq.c b/tools/lib/trace-seq.c
deleted file mode 100644
index d84a5bd..0000000
--- a/tools/lib/trace-seq.c
+++ /dev/null
@@ -1,153 +0,0 @@
-/*
- * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdarg.h>
-
-#include "parse-events.h"
-
-/**
- * trace_seq_printf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-{
-	int len = (TRACE_SEQ_SIZE - 1) - s->len;
-	va_list ap;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
-	va_end(ap);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return 1;
-}
-
-/**
- * trace_seq_vprintf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-{
-	int len = (TRACE_SEQ_SIZE - 1) - s->len;
-	int ret;
-
-	if (s->full || !len)
-		return 0;
-
-	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->len += ret;
-
-	return len;
-}
-
-/**
- * trace_seq_puts - trace sequence printing of simple string
- * @s: trace sequence descriptor
- * @str: simple string to record
- *
- * The tracer may use either the sequence operations or its own
- * copy to user routines. This function records a simple string
- * into a special buffer (@s) for later retrieval by a sequencer
- * or other mechanism.
- */
-int trace_seq_puts(struct trace_seq *s, const char *str)
-{
-	int len = strlen(str);
-
-	if (s->full)
-		return 0;
-
-	if (len > ((TRACE_SEQ_SIZE - 1) - s->len)) {
-		s->full = 1;
-		return 0;
-	}
-
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
-
-	return len;
-}
-
-int trace_seq_putc(struct trace_seq *s, unsigned char c)
-{
-	if (s->full)
-		return 0;
-
-	if (s->len >= (TRACE_SEQ_SIZE - 1)) {
-		s->full = 1;
-		return 0;
-	}
-
-	s->buffer[s->len++] = c;
-
-	return 1;
-}
-
-void trace_seq_terminate(struct trace_seq *s)
-{
-	if (!s->full)
-		s->buffer[s->len] = 0;
-}
-
-int trace_seq_do_printf(struct trace_seq *s)
-{
-	return printf("%.*s%s", s->len, s->buffer,
-			s->full ? "[truncated]" : "");
-}
diff --git a/tools/lib/trace/Makefile b/tools/lib/trace/Makefile
new file mode 100644
index 0000000..4c625e5
--- /dev/null
+++ b/tools/lib/trace/Makefile
@@ -0,0 +1,54 @@
+include ../../scripts/Makefile.lib
+
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
+prefix = $(HOME)
+endif
+bindir_relative = bin
+bindir = $(prefix)/$(bindir_relative)
+mandir = share/man
+infodir = share/info
+sharedir = $(prefix)/share
+ifeq ($(prefix),/usr)
+sysconfdir = /etc
+else
+sysconfdir = $(prefix)/etc
+endif
+
+export prefix bindir sharedir sysconfdir
+
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+RM = rm -f
+TAR = tar
+FIND = find
+INSTALL = install
+RPMBUILD = rpmbuild
+PTHREAD_LIBS = -lpthread
+
+ifeq ("$(origin V)", "command line")
+  VERBOSE = $(V)
+endif
+ifndef VERBOSE
+  VERBOSE = 0
+endif
+
+TRACE_LIB = $(LIB_OUTPUT)libparsevent.a
+
+all: $(TRACE_LIB)
+
+PEVENT_LIB_OBJS += parse-events.o
+PEVENT_LIB_OBJS += parse-filter.o
+PEVENT_LIB_OBJS += parse-utils.o
+PEVENT_LIB_OBJS += trace-seq.o
+
+$(OUTPUT)%.o: %.c
+	$(QUIET_CC)$(CC) -g -o $@ -c $(ALL_CFLAGS) $<
+
+$(TRACE_LIB): $(PEVENT_LIB_OBJS)
+	$(RM) $@;  $(AR) rcs $@ $^
+
+clean:
+	$(RM) *.a *.o *~ *.so $(TRACE_LIB)
+
+.PHONY: clean
diff --git a/tools/lib/trace/parse-events.c b/tools/lib/trace/parse-events.c
new file mode 100644
index 0000000..5503a18
--- /dev/null
+++ b/tools/lib/trace/parse-events.c
@@ -0,0 +1,4655 @@
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  The parts for function graph printing was taken and modified from the
+ *  Linux Kernel that were written by
+ *    - Copyright (C) 2009  Frederic Weisbecker,
+ *  Frederic Weisbecker gave his permission to relicense the code to
+ *  the Lesser General Public License.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <ctype.h>
+#include <errno.h>
+
+#include "parse-events.h"
+
+static const char *input_buf;
+static unsigned long long input_buf_ptr;
+static unsigned long long input_buf_siz;
+
+static int show_warning = 1;
+
+#define do_warning(fmt, ...)				\
+	do {						\
+		if (show_warning)			\
+			warning(fmt, ##__VA_ARGS__);	\
+	} while (0)
+
+static void init_input_buf(const char *buf, unsigned long long size)
+{
+	input_buf = buf;
+	input_buf_siz = size;
+	input_buf_ptr = 0;
+}
+
+struct event_handler {
+	struct event_handler		*next;
+	int				id;
+	const char			*sys_name;
+	const char			*event_name;
+	pevent_event_handler_func	func;
+	void				*context;
+};
+
+struct pevent_func_params {
+	struct pevent_func_params	*next;
+	enum pevent_func_arg_type	type;
+};
+
+struct pevent_function_handler {
+	struct pevent_function_handler	*next;
+	enum pevent_func_arg_type	ret_type;
+	char				*name;
+	pevent_func_handler		func;
+	struct pevent_func_params	*params;
+	int				nr_args;
+};
+
+static unsigned long long
+process_defined_func(struct trace_seq *s, void *data, int size,
+		     struct event_format *event, struct print_arg *arg);
+
+static void free_func_handle(struct pevent_function_handler *func);
+
+/**
+ * pevent_buffer_init - init buffer for parsing
+ * @buf: buffer to parse
+ * @size: the size of the buffer
+ *
+ * For use with pevent_read_token(), this initializes the internal
+ * buffer that pevent_read_token() will parse.
+ */
+void pevent_buffer_init(const char *buf, unsigned long long size)
+{
+	init_input_buf(buf, size);
+}
+
+void breakpoint(void)
+{
+	static int x;
+	x++;
+}
+
+struct print_arg *alloc_arg(void)
+{
+	struct print_arg *arg;
+
+	arg = malloc_or_die(sizeof(*arg));
+	if (!arg)
+		return NULL;
+	memset(arg, 0, sizeof(*arg));
+
+	return arg;
+}
+
+struct cmdline {
+	char *comm;
+	int pid;
+};
+
+static int cmdline_cmp(const void *a, const void *b)
+{
+	const struct cmdline *ca = a;
+	const struct cmdline *cb = b;
+
+	if (ca->pid < cb->pid)
+		return -1;
+	if (ca->pid > cb->pid)
+		return 1;
+
+	return 0;
+}
+
+struct cmdline_list {
+	struct cmdline_list	*next;
+	char			*comm;
+	int			pid;
+};
+
+static int cmdline_init(struct pevent *pevent)
+{
+	struct cmdline_list *cmdlist = pevent->cmdlist;
+	struct cmdline_list *item;
+	struct cmdline *cmdlines;
+	int i;
+
+	cmdlines = malloc_or_die(sizeof(*cmdlines) * pevent->cmdline_count);
+
+	i = 0;
+	while (cmdlist) {
+		cmdlines[i].pid = cmdlist->pid;
+		cmdlines[i].comm = cmdlist->comm;
+		i++;
+		item = cmdlist;
+		cmdlist = cmdlist->next;
+		free(item);
+	}
+
+	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
+
+	pevent->cmdlines = cmdlines;
+	pevent->cmdlist = NULL;
+
+	return 0;
+}
+
+static char *find_cmdline(struct pevent *pevent, int pid)
+{
+	const struct cmdline *comm;
+	struct cmdline key;
+
+	if (!pid)
+		return "<idle>";
+
+	if (!pevent->cmdlines)
+		cmdline_init(pevent);
+
+	key.pid = pid;
+
+	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
+		       sizeof(*pevent->cmdlines), cmdline_cmp);
+
+	if (comm)
+		return comm->comm;
+	return "<...>";
+}
+
+/**
+ * pevent_pid_is_registered - return if a pid has a cmdline registered
+ * @pevent: handle for the pevent
+ * @pid: The pid to check if it has a cmdline registered with.
+ *
+ * Returns 1 if the pid has a cmdline mapped to it
+ * 0 otherwise.
+ */
+int pevent_pid_is_registered(struct pevent *pevent, int pid)
+{
+	const struct cmdline *comm;
+	struct cmdline key;
+
+	if (!pid)
+		return 1;
+
+	if (!pevent->cmdlines)
+		cmdline_init(pevent);
+
+	key.pid = pid;
+
+	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
+		       sizeof(*pevent->cmdlines), cmdline_cmp);
+
+	if (comm)
+		return 1;
+	return 0;
+}
+
+/*
+ * If the command lines have been converted to an array, then
+ * we must add this pid. This is much slower than when cmdlines
+ * are added before the array is initialized.
+ */
+static int add_new_comm(struct pevent *pevent, char *comm, int pid)
+{
+	struct cmdline *cmdlines = pevent->cmdlines;
+	const struct cmdline *cmdline;
+	struct cmdline key;
+
+	if (!pid)
+		return 0;
+
+	/* avoid duplicates */
+	key.pid = pid;
+
+	cmdline = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
+		       sizeof(*pevent->cmdlines), cmdline_cmp);
+	if (cmdline) {
+		errno = EEXIST;
+		return -1;
+	}
+
+	cmdlines = realloc(cmdlines, sizeof(*cmdlines) * (pevent->cmdline_count + 1));
+	if (!cmdlines) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	cmdlines[pevent->cmdline_count].pid = pid;
+	cmdlines[pevent->cmdline_count].comm = comm;
+	pevent->cmdline_count++;
+
+	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
+	pevent->cmdlines = cmdlines;
+
+	return 0;
+}
+
+/**
+ * pevent_register_comm - register a pid / comm mapping
+ * @pevent: handle for the pevent
+ * @comm: the command line to register
+ * @pid: the pid to map the command line to
+ *
+ * This adds a mapping to search for command line names with
+ * a given pid. The comm is duplicated.
+ */
+int pevent_register_comm(struct pevent *pevent, char *comm, int pid)
+{
+	struct cmdline_list *item;
+
+	if (pevent->cmdlines)
+		return add_new_comm(pevent, comm, pid);
+
+	item = malloc_or_die(sizeof(*item));
+	item->comm = strdup(comm);
+	item->pid = pid;
+	item->next = pevent->cmdlist;
+
+	pevent->cmdlist = item;
+	pevent->cmdline_count++;
+
+	return 0;
+}
+
+struct func_map {
+	unsigned long long		addr;
+	char				*func;
+	char				*mod;
+};
+
+struct func_list {
+	struct func_list	*next;
+	unsigned long long	addr;
+	char			*func;
+	char			*mod;
+};
+
+static int func_cmp(const void *a, const void *b)
+{
+	const struct func_map *fa = a;
+	const struct func_map *fb = b;
+
+	if (fa->addr < fb->addr)
+		return -1;
+	if (fa->addr > fb->addr)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * We are searching for a record in between, not an exact
+ * match.
+ */
+static int func_bcmp(const void *a, const void *b)
+{
+	const struct func_map *fa = a;
+	const struct func_map *fb = b;
+
+	if ((fa->addr == fb->addr) ||
+
+	    (fa->addr > fb->addr &&
+	     fa->addr < (fb+1)->addr))
+		return 0;
+
+	if (fa->addr < fb->addr)
+		return -1;
+
+	return 1;
+}
+
+static int func_map_init(struct pevent *pevent)
+{
+	struct func_list *funclist;
+	struct func_list *item;
+	struct func_map *func_map;
+	int i;
+
+	func_map = malloc_or_die(sizeof(*func_map) * (pevent->func_count + 1));
+	funclist = pevent->funclist;
+
+	i = 0;
+	while (funclist) {
+		func_map[i].func = funclist->func;
+		func_map[i].addr = funclist->addr;
+		func_map[i].mod = funclist->mod;
+		i++;
+		item = funclist;
+		funclist = funclist->next;
+		free(item);
+	}
+
+	qsort(func_map, pevent->func_count, sizeof(*func_map), func_cmp);
+
+	/*
+	 * Add a special record at the end.
+	 */
+	func_map[pevent->func_count].func = NULL;
+	func_map[pevent->func_count].addr = 0;
+	func_map[pevent->func_count].mod = NULL;
+
+	pevent->func_map = func_map;
+	pevent->funclist = NULL;
+
+	return 0;
+}
+
+static struct func_map *
+find_func(struct pevent *pevent, unsigned long long addr)
+{
+	struct func_map *func;
+	struct func_map key;
+
+	if (!pevent->func_map)
+		func_map_init(pevent);
+
+	key.addr = addr;
+
+	func = bsearch(&key, pevent->func_map, pevent->func_count,
+		       sizeof(*pevent->func_map), func_bcmp);
+
+	return func;
+}
+
+/**
+ * pevent_find_function - find a function by a given address
+ * @pevent: handle for the pevent
+ * @addr: the address to find the function with
+ *
+ * Returns a pointer to the function stored that has the given
+ * address. Note, the address does not have to be exact, it
+ * will select the function that would contain the address.
+ */
+const char *pevent_find_function(struct pevent *pevent, unsigned long long addr)
+{
+	struct func_map *map;
+
+	map = find_func(pevent, addr);
+	if (!map)
+		return NULL;
+
+	return map->func;
+}
+
+/**
+ * pevent_find_function_address - find a function address by a given address
+ * @pevent: handle for the pevent
+ * @addr: the address to find the function with
+ *
+ * Returns the address the function starts at. This can be used in
+ * conjunction with pevent_find_function to print both the function
+ * name and the function offset.
+ */
+unsigned long long
+pevent_find_function_address(struct pevent *pevent, unsigned long long addr)
+{
+	struct func_map *map;
+
+	map = find_func(pevent, addr);
+	if (!map)
+		return 0;
+
+	return map->addr;
+}
+
+/**
+ * pevent_register_function - register a function with a given address
+ * @pevent: handle for the pevent
+ * @function: the function name to register
+ * @addr: the address the function starts at
+ * @mod: the kernel module the function may be in (NULL for none)
+ *
+ * This registers a function name with an address and module.
+ * The @func passed in is duplicated.
+ */
+int pevent_register_function(struct pevent *pevent, char *func,
+			     unsigned long long addr, char *mod)
+{
+	struct func_list *item;
+
+	item = malloc_or_die(sizeof(*item));
+
+	item->next = pevent->funclist;
+	item->func = strdup(func);
+	if (mod)
+		item->mod = strdup(mod);
+	else
+		item->mod = NULL;
+	item->addr = addr;
+
+	pevent->funclist = item;
+
+	pevent->func_count++;
+
+	return 0;
+}
+
+/**
+ * pevent_print_funcs - print out the stored functions
+ * @pevent: handle for the pevent
+ *
+ * This prints out the stored functions.
+ */
+void pevent_print_funcs(struct pevent *pevent)
+{
+	int i;
+
+	if (!pevent->func_map)
+		func_map_init(pevent);
+
+	for (i = 0; i < (int)pevent->func_count; i++) {
+		printf("%016llx %s",
+		       pevent->func_map[i].addr,
+		       pevent->func_map[i].func);
+		if (pevent->func_map[i].mod)
+			printf(" [%s]\n", pevent->func_map[i].mod);
+		else
+			printf("\n");
+	}
+}
+
+struct printk_map {
+	unsigned long long		addr;
+	char				*printk;
+};
+
+struct printk_list {
+	struct printk_list	*next;
+	unsigned long long	addr;
+	char			*printk;
+};
+
+static int printk_cmp(const void *a, const void *b)
+{
+	const struct func_map *fa = a;
+	const struct func_map *fb = b;
+
+	if (fa->addr < fb->addr)
+		return -1;
+	if (fa->addr > fb->addr)
+		return 1;
+
+	return 0;
+}
+
+static void printk_map_init(struct pevent *pevent)
+{
+	struct printk_list *printklist;
+	struct printk_list *item;
+	struct printk_map *printk_map;
+	int i;
+
+	printk_map = malloc_or_die(sizeof(*printk_map) * (pevent->printk_count + 1));
+
+	printklist = pevent->printklist;
+
+	i = 0;
+	while (printklist) {
+		printk_map[i].printk = printklist->printk;
+		printk_map[i].addr = printklist->addr;
+		i++;
+		item = printklist;
+		printklist = printklist->next;
+		free(item);
+	}
+
+	qsort(printk_map, pevent->printk_count, sizeof(*printk_map), printk_cmp);
+
+	pevent->printk_map = printk_map;
+	pevent->printklist = NULL;
+}
+
+static struct printk_map *
+find_printk(struct pevent *pevent, unsigned long long addr)
+{
+	struct printk_map *printk;
+	struct printk_map key;
+
+	if (!pevent->printk_map)
+		printk_map_init(pevent);
+
+	key.addr = addr;
+
+	printk = bsearch(&key, pevent->printk_map, pevent->printk_count,
+			 sizeof(*pevent->printk_map), printk_cmp);
+
+	return printk;
+}
+
+/**
+ * pevent_register_print_string - register a string by its address
+ * @pevent: handle for the pevent
+ * @fmt: the string format to register
+ * @addr: the address the string was located at
+ *
+ * This registers a string by the address it was stored in the kernel.
+ * The @fmt passed in is duplicated.
+ */
+int pevent_register_print_string(struct pevent *pevent, char *fmt,
+				 unsigned long long addr)
+{
+	struct printk_list *item;
+
+	item = malloc_or_die(sizeof(*item));
+
+	item->next = pevent->printklist;
+	pevent->printklist = item;
+	item->printk = strdup(fmt);
+	item->addr = addr;
+
+	pevent->printk_count++;
+
+	return 0;
+}
+
+/**
+ * pevent_print_printk - print out the stored strings
+ * @pevent: handle for the pevent
+ *
+ * This prints the string formats that were stored.
+ */
+void pevent_print_printk(struct pevent *pevent)
+{
+	int i;
+
+	if (!pevent->printk_map)
+		printk_map_init(pevent);
+
+	for (i = 0; i < (int)pevent->printk_count; i++) {
+		printf("%016llx %s\n",
+		       pevent->printk_map[i].addr,
+		       pevent->printk_map[i].printk);
+	}
+}
+
+static struct event_format *alloc_event(void)
+{
+	struct event_format *event;
+
+	event = malloc_or_die(sizeof(*event));
+	memset(event, 0, sizeof(*event));
+
+	return event;
+}
+
+static void add_event(struct pevent *pevent, struct event_format *event)
+{
+	int i;
+
+	if (!pevent->events)
+		pevent->events = malloc_or_die(sizeof(event));
+	else
+		pevent->events =
+			realloc(pevent->events, sizeof(event) *
+				(pevent->nr_events + 1));
+	if (!pevent->events)
+		die("Can not allocate events");
+
+	for (i = 0; i < pevent->nr_events; i++) {
+		if (pevent->events[i]->id > event->id)
+			break;
+	}
+	if (i < pevent->nr_events)
+		memmove(&pevent->events[i + 1],
+			&pevent->events[i],
+			sizeof(event) * (pevent->nr_events - i));
+
+	pevent->events[i] = event;
+	pevent->nr_events++;
+
+	event->pevent = pevent;
+}
+
+static int event_item_type(enum event_type type)
+{
+	switch (type) {
+	case EVENT_ITEM ... EVENT_SQUOTE:
+		return 1;
+	case EVENT_ERROR ... EVENT_DELIM:
+	default:
+		return 0;
+	}
+}
+
+static void free_flag_sym(struct print_flag_sym *fsym)
+{
+	struct print_flag_sym *next;
+
+	while (fsym) {
+		next = fsym->next;
+		free(fsym->value);
+		free(fsym->str);
+		free(fsym);
+		fsym = next;
+	}
+}
+
+static void free_arg(struct print_arg *arg)
+{
+	struct print_arg *farg;
+
+	if (!arg)
+		return;
+
+	switch (arg->type) {
+	case PRINT_ATOM:
+		free(arg->atom.atom);
+		break;
+	case PRINT_FIELD:
+		free(arg->field.name);
+		break;
+	case PRINT_FLAGS:
+		free_arg(arg->flags.field);
+		free(arg->flags.delim);
+		free_flag_sym(arg->flags.flags);
+		break;
+	case PRINT_SYMBOL:
+		free_arg(arg->symbol.field);
+		free_flag_sym(arg->symbol.symbols);
+		break;
+	case PRINT_TYPE:
+		free(arg->typecast.type);
+		free_arg(arg->typecast.item);
+		break;
+	case PRINT_STRING:
+		free(arg->string.string);
+		break;
+	case PRINT_DYNAMIC_ARRAY:
+		free(arg->dynarray.index);
+		break;
+	case PRINT_OP:
+		free(arg->op.op);
+		free_arg(arg->op.left);
+		free_arg(arg->op.right);
+		break;
+	case PRINT_FUNC:
+		while (arg->func.args) {
+			farg = arg->func.args;
+			arg->func.args = farg->next;
+			free_arg(farg);
+		}
+		break;
+
+	case PRINT_NULL:
+	default:
+		break;
+	}
+
+	free(arg);
+}
+
+static enum event_type get_type(int ch)
+{
+	if (ch == '\n')
+		return EVENT_NEWLINE;
+	if (isspace(ch))
+		return EVENT_SPACE;
+	if (isalnum(ch) || ch == '_')
+		return EVENT_ITEM;
+	if (ch == '\'')
+		return EVENT_SQUOTE;
+	if (ch == '"')
+		return EVENT_DQUOTE;
+	if (!isprint(ch))
+		return EVENT_NONE;
+	if (ch == '(' || ch == ')' || ch == ',')
+		return EVENT_DELIM;
+
+	return EVENT_OP;
+}
+
+static int __read_char(void)
+{
+	if (input_buf_ptr >= input_buf_siz)
+		return -1;
+
+	return input_buf[input_buf_ptr++];
+}
+
+static int __peek_char(void)
+{
+	if (input_buf_ptr >= input_buf_siz)
+		return -1;
+
+	return input_buf[input_buf_ptr];
+}
+
+/**
+ * pevent_peek_char - peek at the next character that will be read
+ *
+ * Returns the next character read, or -1 if end of buffer.
+ */
+int pevent_peek_char(void)
+{
+	return __peek_char();
+}
+
+static enum event_type force_token(const char *str, char **tok);
+
+static enum event_type __read_token(char **tok)
+{
+	char buf[BUFSIZ];
+	int ch, last_ch, quote_ch, next_ch;
+	int i = 0;
+	int tok_size = 0;
+	enum event_type type;
+
+	*tok = NULL;
+
+
+	ch = __read_char();
+	if (ch < 0)
+		return EVENT_NONE;
+
+	type = get_type(ch);
+	if (type == EVENT_NONE)
+		return type;
+
+	buf[i++] = ch;
+
+	switch (type) {
+	case EVENT_NEWLINE:
+	case EVENT_DELIM:
+		*tok = malloc_or_die(2);
+		(*tok)[0] = ch;
+		(*tok)[1] = 0;
+		return type;
+
+	case EVENT_OP:
+		switch (ch) {
+		case '-':
+			next_ch = __peek_char();
+			if (next_ch == '>') {
+				buf[i++] = __read_char();
+				break;
+			}
+			/* fall through */
+		case '+':
+		case '|':
+		case '&':
+		case '>':
+		case '<':
+			last_ch = ch;
+			ch = __peek_char();
+			if (ch != last_ch)
+				goto test_equal;
+			buf[i++] = __read_char();
+			switch (last_ch) {
+			case '>':
+			case '<':
+				goto test_equal;
+			default:
+				break;
+			}
+			break;
+		case '!':
+		case '=':
+			goto test_equal;
+		default: /* what should we do instead? */
+			break;
+		}
+		buf[i] = 0;
+		*tok = strdup(buf);
+		return type;
+
+ test_equal:
+		ch = __peek_char();
+		if (ch == '=')
+			buf[i++] = __read_char();
+		goto out;
+
+	case EVENT_DQUOTE:
+	case EVENT_SQUOTE:
+		/* don't keep quotes */
+		i--;
+		quote_ch = ch;
+		last_ch = 0;
+		do {
+			if (i == (BUFSIZ - 1)) {
+				buf[i] = 0;
+				if (*tok) {
+					*tok = realloc(*tok, tok_size + BUFSIZ);
+					if (!*tok)
+						return EVENT_NONE;
+					strcat(*tok, buf);
+				} else
+					*tok = strdup(buf);
+
+				if (!*tok)
+					return EVENT_NONE;
+				tok_size += BUFSIZ;
+				i = 0;
+			}
+			last_ch = ch;
+			ch = __read_char();
+			buf[i++] = ch;
+			/* the '\' '\' will cancel itself */
+			if (ch == '\\' && last_ch == '\\')
+				last_ch = 0;
+		} while (ch != quote_ch || last_ch == '\\');
+		/* remove the last quote */
+		i--;
+		goto out;
+
+	case EVENT_ERROR ... EVENT_SPACE:
+	case EVENT_ITEM:
+	default:
+		break;
+	}
+
+	while (get_type(__peek_char()) == type) {
+		if (i == (BUFSIZ - 1)) {
+			buf[i] = 0;
+			if (*tok) {
+				*tok = realloc(*tok, tok_size + BUFSIZ);
+				if (!*tok)
+					return EVENT_NONE;
+				strcat(*tok, buf);
+			} else
+				*tok = strdup(buf);
+
+			if (!*tok)
+				return EVENT_NONE;
+			tok_size += BUFSIZ;
+			i = 0;
+		}
+		ch = __read_char();
+		buf[i++] = ch;
+	}
+
+ out:
+	buf[i] = 0;
+	if (*tok) {
+		*tok = realloc(*tok, tok_size + i);
+		if (!*tok)
+			return EVENT_NONE;
+		strcat(*tok, buf);
+	} else
+		*tok = strdup(buf);
+	if (!*tok)
+		return EVENT_NONE;
+
+	if (type == EVENT_ITEM) {
+		/*
+		 * Older versions of the kernel has a bug that
+		 * creates invalid symbols and will break the mac80211
+		 * parsing. This is a work around to that bug.
+		 *
+		 * See Linux kernel commit:
+		 *  811cb50baf63461ce0bdb234927046131fc7fa8b
+		 */
+		if (strcmp(*tok, "LOCAL_PR_FMT") == 0) {
+			free(*tok);
+			*tok = NULL;
+			return force_token("\"\%s\" ", tok);
+		} else if (strcmp(*tok, "STA_PR_FMT") == 0) {
+			free(*tok);
+			*tok = NULL;
+			return force_token("\" sta:%pM\" ", tok);
+		} else if (strcmp(*tok, "VIF_PR_FMT") == 0) {
+			free(*tok);
+			*tok = NULL;
+			return force_token("\" vif:%p(%d)\" ", tok);
+		}
+	}
+
+	return type;
+}
+
+static enum event_type force_token(const char *str, char **tok)
+{
+	const char *save_input_buf;
+	unsigned long long save_input_buf_ptr;
+	unsigned long long save_input_buf_siz;
+	enum event_type type;
+	
+	/* save off the current input pointers */
+	save_input_buf = input_buf;
+	save_input_buf_ptr = input_buf_ptr;
+	save_input_buf_siz = input_buf_siz;
+
+	init_input_buf(str, strlen(str));
+
+	type = __read_token(tok);
+
+	/* reset back to original token */
+	input_buf = save_input_buf;
+	input_buf_ptr = save_input_buf_ptr;
+	input_buf_siz = save_input_buf_siz;
+
+	return type;
+}
+
+static void free_token(char *tok)
+{
+	if (tok)
+		free(tok);
+}
+
+static enum event_type read_token(char **tok)
+{
+	enum event_type type;
+
+	for (;;) {
+		type = __read_token(tok);
+		if (type != EVENT_SPACE)
+			return type;
+
+		free_token(*tok);
+	}
+
+	/* not reached */
+	*tok = NULL;
+	return EVENT_NONE;
+}
+
+/**
+ * pevent_read_token - access to utilites to use the pevent parser
+ * @tok: The token to return
+ *
+ * This will parse tokens from the string given by
+ * pevent_init_data().
+ *
+ * Returns the token type.
+ */
+enum event_type pevent_read_token(char **tok)
+{
+	return read_token(tok);
+}
+
+/**
+ * pevent_free_token - free a token returned by pevent_read_token
+ * @token: the token to free
+ */
+void pevent_free_token(char *token)
+{
+	free_token(token);
+}
+
+/* no newline */
+static enum event_type read_token_item(char **tok)
+{
+	enum event_type type;
+
+	for (;;) {
+		type = __read_token(tok);
+		if (type != EVENT_SPACE && type != EVENT_NEWLINE)
+			return type;
+		free_token(*tok);
+		*tok = NULL;
+	}
+
+	/* not reached */
+	*tok = NULL;
+	return EVENT_NONE;
+}
+
+static int test_type(enum event_type type, enum event_type expect)
+{
+	if (type != expect) {
+		do_warning("Error: expected type %d but read %d",
+		    expect, type);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_type_token(enum event_type type, const char *token,
+		    enum event_type expect, const char *expect_tok)
+{
+	if (type != expect) {
+		do_warning("Error: expected type %d but read %d",
+		    expect, type);
+		return -1;
+	}
+
+	if (strcmp(token, expect_tok) != 0) {
+		do_warning("Error: expected '%s' but read '%s'",
+		    expect_tok, token);
+		return -1;
+	}
+	return 0;
+}
+
+static int __read_expect_type(enum event_type expect, char **tok, int newline_ok)
+{
+	enum event_type type;
+
+	if (newline_ok)
+		type = read_token(tok);
+	else
+		type = read_token_item(tok);
+	return test_type(type, expect);
+}
+
+static int read_expect_type(enum event_type expect, char **tok)
+{
+	return __read_expect_type(expect, tok, 1);
+}
+
+static int __read_expected(enum event_type expect, const char *str,
+			   int newline_ok)
+{
+	enum event_type type;
+	char *token;
+	int ret;
+
+	if (newline_ok)
+		type = read_token(&token);
+	else
+		type = read_token_item(&token);
+
+	ret = test_type_token(type, token, expect, str);
+
+	free_token(token);
+
+	return ret;
+}
+
+static int read_expected(enum event_type expect, const char *str)
+{
+	return __read_expected(expect, str, 1);
+}
+
+static int read_expected_item(enum event_type expect, const char *str)
+{
+	return __read_expected(expect, str, 0);
+}
+
+static char *event_read_name(void)
+{
+	char *token;
+
+	if (read_expected(EVENT_ITEM, "name") < 0)
+		return NULL;
+
+	if (read_expected(EVENT_OP, ":") < 0)
+		return NULL;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+
+	return token;
+
+ fail:
+	free_token(token);
+	return NULL;
+}
+
+static int event_read_id(void)
+{
+	char *token;
+	int id;
+
+	if (read_expected_item(EVENT_ITEM, "ID") < 0)
+		return -1;
+
+	if (read_expected(EVENT_OP, ":") < 0)
+		return -1;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+
+	id = strtoul(token, NULL, 0);
+	free_token(token);
+	return id;
+
+ fail:
+	free_token(token);
+	return -1;
+}
+
+static int field_is_string(struct format_field *field)
+{
+	if ((field->flags & FIELD_IS_ARRAY) &&
+	    (strstr(field->type, "char") || strstr(field->type, "u8") ||
+	     strstr(field->type, "s8")))
+		return 1;
+
+	return 0;
+}
+
+static int field_is_dynamic(struct format_field *field)
+{
+	if (strncmp(field->type, "__data_loc", 10) == 0)
+		return 1;
+
+	return 0;
+}
+
+static int field_is_long(struct format_field *field)
+{
+	/* includes long long */
+	if (strstr(field->type, "long"))
+		return 1;
+
+	return 0;
+}
+
+static int event_read_fields(struct event_format *event, struct format_field **fields)
+{
+	struct format_field *field = NULL;
+	enum event_type type;
+	char *token;
+	char *last_token;
+	int count = 0;
+
+	do {
+		type = read_token(&token);
+		if (type == EVENT_NEWLINE) {
+			free_token(token);
+			return count;
+		}
+
+		count++;
+
+		if (test_type_token(type, token, EVENT_ITEM, "field"))
+			goto fail;
+		free_token(token);
+
+		type = read_token(&token);
+		/*
+		 * The ftrace fields may still use the "special" name.
+		 * Just ignore it.
+		 */
+		if (event->flags & EVENT_FL_ISFTRACE &&
+		    type == EVENT_ITEM && strcmp(token, "special") == 0) {
+			free_token(token);
+			type = read_token(&token);
+		}
+
+		if (test_type_token(type, token, EVENT_OP, ":") < 0)
+			goto fail;
+
+		free_token(token);
+		if (read_expect_type(EVENT_ITEM, &token) < 0)
+			goto fail;
+
+		last_token = token;
+
+		field = malloc_or_die(sizeof(*field));
+		memset(field, 0, sizeof(*field));
+		field->event = event;
+
+		/* read the rest of the type */
+		for (;;) {
+			type = read_token(&token);
+			if (type == EVENT_ITEM ||
+			    (type == EVENT_OP && strcmp(token, "*") == 0) ||
+			    /*
+			     * Some of the ftrace fields are broken and have
+			     * an illegal "." in them.
+			     */
+			    (event->flags & EVENT_FL_ISFTRACE &&
+			     type == EVENT_OP && strcmp(token, ".") == 0)) {
+
+				if (strcmp(token, "*") == 0)
+					field->flags |= FIELD_IS_POINTER;
+
+				if (field->type) {
+					field->type = realloc(field->type,
+							      strlen(field->type) +
+							      strlen(last_token) + 2);
+					strcat(field->type, " ");
+					strcat(field->type, last_token);
+					free(last_token);
+				} else
+					field->type = last_token;
+				last_token = token;
+				continue;
+			}
+
+			break;
+		}
+
+		if (!field->type) {
+			die("no type found");
+			goto fail;
+		}
+		field->name = last_token;
+
+		if (test_type(type, EVENT_OP))
+			goto fail;
+
+		if (strcmp(token, "[") == 0) {
+			enum event_type last_type = type;
+			char *brackets = token;
+			int len;
+
+			field->flags |= FIELD_IS_ARRAY;
+
+			type = read_token(&token);
+
+			if (type == EVENT_ITEM)
+				field->arraylen = strtoul(token, NULL, 0);
+			else
+				field->arraylen = 0;
+
+		        while (strcmp(token, "]") != 0) {
+				if (last_type == EVENT_ITEM &&
+				    type == EVENT_ITEM)
+					len = 2;
+				else
+					len = 1;
+				last_type = type;
+
+				brackets = realloc(brackets,
+						   strlen(brackets) +
+						   strlen(token) + len);
+				if (len == 2)
+					strcat(brackets, " ");
+				strcat(brackets, token);
+				/* We only care about the last token */
+				field->arraylen = strtoul(token, NULL, 0);
+				free_token(token);
+				type = read_token(&token);
+				if (type == EVENT_NONE) {
+					die("failed to find token");
+					goto fail;
+				}
+			}
+
+			free_token(token);
+
+			brackets = realloc(brackets, strlen(brackets) + 2);
+			strcat(brackets, "]");
+
+			/* add brackets to type */
+
+			type = read_token(&token);
+			/*
+			 * If the next token is not an OP, then it is of
+			 * the format: type [] item;
+			 */
+			if (type == EVENT_ITEM) {
+				field->type = realloc(field->type,
+						      strlen(field->type) +
+						      strlen(field->name) +
+						      strlen(brackets) + 2);
+				strcat(field->type, " ");
+				strcat(field->type, field->name);
+				free_token(field->name);
+				strcat(field->type, brackets);
+				field->name = token;
+				type = read_token(&token);
+			} else {
+				field->type = realloc(field->type,
+						      strlen(field->type) +
+						      strlen(brackets) + 1);
+				strcat(field->type, brackets);
+			}
+			free(brackets);
+		}
+
+		if (field_is_string(field))
+			field->flags |= FIELD_IS_STRING;
+		if (field_is_dynamic(field))
+			field->flags |= FIELD_IS_DYNAMIC;
+		if (field_is_long(field))
+			field->flags |= FIELD_IS_LONG;
+
+		if (test_type_token(type, token,  EVENT_OP, ";"))
+			goto fail;
+		free_token(token);
+
+		if (read_expected(EVENT_ITEM, "offset") < 0)
+			goto fail_expect;
+
+		if (read_expected(EVENT_OP, ":") < 0)
+			goto fail_expect;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+		field->offset = strtoul(token, NULL, 0);
+		free_token(token);
+
+		if (read_expected(EVENT_OP, ";") < 0)
+			goto fail_expect;
+
+		if (read_expected(EVENT_ITEM, "size") < 0)
+			goto fail_expect;
+
+		if (read_expected(EVENT_OP, ":") < 0)
+			goto fail_expect;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+		field->size = strtoul(token, NULL, 0);
+		free_token(token);
+
+		if (read_expected(EVENT_OP, ";") < 0)
+			goto fail_expect;
+
+		type = read_token(&token);
+		if (type != EVENT_NEWLINE) {
+			/* newer versions of the kernel have a "signed" type */
+			if (test_type_token(type, token, EVENT_ITEM, "signed"))
+				goto fail;
+
+			free_token(token);
+
+			if (read_expected(EVENT_OP, ":") < 0)
+				goto fail_expect;
+
+			if (read_expect_type(EVENT_ITEM, &token))
+				goto fail;
+
+			/* add signed type */
+
+			free_token(token);
+			if (read_expected(EVENT_OP, ";") < 0)
+				goto fail_expect;
+
+			if (read_expect_type(EVENT_NEWLINE, &token))
+				goto fail;
+		}
+
+		free_token(token);
+
+		if (field->flags & FIELD_IS_ARRAY) {
+			if (field->arraylen)
+				field->elementsize = field->size / field->arraylen;
+			else if (field->flags & FIELD_IS_STRING)
+				field->elementsize = 1;
+			else
+				field->elementsize = event->pevent->long_size;
+		} else
+			field->elementsize = field->size;
+
+		*fields = field;
+		fields = &field->next;
+
+	} while (1);
+
+	return 0;
+
+fail:
+	free_token(token);
+fail_expect:
+	if (field)
+		free(field);
+	return -1;
+}
+
+static int event_read_format(struct event_format *event)
+{
+	char *token;
+	int ret;
+
+	if (read_expected_item(EVENT_ITEM, "format") < 0)
+		return -1;
+
+	if (read_expected(EVENT_OP, ":") < 0)
+		return -1;
+
+	if (read_expect_type(EVENT_NEWLINE, &token))
+		goto fail;
+	free_token(token);
+
+	ret = event_read_fields(event, &event->format.common_fields);
+	if (ret < 0)
+		return ret;
+	event->format.nr_common = ret;
+
+	ret = event_read_fields(event, &event->format.fields);
+	if (ret < 0)
+		return ret;
+	event->format.nr_fields = ret;
+
+	return 0;
+
+ fail:
+	free_token(token);
+	return -1;
+}
+
+static enum event_type
+process_arg_token(struct event_format *event, struct print_arg *arg,
+		  char **tok, enum event_type type);
+
+static enum event_type
+process_arg(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	enum event_type type;
+	char *token;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return process_arg_token(event, arg, tok, type);
+}
+
+static enum event_type
+process_op(struct event_format *event, struct print_arg *arg, char **tok);
+
+static enum event_type
+process_cond(struct event_format *event, struct print_arg *top, char **tok)
+{
+	struct print_arg *arg, *left, *right;
+	enum event_type type;
+	char *token = NULL;
+
+	arg = alloc_arg();
+	left = alloc_arg();
+	right = alloc_arg();
+
+	arg->type = PRINT_OP;
+	arg->op.left = left;
+	arg->op.right = right;
+
+	*tok = NULL;
+	type = process_arg(event, left, &token);
+
+ again:
+	/* Handle other operations in the arguments */
+	if (type == EVENT_OP && strcmp(token, ":") != 0) {
+		type = process_op(event, left, &token);
+		goto again;
+	}
+
+	if (test_type_token(type, token, EVENT_OP, ":"))
+		goto out_free;
+
+	arg->op.op = token;
+
+	type = process_arg(event, right, &token);
+
+	top->op.right = arg;
+
+	*tok = token;
+	return type;
+
+out_free:
+	/* Top may point to itself */
+	top->op.right = NULL;
+	free_token(token);
+	free_arg(arg);
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_array(struct event_format *event, struct print_arg *top, char **tok)
+{
+	struct print_arg *arg;
+	enum event_type type;
+	char *token = NULL;
+
+	arg = alloc_arg();
+
+	*tok = NULL;
+	type = process_arg(event, arg, &token);
+	if (test_type_token(type, token, EVENT_OP, "]"))
+		goto out_free;
+
+	top->op.right = arg;
+
+	free_token(token);
+	type = read_token_item(&token);
+	*tok = token;
+
+	return type;
+
+out_free:
+	free_token(*tok);
+	*tok = NULL;
+	free_arg(arg);
+	return EVENT_ERROR;
+}
+
+static int get_op_prio(char *op)
+{
+	if (!op[1]) {
+		switch (op[0]) {
+		case '*':
+		case '/':
+		case '%':
+			return 6;
+		case '+':
+		case '-':
+			return 7;
+			/* '>>' and '<<' are 8 */
+		case '<':
+		case '>':
+			return 9;
+			/* '==' and '!=' are 10 */
+		case '&':
+			return 11;
+		case '^':
+			return 12;
+		case '|':
+			return 13;
+		case '?':
+			return 16;
+		default:
+			die("unknown op '%c'", op[0]);
+			return -1;
+		}
+	} else {
+		if (strcmp(op, "++") == 0 ||
+		    strcmp(op, "--") == 0) {
+			return 3;
+		} else if (strcmp(op, ">>") == 0 ||
+			   strcmp(op, "<<") == 0) {
+			return 8;
+		} else if (strcmp(op, ">=") == 0 ||
+			   strcmp(op, "<=") == 0) {
+			return 9;
+		} else if (strcmp(op, "==") == 0 ||
+			   strcmp(op, "!=") == 0) {
+			return 10;
+		} else if (strcmp(op, "&&") == 0) {
+			return 14;
+		} else if (strcmp(op, "||") == 0) {
+			return 15;
+		} else {
+			die("unknown op '%s'", op);
+			return -1;
+		}
+	}
+}
+
+static void set_op_prio(struct print_arg *arg)
+{
+
+	/* single ops are the greatest */
+	if (!arg->op.left || arg->op.left->type == PRINT_NULL) {
+		arg->op.prio = 0;
+		return;
+	}
+
+	arg->op.prio = get_op_prio(arg->op.op);
+}
+
+/* Note, *tok does not get freed, but will most likely be saved */
+static enum event_type
+process_op(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *left, *right = NULL;
+	enum event_type type;
+	char *token;
+
+	/* the op is passed in via tok */
+	token = *tok;
+
+	if (arg->type == PRINT_OP && !arg->op.left) {
+		/* handle single op */
+		if (token[1]) {
+			die("bad op token %s", token);
+			goto out_free;
+		}
+		switch (token[0]) {
+		case '!':
+		case '+':
+		case '-':
+			break;
+		default:
+			do_warning("bad op token %s", token);
+			goto out_free;
+
+		}
+
+		/* make an empty left */
+		left = alloc_arg();
+		left->type = PRINT_NULL;
+		arg->op.left = left;
+
+		right = alloc_arg();
+		arg->op.right = right;
+
+		/* do not free the token, it belongs to an op */
+		*tok = NULL;
+		type = process_arg(event, right, tok);
+
+	} else if (strcmp(token, "?") == 0) {
+
+		left = alloc_arg();
+		/* copy the top arg to the left */
+		*left = *arg;
+
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = left;
+		arg->op.prio = 0;
+
+		type = process_cond(event, arg, tok);
+
+	} else if (strcmp(token, ">>") == 0 ||
+		   strcmp(token, "<<") == 0 ||
+		   strcmp(token, "&") == 0 ||
+		   strcmp(token, "|") == 0 ||
+		   strcmp(token, "&&") == 0 ||
+		   strcmp(token, "||") == 0 ||
+		   strcmp(token, "-") == 0 ||
+		   strcmp(token, "+") == 0 ||
+		   strcmp(token, "*") == 0 ||
+		   strcmp(token, "^") == 0 ||
+		   strcmp(token, "/") == 0 ||
+		   strcmp(token, "<") == 0 ||
+		   strcmp(token, ">") == 0 ||
+		   strcmp(token, "==") == 0 ||
+		   strcmp(token, "!=") == 0) {
+
+		left = alloc_arg();
+
+		/* copy the top arg to the left */
+		*left = *arg;
+
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = left;
+
+		set_op_prio(arg);
+
+		type = read_token_item(&token);
+		*tok = token;
+
+		/* could just be a type pointer */
+		if ((strcmp(arg->op.op, "*") == 0) &&
+		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
+			if (left->type != PRINT_ATOM)
+				die("bad pointer type");
+			left->atom.atom = realloc(left->atom.atom,
+					    strlen(left->atom.atom) + 3);
+			strcat(left->atom.atom, " *");
+			free(arg->op.op);
+			*arg = *left;
+			free(left);
+
+			return type;
+		}
+
+		right = alloc_arg();
+		type = process_arg_token(event, right, tok, type);
+		arg->op.right = right;
+
+	} else if (strcmp(token, "[") == 0) {
+
+		left = alloc_arg();
+		*left = *arg;
+
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = left;
+
+		arg->op.prio = 0;
+
+		type = process_array(event, arg, tok);
+
+	} else {
+		do_warning("unknown op '%s'", token);
+		event->flags |= EVENT_FL_FAILED;
+		/* the arg is now the left side */
+		goto out_free;
+	}
+
+	if (type == EVENT_OP && strcmp(*tok, ":") != 0) {
+		int prio;
+
+		/* higher prios need to be closer to the root */
+		prio = get_op_prio(*tok);
+
+		if (prio > arg->op.prio)
+			return process_op(event, arg, tok);
+
+		return process_op(event, right, tok);
+	}
+
+	return type;
+
+ out_free:
+	free_token(token);
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_entry(struct event_format *event __unused, struct print_arg *arg,
+	      char **tok)
+{
+	enum event_type type;
+	char *field;
+	char *token;
+
+	if (read_expected(EVENT_OP, "->") < 0)
+		goto out_err;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto out_free;
+	field = token;
+
+	arg->type = PRINT_FIELD;
+	arg->field.name = field;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return type;
+
+ out_free:
+	free_token(token);
+ out_err:
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+static char *arg_eval (struct print_arg *arg);
+
+static unsigned long long
+eval_type_str(unsigned long long val, const char *type, int pointer)
+{
+	int sign = 0;
+	char *ref;
+	int len;
+
+	len = strlen(type);
+
+	if (pointer) {
+
+		if (type[len-1] != '*') {
+			do_warning("pointer expected with non pointer type");
+			return val;
+		}
+
+		ref = malloc_or_die(len);
+		memcpy(ref, type, len);
+
+		/* chop off the " *" */
+		ref[len - 2] = 0;
+
+		val = eval_type_str(val, ref, 0);
+		free(ref);
+		return val;
+	}
+
+	/* check if this is a pointer */
+	if (type[len - 1] == '*')
+		return val;
+
+	/* Try to figure out the arg size*/
+	if (strncmp(type, "struct", 6) == 0)
+		/* all bets off */
+		return val;
+
+	if (strcmp(type, "u8") == 0)
+		return val & 0xff;
+
+	if (strcmp(type, "u16") == 0)
+		return val & 0xffff;
+
+	if (strcmp(type, "u32") == 0)
+		return val & 0xffffffff;
+
+	if (strcmp(type, "u64") == 0 ||
+	    strcmp(type, "s64"))
+		return val;
+
+	if (strcmp(type, "s8") == 0)
+		return (unsigned long long)(char)val & 0xff;
+
+	if (strcmp(type, "s16") == 0)
+		return (unsigned long long)(short)val & 0xffff;
+
+	if (strcmp(type, "s32") == 0)
+		return (unsigned long long)(int)val & 0xffffffff;
+
+	if (strncmp(type, "unsigned ", 9) == 0) {
+		sign = 0;
+		type += 9;
+	}
+
+	if (strcmp(type, "char") == 0) {
+		if (sign)
+			return (unsigned long long)(char)val & 0xff;
+		else
+			return val & 0xff;
+	}
+
+	if (strcmp(type, "short") == 0) {
+		if (sign)
+			return (unsigned long long)(short)val & 0xffff;
+		else
+			return val & 0xffff;
+	}
+
+	if (strcmp(type, "int") == 0) {
+		if (sign)
+			return (unsigned long long)(int)val & 0xffffffff;
+		else
+			return val & 0xffffffff;
+	}
+
+	return val;
+}
+
+/*
+ * Try to figure out the type.
+ */
+static unsigned long long
+eval_type(unsigned long long val, struct print_arg *arg, int pointer)
+{
+	if (arg->type != PRINT_TYPE)
+		die("expected type argument");
+
+	return eval_type_str(val, arg->typecast.type, pointer);
+}
+
+static long long arg_num_eval(struct print_arg *arg)
+{
+	long long left, right;
+	long long val = 0;
+
+	switch (arg->type) {
+	case PRINT_ATOM:
+		val = strtoll(arg->atom.atom, NULL, 0);
+		break;
+	case PRINT_TYPE:
+		val = arg_num_eval(arg->typecast.item);
+		val = eval_type(val, arg, 0);
+		break;
+	case PRINT_OP:
+		switch (arg->op.op[0]) {
+		case '|':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			if (arg->op.op[1])
+				val = left || right;
+			else
+				val = left | right;
+			break;
+		case '&':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			if (arg->op.op[1])
+				val = left && right;
+			else
+				val = left & right;
+			break;
+		case '<':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left < right;
+				break;
+			case '<':
+				val = left << right;
+				break;
+			case '=':
+				val = left <= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '>':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left > right;
+				break;
+			case '>':
+				val = left >> right;
+				break;
+			case '=':
+				val = left >= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '=':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+
+			if (arg->op.op[1] != '=')
+				die("unknown op '%s'", arg->op.op);
+
+			val = left == right;
+			break;
+		case '!':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+
+			switch (arg->op.op[1]) {
+			case '=':
+				val = left != right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '-':
+			/* check for negative */
+			if (arg->op.left->type == PRINT_NULL)
+				left = 0;
+			else
+				left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			val = left - right;
+			break;
+		default:
+			die("unknown op '%s'", arg->op.op);
+		}
+		break;
+
+	case PRINT_NULL:
+	case PRINT_FIELD ... PRINT_SYMBOL:
+	case PRINT_STRING:
+	default:
+		die("invalid eval type %d", arg->type);
+
+	}
+	return val;
+}
+
+static char *arg_eval (struct print_arg *arg)
+{
+	long long val;
+	static char buf[20];
+
+	switch (arg->type) {
+	case PRINT_ATOM:
+		return arg->atom.atom;
+	case PRINT_TYPE:
+		return arg_eval(arg->typecast.item);
+	case PRINT_OP:
+		val = arg_num_eval(arg);
+		sprintf(buf, "%lld", val);
+		return buf;
+
+	case PRINT_NULL:
+	case PRINT_FIELD ... PRINT_SYMBOL:
+	case PRINT_STRING:
+	default:
+		die("invalid eval type %d", arg->type);
+		break;
+	}
+
+	return NULL;
+}
+
+static enum event_type
+process_fields(struct event_format *event, struct print_flag_sym **list, char **tok)
+{
+	enum event_type type;
+	struct print_arg *arg = NULL;
+	struct print_flag_sym *field;
+	char *token = *tok;
+	char *value;
+
+	do {
+		free_token(token);
+		type = read_token_item(&token);
+		if (test_type_token(type, token, EVENT_OP, "{"))
+			break;
+
+		arg = alloc_arg();
+
+		free_token(token);
+		type = process_arg(event, arg, &token);
+		if (test_type_token(type, token, EVENT_DELIM, ","))
+			goto out_free;
+
+		field = malloc_or_die(sizeof(*field));
+		memset(field, 0, sizeof(field));
+
+		value = arg_eval(arg);
+		field->value = strdup(value);
+
+		free_arg(arg);
+		arg = alloc_arg();
+
+		free_token(token);
+		type = process_arg(event, arg, &token);
+		if (test_type_token(type, token, EVENT_OP, "}"))
+			goto out_free;
+
+		value = arg_eval(arg);
+		field->str = strdup(value);
+		free_arg(arg);
+		arg = NULL;
+
+		*list = field;
+		list = &field->next;
+
+		free_token(token);
+		type = read_token_item(&token);
+	} while (type == EVENT_DELIM && strcmp(token, ",") == 0);
+
+	*tok = token;
+	return type;
+
+out_free:
+	free_arg(arg);
+	free_token(token);
+	*tok = NULL;
+
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_flags(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *field;
+	enum event_type type;
+	char *token;
+
+	memset(arg, 0, sizeof(*arg));
+	arg->type = PRINT_FLAGS;
+
+	field = alloc_arg();
+
+	type = process_arg(event, field, &token);
+	if (test_type_token(type, token, EVENT_DELIM, ","))
+		goto out_free;
+	free_token(token);
+
+	arg->flags.field = field;
+
+	type = read_token_item(&token);
+	if (event_item_type(type)) {
+		arg->flags.delim = token;
+		type = read_token_item(&token);
+	}
+
+	if (test_type_token(type, token, EVENT_DELIM, ","))
+		goto out_free;
+
+	type = process_fields(event, &arg->flags.flags, &token);
+	if (test_type_token(type, token, EVENT_DELIM, ")"))
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+ out_free:
+	free_token(token);
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *field;
+	enum event_type type;
+	char *token;
+
+	memset(arg, 0, sizeof(*arg));
+	arg->type = PRINT_SYMBOL;
+
+	field = alloc_arg();
+
+	type = process_arg(event, field, &token);
+	if (test_type_token(type, token, EVENT_DELIM, ","))
+		goto out_free;
+
+	arg->symbol.field = field;
+
+	type = process_fields(event, &arg->symbol.symbols, &token);
+	if (test_type_token(type, token, EVENT_DELIM, ")"))
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+ out_free:
+	free_token(token);
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_dynamic_array(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	struct format_field *field;
+	enum event_type type;
+	char *token;
+
+	memset(arg, 0, sizeof(*arg));
+	arg->type = PRINT_DYNAMIC_ARRAY;
+
+	/*
+	 * The item within the parenthesis is another field that holds
+	 * the index into where the array starts.
+	 */
+	type = read_token(&token);
+	*tok = token;
+	if (type != EVENT_ITEM)
+		goto out_free;
+
+	/* Find the field */
+
+	field = pevent_find_field(event, token);
+	if (!field)
+		goto out_free;
+
+	arg->dynarray.field = field;
+	arg->dynarray.index = 0;
+
+	if (read_expected(EVENT_DELIM, ")") < 0)
+		goto out_free;
+
+	type = read_token_item(&token);
+	*tok = token;
+	if (type != EVENT_OP || strcmp(token, "[") != 0)
+		return type;
+
+	free_token(token);
+	arg = alloc_arg();
+	type = process_arg(event, arg, &token);
+	if (type == EVENT_ERROR)
+		goto out_free;
+
+	if (!test_type_token(type, token, EVENT_OP, "]"))
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+ out_free:
+	free(arg);
+	free_token(token);
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_paren(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *item_arg;
+	enum event_type type;
+	char *token;
+
+	type = process_arg(event, arg, &token);
+
+	if (type == EVENT_ERROR)
+		goto out_free;
+
+	if (type == EVENT_OP)
+		type = process_op(event, arg, &token);
+
+	if (type == EVENT_ERROR)
+		goto out_free;
+
+	if (test_type_token(type, token, EVENT_DELIM, ")"))
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(&token);
+
+	/*
+	 * If the next token is an item or another open paren, then
+	 * this was a typecast.
+	 */
+	if (event_item_type(type) ||
+	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
+
+		/* make this a typecast and contine */
+
+		/* prevous must be an atom */
+		if (arg->type != PRINT_ATOM)
+			die("previous needed to be PRINT_ATOM");
+
+		item_arg = alloc_arg();
+
+		arg->type = PRINT_TYPE;
+		arg->typecast.type = arg->atom.atom;
+		arg->typecast.item = item_arg;
+		type = process_arg_token(event, item_arg, &token, type);
+
+	}
+
+	*tok = token;
+	return type;
+
+ out_free:
+	free_token(token);
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+
+static enum event_type
+process_str(struct event_format *event __unused, struct print_arg *arg, char **tok)
+{
+	enum event_type type;
+	char *token;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto out_free;
+
+	arg->type = PRINT_STRING;
+	arg->string.string = token;
+	arg->string.offset = -1;
+
+	if (read_expected(EVENT_DELIM, ")") < 0)
+		goto out_err;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return type;
+
+ out_free:
+	free_token(token);
+ out_err:
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+static struct pevent_function_handler *
+find_func_handler(struct pevent *pevent, char *func_name)
+{
+	struct pevent_function_handler *func;
+
+	for (func = pevent->func_handlers; func; func = func->next) {
+		if (strcmp(func->name, func_name) == 0)
+			break;
+	}
+
+	return func;
+}
+
+static void remove_func_handler(struct pevent *pevent, char *func_name)
+{
+	struct pevent_function_handler *func;
+	struct pevent_function_handler **next;
+
+	next = &pevent->func_handlers;
+	while ((func = *next)) {
+		if (strcmp(func->name, func_name) == 0) {
+			*next = func->next;
+			free_func_handle(func);
+			break;
+		}
+		next = &func->next;
+	}
+}
+
+static enum event_type
+process_func_handler(struct event_format *event, struct pevent_function_handler *func,
+		     struct print_arg *arg, char **tok)
+{
+	struct print_arg **next_arg;
+	struct print_arg *farg;
+	enum event_type type;
+	char *token;
+	char *test;
+	int i;
+
+	arg->type = PRINT_FUNC;
+	arg->func.func = func;
+
+	*tok = NULL;
+
+	next_arg = &(arg->func.args);
+	for (i = 0; i < func->nr_args; i++) {
+		farg = alloc_arg();
+		type = process_arg(event, farg, &token);
+		if (i < (func->nr_args - 1))
+			test = ",";
+		else
+			test = ")";
+
+		if (test_type_token(type, token, EVENT_DELIM, test)) {
+			free_arg(farg);
+			free_token(token);
+			return EVENT_ERROR;
+		}
+
+		*next_arg = farg;
+		next_arg = &(farg->next);
+	}
+
+	type = read_token(&token);
+	*tok = token;
+
+	return type;
+}
+
+static enum event_type
+process_function(struct event_format *event, struct print_arg *arg,
+		 char *token, char **tok)
+{
+	struct pevent_function_handler *func;
+
+	if (strcmp(token, "__print_flags") == 0) {
+		free_token(token);
+		return process_flags(event, arg, tok);
+	}
+	if (strcmp(token, "__print_symbolic") == 0) {
+		free_token(token);
+		return process_symbols(event, arg, tok);
+	}
+	if (strcmp(token, "__get_str") == 0) {
+		free_token(token);
+		return process_str(event, arg, tok);
+	}
+	if (strcmp(token, "__get_dynamic_array") == 0) {
+		free_token(token);
+		return process_dynamic_array(event, arg, tok);
+	}
+
+	func = find_func_handler(event->pevent, token);
+	if (func) {
+		free_token(token);
+		return process_func_handler(event, func, arg, tok);
+	}
+
+	do_warning("function %s not defined", token);
+	free_token(token);
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_arg_token(struct event_format *event, struct print_arg *arg,
+		  char **tok, enum event_type type)
+{
+	char *token;
+	char *atom;
+
+	token = *tok;
+
+	switch (type) {
+	case EVENT_ITEM:
+		if (strcmp(token, "REC") == 0) {
+			free_token(token);
+			type = process_entry(event, arg, &token);
+			break;
+		}
+		atom = token;
+		/* test the next token */
+		type = read_token_item(&token);
+
+		/*
+		 * If the next token is a parenthesis, then this
+		 * is a function.
+		 */
+		if (type == EVENT_DELIM && strcmp(token, "(") == 0) {
+			free_token(token);
+			token = NULL;
+			/* this will free atom. */
+			type = process_function(event, arg, atom, &token);
+			break;
+		}
+		/* atoms can be more than one token long */
+		while (type == EVENT_ITEM) {
+			atom = realloc(atom, strlen(atom) + strlen(token) + 2);
+			strcat(atom, " ");
+			strcat(atom, token);
+			free_token(token);
+			type = read_token_item(&token);
+		}
+
+		arg->type = PRINT_ATOM;
+		arg->atom.atom = atom;
+		break;
+
+	case EVENT_DQUOTE:
+	case EVENT_SQUOTE:
+		arg->type = PRINT_ATOM;
+		arg->atom.atom = token;
+		type = read_token_item(&token);
+		break;
+	case EVENT_DELIM:
+		if (strcmp(token, "(") == 0) {
+			free_token(token);
+			type = process_paren(event, arg, &token);
+			break;
+		}
+	case EVENT_OP:
+		/* handle single ops */
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = NULL;
+		type = process_op(event, arg, &token);
+
+		/* On error, the op is freed */
+		if (type == EVENT_ERROR)
+			arg->op.op = NULL;
+
+		/* return error type if errored */
+		break;
+
+	case EVENT_ERROR ... EVENT_NEWLINE:
+	default:
+		die("unexpected type %d", type);
+	}
+	*tok = token;
+
+	return type;
+}
+
+static int event_read_print_args(struct event_format *event, struct print_arg **list)
+{
+	enum event_type type = EVENT_ERROR;
+	struct print_arg *arg;
+	char *token;
+	int args = 0;
+
+	do {
+		if (type == EVENT_NEWLINE) {
+			type = read_token_item(&token);
+			continue;
+		}
+
+		arg = alloc_arg();
+
+		type = process_arg(event, arg, &token);
+
+		if (type == EVENT_ERROR) {
+			free_token(token);
+			free_arg(arg);
+			return -1;
+		}
+
+		*list = arg;
+		args++;
+
+		if (type == EVENT_OP) {
+			type = process_op(event, arg, &token);
+			free_token(token);
+			if (type == EVENT_ERROR) {
+				*list = NULL;
+				free_arg(arg);
+				return -1;
+			}
+			list = &arg->next;
+			continue;
+		}
+
+		if (type == EVENT_DELIM && strcmp(token, ",") == 0) {
+			free_token(token);
+			*list = arg;
+			list = &arg->next;
+			continue;
+		}
+		break;
+	} while (type != EVENT_NONE);
+
+	if (type != EVENT_NONE && type != EVENT_ERROR)
+		free_token(token);
+
+	return args;
+}
+
+static int event_read_print(struct event_format *event)
+{
+	enum event_type type;
+	char *token;
+	int ret;
+
+	if (read_expected_item(EVENT_ITEM, "print") < 0)
+		return -1;
+
+	if (read_expected(EVENT_ITEM, "fmt") < 0)
+		return -1;
+
+	if (read_expected(EVENT_OP, ":") < 0)
+		return -1;
+
+	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
+		goto fail;
+
+ concat:
+	event->print_fmt.format = token;
+	event->print_fmt.args = NULL;
+
+	/* ok to have no arg */
+	type = read_token_item(&token);
+
+	if (type == EVENT_NONE)
+		return 0;
+
+	/* Handle concatenation of print lines */
+	if (type == EVENT_DQUOTE) {
+		char *cat;
+
+		cat = malloc_or_die(strlen(event->print_fmt.format) +
+				    strlen(token) + 1);
+		strcpy(cat, event->print_fmt.format);
+		strcat(cat, token);
+		free_token(token);
+		free_token(event->print_fmt.format);
+		event->print_fmt.format = NULL;
+		token = cat;
+		goto concat;
+	}
+			     
+	if (test_type_token(type, token, EVENT_DELIM, ","))
+		goto fail;
+
+	free_token(token);
+
+	ret = event_read_print_args(event, &event->print_fmt.args);
+	if (ret < 0)
+		return -1;
+
+	return ret;
+
+ fail:
+	free_token(token);
+	return -1;
+}
+
+/**
+ * pevent_find_common_field - return a common field by event
+ * @event: handle for the event
+ * @name: the name of the common field to return
+ *
+ * Returns a common field from the event by the given @name.
+ * This only searchs the common fields and not all field.
+ */
+struct format_field *
+pevent_find_common_field(struct event_format *event, const char *name)
+{
+	struct format_field *format;
+
+	for (format = event->format.common_fields;
+	     format; format = format->next) {
+		if (strcmp(format->name, name) == 0)
+			break;
+	}
+
+	return format;
+}
+
+/**
+ * pevent_find_field - find a non-common field
+ * @event: handle for the event
+ * @name: the name of the non-common field
+ *
+ * Returns a non-common field by the given @name.
+ * This does not search common fields.
+ */
+struct format_field *
+pevent_find_field(struct event_format *event, const char *name)
+{
+	struct format_field *format;
+
+	for (format = event->format.fields;
+	     format; format = format->next) {
+		if (strcmp(format->name, name) == 0)
+			break;
+	}
+
+	return format;
+}
+
+/**
+ * pevent_find_any_field - find any field by name
+ * @event: handle for the event
+ * @name: the name of the field
+ *
+ * Returns a field by the given @name.
+ * This searchs the common field names first, then
+ * the non-common ones if a common one was not found.
+ */
+struct format_field *
+pevent_find_any_field(struct event_format *event, const char *name)
+{
+	struct format_field *format;
+
+	format = pevent_find_common_field(event, name);
+	if (format)
+		return format;
+	return pevent_find_field(event, name);
+}
+
+/**
+ * pevent_read_number - read a number from data
+ * @pevent: handle for the pevent
+ * @ptr: the raw data
+ * @size: the size of the data that holds the number
+ *
+ * Returns the number (converted to host) from the
+ * raw data.
+ */
+unsigned long long pevent_read_number(struct pevent *pevent,
+				      const void *ptr, int size)
+{
+	switch (size) {
+	case 1:
+		return *(unsigned char *)ptr;
+	case 2:
+		return data2host2(pevent, ptr);
+	case 4:
+		return data2host4(pevent, ptr);
+	case 8:
+		return data2host8(pevent, ptr);
+	default:
+		/* BUG! */
+		return 0;
+	}
+}
+
+/**
+ * pevent_read_number_field - read a number from data
+ * @field: a handle to the field
+ * @data: the raw data to read
+ * @value: the value to place the number in
+ *
+ * Reads raw data according to a field offset and size,
+ * and translates it into @value.
+ *
+ * Returns 0 on success, -1 otherwise.
+ */
+int pevent_read_number_field(struct format_field *field, const void *data,
+			     unsigned long long *value)
+{
+	switch (field->size) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		*value = pevent_read_number(field->event->pevent,
+					    data + field->offset, field->size);
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+static int get_common_info(struct pevent *pevent,
+			   const char *type, int *offset, int *size)
+{
+	struct event_format *event;
+	struct format_field *field;
+
+	/*
+	 * All events should have the same common elements.
+	 * Pick any event to find where the type is;
+	 */
+	if (!pevent->events)
+		die("no event_list!");
+
+	event = pevent->events[0];
+	field = pevent_find_common_field(event, type);
+	if (!field)
+		die("field '%s' not found", type);
+
+	*offset = field->offset;
+	*size = field->size;
+
+	return 0;
+}
+
+static int __parse_common(struct pevent *pevent, void *data,
+			  int *size, int *offset, const char *name)
+{
+	int ret;
+
+	if (!*size) {
+		ret = get_common_info(pevent, name, offset, size);
+		if (ret < 0)
+			return ret;
+	}
+	return pevent_read_number(pevent, data + *offset, *size);
+}
+
+static int trace_parse_common_type(struct pevent *pevent, void *data)
+{
+	return __parse_common(pevent, data,
+			      &pevent->type_size, &pevent->type_offset,
+			      "common_type");
+}
+
+static int parse_common_pid(struct pevent *pevent, void *data)
+{
+	return __parse_common(pevent, data,
+			      &pevent->pid_size, &pevent->pid_offset,
+			      "common_pid");
+}
+
+static int parse_common_pc(struct pevent *pevent, void *data)
+{
+	return __parse_common(pevent, data,
+			      &pevent->pc_size, &pevent->pc_offset,
+			      "common_preempt_count");
+}
+
+static int parse_common_flags(struct pevent *pevent, void *data)
+{
+	return __parse_common(pevent, data,
+			      &pevent->flags_size, &pevent->flags_offset,
+			      "common_flags");
+}
+
+static int parse_common_lock_depth(struct pevent *pevent, void *data)
+{
+	int ret;
+
+	ret = __parse_common(pevent, data,
+			     &pevent->ld_size, &pevent->ld_offset,
+			     "common_lock_depth");
+	if (ret < 0)
+		return -1;
+
+	return ret;
+}
+
+static int events_id_cmp(const void *a, const void *b);
+
+/**
+ * pevent_find_event - find an event by given id
+ * @pevent: a handle to the pevent
+ * @id: the id of the event
+ *
+ * Returns an event that has a given @id.
+ */
+struct event_format *pevent_find_event(struct pevent *pevent, int id)
+{
+	struct event_format **eventptr;
+	struct event_format key;
+	struct event_format *pkey = &key;
+
+	/* Check cache first */
+	if (pevent->last_event && pevent->last_event->id == id)
+		return pevent->last_event;
+
+	key.id = id;
+
+	eventptr = bsearch(&pkey, pevent->events, pevent->nr_events,
+			   sizeof(*pevent->events), events_id_cmp);
+
+	if (eventptr) {
+		pevent->last_event = *eventptr;
+		return *eventptr;
+	}
+
+	return NULL;
+}
+
+/**
+ * pevent_find_event_by_name - find an event by given name
+ * @pevent: a handle to the pevent
+ * @sys: the system name to search for
+ * @name: the name of the event to search for
+ *
+ * This returns an event with a given @name and under the system
+ * @sys. If @sys is NULL the first event with @name is returned.
+ */
+struct event_format *
+pevent_find_event_by_name(struct pevent *pevent,
+			  const char *sys, const char *name)
+{
+	struct event_format *event;
+	int i;
+
+	if (pevent->last_event &&
+	    strcmp(pevent->last_event->name, name) == 0 &&
+	    (!sys || strcmp(pevent->last_event->system, sys) == 0))
+		return pevent->last_event;
+
+	for (i = 0; i < pevent->nr_events; i++) {
+		event = pevent->events[i];
+		if (strcmp(event->name, name) == 0) {
+			if (!sys)
+				break;
+			if (strcmp(event->system, sys) == 0)
+				break;
+		}
+	}
+	if (i == pevent->nr_events)
+		event = NULL;
+
+	pevent->last_event = event;
+	return event;
+}
+
+static unsigned long long
+eval_num_arg(void *data, int size, struct event_format *event, struct print_arg *arg)
+{
+	struct pevent *pevent = event->pevent;
+	unsigned long long val = 0;
+	unsigned long long left, right;
+	struct print_arg *typearg = NULL;
+	struct print_arg *larg;
+	unsigned long offset;
+	unsigned int field_size;
+
+	switch (arg->type) {
+	case PRINT_NULL:
+		/* ?? */
+		return 0;
+	case PRINT_ATOM:
+		return strtoull(arg->atom.atom, NULL, 0);
+	case PRINT_FIELD:
+		if (!arg->field.field) {
+			arg->field.field = pevent_find_any_field(event, arg->field.name);
+			if (!arg->field.field)
+				die("field %s not found", arg->field.name);
+		}
+		/* must be a number */
+		val = pevent_read_number(pevent, data + arg->field.field->offset,
+				arg->field.field->size);
+		break;
+	case PRINT_FLAGS:
+	case PRINT_SYMBOL:
+		break;
+	case PRINT_TYPE:
+		val = eval_num_arg(data, size, event, arg->typecast.item);
+		return eval_type(val, arg, 0);
+	case PRINT_STRING:
+		return 0;
+	case PRINT_FUNC: {
+		struct trace_seq s;
+		trace_seq_init(&s);
+		return process_defined_func(&s, data, size, event, arg);
+	}
+	case PRINT_OP:
+		if (strcmp(arg->op.op, "[") == 0) {
+			/*
+			 * Arrays are special, since we don't want
+			 * to read the arg as is.
+			 */
+			right = eval_num_arg(data, size, event, arg->op.right);
+
+			/* handle typecasts */
+			larg = arg->op.left;
+			while (larg->type == PRINT_TYPE) {
+				if (!typearg)
+					typearg = larg;
+				larg = larg->typecast.item;
+			}
+
+			/* Default to long size */
+			field_size = pevent->long_size;
+
+			switch (larg->type) {
+			case PRINT_DYNAMIC_ARRAY:
+				offset = pevent_read_number(pevent,
+						   data + larg->dynarray.field->offset,
+						   larg->dynarray.field->size);
+				if (larg->dynarray.field->elementsize)
+					field_size = larg->dynarray.field->elementsize;
+				/*
+				 * The actual length of the dynamic array is stored
+				 * in the top half of the field, and the offset
+				 * is in the bottom half of the 32 bit field.
+				 */
+				offset &= 0xffff;
+				offset += right;
+				break;
+			case PRINT_FIELD:
+				if (!larg->field.field) {
+					larg->field.field =
+						pevent_find_any_field(event, larg->field.name);
+					if (!larg->field.field)
+						die("field %s not found", larg->field.name);
+				}
+				field_size = larg->field.field->elementsize;
+				offset = larg->field.field->offset +
+					right * larg->field.field->elementsize;
+				break;
+			default:
+				goto default_op; /* oops, all bets off */
+			}
+			val = pevent_read_number(pevent,
+						 data + offset, field_size);
+			if (typearg)
+				val = eval_type(val, typearg, 1);
+			break;
+		} else if (strcmp(arg->op.op, "?") == 0) {
+			left = eval_num_arg(data, size, event, arg->op.left);
+			arg = arg->op.right;
+			if (left)
+				val = eval_num_arg(data, size, event, arg->op.left);
+			else
+				val = eval_num_arg(data, size, event, arg->op.right);
+			break;
+		}
+ default_op:
+		left = eval_num_arg(data, size, event, arg->op.left);
+		right = eval_num_arg(data, size, event, arg->op.right);
+		switch (arg->op.op[0]) {
+		case '|':
+			if (arg->op.op[1])
+				val = left || right;
+			else
+				val = left | right;
+			break;
+		case '&':
+			if (arg->op.op[1])
+				val = left && right;
+			else
+				val = left & right;
+			break;
+		case '<':
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left < right;
+				break;
+			case '<':
+				val = left << right;
+				break;
+			case '=':
+				val = left <= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '>':
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left > right;
+				break;
+			case '>':
+				val = left >> right;
+				break;
+			case '=':
+				val = left >= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '=':
+			if (arg->op.op[1] != '=')
+				die("unknown op '%s'", arg->op.op);
+			val = left == right;
+			break;
+		case '-':
+			val = left - right;
+			break;
+		case '+':
+			val = left + right;
+			break;
+		default:
+			die("unknown op '%s'", arg->op.op);
+		}
+		break;
+	default: /* not sure what to do there */
+		return 0;
+	}
+	return val;
+}
+
+struct flag {
+	const char *name;
+	unsigned long long value;
+};
+
+static const struct flag flags[] = {
+	{ "HI_SOFTIRQ", 0 },
+	{ "TIMER_SOFTIRQ", 1 },
+	{ "NET_TX_SOFTIRQ", 2 },
+	{ "NET_RX_SOFTIRQ", 3 },
+	{ "BLOCK_SOFTIRQ", 4 },
+	{ "BLOCK_IOPOLL_SOFTIRQ", 5 },
+	{ "TASKLET_SOFTIRQ", 6 },
+	{ "SCHED_SOFTIRQ", 7 },
+	{ "HRTIMER_SOFTIRQ", 8 },
+	{ "RCU_SOFTIRQ", 9 },
+
+	{ "HRTIMER_NORESTART", 0 },
+	{ "HRTIMER_RESTART", 1 },
+};
+
+static unsigned long long eval_flag(const char *flag)
+{
+	int i;
+
+	/*
+	 * Some flags in the format files do not get converted.
+	 * If the flag is not numeric, see if it is something that
+	 * we already know about.
+	 */
+	if (isdigit(flag[0]))
+		return strtoull(flag, NULL, 0);
+
+	for (i = 0; i < (int)(sizeof(flags)/sizeof(flags[0])); i++)
+		if (strcmp(flags[i].name, flag) == 0)
+			return flags[i].value;
+
+	return 0;
+}
+
+static void print_str_arg(struct trace_seq *s, void *data, int size,
+			  struct event_format *event, struct print_arg *arg)
+{
+	struct pevent *pevent = event->pevent;
+	struct print_flag_sym *flag;
+	unsigned long long val, fval;
+	unsigned long addr;
+	char *str;
+	int print;
+	int len;
+
+	switch (arg->type) {
+	case PRINT_NULL:
+		/* ?? */
+		return;
+	case PRINT_ATOM:
+		trace_seq_puts(s, arg->atom.atom);
+		return;
+	case PRINT_FIELD:
+		if (!arg->field.field) {
+			arg->field.field = pevent_find_any_field(event, arg->field.name);
+			if (!arg->field.field)
+				die("field %s not found", arg->field.name);
+		}
+		/* Zero sized fields, mean the rest of the data */
+		len = arg->field.field->size ? : size;
+
+		/*
+		 * Some events pass in pointers. If this is not an array
+		 * and the size is the same as long_size, assume that it
+		 * is a pointer.
+		 */
+		if (!(arg->field.field->flags & FIELD_IS_ARRAY) &&
+		    len == pevent->long_size) {
+			addr = *(unsigned long *)(data + arg->field.field->offset);
+			trace_seq_printf(s, "%lx", addr);
+			break;
+		}
+		str = malloc_or_die(len + 1);
+		memcpy(str, data + arg->field.field->offset, len);
+		str[len] = 0;
+		trace_seq_puts(s, str);
+		free(str);
+		break;
+	case PRINT_FLAGS:
+		val = eval_num_arg(data, size, event, arg->flags.field);
+		print = 0;
+		for (flag = arg->flags.flags; flag; flag = flag->next) {
+			fval = eval_flag(flag->value);
+			if (!val && !fval) {
+				trace_seq_puts(s, flag->str);
+				break;
+			}
+			if (fval && (val & fval) == fval) {
+				if (print && arg->flags.delim)
+					trace_seq_puts(s, arg->flags.delim);
+				trace_seq_puts(s, flag->str);
+				print = 1;
+				val &= ~fval;
+			}
+		}
+		break;
+	case PRINT_SYMBOL:
+		val = eval_num_arg(data, size, event, arg->symbol.field);
+		for (flag = arg->symbol.symbols; flag; flag = flag->next) {
+			fval = eval_flag(flag->value);
+			if (val == fval) {
+				trace_seq_puts(s, flag->str);
+				break;
+			}
+		}
+		break;
+
+	case PRINT_TYPE:
+		break;
+	case PRINT_STRING: {
+		int str_offset;
+
+		if (arg->string.offset == -1) {
+			struct format_field *f;
+
+			f = pevent_find_any_field(event, arg->string.string);
+			arg->string.offset = f->offset;
+		}
+		str_offset = data2host4(pevent, data + arg->string.offset);
+		str_offset &= 0xffff;
+		trace_seq_puts(s, ((char *)data) + str_offset);
+		break;
+	}
+	case PRINT_OP:
+		/*
+		 * The only op for string should be ? :
+		 */
+		if (arg->op.op[0] != '?')
+			return;
+		val = eval_num_arg(data, size, event, arg->op.left);
+		if (val)
+			print_str_arg(s, data, size, event, arg->op.right->op.left);
+		else
+			print_str_arg(s, data, size, event, arg->op.right->op.right);
+		break;
+	case PRINT_FUNC:
+		process_defined_func(s, data, size, event, arg);
+		break;
+	default:
+		/* well... */
+		break;
+	}
+}
+
+static unsigned long long
+process_defined_func(struct trace_seq *s, void *data, int size,
+		     struct event_format *event, struct print_arg *arg)
+{
+	struct pevent_function_handler *func_handle = arg->func.func;
+	struct pevent_func_params *param;
+	unsigned long long *args;
+	unsigned long long ret;
+	struct print_arg *farg;
+	struct trace_seq str;
+	struct save_str {
+		struct save_str *next;
+		char *str;
+	} *strings = NULL, *string;
+	int i;
+
+	if (!func_handle->nr_args) {
+		ret = (*func_handle->func)(s, NULL);
+		goto out;
+	}
+
+	farg = arg->func.args;
+	param = func_handle->params;
+
+	args = malloc_or_die(sizeof(*args) * func_handle->nr_args);
+	for (i = 0; i < func_handle->nr_args; i++) {
+		switch (param->type) {
+		case PEVENT_FUNC_ARG_INT:
+		case PEVENT_FUNC_ARG_LONG:
+		case PEVENT_FUNC_ARG_PTR:
+			args[i] = eval_num_arg(data, size, event, farg);
+			break;
+		case PEVENT_FUNC_ARG_STRING:
+			trace_seq_init(&str);
+			print_str_arg(&str, data, size, event, farg);
+			trace_seq_terminate(&str);
+			string = malloc_or_die(sizeof(*string));
+			string->next = strings;
+			string->str = strdup(str.buffer);
+			strings = string;
+			break;
+		default:
+			/*
+			 * Something went totally wrong, this is not
+			 * an input error, something in this code broke.
+			 */
+			die("Unexpected end of arguments\n");
+			break;
+		}
+		farg = farg->next;
+	}
+
+	ret = (*func_handle->func)(s, args);
+	free(args);
+	while (strings) {
+		string = strings;
+		strings = string->next;
+		free(string->str);
+		free(string);
+	}
+
+ out:
+	/* TBD : handle return type here */
+	return ret;
+}
+
+static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event_format *event)
+{
+	struct pevent *pevent = event->pevent;
+	struct format_field *field, *ip_field;
+	struct print_arg *args, *arg, **next;
+	unsigned long long ip, val;
+	char *ptr;
+	void *bptr;
+
+	field = pevent->bprint_buf_field;
+	ip_field = pevent->bprint_ip_field;
+
+	if (!field) {
+		field = pevent_find_field(event, "buf");
+		if (!field)
+			die("can't find buffer field for binary printk");
+		ip_field = pevent_find_field(event, "ip");
+		if (!ip_field)
+			die("can't find ip field for binary printk");
+		pevent->bprint_buf_field = field;
+		pevent->bprint_ip_field = ip_field;
+	}
+
+	ip = pevent_read_number(pevent, data + ip_field->offset, ip_field->size);
+
+	/*
+	 * The first arg is the IP pointer.
+	 */
+	args = alloc_arg();
+	arg = args;
+	arg->next = NULL;
+	next = &arg->next;
+
+	arg->type = PRINT_ATOM;
+	arg->atom.atom = malloc_or_die(32);
+	sprintf(arg->atom.atom, "%lld", ip);
+
+	/* skip the first "%pf : " */
+	for (ptr = fmt + 6, bptr = data + field->offset;
+	     bptr < data + size && *ptr; ptr++) {
+		int ls = 0;
+
+		if (*ptr == '%') {
+ process_again:
+			ptr++;
+			switch (*ptr) {
+			case '%':
+				break;
+			case 'l':
+				ls++;
+				goto process_again;
+			case 'L':
+				ls = 2;
+				goto process_again;
+			case '0' ... '9':
+				goto process_again;
+			case 'p':
+				ls = 1;
+				/* fall through */
+			case 'd':
+			case 'u':
+			case 'x':
+			case 'i':
+				/* the pointers are always 4 bytes aligned */
+				bptr = (void *)(((unsigned long)bptr + 3) &
+						~3);
+				switch (ls) {
+				case 0:
+				case 1:
+					ls = pevent->long_size;
+					break;
+				case 2:
+					ls = 8;
+				default:
+					break;
+				}
+				val = pevent_read_number(pevent, bptr, ls);
+				bptr += ls;
+				arg = alloc_arg();
+				arg->next = NULL;
+				arg->type = PRINT_ATOM;
+				arg->atom.atom = malloc_or_die(32);
+				sprintf(arg->atom.atom, "%lld", val);
+				*next = arg;
+				next = &arg->next;
+				break;
+			case 's':
+				arg = alloc_arg();
+				arg->next = NULL;
+				arg->type = PRINT_STRING;
+				arg->string.string = strdup(bptr);
+				bptr += strlen(bptr) + 1;
+				*next = arg;
+				next = &arg->next;
+			default:
+				break;
+			}
+		}
+	}
+
+	return args;
+}
+
+static void free_args(struct print_arg *args)
+{
+	struct print_arg *next;
+
+	while (args) {
+		next = args->next;
+
+		free_arg(args);
+		args = next;
+	}
+}
+
+static char *
+get_bprint_format(void *data, int size __unused, struct event_format *event)
+{
+	struct pevent *pevent = event->pevent;
+	unsigned long long addr;
+	struct format_field *field;
+	struct printk_map *printk;
+	char *format;
+	char *p;
+
+	field = pevent->bprint_fmt_field;
+
+	if (!field) {
+		field = pevent_find_field(event, "fmt");
+		if (!field)
+			die("can't find format field for binary printk");
+		printf("field->offset = %d size=%d\n", field->offset, field->size);
+		pevent->bprint_fmt_field = field;
+	}
+
+	addr = pevent_read_number(pevent, data + field->offset, field->size);
+
+	printk = find_printk(pevent, addr);
+	if (!printk) {
+		format = malloc_or_die(45);
+		sprintf(format, "%%pf : (NO FORMAT FOUND at %llx)\n",
+			addr);
+		return format;
+	}
+
+	p = printk->printk;
+	/* Remove any quotes. */
+	if (*p == '"')
+		p++;
+	format = malloc_or_die(strlen(p) + 10);
+	sprintf(format, "%s : %s", "%pf", p);
+	/* remove ending quotes and new line since we will add one too */
+	p = format + strlen(format) - 1;
+	if (*p == '"')
+		*p = 0;
+
+	p -= 2;
+	if (strcmp(p, "\\n") == 0)
+		*p = 0;
+
+	return format;
+}
+
+static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
+			  struct event_format *event, struct print_arg *arg)
+{
+	unsigned char *buf;
+	char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
+
+	if (arg->type == PRINT_FUNC) {
+		process_defined_func(s, data, size, event, arg);
+		return;
+	}
+
+	if (arg->type != PRINT_FIELD) {
+		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d",
+				 arg->type);
+		return;
+	}
+
+	if (mac == 'm')
+		fmt = "%.2x%.2x%.2x%.2x%.2x%.2x";
+	if (!arg->field.field) {
+		arg->field.field =
+			pevent_find_any_field(event, arg->field.name);
+		if (!arg->field.field)
+			die("field %s not found", arg->field.name);
+	}
+	if (arg->field.field->size != 6) {
+		trace_seq_printf(s, "INVALIDMAC");
+		return;
+	}
+	buf = data + arg->field.field->offset;
+	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
+}
+
+static void print_event_fields(struct trace_seq *s, void *data, int size,
+			       struct event_format *event)
+{
+	struct format_field *field;
+	unsigned long long val;
+	unsigned int offset, len, i;
+
+	field = event->format.fields;
+	while (field) {
+		trace_seq_printf(s, " %s=", field->name);
+		if (field->flags & FIELD_IS_ARRAY) {
+			offset = field->offset;
+			len = field->size;
+			if (field->flags & FIELD_IS_DYNAMIC) {
+				val = pevent_read_number(event->pevent, data + offset, len);
+				offset = val;
+				len = offset >> 16;
+				offset &= 0xffff;
+			}
+			if (field->flags & FIELD_IS_STRING) {
+				trace_seq_printf(s, "%s", (char *)data + offset);
+			} else {
+				trace_seq_puts(s, "ARRAY[");
+				for (i = 0; i < len; i++) {
+					if (i)
+						trace_seq_puts(s, ", ");
+					trace_seq_printf(s, "%02x",
+							 *((unsigned char *)data + offset + i));
+				}
+				trace_seq_putc(s, ']');
+			}
+		} else {
+			val = pevent_read_number(event->pevent, data + field->offset,
+						 field->size);
+			if (field->flags & FIELD_IS_POINTER) {
+				trace_seq_printf(s, "0x%llx", val);
+			} else if (field->flags & FIELD_IS_SIGNED) {
+				switch (field->size) {
+				case 4:
+					/*
+					 * If field is long then print it in hex.
+					 * A long usually stores pointers.
+					 */
+					if (field->flags & FIELD_IS_LONG)
+						trace_seq_printf(s, "0x%x", (int)val);
+					else
+						trace_seq_printf(s, "%d", (int)val);
+					break;
+				case 2:
+					trace_seq_printf(s, "%2d", (short)val);
+					break;
+				case 1:
+					trace_seq_printf(s, "%1d", (char)val);
+					break;
+				default:
+					trace_seq_printf(s, "%lld", val);
+				}
+			} else {
+				if (field->flags & FIELD_IS_LONG)
+					trace_seq_printf(s, "0x%llx", val);
+				else
+					trace_seq_printf(s, "%llu", val);
+			}
+		}
+		field = field->next;
+	}
+}
+
+static void pretty_print(struct trace_seq *s, void *data, int size, struct event_format *event)
+{
+	struct pevent *pevent = event->pevent;
+	struct print_fmt *print_fmt = &event->print_fmt;
+	struct print_arg *arg = print_fmt->args;
+	struct print_arg *args = NULL;
+	const char *ptr = print_fmt->format;
+	unsigned long long val;
+	struct func_map *func;
+	const char *saveptr;
+	char *bprint_fmt = NULL;
+	char format[32];
+	int show_func;
+	int len;
+	int ls;
+
+	if (event->flags & EVENT_FL_FAILED) {
+		trace_seq_printf(s, "[FAILED TO PARSE]");
+		print_event_fields(s, data, size, event);
+		return;
+	}
+
+	if (event->flags & EVENT_FL_ISBPRINT) {
+		bprint_fmt = get_bprint_format(data, size, event);
+		args = make_bprint_args(bprint_fmt, data, size, event);
+		arg = args;
+		ptr = bprint_fmt;
+	}
+
+	for (; *ptr; ptr++) {
+		ls = 0;
+		if (*ptr == '\\') {
+			ptr++;
+			switch (*ptr) {
+			case 'n':
+				trace_seq_putc(s, '\n');
+				break;
+			case 't':
+				trace_seq_putc(s, '\t');
+				break;
+			case 'r':
+				trace_seq_putc(s, '\r');
+				break;
+			case '\\':
+				trace_seq_putc(s, '\\');
+				break;
+			default:
+				trace_seq_putc(s, *ptr);
+				break;
+			}
+
+		} else if (*ptr == '%') {
+			saveptr = ptr;
+			show_func = 0;
+ cont_process:
+			ptr++;
+			switch (*ptr) {
+			case '%':
+				trace_seq_putc(s, '%');
+				break;
+			case '#':
+				/* FIXME: need to handle properly */
+				goto cont_process;
+			case 'l':
+				ls++;
+				goto cont_process;
+			case 'L':
+				ls = 2;
+				goto cont_process;
+			case '.':
+			case 'z':
+			case 'Z':
+			case '0' ... '9':
+				goto cont_process;
+			case 'p':
+				if (pevent->long_size == 4)
+					ls = 1;
+				else
+					ls = 2;
+
+				if (*(ptr+1) == 'F' ||
+				    *(ptr+1) == 'f') {
+					ptr++;
+					show_func = *ptr;
+				} else if (*(ptr+1) == 'M' || *(ptr+1) == 'm') {
+					print_mac_arg(s, *(ptr+1), data, size, event, arg);
+					ptr++;
+					break;
+				}
+
+				/* fall through */
+			case 'd':
+			case 'i':
+			case 'x':
+			case 'X':
+			case 'u':
+				if (!arg)
+					die("no argument match");
+
+				len = ((unsigned long)ptr + 1) -
+					(unsigned long)saveptr;
+
+				/* should never happen */
+				if (len > 32)
+					die("bad format!");
+
+				memcpy(format, saveptr, len);
+				format[len] = 0;
+
+				val = eval_num_arg(data, size, event, arg);
+				arg = arg->next;
+
+				if (show_func) {
+					func = find_func(pevent, val);
+					if (func) {
+						trace_seq_puts(s, func->func);
+						if (show_func == 'F')
+							trace_seq_printf(s,
+							       "+0x%llx",
+							       val - func->addr);
+						break;
+					}
+				}
+				if (pevent->long_size == 8 && ls) {
+					char *p;
+
+					ls = 2;
+					/* make %l into %ll */
+					p = strchr(format, 'l');
+					if (p)
+						memmove(p, p+1, strlen(p)+1);
+					else if (strcmp(format, "%p") == 0)
+						strcpy(format, "0x%llx");
+				}
+				switch (ls) {
+				case 0:
+					trace_seq_printf(s, format, (int)val);
+					break;
+				case 1:
+					trace_seq_printf(s, format, (long)val);
+					break;
+				case 2:
+					trace_seq_printf(s, format, (long long)val);
+					break;
+				default:
+					die("bad count (%d)", ls);
+				}
+				break;
+			case 's':
+				if (!arg)
+					die("no matching argument");
+
+				print_str_arg(s, data, size, event, arg);
+				arg = arg->next;
+				break;
+			default:
+				trace_seq_printf(s, ">%c<", *ptr);
+
+			}
+		} else
+			trace_seq_putc(s, *ptr);
+	}
+
+	if (args) {
+		free_args(args);
+		free(bprint_fmt);
+	}
+}
+
+/**
+ * pevent_data_lat_fmt - parse the data for the latency format
+ * @pevent: a handle to the pevent
+ * @s: the trace_seq to write to
+ * @data: the raw data to read from
+ * @size: currently unused.
+ *
+ * This parses out the Latency format (interrupts disabled,
+ * need rescheduling, in hard/soft interrupt, preempt count
+ * and lock depth) and places it into the trace_seq.
+ */
+void pevent_data_lat_fmt(struct pevent *pevent,
+			 struct trace_seq *s, struct record *record)
+{
+	static int check_lock_depth = 1;
+	static int lock_depth_exists;
+	unsigned int lat_flags;
+	unsigned int pc;
+	int lock_depth;
+	int hardirq;
+	int softirq;
+	void *data = record->data;
+
+	lat_flags = parse_common_flags(pevent, data);
+	pc = parse_common_pc(pevent, data);
+	/* lock_depth may not always exist */
+	if (check_lock_depth) {
+		struct format_field *field;
+		struct event_format *event;
+
+		check_lock_depth = 0;
+		event = pevent->events[0];
+		field = pevent_find_common_field(event, "common_lock_depth");
+		if (field)
+			lock_depth_exists = 1;
+	}
+	if (lock_depth_exists)
+		lock_depth = parse_common_lock_depth(pevent, data);
+
+	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
+	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
+
+	trace_seq_printf(s, "%c%c%c",
+	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
+	       'X' : '.',
+	       (lat_flags & TRACE_FLAG_NEED_RESCHED) ?
+	       'N' : '.',
+	       (hardirq && softirq) ? 'H' :
+	       hardirq ? 'h' : softirq ? 's' : '.');
+
+	if (pc)
+		trace_seq_printf(s, "%x", pc);
+	else
+		trace_seq_putc(s, '.');
+
+	if (lock_depth_exists) {
+		if (lock_depth < 0)
+			trace_seq_putc(s, '.');
+		else
+			trace_seq_printf(s, "%d", lock_depth);
+	}
+
+	trace_seq_terminate(s);
+}
+
+/**
+ * pevent_data_type - parse out the given event type
+ * @pevent: a handle to the pevent
+ * @rec: the record to read from
+ *
+ * This returns the event id from the @rec.
+ */
+int pevent_data_type(struct pevent *pevent, struct record *rec)
+{
+	return trace_parse_common_type(pevent, rec->data);
+}
+
+/**
+ * pevent_data_event_from_type - find the event by a given type
+ * @pevent: a handle to the pevent
+ * @type: the type of the event.
+ *
+ * This returns the event form a given @type;
+ */
+struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type)
+{
+	return pevent_find_event(pevent, type);
+}
+
+/**
+ * pevent_data_pid - parse the PID from raw data
+ * @pevent: a handle to the pevent
+ * @rec: the record to parse
+ *
+ * This returns the PID from a raw data.
+ */
+int pevent_data_pid(struct pevent *pevent, struct record *rec)
+{
+	return parse_common_pid(pevent, rec->data);
+}
+
+/**
+ * pevent_data_comm_from_pid - return the command line from PID
+ * @pevent: a handle to the pevent
+ * @pid: the PID of the task to search for
+ *
+ * This returns a pointer to the command line that has the given
+ * @pid.
+ */
+const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid)
+{
+	const char *comm;
+
+	comm = find_cmdline(pevent, pid);
+	return comm;
+}
+
+/**
+ * pevent_data_comm_from_pid - parse the data into the print format
+ * @s: the trace_seq to write to
+ * @event: the handle to the event
+ * @cpu: the cpu the event was recorded on
+ * @data: the raw data
+ * @size: the size of the raw data
+ * @nsecs: the timestamp of the event
+ *
+ * This parses the raw @data using the given @event information and
+ * writes the print format into the trace_seq.
+ */
+void pevent_event_info(struct trace_seq *s, struct event_format *event,
+		       struct record *record)
+{
+	int print_pretty = 1;
+
+	if (event->pevent->print_raw)
+		print_event_fields(s, record->data, record->size, event);
+	else {
+
+		if (event->handler)
+			print_pretty = event->handler(s, record, event,
+						      event->context);
+
+		if (print_pretty)
+			pretty_print(s, record->data, record->size, event);
+	}
+
+	trace_seq_terminate(s);
+}
+
+void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
+			struct record *record)
+{
+	static char *spaces = "                    "; /* 20 spaces */
+	struct event_format *event;
+	unsigned long secs;
+	unsigned long usecs;
+	const char *comm;
+	void *data = record->data;
+	int type;
+	int pid;
+	int len;
+
+	secs = record->ts / NSECS_PER_SEC;
+	usecs = record->ts - secs * NSECS_PER_SEC;
+	usecs = (usecs + 500) / NSECS_PER_USEC;
+
+	type = trace_parse_common_type(pevent, data);
+
+	event = pevent_find_event(pevent, type);
+	if (!event) {
+		do_warning("ug! no event found for type %d", type);
+		return;
+	}
+
+	pid = parse_common_pid(pevent, data);
+	comm = find_cmdline(pevent, pid);
+
+	if (pevent->latency_format) {
+		trace_seq_printf(s, "%8.8s-%-5d %3d",
+		       comm, pid, record->cpu);
+		pevent_data_lat_fmt(pevent, s, record);
+	} else
+		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
+
+	trace_seq_printf(s, " %5lu.%06lu: %s: ", secs, usecs, event->name);
+
+	/* Space out the event names evenly. */
+	len = strlen(event->name);
+	if (len < 20)
+		trace_seq_printf(s, "%.*s", 20 - len, spaces);
+
+	pevent_event_info(s, event, record);
+}
+
+static int events_id_cmp(const void *a, const void *b)
+{
+	struct event_format * const * ea = a;
+	struct event_format * const * eb = b;
+
+	if ((*ea)->id < (*eb)->id)
+		return -1;
+
+	if ((*ea)->id > (*eb)->id)
+		return 1;
+
+	return 0;
+}
+
+static int events_name_cmp(const void *a, const void *b)
+{
+	struct event_format * const * ea = a;
+	struct event_format * const * eb = b;
+	int res;
+
+	res = strcmp((*ea)->name, (*eb)->name);
+	if (res)
+		return res;
+
+	res = strcmp((*ea)->system, (*eb)->system);
+	if (res)
+		return res;
+
+	return events_id_cmp(a, b);
+}
+
+static int events_system_cmp(const void *a, const void *b)
+{
+	struct event_format * const * ea = a;
+	struct event_format * const * eb = b;
+	int res;
+
+	res = strcmp((*ea)->system, (*eb)->system);
+	if (res)
+		return res;
+
+	res = strcmp((*ea)->name, (*eb)->name);
+	if (res)
+		return res;
+
+	return events_id_cmp(a, b);
+}
+
+struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type sort_type)
+{
+	struct event_format **events;
+	int (*sort)(const void *a, const void *b);
+
+	events = pevent->sort_events;
+
+	if (events && pevent->last_type == sort_type)
+		return events;
+
+	if (!events) {
+		events = malloc(sizeof(*events) * (pevent->nr_events + 1));
+		if (!events)
+			return NULL;
+
+		memcpy(events, pevent->events, sizeof(*events) * pevent->nr_events);
+		events[pevent->nr_events] = NULL;
+
+		pevent->sort_events = events;
+
+		/* the internal events are sorted by id */
+		if (sort_type == EVENT_SORT_ID) {
+			pevent->last_type = sort_type;
+			return events;
+		}
+	}
+
+	switch (sort_type) {
+	case EVENT_SORT_ID:
+		sort = events_id_cmp;
+		break;
+	case EVENT_SORT_NAME:
+		sort = events_name_cmp;
+		break;
+	case EVENT_SORT_SYSTEM:
+		sort = events_system_cmp;
+		break;
+	default:
+		return events;
+	}
+
+	qsort(events, pevent->nr_events, sizeof(*events), sort);
+	pevent->last_type = sort_type;
+
+	return events;
+}
+
+static struct format_field **
+get_event_fields(const char *type, const char *name,
+		 int count, struct format_field *list)
+{
+	struct format_field **fields;
+	struct format_field *field;
+	int i = 0;
+
+	fields = malloc_or_die(sizeof(*fields) * (count + 1));
+	for (field = list; field; field = field->next) {
+		fields[i++] = field;
+		if (i == count + 1) {
+			do_warning("event %s has more %s fields than specified",
+				name, type);
+			i--;
+			break;
+		}
+	}
+
+	if (i != count)
+		do_warning("event %s has less %s fields than specified",
+			name, type);
+
+	fields[i] = NULL;
+
+	return fields;
+}
+
+/**
+ * pevent_event_common_fields - return a list of common fields for an event
+ * @event: the event to return the common fields of.
+ *
+ * Returns an allocated array of fields. The last item in the array is NULL.
+ * The array must be freed with free().
+ */
+struct format_field **pevent_event_common_fields(struct event_format *event)
+{
+	return get_event_fields("common", event->name,
+				event->format.nr_common,
+				event->format.common_fields);
+}
+
+/**
+ * pevent_event_fields - return a list of event specific fields for an event
+ * @event: the event to return the fields of.
+ *
+ * Returns an allocated array of fields. The last item in the array is NULL.
+ * The array must be freed with free().
+ */
+struct format_field **pevent_event_fields(struct event_format *event)
+{
+	return get_event_fields("event", event->name,
+				event->format.nr_fields,
+				event->format.fields);
+}
+
+static void print_fields(struct trace_seq *s, struct print_flag_sym *field)
+{
+	trace_seq_printf(s, "{ %s, %s }", field->value, field->str);
+	if (field->next) {
+		trace_seq_puts(s, ", ");
+		print_fields(s, field->next);
+	}
+}
+
+/* for debugging */
+static void print_args(struct print_arg *args)
+{
+	int print_paren = 1;
+	struct trace_seq s;
+
+	switch (args->type) {
+	case PRINT_NULL:
+		printf("null");
+		break;
+	case PRINT_ATOM:
+		printf("%s", args->atom.atom);
+		break;
+	case PRINT_FIELD:
+		printf("REC->%s", args->field.name);
+		break;
+	case PRINT_FLAGS:
+		printf("__print_flags(");
+		print_args(args->flags.field);
+		printf(", %s, ", args->flags.delim);
+		trace_seq_init(&s);
+		print_fields(&s, args->flags.flags);
+		trace_seq_do_printf(&s);
+		printf(")");
+		break;
+	case PRINT_SYMBOL:
+		printf("__print_symbolic(");
+		print_args(args->symbol.field);
+		printf(", ");
+		trace_seq_init(&s);
+		print_fields(&s, args->symbol.symbols);
+		trace_seq_do_printf(&s);
+		printf(")");
+		break;
+	case PRINT_STRING:
+		printf("__get_str(%s)", args->string.string);
+		break;
+	case PRINT_TYPE:
+		printf("(%s)", args->typecast.type);
+		print_args(args->typecast.item);
+		break;
+	case PRINT_OP:
+		if (strcmp(args->op.op, ":") == 0)
+			print_paren = 0;
+		if (print_paren)
+			printf("(");
+		print_args(args->op.left);
+		printf(" %s ", args->op.op);
+		print_args(args->op.right);
+		if (print_paren)
+			printf(")");
+		break;
+	default:
+		/* we should warn... */
+		return;
+	}
+	if (args->next) {
+		printf("\n");
+		print_args(args->next);
+	}
+}
+
+static void parse_header_field(const char *field,
+			       int *offset, int *size, int mandatory)
+{
+	unsigned long long save_input_buf_ptr;
+	unsigned long long save_input_buf_siz;
+	char *token;
+	int type;
+
+	save_input_buf_ptr = input_buf_ptr;
+	save_input_buf_siz = input_buf_siz;
+
+	if (read_expected(EVENT_ITEM, "field") < 0)
+		return;
+	if (read_expected(EVENT_OP, ":") < 0)
+		return;
+
+	/* type */
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+	free_token(token);
+
+	/*
+	 * If this is not a mandatory field, then test it first.
+	 */
+	if (mandatory) {
+		if (read_expected(EVENT_ITEM, field) < 0)
+			return;
+	} else {
+		if (read_expect_type(EVENT_ITEM, &token) < 0)
+			goto fail;
+		if (strcmp(token, field) != 0)
+			goto discard;
+		free_token(token);
+	}
+
+	if (read_expected(EVENT_OP, ";") < 0)
+		return;
+	if (read_expected(EVENT_ITEM, "offset") < 0)
+		return;
+	if (read_expected(EVENT_OP, ":") < 0)
+		return;
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+	*offset = atoi(token);
+	free_token(token);
+	if (read_expected(EVENT_OP, ";") < 0)
+		return;
+	if (read_expected(EVENT_ITEM, "size") < 0)
+		return;
+	if (read_expected(EVENT_OP, ":") < 0)
+		return;
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+	*size = atoi(token);
+	free_token(token);
+	if (read_expected(EVENT_OP, ";") < 0)
+		return;
+	type = read_token(&token);
+	if (type != EVENT_NEWLINE) {
+		/* newer versions of the kernel have a "signed" type */
+		if (type != EVENT_ITEM)
+			goto fail;
+
+		if (strcmp(token, "signed") != 0)
+			goto fail;
+
+		free_token(token);
+
+		if (read_expected(EVENT_OP, ":") < 0)
+			return;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+
+		free_token(token);
+		if (read_expected(EVENT_OP, ";") < 0)
+			return;
+
+		if (read_expect_type(EVENT_NEWLINE, &token))
+			goto fail;
+	}
+ fail:
+	free_token(token);
+	return;
+
+ discard:
+	input_buf_ptr = save_input_buf_ptr;
+	input_buf_siz = save_input_buf_siz;
+	*offset = 0;
+	*size = 0;
+	free_token(token);
+}
+
+/**
+ * pevent_parse_header_page - parse the data stored in the header page
+ * @pevent: the handle to the pevent
+ * @buf: the buffer storing the header page format string
+ * @size: the size of @buf
+ * @long_size: the long size to use if there is no header
+ *
+ * This parses the header page format for information on the
+ * ring buffer used. The @buf should be copied from
+ *
+ * /sys/kernel/debug/tracing/events/header_page
+ */
+int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
+			     int long_size)
+{
+	int ignore;
+
+	if (!size) {
+		/*
+		 * Old kernels did not have header page info.
+		 * Sorry but we just use what we find here in user space.
+		 */
+		pevent->header_page_ts_size = sizeof(long long);
+		pevent->header_page_size_size = long_size;
+		pevent->header_page_data_offset = sizeof(long long) + long_size;
+		pevent->old_format = 1;
+		return -1;
+	}
+	init_input_buf(buf, size);
+
+	parse_header_field("timestamp", &pevent->header_page_ts_offset,
+			   &pevent->header_page_ts_size, 1);
+	parse_header_field("commit", &pevent->header_page_size_offset,
+			   &pevent->header_page_size_size, 1);
+	parse_header_field("overwrite", &pevent->header_page_overwrite,
+			   &ignore, 0);
+	parse_header_field("data", &pevent->header_page_data_offset,
+			   &pevent->header_page_data_size, 1);
+
+	return 0;
+}
+
+static int event_matches(struct event_format *event,
+			 int id, const char *sys_name,
+			 const char *event_name)
+{
+	if (id >= 0 && id != event->id)
+		return 0;
+
+	if (event_name && (strcmp(event_name, event->name) != 0))
+		return 0;
+
+	if (sys_name && (strcmp(sys_name, event->system) != 0))
+		return 0;
+
+	return 1;
+}
+
+static void free_handler(struct event_handler *handle)
+{
+	free((void *)handle->sys_name);
+	free((void *)handle->event_name);
+	free(handle);
+}
+
+static int find_event_handle(struct pevent *pevent, struct event_format *event)
+{
+	struct event_handler *handle, **next;
+
+	for (next = &pevent->handlers; *next;
+	     next = &(*next)->next) {
+		handle = *next;
+		if (event_matches(event, handle->id,
+				  handle->sys_name,
+				  handle->event_name))
+			break;
+	}
+
+	if (!(*next))
+		return 0;
+
+	pr_stat("overriding event (%d) %s:%s with new print handler",
+		event->id, event->system, event->name);
+
+	event->handler = handle->func;
+	event->context = handle->context;
+
+	*next = handle->next;
+	free_handler(handle);
+
+	return 1;
+}
+
+/**
+ * pevent_parse_event - parse the event format
+ * @pevent: the handle to the pevent
+ * @buf: the buffer storing the event format string
+ * @size: the size of @buf
+ * @sys: the system the event belongs to
+ *
+ * This parses the event format and creates an event structure
+ * to quickly parse raw data for a given event.
+ *
+ * These files currently come from:
+ *
+ * /sys/kernel/debug/tracing/events/.../.../format
+ */
+int pevent_parse_event(struct pevent *pevent,
+		       const char *buf, unsigned long size,
+		       const char *sys)
+{
+	struct event_format *event;
+	int ret;
+
+	init_input_buf(buf, size);
+
+	event = alloc_event();
+	if (!event)
+		return -ENOMEM;
+
+	event->name = event_read_name();
+	if (!event->name) {
+		/* Bad event? */
+		free(event);
+		return -1;
+	}
+
+	if (strcmp(sys, "ftrace") == 0) {
+
+		event->flags |= EVENT_FL_ISFTRACE;
+
+		if (strcmp(event->name, "bprint") == 0)
+			event->flags |= EVENT_FL_ISBPRINT;
+	}
+		
+	event->id = event_read_id();
+	if (event->id < 0)
+		die("failed to read event id");
+
+	event->system = strdup(sys);
+
+	/* Add pevent to event so that it can be referenced */
+	event->pevent = pevent;
+
+	ret = event_read_format(event);
+	if (ret < 0) {
+		do_warning("failed to read event format for %s", event->name);
+		goto event_failed;
+	}
+
+	/*
+	 * If the event has an override, don't print warnings if the event
+	 * print format fails to parse.
+	 */
+	if (find_event_handle(pevent, event))
+		show_warning = 0;
+
+	ret = event_read_print(event);
+	if (ret < 0) {
+		do_warning("failed to read event print fmt for %s",
+			   event->name);
+		show_warning = 1;
+		goto event_failed;
+	}
+	show_warning = 1;
+
+	add_event(pevent, event);
+
+	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
+		struct format_field *field;
+		struct print_arg *arg, **list;
+
+		/* old ftrace had no args */
+
+		list = &event->print_fmt.args;
+		for (field = event->format.fields; field; field = field->next) {
+			arg = alloc_arg();
+			*list = arg;
+			list = &arg->next;
+			arg->type = PRINT_FIELD;
+			arg->field.name = strdup(field->name);
+			arg->field.field = field;
+		}
+		return 0;
+	}
+
+#define PRINT_ARGS 0
+	if (PRINT_ARGS && event->print_fmt.args)
+		print_args(event->print_fmt.args);
+
+	return 0;
+
+ event_failed:
+	event->flags |= EVENT_FL_FAILED;
+	/* still add it even if it failed */
+	add_event(pevent, event);
+	return -1;
+}
+
+static void free_func_handle(struct pevent_function_handler *func)
+{
+	struct pevent_func_params *params;
+
+	free(func->name);
+
+	while (func->params) {
+		params = func->params;
+		func->params = params->next;
+		free(params);
+	}
+
+	free(func);
+}
+
+/**
+ * pevent_register_print_function - register a helper function
+ * @pevent: the handle to the pevent
+ * @func: the function to process the helper function
+ * @name: the name of the helper function
+ * @parameters: A list of enum pevent_func_arg_type
+ *
+ * Some events may have helper functions in the print format arguments.
+ * This allows a plugin to dynmically create a way to process one
+ * of these functions.
+ *
+ * The @parameters is a variable list of pevent_func_arg_type enums that
+ * must end with PEVENT_FUNC_ARG_VOID.
+ */
+int pevent_register_print_function(struct pevent *pevent,
+				   pevent_func_handler func,
+				   enum pevent_func_arg_type ret_type,
+				   char *name, ...)
+{
+	struct pevent_function_handler *func_handle;
+	struct pevent_func_params **next_param;
+	struct pevent_func_params *param;
+	enum pevent_func_arg_type type;
+	va_list ap;
+
+	func_handle = find_func_handler(pevent, name);
+	if (func_handle) {
+		/*
+		 * This is most like caused by the users own
+		 * plugins updating the function. This overrides the
+		 * system defaults.
+		 */
+		pr_stat("override of function helper '%s'", name);
+		remove_func_handler(pevent, name);
+	}
+
+	func_handle = malloc_or_die(sizeof(*func_handle));
+	memset(func_handle, 0, sizeof(*func_handle));
+
+	func_handle->ret_type = ret_type;
+	func_handle->name = strdup(name);
+	func_handle->func = func;
+	if (!func_handle->name)
+		die("Failed to allocate function name");
+
+	next_param = &(func_handle->params);
+	va_start(ap, name);
+	for (;;) {
+		type = va_arg(ap, enum pevent_func_arg_type);
+		if (type == PEVENT_FUNC_ARG_VOID)
+			break;
+
+		if (type < 0 || type >= PEVENT_FUNC_ARG_MAX_TYPES) {
+			warning("Invalid argument type %d", type);
+			goto out_free;
+		}
+
+		param = malloc_or_die(sizeof(*param));
+		param->type = type;
+		param->next = NULL;
+
+		*next_param = param;
+		next_param = &(param->next);
+
+		func_handle->nr_args++;
+	}
+	va_end(ap);
+
+	func_handle->next = pevent->func_handlers;
+	pevent->func_handlers = func_handle;
+
+	return 0;
+ out_free:
+	va_end(ap);
+	free_func_handle(func_handle);
+	return -1;
+}
+
+/**
+ * pevent_register_event_handle - register a way to parse an event
+ * @pevent: the handle to the pevent
+ * @id: the id of the event to register
+ * @sys_name: the system name the event belongs to
+ * @event_name: the name of the event
+ * @func: the function to call to parse the event information
+ *
+ * This function allows a developer to override the parsing of
+ * a given event. If for some reason the default print format
+ * is not sufficient, this function will register a function
+ * for an event to be used to parse the data instead.
+ *
+ * If @id is >= 0, then it is used to find the event.
+ * else @sys_name and @event_name are used.
+ */
+int pevent_register_event_handler(struct pevent *pevent,
+				  int id, char *sys_name, char *event_name,
+				  pevent_event_handler_func func,
+				  void *context)
+{
+	struct event_format *event;
+	struct event_handler *handle;
+
+	if (id >= 0) {
+		/* search by id */
+		event = pevent_find_event(pevent, id);
+		if (!event)
+			goto not_found;
+		if (event_name && (strcmp(event_name, event->name) != 0))
+			goto not_found;
+		if (sys_name && (strcmp(sys_name, event->system) != 0))
+			goto not_found;
+	} else {
+		event = pevent_find_event_by_name(pevent, sys_name, event_name);
+		if (!event)
+			goto not_found;
+	}
+
+	pr_stat("overriding event (%d) %s:%s with new print handler",
+		event->id, event->system, event->name);
+
+	event->handler = func;
+	event->context = context;
+	return 0;
+
+ not_found:
+	/* Save for later use. */
+	handle = malloc_or_die(sizeof(*handle));
+	memset(handle, 0, sizeof(handle));
+	handle->id = id;
+	if (event_name)
+		handle->event_name = strdup(event_name);
+	if (sys_name)
+		handle->sys_name = strdup(sys_name);
+
+	handle->func = func;
+	handle->next = pevent->handlers;
+	pevent->handlers = handle;
+	handle->context = context;
+
+	return -1;
+}
+
+/**
+ * pevent_alloc - create a pevent handle
+ */
+struct pevent *pevent_alloc(void)
+{
+	struct pevent *pevent;
+
+	pevent = malloc(sizeof(*pevent));
+	if (!pevent)
+		return NULL;
+	memset(pevent, 0, sizeof(*pevent));
+	pevent->ref_count = 1;
+
+	return pevent;
+}
+
+void pevent_ref(struct pevent *pevent)
+{
+	pevent->ref_count++;
+}
+
+static void free_format_fields(struct format_field *field)
+{
+	struct format_field *next;
+
+	while (field) {
+		next = field->next;
+		free(field->type);
+		free(field->name);
+		free(field);
+		field = next;
+	}
+}
+
+static void free_formats(struct format *format)
+{
+	free_format_fields(format->common_fields);
+	free_format_fields(format->fields);
+}
+
+static void free_event(struct event_format *event)
+{
+	free(event->name);
+	free(event->system);
+
+	free_formats(&event->format);
+
+	free(event->print_fmt.format);
+	free_args(event->print_fmt.args);
+
+	free(event);
+}
+
+/**
+ * pevent_free - free a pevent handle
+ * @pevent: the pevent handle to free
+ */
+void pevent_free(struct pevent *pevent)
+{
+	struct cmdline_list *cmdlist = pevent->cmdlist, *cmdnext;
+	struct func_list *funclist = pevent->funclist, *funcnext;
+	struct printk_list *printklist = pevent->printklist, *printknext;
+	struct pevent_function_handler *func_handler;
+	struct event_handler *handle;
+	int i;
+
+	pevent->ref_count--;
+	if (pevent->ref_count)
+		return;
+
+	if (pevent->cmdlines) {
+		for (i = 0; i < pevent->cmdline_count; i++)
+			free(pevent->cmdlines[i].comm);
+		free(pevent->cmdlines);
+	}
+
+	while (cmdlist) {
+		cmdnext = cmdlist->next;
+		free(cmdlist->comm);
+		free(cmdlist);
+		cmdlist = cmdnext;
+	}
+
+	if (pevent->func_map) {
+		for (i = 0; i < pevent->func_count; i++) {
+			free(pevent->func_map[i].func);
+			free(pevent->func_map[i].mod);
+		}
+		free(pevent->func_map);
+	}
+
+	while (funclist) {
+		funcnext = funclist->next;
+		free(funclist->func);
+		free(funclist->mod);
+		free(funclist);
+		funclist = funcnext;
+	}
+
+	while (pevent->func_handlers) {
+		func_handler = pevent->func_handlers;
+		pevent->func_handlers = func_handler->next;
+		free_func_handle(func_handler);
+	}
+
+	if (pevent->printk_map) {
+		for (i = 0; i < pevent->printk_count; i++)
+			free(pevent->printk_map[i].printk);
+		free(pevent->printk_map);
+	}
+
+	while (printklist) {
+		printknext = printklist->next;
+		free(printklist->printk);
+		free(printklist);
+		printklist = printknext;
+	}
+
+	for (i = 0; i < pevent->nr_events; i++)
+		free_event(pevent->events[i]);
+
+	while (pevent->handlers) {
+		handle = pevent->handlers;
+		pevent->handlers = handle->next;
+		free_handler(handle);
+	}
+
+	free(pevent->events);
+	free(pevent->sort_events);
+
+	free(pevent);
+}
+
+void pevent_unref(struct pevent *pevent)
+{
+	pevent_free(pevent);
+}
diff --git a/tools/lib/trace/parse-events.h b/tools/lib/trace/parse-events.h
new file mode 100644
index 0000000..5c10208
--- /dev/null
+++ b/tools/lib/trace/parse-events.h
@@ -0,0 +1,719 @@
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#ifndef _PARSE_EVENTS_H
+#define _PARSE_EVENTS_H
+
+#include <stdarg.h>
+#include <regex.h>
+
+#ifndef __unused
+#define __unused __attribute__ ((unused))
+#endif
+
+/* ----------------------- trace_seq ----------------------- */
+
+
+#ifndef TRACE_SEQ_SIZE
+#define TRACE_SEQ_SIZE 4096
+#endif
+
+struct record {
+	unsigned long long	ts;
+	unsigned long long	offset;
+	long long		missed_events;	/* buffer dropped events before */
+	int			record_size;	/* size of binary record */
+	int			size;		/* size of data */
+	void			*data;
+	int			cpu;
+	int			ref_count;
+	int			locked;		/* Do not free, even if ref_count is zero */
+	void			*private;
+};
+
+/*
+ * Trace sequences are used to allow a function to call several other functions
+ * to create a string of data to use (up to a max of PAGE_SIZE).
+ */
+
+struct trace_seq {
+	char			buffer[TRACE_SEQ_SIZE];
+	unsigned int		len;
+	unsigned int		readpos;
+	int			full;
+};
+
+static inline void
+trace_seq_init(struct trace_seq *s)
+{
+	s->len = 0;
+	s->readpos = 0;
+	s->full = 0;
+}
+
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+
+extern int trace_seq_puts(struct trace_seq *s, const char *str);
+extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
+
+extern void trace_seq_terminate(struct trace_seq *s);
+
+extern int trace_seq_do_printf(struct trace_seq *s);
+
+
+/* ----------------------- pevent ----------------------- */
+
+struct pevent;
+struct event_format;
+
+typedef int (*pevent_event_handler_func)(struct trace_seq *s,
+					 struct record *record,
+					 struct event_format *event,
+					 void *context);
+
+typedef int (*pevent_plugin_load_func)(struct pevent *pevent);
+typedef int (*pevent_plugin_unload_func)(void);
+
+#define PEVENT_PLUGIN_LOADER pevent_plugin_loader
+#define PEVENT_PLUGIN_UNLOADER pevent_plugin_unloader
+#define _MAKE_STR(x)	#x
+#define MAKE_STR(x)	_MAKE_STR(x)
+#define PEVENT_PLUGIN_LOADER_NAME MAKE_STR(PEVENT_PLUGIN_LOADER)
+#define PEVENT_PLUGIN_UNLOADER_NAME MAKE_STR(PEVENT_PLUGIN_UNLOADER)
+
+#define NSECS_PER_SEC		1000000000ULL
+#define NSECS_PER_USEC		1000ULL
+
+enum format_flags {
+	FIELD_IS_ARRAY		= 1,
+	FIELD_IS_POINTER	= 2,
+	FIELD_IS_SIGNED		= 4,
+	FIELD_IS_STRING		= 8,
+	FIELD_IS_DYNAMIC	= 16,
+	FIELD_IS_LONG		= 32,
+	FIELD_IS_FLAG		= 64,
+	FIELD_IS_SYMBOLIC	= 128,
+};
+
+struct format_field {
+	struct format_field	*next;
+	struct event_format	*event;
+	char			*type;
+	char			*name;
+	int			offset;
+	int			size;
+	unsigned int		arraylen;
+	unsigned int		elementsize;
+	unsigned long		flags;
+};
+
+struct format {
+	int			nr_common;
+	int			nr_fields;
+	struct format_field	*common_fields;
+	struct format_field	*fields;
+};
+
+struct print_arg_atom {
+	char			*atom;
+};
+
+struct print_arg_string {
+	char			*string;
+	int			offset;
+};
+
+struct print_arg_field {
+	char			*name;
+	struct format_field	*field;
+};
+
+struct print_flag_sym {
+	struct print_flag_sym	*next;
+	char			*value;
+	char			*str;
+};
+
+struct print_arg_typecast {
+	char 			*type;
+	struct print_arg	*item;
+};
+
+struct print_arg_flags {
+	struct print_arg	*field;
+	char			*delim;
+	struct print_flag_sym	*flags;
+};
+
+struct print_arg_symbol {
+	struct print_arg	*field;
+	struct print_flag_sym	*symbols;
+};
+
+struct print_arg_dynarray {
+	struct format_field	*field;
+	struct print_arg	*index;
+};
+
+struct print_arg;
+
+struct print_arg_op {
+	char			*op;
+	int			prio;
+	struct print_arg	*left;
+	struct print_arg	*right;
+};
+
+struct pevent_function_handler;
+
+struct print_arg_func {
+	struct pevent_function_handler	*func;
+	struct print_arg		*args;
+};
+
+enum print_arg_type {
+	PRINT_NULL,
+	PRINT_ATOM,
+	PRINT_FIELD,
+	PRINT_FLAGS,
+	PRINT_SYMBOL,
+	PRINT_TYPE,
+	PRINT_STRING,
+	PRINT_DYNAMIC_ARRAY,
+	PRINT_OP,
+	PRINT_FUNC,
+};
+
+struct print_arg {
+	struct print_arg		*next;
+	enum print_arg_type		type;
+	union {
+		struct print_arg_atom		atom;
+		struct print_arg_field		field;
+		struct print_arg_typecast	typecast;
+		struct print_arg_flags		flags;
+		struct print_arg_symbol		symbol;
+		struct print_arg_func		func;
+		struct print_arg_string		string;
+		struct print_arg_op		op;
+		struct print_arg_dynarray	dynarray;
+	};
+};
+
+struct print_fmt {
+	char			*format;
+	struct print_arg	*args;
+};
+
+struct event_format {
+	struct pevent		*pevent;
+	char			*name;
+	int			id;
+	int			flags;
+	struct format		format;
+	struct print_fmt	print_fmt;
+	char			*system;
+	pevent_event_handler_func handler;
+	void			*context;
+};
+
+enum {
+	EVENT_FL_ISFTRACE	= 0x01,
+	EVENT_FL_ISPRINT	= 0x02,
+	EVENT_FL_ISBPRINT	= 0x04,
+	EVENT_FL_ISFUNCENT	= 0x10,
+	EVENT_FL_ISFUNCRET	= 0x20,
+
+	EVENT_FL_FAILED		= 0x80000000
+};
+
+enum event_sort_type {
+	EVENT_SORT_ID,
+	EVENT_SORT_NAME,
+	EVENT_SORT_SYSTEM,
+};
+
+enum event_type {
+	EVENT_ERROR,
+	EVENT_NONE,
+	EVENT_SPACE,
+	EVENT_NEWLINE,
+	EVENT_OP,
+	EVENT_DELIM,
+	EVENT_ITEM,
+	EVENT_DQUOTE,
+	EVENT_SQUOTE,
+};
+
+typedef unsigned long long (*pevent_func_handler)(struct trace_seq *s,
+					     unsigned long long *args);
+
+enum pevent_func_arg_type {
+	PEVENT_FUNC_ARG_VOID,
+	PEVENT_FUNC_ARG_INT,
+	PEVENT_FUNC_ARG_LONG,
+	PEVENT_FUNC_ARG_STRING,
+	PEVENT_FUNC_ARG_PTR,
+	PEVENT_FUNC_ARG_MAX_TYPES
+};
+
+struct cmdline;
+struct cmdline_list;
+struct func_map;
+struct func_list;
+struct event_handler;
+
+struct pevent {
+	int ref_count;
+
+	int header_page_ts_offset;
+	int header_page_ts_size;
+	int header_page_size_offset;
+	int header_page_size_size;
+	int header_page_data_offset;
+	int header_page_data_size;
+	int header_page_overwrite;
+
+	int file_bigendian;
+	int host_bigendian;
+
+	int latency_format;
+
+	int old_format;
+
+	int cpus;
+	int long_size;
+
+	struct cmdline *cmdlines;
+	struct cmdline_list *cmdlist;
+	int cmdline_count;
+
+	struct func_map *func_map;
+	struct func_list *funclist;
+	unsigned int func_count;
+
+	struct printk_map *printk_map;
+	struct printk_list *printklist;
+	unsigned int printk_count;
+
+	struct event_format **events;
+	int nr_events;
+	struct event_format **sort_events;
+	enum event_sort_type last_type;
+
+	int type_offset;
+	int type_size;
+
+	int pid_offset;
+	int pid_size;
+
+ 	int pc_offset;
+	int pc_size;
+
+	int flags_offset;
+	int flags_size;
+
+	int ld_offset;
+	int ld_size;
+
+	int print_raw;
+
+	struct format_field *bprint_ip_field;
+	struct format_field *bprint_fmt_field;
+	struct format_field *bprint_buf_field;
+
+	struct event_handler *handlers;
+	struct pevent_function_handler *func_handlers;
+
+	/* cache */
+	struct event_format *last_event;
+};
+
+/* Can be overridden */
+void *malloc_or_die(unsigned int size);
+void pr_stat(const char *fmt, ...);
+void vpr_stat(const char *fmt, va_list ap);
+
+/* Always available */
+void __die(const char *fmt, ...);
+void __warning(const char *fmt, ...);
+void __pr_stat(const char *fmt, ...);
+
+void __vdie(const char *fmt, ...);
+void __vwarning(const char *fmt, ...);
+void __vpr_stat(const char *fmt, ...);
+
+static inline unsigned short
+__data2host2(struct pevent *pevent, unsigned short data)
+{
+	unsigned short swap;
+
+	if (pevent->host_bigendian == pevent->file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 8) |
+		((data & (0xffULL << 8)) >> 8);
+
+	return swap;
+}
+
+static inline unsigned int
+__data2host4(struct pevent *pevent, unsigned int data)
+{
+	unsigned int swap;
+
+	if (pevent->host_bigendian == pevent->file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 24) |
+		((data & (0xffULL << 8)) << 8) |
+		((data & (0xffULL << 16)) >> 8) |
+		((data & (0xffULL << 24)) >> 24);
+
+	return swap;
+}
+
+static inline unsigned long long
+__data2host8(struct pevent *pevent, unsigned long long data)
+{
+	unsigned long long swap;
+
+	if (pevent->host_bigendian == pevent->file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 56) |
+		((data & (0xffULL << 8)) << 40) |
+		((data & (0xffULL << 16)) << 24) |
+		((data & (0xffULL << 24)) << 8) |
+		((data & (0xffULL << 32)) >> 8) |
+		((data & (0xffULL << 40)) >> 24) |
+		((data & (0xffULL << 48)) >> 40) |
+		((data & (0xffULL << 56)) >> 56);
+
+	return swap;
+}
+
+#define data2host2(pevent, ptr)		__data2host2(pevent, *(unsigned short *)(ptr))
+#define data2host4(pevent, ptr)		__data2host4(pevent, *(unsigned int *)(ptr))
+#define data2host8(pevent, ptr)					\
+({								\
+	unsigned long long __val;				\
+								\
+	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
+	__data2host8(pevent, __val);				\
+})
+
+/* taken from kernel/trace/trace.h */
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
+	TRACE_FLAG_NEED_RESCHED		= 0x04,
+	TRACE_FLAG_HARDIRQ		= 0x08,
+	TRACE_FLAG_SOFTIRQ		= 0x10,
+};
+
+int pevent_register_comm(struct pevent *pevent, char *comm, int pid);
+int pevent_register_function(struct pevent *pevent, char *name,
+			     unsigned long long addr, char *mod);
+int pevent_register_print_string(struct pevent *pevent, char *fmt,
+				 unsigned long long addr);
+int pevent_pid_is_registered(struct pevent *pevent, int pid);
+
+void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
+			struct record *record);
+
+int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
+			     int long_size);
+
+int pevent_parse_event(struct pevent *pevent, const char *buf,
+		       unsigned long size, const char *sys);
+
+int pevent_register_event_handler(struct pevent *pevent, int id, char *sys_name, char *event_name,
+				  pevent_event_handler_func func, void *context);
+int pevent_register_print_function(struct pevent *pevent,
+				   pevent_func_handler func,
+				   enum pevent_func_arg_type ret_type,
+				   char *name, ...);
+
+struct format_field *pevent_find_common_field(struct event_format *event, const char *name);
+struct format_field *pevent_find_field(struct event_format *event, const char *name);
+struct format_field *pevent_find_any_field(struct event_format *event, const char *name);
+
+const char *pevent_find_function(struct pevent *pevent, unsigned long long addr);
+unsigned long long
+pevent_find_function_address(struct pevent *pevent, unsigned long long addr);
+unsigned long long pevent_read_number(struct pevent *pevent, const void *ptr, int size);
+int pevent_read_number_field(struct format_field *field, const void *data,
+			     unsigned long long *value);
+
+struct event_format *pevent_find_event(struct pevent *pevent, int id);
+
+struct event_format *
+pevent_find_event_by_name(struct pevent *pevent, const char *sys, const char *name);
+
+void pevent_data_lat_fmt(struct pevent *pevent,
+			 struct trace_seq *s, struct record *record);
+int pevent_data_type(struct pevent *pevent, struct record *rec);
+struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type);
+int pevent_data_pid(struct pevent *pevent, struct record *rec);
+const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
+void pevent_event_info(struct trace_seq *s, struct event_format *event,
+		       struct record *record);
+
+struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
+struct format_field **pevent_event_common_fields(struct event_format *event);
+struct format_field **pevent_event_fields(struct event_format *event);
+
+static inline int pevent_get_cpus(struct pevent *pevent)
+{
+	return pevent->cpus;
+}
+
+static inline void pevent_set_cpus(struct pevent *pevent, int cpus)
+{
+	pevent->cpus = cpus;
+}
+
+static inline int pevent_get_long_size(struct pevent *pevent)
+{
+	return pevent->long_size;
+}
+
+static inline void pevent_set_long_size(struct pevent *pevent, int long_size)
+{
+	pevent->long_size = long_size;
+}
+
+static inline int pevent_is_file_bigendian(struct pevent *pevent)
+{
+	return pevent->file_bigendian;
+}
+
+static inline void pevent_set_file_bigendian(struct pevent *pevent, int endian)
+{
+	pevent->file_bigendian = endian;
+}
+
+static inline int pevent_is_host_bigendian(struct pevent *pevent)
+{
+	return pevent->host_bigendian;
+}
+
+static inline void pevent_set_host_bigendian(struct pevent *pevent, int endian)
+{
+	pevent->host_bigendian = endian;
+}
+
+static inline int pevent_is_latency_format(struct pevent *pevent)
+{
+	return pevent->latency_format;
+}
+
+static inline void pevent_set_latency_format(struct pevent *pevent, int lat)
+{
+	pevent->latency_format = lat;
+}
+
+struct pevent *pevent_alloc(void);
+void pevent_free(struct pevent *pevent);
+void pevent_ref(struct pevent *pevent);
+void pevent_unref(struct pevent *pevent);
+
+/* access to the internal parser */
+void pevent_buffer_init(const char *buf, unsigned long long size);
+enum event_type pevent_read_token(char **tok);
+void pevent_free_token(char *token);
+int pevent_peek_char(void);
+
+/* for debugging */
+void pevent_print_funcs(struct pevent *pevent);
+void pevent_print_printk(struct pevent *pevent);
+
+/* ----------------------- filtering ----------------------- */
+
+enum filter_boolean_type {
+	FILTER_FALSE,
+	FILTER_TRUE,
+};
+
+enum filter_op_type {
+	FILTER_OP_AND = 1,
+	FILTER_OP_OR,
+	FILTER_OP_NOT,
+};
+
+enum filter_cmp_type {
+	FILTER_CMP_NONE,
+	FILTER_CMP_EQ,
+	FILTER_CMP_NE,
+	FILTER_CMP_GT,
+	FILTER_CMP_LT,
+	FILTER_CMP_GE,
+	FILTER_CMP_LE,
+	FILTER_CMP_MATCH,
+	FILTER_CMP_NOT_MATCH,
+	FILTER_CMP_REGEX,
+	FILTER_CMP_NOT_REGEX,
+};
+
+enum filter_exp_type {
+	FILTER_EXP_NONE,
+	FILTER_EXP_ADD,
+	FILTER_EXP_SUB,
+	FILTER_EXP_MUL,
+	FILTER_EXP_DIV,
+	FILTER_EXP_MOD,
+	FILTER_EXP_RSHIFT,
+	FILTER_EXP_LSHIFT,
+	FILTER_EXP_AND,
+	FILTER_EXP_OR,
+	FILTER_EXP_XOR,
+	FILTER_EXP_NOT,
+};
+
+enum filter_arg_type {
+	FILTER_ARG_NONE,
+	FILTER_ARG_BOOLEAN,
+	FILTER_ARG_VALUE,
+	FILTER_ARG_FIELD,
+	FILTER_ARG_EXP,
+	FILTER_ARG_OP,
+	FILTER_ARG_NUM,
+	FILTER_ARG_STR,
+};
+
+enum filter_value_type {
+	FILTER_NUMBER,
+	FILTER_STRING
+};
+
+struct fliter_arg;
+
+struct filter_arg_boolean {
+	enum filter_boolean_type	value;
+};
+
+struct filter_arg_field {
+	struct format_field	*field;
+};
+
+struct filter_arg_value {
+	enum filter_value_type	type;
+	union {
+		char			*str;
+		unsigned long long	val;
+	};
+};
+
+struct filter_arg_op {
+	enum filter_op_type	type;
+	struct filter_arg	*left;
+	struct filter_arg	*right;
+};
+
+struct filter_arg_num {
+	enum filter_cmp_type	type;
+	struct filter_arg	*left;
+	struct filter_arg	*right;
+};
+
+struct filter_arg_str {
+	enum filter_cmp_type	type;
+	struct format_field	*field;
+	char			*val;
+	char			*buffer;
+	regex_t			reg;
+};
+
+struct filter_arg {
+	enum filter_arg_type	type;
+	union {
+		struct filter_arg_boolean	boolean;
+		struct filter_arg_field		field;
+		struct filter_arg_value		value;
+		struct filter_arg_op		op;
+		struct filter_arg_num		num;
+		struct filter_arg_str		str;
+	};
+};
+
+struct filter_type {
+	int			event_id;
+	struct event_format	*event;
+	struct filter_arg	*filter;
+};
+
+struct event_filter {
+	struct pevent		*pevent;
+	int			filters;
+	struct filter_type	*event_filters;
+};
+
+struct event_filter *pevent_filter_alloc(struct pevent *pevent);
+
+#define FILTER_NONE		-2
+#define FILTER_NOEXIST		-1
+#define FILTER_MISS		0
+#define FILTER_MATCH		1
+
+enum filter_trivial_type {
+	FILTER_TRIVIAL_FALSE,
+	FILTER_TRIVIAL_TRUE,
+	FILTER_TRIVIAL_BOTH,
+};
+
+int pevent_filter_add_filter_str(struct event_filter *filter,
+				 const char *filter_str,
+				 char **error_str);
+
+
+int pevent_filter_match(struct event_filter *filter,
+			struct record *record);
+
+int pevent_event_filtered(struct event_filter *filter,
+			  int event_id);
+
+void pevent_filter_reset(struct event_filter *filter);
+
+void pevent_filter_clear_trivial(struct event_filter *filter,
+				 enum filter_trivial_type type);
+
+void pevent_filter_free(struct event_filter *filter);
+
+char *pevent_filter_make_string(struct event_filter *filter, int event_id);
+
+int pevent_filter_remove_event(struct event_filter *filter,
+			       int event_id);
+
+int pevent_filter_event_has_trivial(struct event_filter *filter,
+				    int event_id,
+				    enum filter_trivial_type type);
+
+int pevent_filter_copy(struct event_filter *dest, struct event_filter *source);
+
+int pevent_update_trivial(struct event_filter *dest, struct event_filter *source,
+			  enum filter_trivial_type type);
+
+int pevent_filter_compare(struct event_filter *filter1, struct event_filter *filter2);
+
+#endif /* _PARSE_EVENTS_H */
diff --git a/tools/lib/trace/parse-filter.c b/tools/lib/trace/parse-filter.c
new file mode 100644
index 0000000..9cc64fe
--- /dev/null
+++ b/tools/lib/trace/parse-filter.c
@@ -0,0 +1,2085 @@
+/*
+ * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <errno.h>
+#include <sys/types.h>
+
+#include "parse-events.h"
+#include "trace-util.h"
+
+struct event_list {
+	struct event_list	*next;
+	struct event_format	*event;
+};
+
+#define MAX_ERR_STR_SIZE 256
+
+static void show_error(char **error_str, const char *fmt, ...)
+{
+	va_list ap;
+
+	if (!error_str)
+		return;
+
+	*error_str = malloc_or_die(MAX_ERR_STR_SIZE);
+
+	va_start(ap, fmt);
+	vsnprintf(*error_str, MAX_ERR_STR_SIZE, fmt, ap);
+	va_end(ap);
+}
+
+static void free_token(char *token)
+{
+	pevent_free_token(token);
+}
+
+static enum event_type read_token(char **tok)
+{
+	enum event_type type;
+	char *token = NULL;
+
+	do {
+		free_token(token);
+		type = pevent_read_token(&token);
+	} while (type == EVENT_NEWLINE || type == EVENT_SPACE);
+
+	/* If token is = or ! check to see if the next char is ~ */
+	if (token &&
+	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
+	    pevent_peek_char() == '~') {
+		/* append it */
+		*tok = malloc(3);
+		sprintf(*tok, "%c%c", *token, '~');
+		free_token(token);
+		/* Now remove the '~' from the buffer */
+		pevent_read_token(&token);
+		free_token(token);
+	} else
+		*tok = token;
+
+	return type;
+}
+
+static int filter_cmp(const void *a, const void *b)
+{
+	const struct filter_type *ea = a;
+	const struct filter_type *eb = b;
+
+	if (ea->event_id < eb->event_id)
+		return -1;
+
+	if (ea->event_id > eb->event_id)
+		return 1;
+
+	return 0;
+}
+
+static struct filter_type *
+find_filter_type(struct event_filter *filter, int id)
+{
+	struct filter_type *filter_type;
+	struct filter_type key;
+
+	key.event_id = id;
+
+	filter_type = bsearch(&key, filter->event_filters,
+			      filter->filters,
+			      sizeof(*filter->event_filters),
+			      filter_cmp);
+
+	return filter_type;
+}
+
+static struct filter_type *
+add_filter_type(struct event_filter *filter, int id)
+{
+	struct filter_type *filter_type;
+	int i;
+
+	filter_type = find_filter_type(filter, id);
+	if (filter_type)
+		return filter_type;
+
+	if (!filter->filters)
+		filter->event_filters =
+			malloc_or_die(sizeof(*filter->event_filters));
+	else {
+		filter->event_filters =
+			realloc(filter->event_filters,
+				sizeof(*filter->event_filters) *
+				(filter->filters + 1));
+		if (!filter->event_filters)
+			die("Could not allocate filter");
+	}
+
+	for (i = 0; i < filter->filters; i++) {
+		if (filter->event_filters[i].event_id > id)
+			break;
+	}
+
+	if (i < filter->filters)
+		memmove(&filter->event_filters[i+1],
+			&filter->event_filters[i],
+			sizeof(*filter->event_filters) *
+			(filter->filters - i));
+
+	filter_type = &filter->event_filters[i];
+	filter_type->event_id = id;
+	filter_type->event = pevent_find_event(filter->pevent, id);
+	filter_type->filter = NULL;
+
+	filter->filters++;
+
+	return filter_type;
+}
+
+/**
+ * pevent_filter_alloc - create a new event filter
+ * @pevent: The pevent that this filter is associated with
+ */
+struct event_filter *pevent_filter_alloc(struct pevent *pevent)
+{
+	struct event_filter *filter;
+
+	filter = malloc_or_die(sizeof(*filter));
+	memset(filter, 0, sizeof(*filter));
+	filter->pevent = pevent;
+	pevent_ref(pevent);
+
+	return filter;
+}
+
+static struct filter_arg *allocate_arg(void)
+{
+	struct filter_arg *arg;
+
+	arg = malloc_or_die(sizeof(*arg));
+	memset(arg, 0, sizeof(*arg));
+
+	return arg;
+}
+
+static void free_arg(struct filter_arg *arg)
+{
+	if (!arg)
+		return;
+
+	switch (arg->type) {
+	case FILTER_ARG_NONE:
+	case FILTER_ARG_BOOLEAN:
+	case FILTER_ARG_NUM:
+		break;
+
+	case FILTER_ARG_STR:
+		free(arg->str.val);
+		regfree(&arg->str.reg);
+		free(arg->str.buffer);
+		break;
+
+	case FILTER_ARG_OP:
+		free_arg(arg->op.left);
+		free_arg(arg->op.right);
+	default:
+		break;
+	}
+
+	free(arg);
+}
+
+static void add_event(struct event_list **events,
+		      struct event_format *event)
+{
+	struct event_list *list;
+
+	list = malloc_or_die(sizeof(*list));
+	list->next = *events;
+	*events = list;
+	list->event = event;
+}
+
+static int event_match(struct event_format *event,
+		       regex_t *sreg, regex_t *ereg)
+{
+	if (sreg) {
+		return !regexec(sreg, event->system, 0, NULL, 0) &&
+			!regexec(ereg, event->name, 0, NULL, 0);
+	}
+
+	return !regexec(ereg, event->system, 0, NULL, 0) ||
+		!regexec(ereg, event->name, 0, NULL, 0);
+}
+
+static int
+find_event(struct pevent *pevent, struct event_list **events,
+	   char *sys_name, char *event_name)
+{
+	struct event_format *event;
+	regex_t ereg;
+	regex_t sreg;
+	int match = 0;
+	char *reg;
+	int ret;
+	int i;
+
+	if (!event_name) {
+		/* if no name is given, then swap sys and name */
+		event_name = sys_name;
+		sys_name = NULL;
+	}
+
+	reg = malloc_or_die(strlen(event_name) + 3);
+	sprintf(reg, "^%s$", event_name);
+
+	ret = regcomp(&ereg, reg, REG_ICASE|REG_NOSUB);
+	free(reg);
+
+	if (ret)
+		return -1;
+
+	if (sys_name) {
+		reg = malloc_or_die(strlen(sys_name) + 3);
+		sprintf(reg, "^%s$", sys_name);
+		ret = regcomp(&sreg, reg, REG_ICASE|REG_NOSUB);
+		free(reg);
+		if (ret) {
+			regfree(&ereg);
+			return -1;
+		}
+	}
+
+	for (i = 0; i < pevent->nr_events; i++) {
+		event = pevent->events[i];
+		if (event_match(event, sys_name ? &sreg : NULL, &ereg)) {
+			match = 1;
+			add_event(events, event);
+		}
+	}
+
+	regfree(&ereg);
+	if (sys_name)
+		regfree(&sreg);
+
+	if (!match)
+		return -1;
+
+	return 0;
+}
+
+static void free_events(struct event_list *events)
+{
+	struct event_list *event;
+
+	while (events) {
+		event = events;
+		events = events->next;
+		free(event);
+	}
+}
+
+static enum event_type
+process_paren(struct event_format *event, struct filter_arg **parg,
+	      char **tok, char **error_str);
+
+static enum event_type
+process_not(struct event_format *event, struct filter_arg **parg,
+	    char **tok, char **error_str);
+
+static enum event_type
+process_value_token(struct event_format *event, struct filter_arg **parg,
+		    enum event_type type, char **tok, char **error_str);
+
+static enum event_type
+process_op_token(struct event_format *event, struct filter_arg *larg,
+		 struct filter_arg **parg, enum event_type type, char **tok,
+		 char **error_str);
+
+/*
+ * process_token
+ *  Called when a new expression is found. Processes an op, or
+ *  ends early if a ')' is found.
+ *
+ * Output: tok, parg
+ */
+static enum event_type
+process_token(struct event_format *event, struct filter_arg **parg,
+	      char **tok, char **error_str)
+{
+	struct filter_arg *arg = NULL;
+	enum event_type type;
+	char *token;
+
+	*tok = NULL;
+	*parg = NULL;
+
+	type = read_token(&token);
+
+	/*
+	 * This is a start of a new expresion. We expect to find
+	 * a item or a parenthesis.
+	 */
+	switch (type) {
+	case EVENT_SQUOTE:
+	case EVENT_DQUOTE:
+	case EVENT_ITEM:
+		type = process_value_token(event, &arg, type, &token, error_str);
+		if (type == EVENT_ERROR) {
+			free_token(token);
+			return type;
+		}
+		type = read_token(&token);
+		break;
+	case EVENT_DELIM:
+		if (strcmp(token, "(") != 0)
+			break;
+
+		free_token(token);
+		type = process_paren(event, &arg, &token, error_str);
+		if (type == EVENT_NONE) {
+			*tok = token;
+			*parg = arg;
+			return type;
+		}
+		if (arg) {
+			/*
+			 * If the parenthesis was a full expression,
+			 * then just return it. Otherwise, we may still
+			 * need to find an op.
+			 */
+			switch (arg->type) {
+			case FILTER_ARG_OP:
+			case FILTER_ARG_NUM:
+			case FILTER_ARG_STR:
+				*tok = token;
+				*parg = arg;
+				return type;
+			default:
+				break;
+			}
+		}
+		break;
+
+	case EVENT_OP:
+		if (strcmp(token, "!") != 0)
+			break;
+
+		/*
+		 * A not is its own filter, it just negates,
+		 * process it by itself.
+		 */
+		*tok = token;
+		type = process_not(event, parg, tok, error_str);
+		return type;
+
+	default:
+		break;
+	}
+
+	for (;;) {
+		if (type == EVENT_NONE) {
+			show_error(error_str, "unexpected end of filter");
+			type = EVENT_ERROR;
+
+		} else if (type == EVENT_DELIM && strcmp(token, ")") == 0) {
+			/* Parenthesis call this and may return at anytime. */
+			*tok = token;
+			*parg = arg;
+			return type;
+
+		} else if (type != EVENT_OP) {
+			show_error(error_str, "Expected an OP but found %s", token);
+			type = EVENT_ERROR;
+		}
+
+		if (type == EVENT_ERROR) {
+			free_token(token);
+			return type;
+		}
+
+		*tok = token;
+		*parg = NULL;
+		type = process_op_token(event, arg, parg, type, tok, error_str);
+
+		if (type == EVENT_ERROR) {
+			free_arg(*parg);
+			*parg = NULL;
+			return EVENT_ERROR;
+		}
+
+		if (!(*parg) || (*parg)->type != FILTER_ARG_EXP)
+			break;
+
+		/*
+		 * This op was an expression (value return)
+		 * It's not fine by itself, there had better be an OP
+		 * after it.
+		 */
+		token = *tok;
+		*tok = NULL;
+		arg = *parg;
+	}
+
+	return type;
+}
+
+/*
+ * Input: tok
+ * Output: parg, tok
+ */
+static enum event_type
+process_bool(struct event_format *event, struct filter_arg *larg,
+	     struct filter_arg **parg, char **tok, char **error_str)
+{
+	struct filter_arg *rarg;
+	struct filter_arg *arg;
+	enum event_type type;
+	enum filter_op_type btype;
+
+	/* Can only be called with '&&' or '||' */
+	btype = strcmp(*tok, "&&") == 0 ?
+		FILTER_OP_AND : FILTER_OP_OR;
+
+	type = process_token(event, &rarg, tok, error_str);
+	if (type == EVENT_ERROR) {
+		free_arg(larg);
+		*parg = NULL;
+		return type;
+	}
+
+	/*
+	 * If larg or rarg is null then if this is AND, the whole expression
+	 * becomes NULL, else if this is an OR, then we use the non NULL
+	 * condition.
+	 */
+	if (!larg || !rarg) {
+		if (btype == FILTER_OP_AND ||
+		    (!larg && !rarg)) {
+			free_arg(larg);
+			free_arg(rarg);
+			*parg = NULL;
+			return type;
+		}
+		*parg = larg ? larg : rarg;
+		return type;
+	}
+
+	arg = allocate_arg();
+	arg->type = FILTER_ARG_OP;
+	arg->op.type = btype;
+	arg->op.left = larg;
+	arg->op.right = rarg;
+
+
+	/*
+	 * If the next token is also a boolean expression, then
+	 * make the next boolean the parent..
+	 */
+	if (type != EVENT_OP ||
+	    (strcmp(*tok, "&&") != 0 && strcmp(*tok, "||") != 0)) {
+		*parg = arg;
+		return type;
+	}
+
+	return process_bool(event, arg, parg, tok, error_str);
+}
+
+/*
+ * Input: tok
+ * Output: parg
+ */
+static enum event_type
+process_value_token(struct event_format *event, struct filter_arg **parg,
+		    enum event_type type, char **tok, char **error_str)
+{
+	struct format_field *field;
+	struct filter_arg *arg;
+	char *token;
+
+	token = *tok;
+	*tok = NULL;
+
+	arg = allocate_arg();
+
+	switch (type) {
+
+	case EVENT_SQUOTE:
+	case EVENT_DQUOTE:
+		arg->type = FILTER_ARG_VALUE;
+		arg->value.type = FILTER_STRING;
+		arg->value.str = token;
+		break;
+	case EVENT_ITEM:
+		/* if it is a number, then convert it */
+		if (isdigit(token[0])) {
+			arg->type = FILTER_ARG_VALUE;
+			arg->value.type = FILTER_NUMBER;
+			arg->value.val = strtoll(token, NULL, 0);
+			free_token(token);
+			break;
+		}
+		/* Consider this a field */
+		field = pevent_find_any_field(event, token);
+		free_token(token);
+		if (!field) {
+			/* not a field, so NULL it up */
+			free_arg(arg);
+			arg = NULL;
+			break;
+		}
+
+		arg->type = FILTER_ARG_FIELD;
+		arg->field.field = field;
+		break;
+	default:
+		free_arg(arg);
+		show_error(error_str, "expected a value but found %s",
+			   token);
+		free_token(token);
+		return EVENT_ERROR;
+	}
+
+	*parg = arg;
+	return type;
+}
+
+/*
+ * Output: parg, tok
+ */
+static enum event_type
+process_value(struct event_format *event, struct filter_arg **parg,
+	      enum event_type *orig_type, char **tok, char **error_str)
+{
+	enum event_type type;
+	char *token;
+
+	*tok = NULL;
+	type = read_token(&token);
+	*orig_type = type;
+	if (type == EVENT_DELIM && strcmp(token, "(") == 0) {
+		type = process_paren(event, parg, &token, error_str);
+		/* Must be a expression or value */
+		if (type == EVENT_ERROR || !(*parg)) {
+			free_token(token);
+			return type;
+		}
+		switch ((*parg)->type) {
+		case FILTER_ARG_BOOLEAN:
+		case FILTER_ARG_VALUE:
+		case FILTER_ARG_FIELD:
+		case FILTER_ARG_EXP:
+			break;
+		default:
+			show_error(error_str, "expected a value");
+			free_token(token);
+			return EVENT_ERROR;
+		}
+	} else {
+		type = process_value_token(event, parg, type, &token, error_str);
+		free_token(token);
+		if (type == EVENT_ERROR)
+			return type;
+		type = read_token(&token);
+	}
+
+	*tok = token;
+	return type;
+}
+
+/*
+ * Input: larg
+ * Output: parg, tok
+ */
+static enum event_type
+process_cmp(struct event_format *event, enum filter_cmp_type op_type,
+	    struct filter_arg *larg, struct filter_arg **parg,
+	    char **tok, char **error_str)
+{
+	struct filter_arg *arg;
+	struct filter_arg *rarg = NULL;
+	enum event_type orig_type;
+	enum event_type type;
+	int ret;
+
+	*parg = NULL;
+
+	type = process_value(event, &rarg, &orig_type, tok, error_str);
+	if (type == EVENT_ERROR) {
+		free_arg(rarg);
+		return type;
+	}
+
+	arg = allocate_arg();
+	/*
+	 * If either arg is NULL or right was field not found.
+	 * Then make the entire expression NULL. (will turn to FALSE)
+	 */
+	if (!larg || !rarg) {
+		free_arg(larg);
+		free_arg(rarg);
+		free_arg(arg);
+		arg = NULL;
+		goto cont;
+	}
+
+	switch (orig_type) {
+	case EVENT_SQUOTE:
+		/* treat this as a character if string is of length 1? */
+		if (strlen(rarg->str.val) == 1) {
+			switch (op_type) {
+			case FILTER_CMP_REGEX:
+			case FILTER_CMP_NOT_REGEX:
+				/* regex can't be used with ints */
+				break;
+			default:
+				goto as_int;
+			}
+		}
+		/* fall through */
+	case EVENT_DQUOTE:
+		arg->type = FILTER_ARG_STR;
+
+		if (larg->type != FILTER_ARG_FIELD) {
+			free(larg);
+			free(rarg);
+			show_error(error_str,
+				   "Illegal lval for string comparison");
+			free_arg(arg);
+			return EVENT_ERROR;
+		}
+
+		arg->str.field = larg->field.field;
+		free_arg(larg);
+
+		/* free the rarg, and use its token */
+		arg->str.val = rarg->value.str;
+		rarg->value.str = NULL;
+		free_arg(rarg);
+
+		/* Make sure this is a valid string compare */
+		switch (op_type) {
+		case FILTER_CMP_EQ:
+			op_type = FILTER_CMP_MATCH;
+			break;
+		case FILTER_CMP_NE:
+			op_type = FILTER_CMP_NOT_MATCH;
+			break;
+
+		case FILTER_CMP_REGEX:
+		case FILTER_CMP_NOT_REGEX:
+			ret = regcomp(&arg->str.reg, arg->str.val, REG_ICASE|REG_NOSUB);
+			if (ret) {
+				show_error(error_str,
+					   "RegEx '%s' did not compute",
+					   arg->str.val);
+				free_arg(arg);
+				return EVENT_ERROR;
+			}
+			break;
+		default:
+			show_error(error_str,
+				   "Illegal comparison for string");
+			free_arg(arg);
+			return EVENT_ERROR;
+		}
+
+		arg->str.type = op_type;
+
+		/*
+		 * Need a buffer to copy data int for tests		 */
+		arg->str.buffer = malloc_or_die(arg->str.field->size + 1);
+		/* Null terminate this buffer */
+		arg->str.buffer[arg->str.field->size] = 0;
+
+		break;
+	default:
+ as_int:
+		switch (op_type) {
+		case FILTER_CMP_REGEX:
+		case FILTER_CMP_NOT_REGEX:
+			show_error(error_str,
+				   "Op not allowed with integers");
+			free_arg(arg);
+			return EVENT_ERROR;
+		default:
+			break;
+		}
+		/* numeric compare */
+		arg->type = FILTER_ARG_NUM;
+		arg->num.type = op_type;
+		arg->num.left = larg;
+		arg->num.right = rarg;
+		break;
+	}
+ cont:
+	*parg = arg;
+	return type;
+}
+
+/*
+ * Input: larg
+ * Output: parg, tok
+ */
+static enum event_type
+process_exp(struct event_format *event, enum filter_exp_type etype,
+	    struct filter_arg *larg, struct filter_arg **parg,
+	    char **tok, char **error_str)
+{
+	struct filter_arg *rarg = NULL;
+	struct filter_arg *arg;
+	enum event_type orig_type;
+	enum event_type type;
+
+	type = process_value(event, &rarg, &orig_type, tok, error_str);
+	if (type == EVENT_ERROR) {
+		free_arg(rarg);
+		return type;
+	}
+
+	/* larg can be NULL if a field did not match */
+	if (!larg) {
+		/* syntax is correct, just return NULL */
+		arg = NULL;
+		free_arg(rarg);
+		goto cont;
+	}
+
+	arg = allocate_arg();
+	arg->type = FILTER_ARG_EXP;
+	arg->op.type = etype;
+	arg->op.left = larg;
+	arg->op.right = rarg;
+
+ cont:
+	/* still need a cmp */
+	type = process_op_token(event, arg, parg, type, tok, error_str);
+	return type;
+}
+
+/*
+ * Input: tok
+ * Output: parg, tok
+ */
+static enum event_type
+process_op_token(struct event_format *event, struct filter_arg *larg,
+		 struct filter_arg **parg, enum event_type type, char **tok,
+		 char **error_str)
+{
+	enum filter_cmp_type ctype;
+	enum filter_exp_type etype = FILTER_EXP_NONE;
+	char *token;
+
+	token = *tok;
+	*parg = NULL;
+
+	if (type != EVENT_OP) {
+		*parg = larg;
+		return type;
+	}
+
+	if (strcmp(token, "&&") == 0 || strcmp(token, "||") == 0) {
+		/* handle boolean cases */
+		return process_bool(event, larg, parg, tok, error_str);
+	}
+
+	/* Check for value expressions */
+	if (strcmp(token, "+") == 0) {
+		etype = FILTER_EXP_ADD;
+	} else if (strcmp(token, "-") == 0) {
+		etype = FILTER_EXP_SUB;
+	} else if (strcmp(token, "*") == 0) {
+		etype = FILTER_EXP_MUL;
+	} else if (strcmp(token, "/") == 0) {
+		etype = FILTER_EXP_DIV;
+	} else if (strcmp(token, "%") == 0) {
+		etype = FILTER_EXP_MOD;
+	} else if (strcmp(token, ">>") == 0) {
+		etype = FILTER_EXP_RSHIFT;
+	} else if (strcmp(token, "<<") == 0) {
+		etype = FILTER_EXP_LSHIFT;
+	} else if (strcmp(token, "&") == 0) {
+		etype = FILTER_EXP_AND;
+	} else if (strcmp(token, "|") == 0) {
+		etype = FILTER_EXP_OR;
+	} else if (strcmp(token, "^") == 0) {
+		etype = FILTER_EXP_XOR;
+	} else if (strcmp(token, "~") == 0)
+		etype = FILTER_EXP_NOT;
+
+	if (etype != FILTER_EXP_NONE) {
+		free_token(token);
+		return process_exp(event, etype, larg, parg, tok, error_str);
+	}
+
+	if (strcmp(token, "==") == 0) {
+		ctype = FILTER_CMP_EQ;
+	} else if (strcmp(token, "!=") == 0) {
+		ctype = FILTER_CMP_NE;
+	} else if (strcmp(token, "<") == 0) {
+		ctype = FILTER_CMP_LT;
+	} else if (strcmp(token, ">") == 0) {
+		ctype = FILTER_CMP_GT;
+	} else if (strcmp(token, "<=") == 0) {
+		ctype = FILTER_CMP_LE;
+	} else if (strcmp(token, ">=") == 0) {
+		ctype = FILTER_CMP_GE;
+	} else if (strcmp(token, "=~") == 0) {
+		ctype = FILTER_CMP_REGEX;
+	} else if (strcmp(token, "!~") == 0) {
+		ctype = FILTER_CMP_NOT_REGEX;
+	} else {
+		show_error(error_str,
+			   "Unknown op '%s'", token);
+		free_token(token);
+		return EVENT_ERROR;
+	}
+
+	free_token(token);
+	*tok = NULL;
+	return process_cmp(event, ctype, larg, parg, tok, error_str);
+}
+
+static enum event_type
+process_filter(struct event_format *event, struct filter_arg **parg,
+	       char **tok, char **error_str)
+{
+	struct filter_arg *larg = NULL;
+	enum event_type type;
+
+	*parg = NULL;
+	*tok = NULL;
+
+	type = process_token(event, parg, tok, error_str);
+
+	if (type == EVENT_OP &&
+	    (strcmp(*tok, "&&") == 0 || strcmp(*tok, "||") == 0)) {
+		larg = *parg;
+		*parg = NULL;
+		type = process_bool(event, larg, parg, tok, error_str);
+	}
+
+	return type;
+}
+
+static enum event_type
+process_paren(struct event_format *event, struct filter_arg **parg,
+	      char **tok, char **error_str)
+{
+	struct filter_arg *arg;
+	enum event_type type;
+
+	*parg = NULL;
+
+	type = process_token(event, &arg, tok, error_str);
+	if (type == EVENT_ERROR) {
+		free_arg(arg);
+		return type;
+	}
+
+	if (type == EVENT_OP &&
+	    (strcmp(*tok, "&&") == 0 || strcmp(*tok, "||") == 0)) {
+		type = process_bool(event, arg, parg, tok, error_str);
+	}
+
+	if (type != EVENT_DELIM || strcmp(*tok, ")") != 0) {
+		if (*tok)
+			show_error(error_str,
+				   "Expected ')' but found %s", *tok);
+		else
+			show_error(error_str,
+				   "Unexpected end of filter; Expected ')'");
+		free_token(*tok);
+		*tok = NULL;
+		free_arg(arg);
+		return EVENT_ERROR;
+	}
+	free_token(*tok);
+	*tok = NULL;
+
+	*parg = arg;
+
+	return read_token(tok);
+}
+
+static enum event_type
+process_not(struct event_format *event, struct filter_arg **parg,
+	    char **tok, char **error_str)
+{
+	struct filter_arg *arg;
+	enum event_type type;
+
+	arg = allocate_arg();
+	arg->type = FILTER_ARG_OP;
+	arg->op.type = FILTER_OP_NOT;
+
+	arg->op.left = NULL;
+	type = process_token(event, &arg->op.right, tok, error_str);
+	if (type == EVENT_ERROR) {
+		free_arg(arg);
+		*parg = NULL;
+		free_token(*tok);
+		*tok = NULL;
+		return EVENT_ERROR;
+	}
+	/* If the bool value is NULL, then make this into TRUE */
+	if (!arg->op.right) {
+		arg->type = FILTER_ARG_BOOLEAN;
+		arg->boolean.value = FILTER_TRUE;
+	}
+
+	*parg = arg;
+	free_token(*tok);
+	*tok = NULL;
+
+	return type;
+}
+
+static int
+process_event(struct event_format *event, const char *filter_str,
+	      struct filter_arg **parg, char **error_str)
+{
+	enum event_type type;
+	char *token;
+
+	pevent_buffer_init(filter_str, strlen(filter_str));
+
+	type = process_filter(event, parg, &token, error_str);
+
+	if (type == EVENT_ERROR)
+		return -1;
+
+	if (type != EVENT_NONE) {
+		show_error(error_str,
+			   "Expected end where %s was found",
+			   token);
+		free_token(token);
+		free_arg(*parg);
+		*parg = NULL;
+		return -1;
+	}
+
+	/* If parg is NULL, then make it into FALSE */
+	if (!*parg) {
+		*parg = allocate_arg();
+		(*parg)->type = FILTER_ARG_BOOLEAN;
+		(*parg)->boolean.value = FILTER_FALSE;
+	}
+
+	return 0;
+}
+
+static int filter_event(struct event_filter *filter,
+			struct event_format *event,
+			const char *filter_str, char **error_str)
+{
+	struct filter_type *filter_type;
+	struct filter_arg *arg;
+	int ret;
+
+	if (filter_str) {
+		ret = process_event(event, filter_str, &arg, error_str);
+		if (ret < 0)
+			return ret;
+	} else {
+		/* just add a TRUE arg */
+		arg = allocate_arg();
+		arg->type = FILTER_ARG_BOOLEAN;
+		arg->boolean.value = FILTER_TRUE;
+	}
+
+	filter_type = add_filter_type(filter, event->id);
+	if (filter_type->filter)
+		free_arg(filter_type->filter);
+	filter_type->filter = arg;
+
+	return 0;
+}
+
+/**
+ * pevent_filter_add_filter_str - add a new filter
+ * @filter: the event filter to add to
+ * @filter_str: the filter string that contains the filter
+ * @error_str: string containing reason for failed filter
+ *
+ * Returns 0 if the filter was successfully added
+ *   -1 if there was an error.
+ *
+ * On error, if @error_str points to a string pointer,
+ * it is set to the reason that the filter failed.
+ * This string must be freed with "free".
+ */
+int pevent_filter_add_filter_str(struct event_filter *filter,
+				 const char *filter_str,
+				 char **error_str)
+{
+	struct pevent *pevent = filter->pevent;
+	struct event_list *event;
+	struct event_list *events = NULL;
+	const char *filter_start;
+	const char *next_event;
+	char *this_event;
+	char *event_name = NULL;
+	char *sys_name = NULL;
+	char *sp;
+	int rtn = 0;
+	int len;
+	int ret;
+
+	if (error_str)
+		*error_str = NULL;
+
+	filter_start = strchr(filter_str, ':');
+	if (filter_start)
+		len = filter_start - filter_str;
+	else
+		len = strlen(filter_str);
+
+
+	do {
+		next_event = strchr(filter_str, ',');
+		if (next_event &&
+		    (!filter_start || next_event < filter_start))
+			len = next_event - filter_str;
+		else if (filter_start)
+			len = filter_start - filter_str;
+		else
+			len = strlen(filter_str);
+
+		this_event = malloc_or_die(len + 1);
+		memcpy(this_event, filter_str, len);
+		this_event[len] = 0;
+
+		if (next_event)
+			next_event++;
+
+		filter_str = next_event;
+
+		sys_name = strtok_r(this_event, "/", &sp);
+		event_name = strtok_r(NULL, "/", &sp);
+
+		if (!sys_name) {
+			show_error(error_str, "No filter found");
+			/* This can only happen when events is NULL, but still */
+			free_events(events);
+			free(this_event);
+			return -1;
+		}
+
+		/* Find this event */
+		ret = find_event(pevent, &events, strim(sys_name), strim(event_name));
+		if (ret < 0) {
+			if (event_name)
+				show_error(error_str,
+					   "No event found under '%s.%s'",
+					   sys_name, event_name);
+			else
+				show_error(error_str,
+					   "No event found under '%s'",
+					   sys_name);
+			free_events(events);
+			free(this_event);
+			return -1;
+		}
+		free(this_event);
+	} while (filter_str);
+
+	/* Skip the ':' */
+	if (filter_start)
+		filter_start++;
+
+	/* filter starts here */
+	for (event = events; event; event = event->next) {
+		ret = filter_event(filter, event->event, filter_start,
+				   error_str);
+		/* Failures are returned if a parse error happened */
+		if (ret < 0)
+			rtn = ret;
+	}
+
+	free_events(events);
+
+	return rtn;
+}
+
+static void free_filter_type(struct filter_type *filter_type)
+{
+	free_arg(filter_type->filter);
+}
+
+/**
+ * pevent_filter_remove_event - remove a filter for an event
+ * @filter: the event filter to remove from
+ * @event_id: the event to remove a filter for
+ *
+ * Removes the filter saved for an event defined by @event_id
+ * from the @filter.
+ *
+ * Returns 1: if an event was removed
+ *   0: if the event was not found
+ */
+int pevent_filter_remove_event(struct event_filter *filter,
+			       int event_id)
+{
+	struct filter_type *filter_type;
+	unsigned long len;
+
+	if (!filter->filters)
+		return 0;
+
+	filter_type = find_filter_type(filter, event_id);
+
+	if (!filter_type)
+		return 0;
+
+	free_filter_type(filter_type);
+
+	/* The filter_type points into the event_filters array */
+	len = (unsigned long)(filter->event_filters + filter->filters) -
+		(unsigned long)(filter_type + 1);
+
+	memmove(filter_type, filter_type + 1, len);
+	filter->filters--;
+
+	memset(&filter->event_filters[filter->filters], 0,
+	       sizeof(*filter_type));
+
+	return 1;
+}
+
+/**
+ * pevent_filter_reset - clear all filters in a filter
+ * @filter: the event filter to reset
+ *
+ * Removes all filters from a filter and resets it.
+ */
+void pevent_filter_reset(struct event_filter *filter)
+{
+	int i;
+
+	for (i = 0; i < filter->filters; i++)
+		free_filter_type(&filter->event_filters[i]);
+
+	free(filter->event_filters);
+	filter->filters = 0;
+	filter->event_filters = NULL;
+}
+
+void pevent_filter_free(struct event_filter *filter)
+{
+	pevent_unref(filter->pevent);
+
+	pevent_filter_reset(filter);
+
+	free(filter);
+}
+
+static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg);
+
+static int copy_filter_type(struct event_filter *filter,
+			     struct event_filter *source,
+			     struct filter_type *filter_type)
+{
+	struct filter_arg *arg;
+	struct event_format *event;
+	const char *sys;
+	const char *name;
+	char *str;
+
+	/* Can't assume that the pevent's are the same */
+	sys = filter_type->event->system;
+	name = filter_type->event->name;
+	event = pevent_find_event_by_name(filter->pevent, sys, name);
+	if (!event)
+		return -1;
+
+	str = arg_to_str(source, filter_type->filter);
+	if (!str)
+		return -1;
+
+	if (strcmp(str, "TRUE") == 0 || strcmp(str, "FALSE") == 0) {
+		/* Add trivial event */
+		arg = allocate_arg();
+		arg->type = FILTER_ARG_BOOLEAN;
+		if (strcmp(str, "TRUE") == 0)
+			arg->boolean.value = 1;
+		else
+			arg->boolean.value = 0;
+
+		filter_type = add_filter_type(filter, event->id);
+		filter_type->filter = arg;
+
+		free(str);
+		return 0;
+	}
+
+	filter_event(filter, event, str, NULL);
+	free(str);
+
+	return 0;
+}
+
+/**
+ * pevent_filter_copy - copy a filter using another filter
+ * @dest - the filter to copy to
+ * @source - the filter to copy from
+ *
+ * Returns 0 on success and -1 if not all filters were copied
+ */
+int pevent_filter_copy(struct event_filter *dest, struct event_filter *source)
+{
+	int ret = 0;
+	int i;
+
+	pevent_filter_reset(dest);
+
+	for (i = 0; i < source->filters; i++) {
+		if (copy_filter_type(dest, source, &source->event_filters[i]))
+			ret = -1;
+	}
+	return ret;
+}
+
+
+/**
+ * pevent_update_trivial - update the trivial filters with the given filter
+ * @dest - the filter to update
+ * @source - the filter as the source of the update
+ * @type - the type of trivial filter to update.
+ *
+ * Scan dest for trivial events matching @type to replace with the source.
+ *
+ * Returns 0 on success and -1 if there was a problem updating, but
+ *   events may have still been updated on error.
+ */
+int pevent_update_trivial(struct event_filter *dest, struct event_filter *source,
+			  enum filter_trivial_type type)
+{
+	struct pevent *src_pevent;
+	struct pevent *dest_pevent;
+	struct event_format *event;
+	struct filter_type *filter_type;
+	struct filter_arg *arg;
+	char *str;
+	int i;
+
+	src_pevent = source->pevent;
+	dest_pevent = dest->pevent;
+
+	/* Do nothing if either of the filters has nothing to filter */
+	if (!dest->filters || !source->filters)
+		return 0;
+
+	for (i = 0; i < dest->filters; i++) {
+		filter_type = &dest->event_filters[i];
+		arg = filter_type->filter;
+		if (arg->type != FILTER_ARG_BOOLEAN)
+			continue;
+		if ((arg->boolean.value && type == FILTER_TRIVIAL_FALSE) ||
+		    (!arg->boolean.value && type == FILTER_TRIVIAL_TRUE))
+			continue;
+
+		event = filter_type->event;
+
+		if (src_pevent != dest_pevent) {
+			/* do a look up */
+			event = pevent_find_event_by_name(src_pevent,
+							  event->system,
+							  event->name);
+			if (!event)
+				return -1;
+		}
+
+		str = pevent_filter_make_string(source, event->id);
+		if (!str)
+			continue;
+
+		/* Don't bother if the filter is trivial too */
+		if (strcmp(str, "TRUE") != 0 && strcmp(str, "FALSE") != 0)
+			filter_event(dest, event, str, NULL);
+		free(str);
+	}
+	return 0;
+}
+
+/**
+ * pevent_filter_clear_trivial - clear TRUE and FALSE filters
+ * @filter: the filter to remove trivial filters from
+ * @type: remove only true, false, or both
+ *
+ * Removes filters that only contain a TRUE or FALES boolean arg.
+ */
+void pevent_filter_clear_trivial(struct event_filter *filter,
+				 enum filter_trivial_type type)
+{
+	struct filter_type *filter_type;
+	int count = 0;
+	int *ids;
+	int i;
+
+	if (!filter->filters)
+		return;
+
+	/*
+	 * Two steps, first get all ids with trivial filters.
+	 *  then remove those ids.
+	 */
+	for (i = 0; i < filter->filters; i++) {
+		filter_type = &filter->event_filters[i];
+		if (filter_type->filter->type != FILTER_ARG_BOOLEAN)
+			continue;
+		switch (type) {
+		case FILTER_TRIVIAL_FALSE:
+			if (filter_type->filter->boolean.value)
+				continue;
+		case FILTER_TRIVIAL_TRUE:
+			if (!filter_type->filter->boolean.value)
+				continue;
+		default:
+			break;
+		}
+		if (count)
+			ids = realloc(ids, sizeof(*ids) * (count + 1));
+		else
+			ids = malloc(sizeof(*ids));
+		if (!ids)
+			die("Can't allocate ids");
+		ids[count++] = filter_type->event_id;
+	}
+
+	if (!count)
+		return;
+
+	for (i = 0; i < count; i++)
+		pevent_filter_remove_event(filter, ids[i]);
+
+	free(ids);
+}
+
+/**
+ * pevent_filter_event_has_trivial - return true event contains trivial filter
+ * @filter: the filter with the information
+ * @event_id: the id of the event to test
+ * @type: trivial type to test for (TRUE, FALSE, EITHER)
+ *
+ * Returns 1 if the event contains a matching trivial type
+ *  otherwise 0.
+ */
+int pevent_filter_event_has_trivial(struct event_filter *filter,
+				    int event_id,
+				    enum filter_trivial_type type)
+{
+	struct filter_type *filter_type;
+
+	if (!filter->filters)
+		return 0;
+
+	filter_type = find_filter_type(filter, event_id);
+
+	if (!filter_type)
+		return 0;
+
+	if (filter_type->filter->type != FILTER_ARG_BOOLEAN)
+		return 0;
+
+	switch (type) {
+	case FILTER_TRIVIAL_FALSE:
+		return !filter_type->filter->boolean.value;
+
+	case FILTER_TRIVIAL_TRUE:
+		return filter_type->filter->boolean.value;
+	default:
+		return 1;
+	}
+}
+
+static int test_filter(struct event_format *event,
+		       struct filter_arg *arg, struct record *record);
+
+static unsigned long long
+get_value(struct format_field *field, struct record *record)
+{
+	unsigned long long val;
+
+	pevent_read_number_field(field, record->data, &val);
+
+	if (!(field->flags & FIELD_IS_SIGNED))
+		return val;
+
+	switch (field->size) {
+	case 1:
+		return (char)val;
+	case 2:
+		return (short)val;
+	case 4:
+		return (int)val;
+	case 8:
+		return (long long)val;
+	}
+	return val;
+}
+
+static unsigned long long
+get_arg_value(struct event_format *event, struct filter_arg *arg, struct record *record);
+
+static unsigned long long
+get_exp_value(struct event_format *event, struct filter_arg *arg, struct record *record)
+{
+	unsigned long long lval, rval;
+
+	lval = get_arg_value(event, arg->op.left, record);
+	rval = get_arg_value(event, arg->op.right, record);
+
+	switch (arg->op.type) {
+	case FILTER_EXP_ADD:
+		return lval + rval;
+
+	case FILTER_EXP_SUB:
+		return lval - rval;
+
+	case FILTER_EXP_MUL:
+		return lval * rval;
+
+	case FILTER_EXP_DIV:
+		return lval / rval;
+
+	case FILTER_EXP_MOD:
+		return lval % rval;
+
+	case FILTER_EXP_RSHIFT:
+		return lval >> rval;
+
+	case FILTER_EXP_LSHIFT:
+		return lval << rval;
+
+	case FILTER_EXP_AND:
+		return lval & rval;
+
+	case FILTER_EXP_OR:
+		return lval | rval;
+
+	case FILTER_EXP_XOR:
+		return lval ^ rval;
+
+	case FILTER_EXP_NOT:
+	default:
+		die("error in exp");
+	}
+	return 0;
+}
+
+static unsigned long long
+get_arg_value(struct event_format *event, struct filter_arg *arg, struct record *record)
+{
+	switch (arg->type) {
+	case FILTER_ARG_FIELD:
+		return get_value(arg->field.field, record);
+
+	case FILTER_ARG_VALUE:
+		if (arg->value.type != FILTER_NUMBER)
+			die("must have number field!");
+		return arg->value.val;
+
+	case FILTER_ARG_EXP:
+		return get_exp_value(event, arg, record);
+
+	default:
+		die("oops in filter");
+	}
+	return 0;
+}
+
+static int test_num(struct event_format *event,
+		    struct filter_arg *arg, struct record *record)
+{
+	unsigned long long lval, rval;
+
+	lval = get_arg_value(event, arg->num.left, record);
+	rval = get_arg_value(event, arg->num.right, record);
+
+	switch (arg->num.type) {
+	case FILTER_CMP_EQ:
+		return lval == rval;
+
+	case FILTER_CMP_NE:
+		return lval != rval;
+
+	case FILTER_CMP_GT:
+		return lval > rval;
+
+	case FILTER_CMP_LT:
+		return lval < rval;
+
+	case FILTER_CMP_GE:
+		return lval >= rval;
+
+	case FILTER_CMP_LE:
+		return lval <= rval;
+
+	default:
+		/* ?? */
+		return 0;
+	}
+}
+
+static int test_str(struct event_format *event,
+		    struct filter_arg *arg, struct record *record)
+{
+	const char *val = record->data + arg->str.field->offset;
+	const char *buffer;
+
+	/*
+	 * We need to copy the data since we can't be sure the field
+	 * is null terminated.
+	 */
+	if (*(val + arg->str.field->size - 1)) {
+		/* copy it */
+		memcpy(arg->str.buffer, val, arg->str.field->size);
+		/* the buffer is already NULL terminated */
+		buffer = arg->str.buffer;
+	} else
+		/* OK, it's NULL terminated */
+		buffer = val;
+
+	switch (arg->str.type) {
+	case FILTER_CMP_MATCH:
+		return strcmp(buffer, arg->str.val) == 0;
+
+	case FILTER_CMP_NOT_MATCH:
+		return strcmp(buffer, arg->str.val) != 0;
+
+	case FILTER_CMP_REGEX:
+		/* Returns zero on match */
+		return !regexec(&arg->str.reg, buffer, 0, NULL, 0);
+
+	case FILTER_CMP_NOT_REGEX:
+		return regexec(&arg->str.reg, buffer, 0, NULL, 0);
+
+	default:
+		/* ?? */
+		return 0;
+	}
+}
+
+static int test_op(struct event_format *event,
+		   struct filter_arg *arg, struct record *record)
+{
+	switch (arg->op.type) {
+	case FILTER_OP_AND:
+		return test_filter(event, arg->op.left, record) &&
+			test_filter(event, arg->op.right, record);
+
+	case FILTER_OP_OR:
+		return test_filter(event, arg->op.left, record) ||
+			test_filter(event, arg->op.right, record);
+
+	case FILTER_OP_NOT:
+		return !test_filter(event, arg->op.right, record);
+
+	default:
+		/* ?? */
+		return 0;
+	}
+}
+
+static int test_filter(struct event_format *event,
+		       struct filter_arg *arg, struct record *record)
+{
+	switch (arg->type) {
+	case FILTER_ARG_BOOLEAN:
+		/* easy case */
+		return arg->boolean.value;
+
+	case FILTER_ARG_OP:
+		return test_op(event, arg, record);
+
+	case FILTER_ARG_NUM:
+		return test_num(event, arg, record);
+
+	case FILTER_ARG_STR:
+		return test_str(event, arg, record);
+
+	case FILTER_ARG_EXP:
+	case FILTER_ARG_VALUE:
+	case FILTER_ARG_FIELD:
+		/*
+		 * Expressions, fields and values evaluate
+		 * to true if they return non zero
+		 */
+		return !!get_arg_value(event, arg, record);
+
+	default:
+		die("oops!");
+		/* ?? */
+		return 0;
+	}
+}
+
+/**
+ * pevent_event_filtered - return true if event has filter
+ * @filter: filter struct with filter information
+ * @event_id: event id to test if filter exists
+ *
+ * Returns 1 if filter found for @event_id
+ *   otherwise 0;
+ */
+int pevent_event_filtered(struct event_filter *filter,
+			  int event_id)
+{
+	struct filter_type *filter_type;
+
+	if (!filter->filters)
+		return 0;
+
+	filter_type = find_filter_type(filter, event_id);
+
+	return filter_type ? 1 : 0;
+}
+
+/**
+ * pevent_filter_match - test if a record matches a filter
+ * @filter: filter struct with filter information
+ * @record: the record to test against the filter
+ *
+ * Returns:
+ *  1 - filter found for event and @record matches
+ *  0 - filter found for event and @record does not match
+ * -1 - no filter found for @record's event
+ * -2 - if no filters exist
+ */
+int pevent_filter_match(struct event_filter *filter,
+			struct record *record)
+{
+	struct pevent *pevent = filter->pevent;
+	struct filter_type *filter_type;
+	int event_id;
+
+	if (!filter->filters)
+		return FILTER_NONE;
+
+	event_id = pevent_data_type(pevent, record);
+
+	filter_type = find_filter_type(filter, event_id);
+
+	if (!filter_type)
+		return FILTER_NOEXIST;
+
+	return test_filter(filter_type->event, filter_type->filter, record) ?
+		FILTER_MATCH : FILTER_MISS;
+}
+
+static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
+{
+	char *str = NULL;
+	char *left = NULL;
+	char *right = NULL;
+	char *op = NULL;
+	int left_val = -1;
+	int right_val = -1;
+	int val;
+	int len;
+
+	switch (arg->op.type) {
+	case FILTER_OP_AND:
+		op = "&&";
+		/* fall through */
+	case FILTER_OP_OR:
+		if (!op)
+			op = "||";
+
+		left = arg_to_str(filter, arg->op.left);
+		right = arg_to_str(filter, arg->op.right);
+		if (!left || !right)
+			break;
+
+		/* Try to consolidate boolean values */
+		if (strcmp(left, "TRUE") == 0)
+			left_val = 1;
+		else if (strcmp(left, "FALSE") == 0)
+			left_val = 0;
+
+		if (strcmp(right, "TRUE") == 0)
+			right_val = 1;
+		else if (strcmp(right, "FALSE") == 0)
+			right_val = 0;
+
+		if (left_val >= 0) {
+			if ((arg->op.type == FILTER_OP_AND && !left_val) ||
+			    (arg->op.type == FILTER_OP_OR && left_val)) {
+				/* Just return left value */
+				str = left;
+				left = NULL;
+				break;
+			}
+			if (right_val >= 0) {
+				/* just evaluate this. */
+				val = 0;
+				switch (arg->op.type) {
+				case FILTER_OP_AND:
+					val = left_val && right_val;
+					break;
+				case FILTER_OP_OR:
+					val = left_val || right_val;
+					break;
+				default:
+					break;
+				}
+				str = malloc_or_die(6);
+				if (val)
+					strcpy(str, "TRUE");
+				else
+					strcpy(str, "FALSE");
+				break;
+			}
+		}
+		if (right_val >= 0) {
+			if ((arg->op.type == FILTER_OP_AND && !right_val) ||
+			    (arg->op.type == FILTER_OP_OR && right_val)) {
+				/* Just return right value */
+				str = right;
+				right = NULL;
+				break;
+			}
+			/* The right value is meaningless */
+			str = left;
+			left = NULL;
+			break;
+		}
+
+		len = strlen(left) + strlen(right) + strlen(op) + 10;
+		str = malloc_or_die(len);
+		snprintf(str, len, "(%s) %s (%s)",
+			 left, op, right);
+		break;
+
+	case FILTER_OP_NOT:
+		op = "!";
+		right = arg_to_str(filter, arg->op.right);
+		if (!right)
+			break;
+
+		/* See if we can consolidate */
+		if (strcmp(right, "TRUE") == 0)
+			right_val = 1;
+		else if (strcmp(right, "FALSE") == 0)
+			right_val = 0;
+		if (right_val >= 0) {
+			/* just return the opposite */
+			str = malloc_or_die(6);
+			if (right_val)
+				strcpy(str, "FALSE");
+			else
+				strcpy(str, "TRUE");
+			break;
+		}
+		len = strlen(right) + strlen(op) + 3;
+		str = malloc_or_die(len);
+		snprintf(str, len, "%s(%s)", op, right);
+		break;
+
+	default:
+		/* ?? */
+		break;
+	}
+	free(left);
+	free(right);
+	return str;
+}
+
+static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
+{
+	char *str;
+
+	str = malloc_or_die(30);
+
+	snprintf(str, 30, "%lld", arg->value.val);
+
+	return str;
+}
+
+static char *field_to_str(struct event_filter *filter, struct filter_arg *arg)
+{
+	return strdup(arg->field.field->name);
+}
+
+static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
+{
+	char *lstr;
+	char *rstr;
+	char *op;
+	char *str;
+	int len;
+
+	lstr = arg_to_str(filter, arg->op.left);
+	rstr = arg_to_str(filter, arg->op.right);
+
+	switch (arg->op.type) {
+	case FILTER_EXP_ADD:
+		op = "+";
+		break;
+	case FILTER_EXP_SUB:
+		op = "-";
+		break;
+	case FILTER_EXP_MUL:
+		op = "*";
+		break;
+	case FILTER_EXP_DIV:
+		op = "/";
+		break;
+	case FILTER_EXP_MOD:
+		op = "%";
+		break;
+	case FILTER_EXP_RSHIFT:
+		op = ">>";
+		break;
+	case FILTER_EXP_LSHIFT:
+		op = "<<";
+		break;
+	case FILTER_EXP_AND:
+		op = "&";
+		break;
+	case FILTER_EXP_OR:
+		op = "|";
+		break;
+	case FILTER_EXP_XOR:
+		op = "^";
+		break;
+	default:
+		die("oops in exp");
+	}
+
+	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
+	str = malloc_or_die(len);
+	snprintf(str, len, "%s %s %s", lstr, op, rstr);
+	free(lstr);
+	free(rstr);
+
+	return str;
+}
+
+static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
+{
+	char *lstr;
+	char *rstr;
+	char *str = NULL;
+	char *op = NULL;
+	int len;
+
+	lstr = arg_to_str(filter, arg->num.left);
+	rstr = arg_to_str(filter, arg->num.right);
+
+	switch (arg->num.type) {
+	case FILTER_CMP_EQ:
+		op = "==";
+		/* fall through */
+	case FILTER_CMP_NE:
+		if (!op)
+			op = "!=";
+		/* fall through */
+	case FILTER_CMP_GT:
+		if (!op)
+			op = ">";
+		/* fall through */
+	case FILTER_CMP_LT:
+		if (!op)
+			op = "<";
+		/* fall through */
+	case FILTER_CMP_GE:
+		if (!op)
+			op = ">=";
+		/* fall through */
+	case FILTER_CMP_LE:
+		if (!op)
+			op = "<=";
+
+		len = strlen(lstr) + strlen(op) + strlen(rstr) + 4;
+		str = malloc_or_die(len);
+		sprintf(str, "%s %s %s", lstr, op, rstr);
+
+		break;
+
+	default:
+		/* ?? */
+		break;
+	}
+
+	free(lstr);
+	free(rstr);
+	return str;
+}
+
+static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
+{
+	char *str = NULL;
+	char *op = NULL;
+	int len;
+
+	switch (arg->str.type) {
+	case FILTER_CMP_MATCH:
+		op = "==";
+		/* fall through */
+	case FILTER_CMP_NOT_MATCH:
+		if (!op)
+			op = "!=";
+		/* fall through */
+	case FILTER_CMP_REGEX:
+		if (!op)
+			op = "=~";
+		/* fall through */
+	case FILTER_CMP_NOT_REGEX:
+		if (!op)
+			op = "!~";
+
+		len = strlen(arg->str.field->name) + strlen(op) +
+			strlen(arg->str.val) + 6;
+		str = malloc_or_die(len);
+		snprintf(str, len, "%s %s \"%s\"",
+			 arg->str.field->name,
+			 op, arg->str.val);
+		break;
+
+	default:
+		/* ?? */
+		break;
+	}
+	return str;
+}
+
+static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
+{
+	char *str;
+
+	switch (arg->type) {
+	case FILTER_ARG_BOOLEAN:
+		str = malloc_or_die(6);
+		if (arg->boolean.value)
+			strcpy(str, "TRUE");
+		else
+			strcpy(str, "FALSE");
+		return str;
+
+	case FILTER_ARG_OP:
+		return op_to_str(filter, arg);
+
+	case FILTER_ARG_NUM:
+		return num_to_str(filter, arg);
+
+	case FILTER_ARG_STR:
+		return str_to_str(filter, arg);
+
+	case FILTER_ARG_VALUE:
+		return val_to_str(filter, arg);
+
+	case FILTER_ARG_FIELD:
+		return field_to_str(filter, arg);
+
+	case FILTER_ARG_EXP:
+		return exp_to_str(filter, arg);
+
+	default:
+		/* ?? */
+		return NULL;
+	}
+
+}
+
+/**
+ * pevent_filter_make_string - return a string showing the filter
+ * @filter: filter struct with filter information
+ * @event_id: the event id to return the filter string with
+ *
+ * Returns a string that displays the filter contents.
+ *  This string must be freed with free(str).
+ *  NULL is returned if no filter is found.
+ */
+char *
+pevent_filter_make_string(struct event_filter *filter, int event_id)
+{
+	struct filter_type *filter_type;
+
+	if (!filter->filters)
+		return NULL;
+
+	filter_type = find_filter_type(filter, event_id);
+
+	if (!filter_type)
+		return NULL;
+
+	return arg_to_str(filter, filter_type->filter);
+}
+
+/**
+ * pevent_filter_compare - compare two filters and return if they are the same
+ * @filter1: Filter to compare with @filter2
+ * @filter2: Filter to compare with @filter1
+ *
+ * Returns:
+ *  1 if the two filters hold the same content.
+ *  0 if they do not.
+ */
+int pevent_filter_compare(struct event_filter *filter1, struct event_filter *filter2)
+{
+	struct filter_type *filter_type1;
+	struct filter_type *filter_type2;
+	char *str1, *str2;
+	int result;
+	int i;
+
+	/* Do the easy checks first */
+	if (filter1->filters != filter2->filters)
+		return 0;
+	if (!filter1->filters && !filter2->filters)
+		return 1;
+
+	/*
+	 * Now take a look at each of the events to see if they have the same
+	 * filters to them.
+	 */
+	for (i = 0; i < filter1->filters; i++) {
+		filter_type1 = &filter1->event_filters[i];
+		filter_type2 = find_filter_type(filter2, filter_type1->event_id);
+		if (!filter_type2)
+			break;
+		if (filter_type1->filter->type != filter_type2->filter->type)
+			break;
+		switch (filter_type1->filter->type) {
+		case FILTER_TRIVIAL_FALSE:
+		case FILTER_TRIVIAL_TRUE:
+			/* trivial types just need the type compared */
+			continue;
+		default:
+			break;
+		}
+		/* The best way to compare complex filters is with strings */
+		str1 = arg_to_str(filter1, filter_type1->filter);
+		str2 = arg_to_str(filter2, filter_type2->filter);
+		result = strcmp(str1, str2) != 0;
+		free(str1);
+		free(str2);
+		if (result)
+			break;
+	}
+
+	if (i < filter1->filters)
+		return 0;
+	return 1;
+}
+
diff --git a/tools/lib/trace/parse-utils.c b/tools/lib/trace/parse-utils.c
new file mode 100644
index 0000000..f023a13
--- /dev/null
+++ b/tools/lib/trace/parse-utils.c
@@ -0,0 +1,110 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <errno.h>
+
+#define __weak __attribute__((weak))
+
+void __vdie(const char *fmt, va_list ap)
+{
+	int ret = errno;
+
+	if (errno)
+		perror("trace-cmd");
+	else
+		ret = -1;
+
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+
+	fprintf(stderr, "\n");
+	exit(ret);
+}
+
+void __die(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vdie(fmt, ap);
+	va_end(ap);
+}
+
+void __weak die(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vdie(fmt, ap);
+	va_end(ap);
+}
+
+void __vwarning(const char *fmt, va_list ap)
+{
+	if (errno)
+		perror("trace-cmd");
+	errno = 0;
+
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+
+	fprintf(stderr, "\n");
+}
+
+void __warning(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vwarning(fmt, ap);
+	va_end(ap);
+}
+
+void __weak warning(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vwarning(fmt, ap);
+	va_end(ap);
+}
+
+void __vpr_stat(const char *fmt, va_list ap)
+{
+	vprintf(fmt, ap);
+	printf("\n");
+}
+
+void __pr_stat(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vpr_stat(fmt, ap);
+	va_end(ap);
+}
+
+void __weak vpr_stat(const char *fmt, va_list ap)
+{
+	__vpr_stat(fmt, ap);
+}
+
+void __weak pr_stat(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vpr_stat(fmt, ap);
+	va_end(ap);
+}
+
+void __weak *malloc_or_die(unsigned int size)
+{
+	void *data;
+
+	data = malloc(size);
+	if (!data)
+		die("malloc");
+	return data;
+}
diff --git a/tools/lib/trace/trace-seq.c b/tools/lib/trace/trace-seq.c
new file mode 100644
index 0000000..d84a5bd
--- /dev/null
+++ b/tools/lib/trace/trace-seq.c
@@ -0,0 +1,153 @@
+/*
+ * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+
+#include "parse-events.h"
+
+/**
+ * trace_seq_printf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+{
+	int len = (TRACE_SEQ_SIZE - 1) - s->len;
+	va_list ap;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	va_end(ap);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return 1;
+}
+
+/**
+ * trace_seq_vprintf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+{
+	int len = (TRACE_SEQ_SIZE - 1) - s->len;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->len += ret;
+
+	return len;
+}
+
+/**
+ * trace_seq_puts - trace sequence printing of simple string
+ * @s: trace sequence descriptor
+ * @str: simple string to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple string
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ */
+int trace_seq_puts(struct trace_seq *s, const char *str)
+{
+	int len = strlen(str);
+
+	if (s->full)
+		return 0;
+
+	if (len > ((TRACE_SEQ_SIZE - 1) - s->len)) {
+		s->full = 1;
+		return 0;
+	}
+
+	memcpy(s->buffer + s->len, str, len);
+	s->len += len;
+
+	return len;
+}
+
+int trace_seq_putc(struct trace_seq *s, unsigned char c)
+{
+	if (s->full)
+		return 0;
+
+	if (s->len >= (TRACE_SEQ_SIZE - 1)) {
+		s->full = 1;
+		return 0;
+	}
+
+	s->buffer[s->len++] = c;
+
+	return 1;
+}
+
+void trace_seq_terminate(struct trace_seq *s)
+{
+	if (!s->full)
+		s->buffer[s->len] = 0;
+}
+
+int trace_seq_do_printf(struct trace_seq *s)
+{
+	return printf("%.*s%s", s->len, s->buffer,
+			s->full ? "[truncated]" : "");
+}
diff --git a/tools/lib/trace/trace-util.h b/tools/lib/trace/trace-util.h
new file mode 100644
index 0000000..d3faf10
--- /dev/null
+++ b/tools/lib/trace/trace-util.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#ifndef __TRACE_UTIL_H
+#define __TRACE_UTIL_H
+
+#include <ctype.h>
+
+static inline char *strim(char *string)
+{
+	char *ret;
+
+	if (!string)
+		return NULL;
+	while (*string) {
+		if (!isspace(*string))
+			break;
+		string++;
+	}
+	ret = string;
+
+	string = ret + strlen(ret) - 1;
+	while (string > ret) {
+		if (!isspace(*string))
+			break;
+		string--;
+	}
+	string[1] = 0;
+
+	return ret;
+}
+
+static inline int has_text(const char *text)
+{
+	if (!text)
+		return 0;
+
+	while (*text) {
+		if (!isspace(*text))
+			return 1;
+		text++;
+	}
+
+	return 0;
+}
+
+#endif /* __TRACE_UTIL_H */
diff --git a/tools/lib/util.h b/tools/lib/util.h
deleted file mode 100644
index 2bb9fe6..0000000
--- a/tools/lib/util.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-#ifndef __UTIL_H
-#define __UTIL_H
-
-#include <ctype.h>
-
-static inline char *strim(char *string)
-{
-	char *ret;
-
-	if (!string)
-		return NULL;
-	while (*string) {
-		if (!isspace(*string))
-			break;
-		string++;
-	}
-	ret = string;
-
-	string = ret + strlen(ret) - 1;
-	while (string > ret) {
-		if (!isspace(*string))
-			break;
-		string--;
-	}
-	string[1] = 0;
-
-	return ret;
-}
-
-static inline int has_text(const char *text)
-{
-	if (!text)
-		return 0;
-
-	while (*text) {
-		if (!isspace(*text))
-			return 1;
-		text++;
-	}
-
-	return 0;
-}
-
-#endif
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f7a2626..425a572 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,12 +1,7 @@
-ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-	LIB_OUTPUT := $(OUTPUT)generic-lib/
-else
-	LIB_OUTPUT := ../lib/
-endif
-
 export OUTPUT ALL_CFLAGS
 
+include ../scripts/Makefile.lib
+
 # The default target of this Makefile is...
 all::
 
@@ -195,33 +190,6 @@ endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
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
 ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
@@ -862,11 +830,6 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
-force:
-
-$(LIB_OUTPUT)libparsevent.a: force
-	$(MAKE) -C ../lib libparsevent.a
-
 # Shell quote (do not use $(call) to accommodate ancient setups);
 
 SHA1_HEADER_SQ = $(subst ','\'',$(SHA1_HEADER))
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index e9923bc..6597c73 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_UTIL_TRACE_EVENT_H
 #define _PERF_UTIL_TRACE_EVENT_H
 
-#include "../../lib/parse-events.h"
+#include "../../lib/trace/parse-events.h"
 #include "parse-events.h"
 
 extern int header_page_size_size;
diff --git a/tools/scripts/Makefile.lib b/tools/scripts/Makefile.lib
new file mode 100644
index 0000000..f125d62
--- /dev/null
+++ b/tools/scripts/Makefile.lib
@@ -0,0 +1,33 @@
+QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =
+
+ifneq ($(findstring $(MAKEFLAGS),w),w)
+PRINT_DIR = --no-print-directory
+else # "make -w"
+NO_SUBDIR = :
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
+	export QUIET_GEN
+	export QUIET_BUILT_IN
+endif
+endif
+
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+	LIB_OUTPUT := $(OUTPUT)generic-lib/
+	__dummy := $(shell if [ ! -d $(LIB_OUTPUT) ]; then mkdir -p $(LIB_OUTPUT); fi)
+
+else
+	LIB_OUTPUT := $(PERF_TOP_DIR)/lib/
+endif
-- 
1.7.3.1

