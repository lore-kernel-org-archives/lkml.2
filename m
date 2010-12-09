Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0LIXif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:38:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:56464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab0LIXid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:38:33 -0500
Date: Thu, 9 Dec 2010 23:38:09 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124550.725128545@linutronix.de>
References: <20101207124550.725128545@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Store file offset in sample_queue
Message-ID: <tip-e4c2df132fef60a28b851abc1859a531e64f350c@git.kernel.org>
Git-Commit-ID: e4c2df132fef60a28b851abc1859a531e64f350c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:38:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4c2df132fef60a28b851abc1859a531e64f350c
Gitweb:     http://git.kernel.org/tip/e4c2df132fef60a28b851abc1859a531e64f350c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:48:50 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 12:09:18 -0200

perf session: Store file offset in sample_queue

Preparatory patch for ordered output of perf report -D.

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.725128545@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 12761d5..a433954 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -444,6 +444,7 @@ static event__swap_op event__swap_ops[] = {
 
 struct sample_queue {
 	u64			timestamp;
+	u64			file_offset;
 	event_t			*event;
 	struct list_head	list;
 };
@@ -596,7 +597,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
 static int perf_session_queue_event(struct perf_session *s, event_t *event,
-				    struct sample_data *data)
+				    struct sample_data *data, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *sc = &os->sample_cache;
@@ -628,6 +629,7 @@ static int perf_session_queue_event(struct perf_session *s, event_t *event,
 	}
 
 	new->timestamp = timestamp;
+	new->file_offset = file_offset;
 	new->event = event;
 
 	__queue_event(new, s);
@@ -780,7 +782,8 @@ static int perf_session__process_event(struct perf_session *session,
 	}
 
 	if (ops->ordered_samples) {
-		ret = perf_session_queue_event(session, event, &sample);
+		ret = perf_session_queue_event(session, event, &sample,
+					       file_offset);
 		if (ret != -ETIME)
 			return ret;
 	}
