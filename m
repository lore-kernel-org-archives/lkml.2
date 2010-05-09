Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0EIUog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:44:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34161 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0EIUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=kqyRGqp89ljYNOzotmb7inY7JO/z8lTNcGcjDm+dz2wAjaDgIyyVuQTzjjvGoygCK1
         jBaYLhIHDQ34ltKaMAFpmcDUEf31gVZcIhwAYF372UqOg1cXOurPhrmpqCBCAdxTeGV6
         QUXlFYGYBaVOOyjTGXV53kPvI+3K4qDW7E97w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/10] perf/live-mode: Handle payload-less events
Date: Sun,  9 May 2010 22:43:37 +0200
Message-Id: <1273437818-8130-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

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
-- 
1.6.2.3

