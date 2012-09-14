Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2INF5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:57:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2INF5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:57:46 -0400
Date: Thu, 13 Sep 2012 22:57:23 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@gmail.com>
Message-ID: <tip-9ac3e487f0eeef0fa058d72da7681398cc052ee9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        rostedt@goodmis.org, irina.tirdea@intel.com, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, irina.tirdea@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1347315303-29906-5-git-send-email-irina.tirdea@intel.com>
References: <1347315303-29906-5-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  fix ALIGN redefinition in system headers
Git-Commit-ID: 9ac3e487f0eeef0fa058d72da7681398cc052ee9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 22:57:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ac3e487f0eeef0fa058d72da7681398cc052ee9
Gitweb:     http://git.kernel.org/tip/9ac3e487f0eeef0fa058d72da7681398cc052ee9
Author:     Irina Tirdea <irina.tirdea@gmail.com>
AuthorDate: Tue, 11 Sep 2012 01:15:01 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 11:48:30 -0300

perf tools: fix ALIGN redefinition in system headers

On some systems (e.g. Android), ALIGN is defined in system headers as
ALIGN(p).  The definition of ALIGN used in perf takes 2 parameters:
ALIGN(x,a).  This leads to redefinition conflicts.

Redefinition error on Android:
In file included from util/include/linux/list.h:1:0,
from util/callchain.h:5,
from util/hist.h:6,
from util/session.h:4,
from util/build-id.h:4,
from util/annotate.c:11:
util/include/linux/kernel.h:11:0: error: "ALIGN" redefined [-Werror]
bionic/libc/include/sys/param.h:38:0: note: this is the location of
the previous definition

Conflics with system defined ALIGN in Android:
util/event.c: In function 'perf_event__synthesize_comm':
util/event.c:115:32: error: macro "ALIGN" passed 2 arguments, but takes just 1
util/event.c:115:9: error: 'ALIGN' undeclared (first use in this function)
util/event.c:115:9: note: each undeclared identifier is reported only once for
each function it appears in

In order to avoid this redefinition, ALIGN is renamed to PERF_ALIGN.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347315303-29906-5-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c                |   10 +++++-----
 tools/perf/util/event.h                |    2 +-
 tools/perf/util/header.c               |   16 ++++++++--------
 tools/perf/util/include/linux/kernel.h |    4 ++--
 tools/perf/util/session.c              |    4 ++--
 tools/perf/util/symbol.c               |    2 +-
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 84ff6f16..f7f4805 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -112,7 +112,7 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 	event->comm.header.type = PERF_RECORD_COMM;
 
 	size = strlen(event->comm.comm) + 1;
-	size = ALIGN(size, sizeof(u64));
+	size = PERF_ALIGN(size, sizeof(u64));
 	memset(event->comm.comm + size, 0, machine->id_hdr_size);
 	event->comm.header.size = (sizeof(event->comm) -
 				(sizeof(event->comm.comm) - size) +
@@ -145,7 +145,7 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 					 sizeof(event->comm.comm));
 
 		size = strlen(event->comm.comm) + 1;
-		size = ALIGN(size, sizeof(u64));
+		size = PERF_ALIGN(size, sizeof(u64));
 		memset(event->comm.comm + size, 0, machine->id_hdr_size);
 		event->comm.header.size = (sizeof(event->comm) -
 					  (sizeof(event->comm.comm) - size) +
@@ -228,7 +228,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
 			memcpy(event->mmap.filename, execname, size);
-			size = ALIGN(size, sizeof(u64));
+			size = PERF_ALIGN(size, sizeof(u64));
 			event->mmap.len -= event->mmap.start;
 			event->mmap.header.size = (sizeof(event->mmap) -
 					        (sizeof(event->mmap.filename) - size));
@@ -282,7 +282,7 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 		if (pos->dso->kernel)
 			continue;
 
-		size = ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
+		size = PERF_ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
 		event->mmap.header.type = PERF_RECORD_MMAP;
 		event->mmap.header.size = (sizeof(event->mmap) -
 				        (sizeof(event->mmap.filename) - size));
@@ -494,7 +494,7 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 	map = machine->vmlinux_maps[MAP__FUNCTION];
 	size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
 			"%s%s", mmap_name, symbol_name) + 1;
