Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab0D1BxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:53:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:40903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab0D1Bw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:52:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: [PATCH 2/5] perf machine: Pass buffer size to machine__mmap_name
Date: Tue, 27 Apr 2010 22:52:37 -0300
Message-Id: <1272419560-4332-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272419560-4332-1-git-send-email-acme@infradead.org>
References: <1272419560-4332-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Don't blindly assume that the size of the buffer is enough, use
snprintf.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    4 ++--
 tools/perf/util/map.c    |   10 +++++-----
 tools/perf/util/map.h    |    2 +-
 tools/perf/util/symbol.c |    6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2f33ca9..7400e51 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -288,7 +288,7 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 	 */
 	struct process_symbol_args args = { .name = symbol_name, };
 
-	mmap_name = machine__mmap_name(machine, name_buff);
+	mmap_name = machine__mmap_name(machine, name_buff, sizeof(name_buff));
 	if (machine__is_host(machine)) {
 		/*
 		 * kernel uses PERF_RECORD_MISC_USER for user space maps,
@@ -399,7 +399,7 @@ static int event__process_kernel_mmap(event_t *self,
 		goto out_problem;
 	}
 
-	machine__mmap_name(machine, kmmap_prefix);
+	machine__mmap_name(machine, kmmap_prefix, sizeof(kmmap_prefix));
 	if (machine__is_host(machine))
 		kernel_type = DSO_TYPE_KERNEL;
 	else
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index da3d4e8..ee25ee9 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -629,14 +629,14 @@ void machines__process(struct rb_root *self, machine__process_t process, void *d
 	}
 }
 
-char *machine__mmap_name(struct machine *self, char *buff)
+char *machine__mmap_name(struct machine *self, char *bf, size_t size)
 {
 	if (machine__is_host(self))
-		sprintf(buff, "[%s]", "kernel.kallsyms");
+		snprintf(bf, size, "[%s]", "kernel.kallsyms");
 	else if (machine__is_default_guest(self))
-		sprintf(buff, "[%s]", "guest.kernel.kallsyms");
+		snprintf(bf, size, "[%s]", "guest.kernel.kallsyms");
 	else
-		sprintf(buff, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
+		snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
 
-	return buff;
+	return bf;
 }
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 4c1c2da..6fabad1 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -133,7 +133,7 @@ struct machine *machines__add(struct rb_root *self, pid_t pid,
 struct machine *machines__find_host(struct rb_root *self);
 struct machine *machines__find(struct rb_root *self, pid_t pid);
 struct machine *machines__findnew(struct rb_root *self, pid_t pid);
-char *machine__mmap_name(struct machine *self, char *buff);
+char *machine__mmap_name(struct machine *self, char *bf, size_t size);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index dc04636..c9c0bdd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1856,7 +1856,7 @@ static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
 out_try_fixup:
 	if (err > 0) {
 		if (kallsyms_filename != NULL) {
-			machine__mmap_name(machine, path);
+			machine__mmap_name(machine, path, sizeof(path));
 			dso__set_long_name(self, strdup(path));
 		}
 		map__fixup_start(map);
@@ -1961,8 +1961,8 @@ struct dso *dso__new_kernel(const char *name)
 static struct dso *dso__new_guest_kernel(struct machine *machine,
 					const char *name)
 {
-	char buff[PATH_MAX];
-	struct dso *self = dso__new(name ?: machine__mmap_name(machine, buff));
+	char bf[PATH_MAX];
+	struct dso *self = dso__new(name ?: machine__mmap_name(machine, bf, sizeof(bf)));
 
 	if (self != NULL) {
 		dso__set_short_name(self, "[guest.kernel]");
-- 
1.6.2.5

