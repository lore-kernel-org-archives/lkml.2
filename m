Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2FSPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:50:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab2FSPuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:50:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 18/23] perf, tool: Support user regs and stack in sample parsing
Date: Tue, 19 Jun 2012 17:48:09 +0200
Message-Id: <1340120894-9465-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding following info to be parsed out of the event sample:
 - user register set
 - user stack dump

Both are global and specific to all events within the session.
This info will be used in the unwind patches comming in shortly.

Adding simple output printout (report -D) for both register and
stack dumps.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c |    4 ++--
 tools/perf/util/event.h   |   16 +++++++++++++++-
 tools/perf/util/evlist.c  |    8 ++++++++
 tools/perf/util/evlist.h  |    1 +
 tools/perf/util/evsel.c   |   29 ++++++++++++++++++++++++++++-
 tools/perf/util/header.c  |    2 ++
 tools/perf/util/python.c  |    3 ++-
 tools/perf/util/session.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |    8 ++++++--
 9 files changed, 107 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5a8727c..8d3ed01 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -564,7 +564,7 @@ static int test__basic_mmap(void)
 		}
 
 		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
-					       false, &sample, false);
+					       false, 0, &sample, false);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
 			goto out_munmap;
@@ -790,7 +790,7 @@ static int test__PERF_RECORD(void)
 
 				err = perf_event__parse_sample(event, sample_type,
 							       sample_size, true,
-							       &sample, false);
+							       0, &sample, false);
 				if (err < 0) {
 					if (verbose)
 						perf_event__fprintf(event, stderr);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1b19728..ed978eb 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -69,6 +69,16 @@ struct sample_event {
 	u64 array[];
 };
 
+struct regs_dump {
+	u64 *regs;
+};
+
+struct stack_dump {
+	u16 offset;
+	u64 size;
+	char *data;
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -82,6 +92,8 @@ struct perf_sample {
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
+	struct regs_dump  user_regs;
+	struct stack_dump user_stack;
 };
 
 #define BUILD_ID_SIZE 20
@@ -199,7 +211,9 @@ const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *sample, bool swapped);
+			     u64 sample_regs_user, struct perf_sample *data,
+			     bool swapped);
+
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7400fb3..91dc8c2 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -689,6 +689,14 @@ bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
 	return true;
 }
 
+u64 perf_evlist__sample_regs_user(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_regs_user;
+}
+
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
 {
 	struct perf_evsel *first;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 989bee9..ed1deab 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -121,6 +121,7 @@ u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_regs_user(const struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9f6cebd..6b90214 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -8,6 +8,7 @@
  */
 
 #include <byteswap.h>
+#include <linux/bitops.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -559,7 +560,8 @@ static bool sample_overlap(const union perf_event *event,
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *data, bool swapped)
+			     u64 sample_regs_user, struct perf_sample *data,
+			     bool swapped)
 {
 	const u64 *array;
 
@@ -697,6 +699,31 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		sz /= sizeof(u64);
 		array += sz;
 	}
+
+	if (type & PERF_SAMPLE_REGS_USER) {
+		/* First u64 tells us if we have any regs in sample. */
+		u64 avail = *array++;
+
+		if (avail) {
+			data->user_regs.regs = (u64 *)array;
+			array += hweight_long(sample_regs_user);
+		}
+	}
+
+	if (type & PERF_SAMPLE_STACK_USER) {
+		u64 size = *array++;
+
+		data->user_stack.offset = ((char*)(array - 1) - (char*) event);
+
+		if (!size) {
+			data->user_stack.size = 0;
+		} else {
+			data->user_stack.data = (char *)array;
+			array += size / sizeof(*array);
+			data->user_stack.size = *array;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 997b075..a377b99 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1815,6 +1815,8 @@ static const int attr_file_abi_sizes[] = {
 	[0] = PERF_ATTR_SIZE_VER0,
 	[1] = PERF_ATTR_SIZE_VER1,
 	[2] = PERF_ATTR_SIZE_VER2,
+	[3] = PERF_ATTR_SIZE_VER3,
+	[4] = PERF_ATTR_SIZE_VER4,
 	0,
 };
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e03b58a..a35d9c9 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -807,7 +807,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
 		err = perf_event__parse_sample(event, first->attr.sample_type,
 					       perf_evsel__sample_size(first),
-					       sample_id_all, &pevent->sample, false);
+					       sample_id_all, 0,
+					       &pevent->sample, false);
 		if (err)
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 680fc15..455d062 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "vdso.h"
+#include "perf_regs.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -87,6 +88,7 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 	self->host_machine.id_hdr_size = self->id_hdr_size;
+	self->sample_regs_user = perf_evlist__sample_regs_user(self->evlist);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
@@ -861,6 +863,41 @@ static void branch_stack__printf(struct perf_sample *sample)
 			sample->branch_stack->entries[i].to);
 }
 
+static void regs_dump__printf(u64 mask, u64 *regs)
+{
+	int i = 0, rid = 0;
+
+	do {
+		u64 val;
+
+		if (mask & 1) {
+			val = regs[i++];
+			printf(".... %-5s 0x%" PRIx64 "\n",
+			       perf_reg_name(rid), val);
+		}
+
+		rid++;
+		mask >>= 1;
+
+	} while (mask);
+}
+
+static void regs_user__printf(struct perf_sample *sample, u64 mask)
+{
+	struct regs_dump *user_regs = &sample->user_regs;
+
+	if (user_regs->regs) {
+		printf("... user regs: mask 0x%" PRIx64 "\n", mask);
+		regs_dump__printf(mask, user_regs->regs);
+	}
+}
+
+static void stack_user__printf(struct stack_dump *dump)
+{
+	printf("... ustack: size %" PRIu64 ", offset 0x%x\n",
+	       dump->size, dump->offset);
+}
+
 static void perf_session__print_tstamp(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_sample *sample)
@@ -911,6 +948,12 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 
 	if (session->sample_type & PERF_SAMPLE_BRANCH_STACK)
 		branch_stack__printf(sample);
+
+	if (session->sample_type & PERF_SAMPLE_REGS_USER)
+		regs_user__printf(sample, session->sample_regs_user);
+
+	if (session->sample_type & PERF_SAMPLE_STACK_USER)
+		stack_user__printf(&sample->user_stack);
 }
 
 static struct machine *
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index c71a1a7..f5fea51 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -42,6 +42,7 @@ struct perf_session {
 	struct hists		hists;
 	u64			sample_type;
 	int			sample_size;
+	u64			sample_regs_user;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -133,9 +134,12 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					     const union perf_event *event,
 					     struct perf_sample *sample)
 {
-	return perf_event__parse_sample(event, session->sample_type,
+	return perf_event__parse_sample(event,
+					session->sample_type,
 					session->sample_size,
-					session->sample_id_all, sample,
+					session->sample_id_all,
+					session->sample_regs_user,
+					sample,
 					session->header.needs_swap);
 }
 
-- 
1.7.7.6

