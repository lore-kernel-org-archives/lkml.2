Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0HBMlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:41:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43785 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0HBMlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:41:11 -0400
Date: Mon, 2 Aug 2010 18:08:51 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] perf: expose event__process function
Message-ID: <20100802123851.GD22812@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
 <20100730191903.GD12166@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100730191903.GD12166@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event__process is useful in processing /proc/<pid>/maps.
All of the functions that are called from event__process are defined
in util/event.c. Though its defined in builtin-top.c, it could be
reused for perf probe for uprobes. Hence moving it to util/event.c
and exporting the function.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/builtin-top.c |   20 --------------------
 tools/perf/util/event.c  |   20 ++++++++++++++++++++
 tools/perf/util/event.h  |    1 +
 3 files changed, 21 insertions(+), 20 deletions(-)


diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1e8e92e..b513e40 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1082,26 +1082,6 @@ static void event__process_sample(const event_t *self,
 	}
 }
 
-static int event__process(event_t *event, struct perf_session *session)
-{
-	switch (event->header.type) {
-	case PERF_RECORD_COMM:
-		event__process_comm(event, session);
-		break;
-	case PERF_RECORD_MMAP:
-		event__process_mmap(event, session);
-		break;
-	case PERF_RECORD_FORK:
-	case PERF_RECORD_EXIT:
-		event__process_task(event, session);
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 struct mmap_data {
 	int			counter;
 	void			*base;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6b0db55..08b6424 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -554,6 +554,26 @@ int event__process_task(event_t *self, struct perf_session *session)
 	return 0;
 }
 
+int event__process(event_t *event, struct perf_session *session)
+{
+	switch (event->header.type) {
+	case PERF_RECORD_COMM:
+		event__process_comm(event, session);
+		break;
+	case PERF_RECORD_MMAP:
+		event__process_mmap(event, session);
+		break;
+	case PERF_RECORD_FORK:
+	case PERF_RECORD_EXIT:
+		event__process_task(event, session);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 void thread__find_addr_map(struct thread *self,
 			   struct perf_session *session, u8 cpumode,
 			   enum map_type type, pid_t pid, u64 addr,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 887ee63..8e790da 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -154,6 +154,7 @@ int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
 int event__process_mmap(event_t *self, struct perf_session *session);
 int event__process_task(event_t *self, struct perf_session *session);
+int event__process(event_t *event, struct perf_session *session);
 
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
