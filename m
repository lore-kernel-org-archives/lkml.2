Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0EJHWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 03:22:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:53947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab0EJHV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 03:21:59 -0400
Date: Mon, 10 May 2010 07:21:33 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1273038527.6383.51.camel@tropicana>
References: <1273038527.6383.51.camel@tropicana>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/live-mode: Handle payload-less events
Message-ID: <tip-794e43b56c18b95fc9776c914a2659e7d558a352@git.kernel.org>
Git-Commit-ID: 794e43b56c18b95fc9776c914a2659e7d558a352
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 07:21:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  794e43b56c18b95fc9776c914a2659e7d558a352
Gitweb:     http://git.kernel.org/tip/794e43b56c18b95fc9776c914a2659e7d558a352
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 5 May 2010 00:27:40 -0500
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 9 May 2010 13:49:52 +0200

perf/live-mode: Handle payload-less events

Some events, such as the PERF_RECORD_FINISHED_ROUND event consist of
only an event header and no data.  In this case, a 0-length payload
will be read, and the 0 return value will be wrongly interpreted as an
'unexpected end of event stream'.

This patch allows for proper handling of data-less events by skipping
0-length reads.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <1273038527.6383.51.camel@tropicana>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/session.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9401909..00ab298 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -696,15 +696,18 @@ more:
 	p = &event;
 	p += sizeof(struct perf_event_header);
 
-	err = do_read(self->fd, p, size - sizeof(struct perf_event_header));
-	if (err <= 0) {
-		if (err == 0) {
-			pr_err("unexpected end of event stream\n");
-			goto done;
-		}
+	if (size - sizeof(struct perf_event_header)) {
+		err = do_read(self->fd, p,
+			      size - sizeof(struct perf_event_header));
+		if (err <= 0) {
+			if (err == 0) {
+				pr_err("unexpected end of event stream\n");
+				goto done;
+			}
 
-		pr_err("failed to read event data\n");
-		goto out_err;
+			pr_err("failed to read event data\n");
+			goto out_err;
+		}
 	}
 
 	if (size == 0 ||
