Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965825Ab2FAWR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:17:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965745Ab2FAWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/15] perf session: Handle endianity swap on sample_id_all header data
Date: Fri,  1 Jun 2012 19:16:34 -0300
Message-Id: <1338588999-32509-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding endianity swapping for event header attached via sample_id_all.

Currently we dont do that and it's causing wrong data to be read when
running report on architecture with different endianity than the record.

The perf is currently able to process 32-bit PPC samples on 32-bit
and 64-bit x86.

Together with other endianity patches, this change fixies perf report
discrepancies on origin and target systems as described in test 1
below, e.g. following perf report diff:

...
      0.12%               ps  [kernel.kallsyms]    [k] clear_page
-     0.12%              awk  bash                 [.] alloc_word_desc
+     0.12%              awk  bash                 [.] yyparse
      0.11%   beah-rhts-task  libpython2.6.so.1.0  [.] 0x5560e
      0.10%             perf  libc-2.12.so         [.] __ctype_toupper_loc
-     0.09%  rhts-test-runne  bash                 [.] maybe_make_export_env
+     0.09%  rhts-test-runne  bash                 [.] 0x385a0
      0.09%               ps  [kernel.kallsyms]    [k] page_fault
...

Note, running following to test perf endianity handling:
test 1)
  - origin system:
    # perf record -a -- sleep 10 (any perf record will do)
    # perf report > report.origin
    # perf archive perf.data

  - copy the perf.data, report.origin and perf.data.tar.bz2
    to a target system and run:
    # tar xjvf perf.data.tar.bz2 -C ~/.debug
    # perf report > report.target
    # diff -u report.origin report.target

  - the diff should produce no output
    (besides some white space stuff and possibly different
     date/TZ output)

test 2)
  - origin system:
    # perf record -ag -fo /tmp/perf.data -- sleep 1
  - mount origin system root to the target system on /mnt/origin
  - target system:
    # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
     --kallsyms /mnt/origin/proc/kallsyms
  - complete perf.data header is displayed

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338380624-7443-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   67 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 04d1e33..2600916 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -454,37 +454,65 @@ void mem_bswap_64(void *src, int byte_size)
 	}
 }
 
-static void perf_event__all64_swap(union perf_event *event)
+static void swap_sample_id_all(union perf_event *event, void *data)
+{
+	void *end = (void *) event + event->header.size;
+	int size = end - data;
+
+	BUG_ON(size % sizeof(u64));
+	mem_bswap_64(data, size);
+}
+
+static void perf_event__all64_swap(union perf_event *event,
+				   bool sample_id_all __used)
 {
 	struct perf_event_header *hdr = &event->header;
 	mem_bswap_64(hdr + 1, event->header.size - sizeof(*hdr));
 }
 
-static void perf_event__comm_swap(union perf_event *event)
+static void perf_event__comm_swap(union perf_event *event, bool sample_id_all)
 {
 	event->comm.pid = bswap_32(event->comm.pid);
 	event->comm.tid = bswap_32(event->comm.tid);
+
+	if (sample_id_all) {
+		void *data = &event->comm.comm;
+
+		data += ALIGN(strlen(data) + 1, sizeof(u64));
+		swap_sample_id_all(event, data);
+	}
 }
 
-static void perf_event__mmap_swap(union perf_event *event)
+static void perf_event__mmap_swap(union perf_event *event,
+				  bool sample_id_all)
 {
 	event->mmap.pid	  = bswap_32(event->mmap.pid);
 	event->mmap.tid	  = bswap_32(event->mmap.tid);
 	event->mmap.start = bswap_64(event->mmap.start);
 	event->mmap.len	  = bswap_64(event->mmap.len);
 	event->mmap.pgoff = bswap_64(event->mmap.pgoff);
+
+	if (sample_id_all) {
+		void *data = &event->mmap.filename;
+
+		data += ALIGN(strlen(data) + 1, sizeof(u64));
+		swap_sample_id_all(event, data);
+	}
 }
 
-static void perf_event__task_swap(union perf_event *event)
+static void perf_event__task_swap(union perf_event *event, bool sample_id_all)
 {
 	event->fork.pid	 = bswap_32(event->fork.pid);
 	event->fork.tid	 = bswap_32(event->fork.tid);
 	event->fork.ppid = bswap_32(event->fork.ppid);
 	event->fork.ptid = bswap_32(event->fork.ptid);
 	event->fork.time = bswap_64(event->fork.time);
+
+	if (sample_id_all)
+		swap_sample_id_all(event, &event->fork + 1);
 }
 
-static void perf_event__read_swap(union perf_event *event)
+static void perf_event__read_swap(union perf_event *event, bool sample_id_all)
 {
 	event->read.pid		 = bswap_32(event->read.pid);
 	event->read.tid		 = bswap_32(event->read.tid);
@@ -492,6 +520,9 @@ static void perf_event__read_swap(union perf_event *event)
 	event->read.time_enabled = bswap_64(event->read.time_enabled);
 	event->read.time_running = bswap_64(event->read.time_running);
 	event->read.id		 = bswap_64(event->read.id);
+
+	if (sample_id_all)
+		swap_sample_id_all(event, &event->read + 1);
 }
 
 static u8 revbyte(u8 b)
@@ -543,7 +574,8 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 	swap_bitfield((u8 *) (&attr->read_format + 1), sizeof(u64));
 }
 
-static void perf_event__hdr_attr_swap(union perf_event *event)
+static void perf_event__hdr_attr_swap(union perf_event *event,
+				      bool sample_id_all __used)
 {
 	size_t size;
 
@@ -554,18 +586,21 @@ static void perf_event__hdr_attr_swap(union perf_event *event)
 	mem_bswap_64(event->attr.id, size);
 }
 
-static void perf_event__event_type_swap(union perf_event *event)
+static void perf_event__event_type_swap(union perf_event *event,
+					bool sample_id_all __used)
 {
 	event->event_type.event_type.event_id =
 		bswap_64(event->event_type.event_type.event_id);
 }
 
-static void perf_event__tracing_data_swap(union perf_event *event)
+static void perf_event__tracing_data_swap(union perf_event *event,
+					  bool sample_id_all __used)
 {
 	event->tracing_data.size = bswap_32(event->tracing_data.size);
 }
 
-typedef void (*perf_event__swap_op)(union perf_event *event);
+typedef void (*perf_event__swap_op)(union perf_event *event,
+				    bool sample_id_all);
 
 static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
@@ -999,6 +1034,15 @@ static int perf_session__process_user_event(struct perf_session *session, union
 	}
 }
 
+static void event_swap(union perf_event *event, bool sample_id_all)
+{
+	perf_event__swap_op swap;
+
+	swap = perf_event__swap_ops[event->header.type];
+	if (swap)
+		swap(event, sample_id_all);
+}
+
 static int perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_tool *tool,
@@ -1007,9 +1051,8 @@ static int perf_session__process_event(struct perf_session *session,
 	struct perf_sample sample;
 	int ret;
 
-	if (session->header.needs_swap &&
-	    perf_event__swap_ops[event->header.type])
-		perf_event__swap_ops[event->header.type](event);
+	if (session->header.needs_swap)
+		event_swap(event, session->sample_id_all);
 
 	if (event->header.type >= PERF_RECORD_HEADER_MAX)
 		return -EINVAL;
-- 
1.7.1

