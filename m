Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2HUPyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:54:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2HUPyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:54:31 -0400
Date: Tue, 21 Aug 2012 08:54:00 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0f6a30150ca2e0cf4f893e7173d61434a3c02e0e@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
In-Reply-To: <1344345647-11536-11-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-11-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Support user regs and stack in sample parsing
Git-Commit-ID: 0f6a30150ca2e0cf4f893e7173d61434a3c02e0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:54:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f6a30150ca2e0cf4f893e7173d61434a3c02e0e
Gitweb:     http://git.kernel.org/tip/0f6a30150ca2e0cf4f893e7173d61434a3c02e0e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Aug 2012 15:20:45 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 16:47:02 -0300

perf tools: Support user regs and stack in sample parsing

Adding following info to be parsed out of the event sample:
 - user register set
 - user stack dump

Both are global and specific to all events within the session.
This info will be used in the unwind patches coming in shortly.

Adding simple output printout (report -D) for both register and
stack dumps.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1344345647-11536-11-git-send-email-jolsa@redhat.com
[ Use evsel->attr.sample_regs_user ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h   |   12 ++++++++++++
 tools/perf/util/evsel.c   |   28 ++++++++++++++++++++++++++++
 tools/perf/util/header.c  |    2 ++
 tools/perf/util/session.c |   41 ++++++++++++++++++++++++++++++++++++++---
 4 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d84870b..0e088d0 100644
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
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2eaae14..a2da682 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -8,6 +8,7 @@
  */
 
 #include <byteswap.h>
+#include <linux/bitops.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -733,6 +734,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *data, bool swapped)
 {
 	u64 type = evsel->attr.sample_type;
+	u64 regs_user = evsel->attr.sample_regs_user;
 	const u64 *array;
 
 	/*
@@ -869,6 +871,32 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
+			array += hweight_long(regs_user);
+		}
+	}
+
+	if (type & PERF_SAMPLE_STACK_USER) {
+		u64 size = *array++;
+
+		data->user_stack.offset = ((char *)(array - 1)
+					  - (char *) event);
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
index dd5a53c..7e7d34f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1830,6 +1830,8 @@ static const int attr_file_abi_sizes[] = {
 	[0] = PERF_ATTR_SIZE_VER0,
 	[1] = PERF_ATTR_SIZE_VER1,
 	[2] = PERF_ATTR_SIZE_VER2,
+	[3] = PERF_ATTR_SIZE_VER3,
+	[4] = PERF_ATTR_SIZE_VER4,
 	0,
 };
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2437fb0..c9ed7e3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "event-parse.h"
+#include "perf_regs.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -860,6 +861,34 @@ static void branch_stack__printf(struct perf_sample *sample)
 			sample->branch_stack->entries[i].to);
 }
 
+static void regs_dump__printf(u64 mask, u64 *regs)
+{
+	unsigned rid, i = 0;
+
+	for_each_set_bit(rid, (unsigned long *) &mask, sizeof(mask) * 8) {
+		u64 val = regs[i++];
+
+		printf(".... %-5s 0x%" PRIx64 "\n",
+		       perf_reg_name(rid), val);
+	}
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
@@ -897,7 +926,7 @@ static void dump_event(struct perf_session *session, union perf_event *event,
 	       event->header.size, perf_event__name(event->header.type));
 }
 
-static void dump_sample(struct perf_session *session, union perf_event *event,
+static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 			struct perf_sample *sample)
 {
 	u64 sample_type;
@@ -909,13 +938,19 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 	       event->header.misc, sample->pid, sample->tid, sample->ip,
 	       sample->period, sample->addr);
 
-	sample_type = perf_evlist__sample_type(session->evlist);
+	sample_type = evsel->attr.sample_type;
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN)
 		callchain__printf(sample);
 
 	if (sample_type & PERF_SAMPLE_BRANCH_STACK)
 		branch_stack__printf(sample);
+
+	if (sample_type & PERF_SAMPLE_REGS_USER)
+		regs_user__printf(sample, evsel->attr.sample_regs_user);
+
+	if (sample_type & PERF_SAMPLE_STACK_USER)
+		stack_user__printf(&sample->user_stack);
 }
 
 static struct machine *
@@ -973,7 +1008,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		dump_sample(session, event, sample);
+		dump_sample(evsel, event, sample);
 		if (evsel == NULL) {
 			++session->hists.stats.nr_unknown_id;
 			return 0;
