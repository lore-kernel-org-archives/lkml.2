Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab0HEIB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:46060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915Ab0HEIBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:01:25 -0400
Date: Thu, 5 Aug 2010 08:01:05 GMT
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20100802123851.GD22812@linux.vnet.ibm.com>
References: <20100802123851.GD22812@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: expose event__process function
Message-ID: <tip-b83f920e179101a54721e5ab1d6c3edfb9d4bcbb@git.kernel.org>
Git-Commit-ID: b83f920e179101a54721e5ab1d6c3edfb9d4bcbb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 08:01:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b83f920e179101a54721e5ab1d6c3edfb9d4bcbb
Gitweb:     http://git.kernel.org/tip/b83f920e179101a54721e5ab1d6c3edfb9d4bcbb
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Mon, 2 Aug 2010 18:08:51 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Aug 2010 12:41:23 -0300

perf: expose event__process function

The event__process function is useful in processing /proc/<pid>/maps.  All of
the functions that are called from event__process are defined in util/event.c.
Though its defined in builtin-top.c, it could be reused for perf probe for
uprobes. Hence moving it to util/event.c and exporting the function.

LKML-Reference: <20100802123851.GD22812@linux.vnet.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index db8a1d4..dab9e75 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -548,6 +548,26 @@ int event__process_task(event_t *self, struct perf_session *session)
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
index 887ee63bb..8e790da 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -154,6 +154,7 @@ int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
 int event__process_mmap(event_t *self, struct perf_session *session);
 int event__process_task(event_t *self, struct perf_session *session);
+int event__process(event_t *event, struct perf_session *session);
 
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
