Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab0E1KJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:09:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:58590 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0E1KJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:09:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=Zpqeu9GVDFGcq/7P2aXQT5ZX1Oeaj++Y4UkZHNIic41gbRc7FrZavVb7qTYJ/VTho
	H0wwPrrF+xwxX+qk3F5jA==
Message-ID: <4bff964c.e88cd80a.3106.7d31@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 28 May 2010 12:08:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, tzanussi@gmail.com
Subject: [PATCH] perf: make perf report -D print sampled CPU
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to know on which CPU a sample was captured on.
The information is captured with perf record -R but it was
not printed out by perf report -D. This patch adds this.

When -R is not used, cpu is set to -1to indicate that
the CPU is unknown (it is not captured).

Signed-off-by: Stephane Eranian <eranian@google.com>

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
