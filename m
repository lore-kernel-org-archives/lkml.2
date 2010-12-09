Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0LIXhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:37:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:56421 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab0LIXhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:37:50 -0500
Date: Thu, 9 Dec 2010 23:37:27 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <20101207124550.528788441@linutronix.de>
References: <20101207124550.528788441@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Dont queue events w/o timestamps
Message-ID: <tip-79a14c1f458d598642bf11f09512c83d33a114e6@git.kernel.org>
Git-Commit-ID: 79a14c1f458d598642bf11f09512c83d33a114e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:37:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79a14c1f458d598642bf11f09512c83d33a114e6
Gitweb:     http://git.kernel.org/tip/79a14c1f458d598642bf11f09512c83d33a114e6
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Dec 2010 12:48:44 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Dec 2010 11:15:38 -0200

perf session: Dont queue events w/o timestamps

If the event has no timestamp assigned then the parse code sets it to
~0ULL which causes the ordering code to enqueue it at the end.

Process it right away.

Reported-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.528788441@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b3b145a..e5d0ed9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -603,7 +603,7 @@ static int perf_session_queue_event(struct perf_session *s, event_t *event,
 	u64 timestamp = data->time;
 	struct sample_queue *new;
 
-	if (!timestamp)
+	if (!timestamp || timestamp == ~0ULL)
 		return -ETIME;
 
 	if (timestamp < s->ordered_samples.last_flush) {
