Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab0FBUlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:41:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:56077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab0FBUko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:40:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf report: Make -D print sampled CPU
Date: Wed,  2 Jun 2010 17:40:12 -0300
Message-Id: <1275511215-25703-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275511215-25703-1-git-send-email-acme@infradead.org>
References: <1275511215-25703-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

It is useful to know on which CPU a sample was captured on.
The information is captured with perf record -R but it was
not printed out by perf report -D. This patch adds this.

When -R is not used, cpu is set to -1to indicate that
the CPU is unknown (it is not captured).

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4bff964c.e88cd80a.3106.7d31@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 +++--
 tools/perf/util/event.c     |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3592057..207da18 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -157,8 +157,9 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-		    data.pid, data.tid, data.ip, data.period);
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld cpu:%d\n",
+		    event->header.misc, data.pid, data.tid, data.ip,
+		    data.period, data.cpu);
 
 	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
 		unsigned int i;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 50771b5..58cb96b 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -770,7 +770,8 @@ int event__parse_sample(event_t *event, u64 type, struct sample_data *data)
 		u32 *p = (u32 *)array;
 		data->cpu = *p;
 		array++;
-	}
+	} else
+		data->cpu = -1;
 
 	if (type & PERF_SAMPLE_PERIOD) {
 		data->period = *array;
-- 
1.6.2.5