-	size = ALIGN(size, sizeof(u64));
+	size = PERF_ALIGN(size, sizeof(u64));
 	event->mmap.header.type = PERF_RECORD_MMAP;
 	event->mmap.header.size = (sizeof(event->mmap) -
 			(sizeof(event->mmap.filename) - size) + machine->id_hdr_size);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0e088d0..21b99e7 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -101,7 +101,7 @@ struct perf_sample {
 struct build_id_event {
 	struct perf_event_header header;
 	pid_t			 pid;
-	u8			 build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
+	u8			 build_id[PERF_ALIGN(BUILD_ID_SIZE, sizeof(u64))];
 	char			 filename[];
 };
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d07bc13..974e758 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -129,7 +129,7 @@ static int do_write_string(int fd, const char *str)
 	int ret;
 
 	olen = strlen(str) + 1;
-	len = ALIGN(olen, NAME_ALIGN);
+	len = PERF_ALIGN(olen, NAME_ALIGN);
 
 	/* write len, incl. \0 */
 	ret = do_write(fd, &len, sizeof(len));
@@ -220,7 +220,7 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 		if (!pos->hit)
 			continue;
 		len = pos->long_name_len + 1;
-		len = ALIGN(len, NAME_ALIGN);
+		len = PERF_ALIGN(len, NAME_ALIGN);
 		memset(&b, 0, sizeof(b));
 		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
 		b.pid = pid;
@@ -1532,7 +1532,7 @@ static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
 	struct perf_session *session = container_of(header, struct perf_session, header);
 	struct {
 		struct perf_event_header   header;
-		u8			   build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
+		u8			   build_id[PERF_ALIGN(BUILD_ID_SIZE, sizeof(u64))];
 		char			   filename[0];
 	} old_bev;
 	struct build_id_event bev;
@@ -2439,7 +2439,7 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 	int err;
 
 	size = sizeof(struct perf_event_attr);
-	size = ALIGN(size, sizeof(u64));
+	size = PERF_ALIGN(size, sizeof(u64));
 	size += sizeof(struct perf_event_header);
 	size += ids * sizeof(u64);
 
@@ -2537,7 +2537,7 @@ int perf_event__synthesize_event_type(struct perf_tool *tool,
 
 	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
 	size = strlen(ev.event_type.event_type.name);
-	size = ALIGN(size, sizeof(u64));
+	size = PERF_ALIGN(size, sizeof(u64));
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
 
@@ -2606,7 +2606,7 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 
 	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
 	size = tdata->size;
-	aligned_size = ALIGN(size, sizeof(u64));
+	aligned_size = PERF_ALIGN(size, sizeof(u64));
 	padding = aligned_size - size;
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
 	ev.tracing_data.size = aligned_size;
@@ -2637,7 +2637,7 @@ int perf_event__process_tracing_data(union perf_event *event,
 
 	size_read = trace_report(session->fd, &session->pevent,
 				 session->repipe);
-	padding = ALIGN(size_read, sizeof(u64)) - size_read;
+	padding = PERF_ALIGN(size_read, sizeof(u64)) - size_read;
 
 	if (read(session->fd, buf, padding) < 0)
 		die("reading input file");
@@ -2671,7 +2671,7 @@ int perf_event__synthesize_build_id(struct perf_tool *tool,
 	memset(&ev, 0, sizeof(ev));
 
 	len = pos->long_name_len + 1;
-	len = ALIGN(len, NAME_ALIGN);
+	len = PERF_ALIGN(len, NAME_ALIGN);
 	memcpy(&ev.build_id.build_id, pos->build_id, sizeof(pos->build_id));
 	ev.build_id.header.type = PERF_RECORD_HEADER_BUILD_ID;
 	ev.build_id.header.misc = misc;
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index a978f26..d8c927c 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -8,8 +8,8 @@
 
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define PERF_ALIGN(x, a)	__PERF_ALIGN_MASK(x, (typeof(x))(a)-1)
+#define __PERF_ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
 
 #ifndef offsetof
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9453758..3806ea4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -527,7 +527,7 @@ static void perf_event__comm_swap(union perf_event *event, bool sample_id_all)
 	if (sample_id_all) {
 		void *data = &event->comm.comm;
 
-		data += ALIGN(strlen(data) + 1, sizeof(u64));
+		data += PERF_ALIGN(strlen(data) + 1, sizeof(u64));
 		swap_sample_id_all(event, data);
 	}
 }
@@ -544,7 +544,7 @@ static void perf_event__mmap_swap(union perf_event *event,
 	if (sample_id_all) {
 		void *data = &event->mmap.filename;
 
-		data += ALIGN(strlen(data) + 1, sizeof(u64));
+		data += PERF_ALIGN(strlen(data) + 1, sizeof(u64));
 		swap_sample_id_all(event, data);
 	}
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 753699a..ba85d4f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1991,7 +1991,7 @@ int symbol__init(void)
 	if (symbol_conf.initialized)
 		return 0;
 
-	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
+	symbol_conf.priv_size = PERF_ALIGN(symbol_conf.priv_size, sizeof(u64));
 
 	symbol__elf_init();
 
