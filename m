Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2JIRcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:32:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2JIRcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:32:15 -0400
Date: Tue, 9 Oct 2012 10:31:47 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8wpzqs9kfupng6xq8hx6lnxa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Introduce find_thread method
Git-Commit-ID: 9d2f8e22fc965bcdd5561d000d234fe2d23657ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:31:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d2f8e22fc965bcdd5561d000d234fe2d23657ba
Gitweb:     http://git.kernel.org/tip/9d2f8e22fc965bcdd5561d000d234fe2d23657ba
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 6 Oct 2012 15:43:20 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 6 Oct 2012 16:33:22 -0300

perf machine: Introduce find_thread method

There are cases where we want just to find a thread if it exists
already, so provide a method for that.

While doing that start moving 'machine' methods to a separate file.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8wpzqs9kfupng6xq8hx6lnxa@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile       |    2 +
 tools/perf/util/machine.c |   57 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h |   11 ++++++++
 tools/perf/util/thread.c  |   41 +-------------------------------
 tools/perf/util/thread.h  |    2 +
 5 files changed, 73 insertions(+), 40 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f9126f8..d80a333 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -300,6 +300,7 @@ LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
+LIB_H += util/machine.h
 LIB_H += util/map.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
@@ -383,6 +384,7 @@ LIB_OBJS += $(OUTPUT)util/header.o
 LIB_OBJS += $(OUTPUT)util/callchain.o
 LIB_OBJS += $(OUTPUT)util/values.o
 LIB_OBJS += $(OUTPUT)util/debug.o
+LIB_OBJS += $(OUTPUT)util/machine.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
new file mode 100644
index 0000000..9d36d7e
--- /dev/null
+++ b/tools/perf/util/machine.c
@@ -0,0 +1,57 @@
+#include "machine.h"
+#include "map.h"
+#include "thread.h"
+#include <stdbool.h>
+
+static struct thread *__machine__findnew_thread(struct machine *machine, pid_t pid,
+						bool create)
+{
+	struct rb_node **p = &machine->threads.rb_node;
+	struct rb_node *parent = NULL;
+	struct thread *th;
+
+	/*
+	 * Font-end cache - PID lookups come in blocks,
+	 * so most of the time we dont have to look up
+	 * the full rbtree:
+	 */
+	if (machine->last_match && machine->last_match->pid == pid)
+		return machine->last_match;
+
+	while (*p != NULL) {
+		parent = *p;
+		th = rb_entry(parent, struct thread, rb_node);
+
+		if (th->pid == pid) {
+			machine->last_match = th;
+			return th;
+		}
+
+		if (pid < th->pid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	if (!create)
+		return NULL;
+
+	th = thread__new(pid);
+	if (th != NULL) {
+		rb_link_node(&th->rb_node, parent, p);
+		rb_insert_color(&th->rb_node, &machine->threads);
+		machine->last_match = th;
+	}
+
+	return th;
+}
+
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid)
+{
+	return __machine__findnew_thread(machine, pid, true);
+}
+
+struct thread *machine__find_thread(struct machine *machine, pid_t pid)
+{
+	return __machine__findnew_thread(machine, pid, false);
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
new file mode 100644
index 0000000..54df0cd
--- /dev/null
+++ b/tools/perf/util/machine.h
@@ -0,0 +1,11 @@
+#ifndef __PERF_MACHINE_H
+#define __PERF_MACHINE_H
+
+#include <sys/types.h>
+
+struct thread;
+struct machine;
+
+struct thread *machine__find_thread(struct machine *machine, pid_t pid);
+
+#endif /* __PERF_MACHINE_H */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..fe3bb1e 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,7 +7,7 @@
 #include "util.h"
 #include "debug.h"
 
-static struct thread *thread__new(pid_t pid)
+struct thread *thread__new(pid_t pid)
 {
 	struct thread *self = zalloc(sizeof(*self));
 
@@ -61,45 +61,6 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	       map_groups__fprintf(&self->mg, verbose, fp);
 }
 
-struct thread *machine__findnew_thread(struct machine *self, pid_t pid)
-{
-	struct rb_node **p = &self->threads.rb_node;
-	struct rb_node *parent = NULL;
-	struct thread *th;
-
-	/*
-	 * Font-end cache - PID lookups come in blocks,
-	 * so most of the time we dont have to look up
-	 * the full rbtree:
-	 */
-	if (self->last_match && self->last_match->pid == pid)
-		return self->last_match;
-
-	while (*p != NULL) {
-		parent = *p;
-		th = rb_entry(parent, struct thread, rb_node);
-
-		if (th->pid == pid) {
-			self->last_match = th;
-			return th;
-		}
-
-		if (pid < th->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	th = thread__new(pid);
-	if (th != NULL) {
-		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &self->threads);
-		self->last_match = th;
-	}
-
-	return th;
-}
-
 void thread__insert_map(struct thread *self, struct map *map)
 {
 	map_groups__fixup_overlappings(&self->mg, map, verbose, stderr);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index f66610b..f2fa17c 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -3,6 +3,7 @@
 
 #include <linux/rbtree.h>
 #include <unistd.h>
+#include <sys/types.h>
 #include "symbol.h"
 
 struct thread {
@@ -22,6 +23,7 @@ struct thread {
 
 struct machine;
 
+struct thread *thread__new(pid_t pid);
 void thread__delete(struct thread *self);
 
 int thread__set_comm(struct thread *self, const char *comm);
