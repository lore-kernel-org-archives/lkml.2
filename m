Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0DXCFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:05:48 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61498 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0DXCFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=BbvEWbpKqRiV2NFjVWwVThxL2etyMqSbkM3AeBVWr3hB66dOnV4pZkhDnA55S8k0/8
         cTXEbj+pywV0dg0z5d7DhzdwKTrOwq9STMg9GJJ9wZlFv27WvAdLAkcNn0nz5xjoCQ0F
         p5lI+bjJMMAPQ98vlIElfbXGTlxxf9kWNZ69U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/9] perf: Fix initialization bug in parse_single_tracepoint_event()
Date: Sat, 24 Apr 2010 04:05:35 +0200
Message-Id: <1272074742-3654-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The parse_single_tracepoint_event() was setting some attributes
before it validated the event was indeed a tracepoint event. This
caused problems with other initialization routines like in the
builtin-top.c module whereby sample_period is not set if not 0.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <4bcf232b.698fd80a.6fbe.ffffb737@mx.google.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/parse-events.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3b4ec67..600d327 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -418,12 +418,6 @@ parse_single_tracepoint_event(char *sys_name,
 	u64 id;
 	int fd;
 
-	attr->sample_type |= PERF_SAMPLE_RAW;
-	attr->sample_type |= PERF_SAMPLE_TIME;
-	attr->sample_type |= PERF_SAMPLE_CPU;
-
-	attr->sample_period = 1;
-
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
 		 sys_name, evt_name);
 
@@ -442,6 +436,13 @@ parse_single_tracepoint_event(char *sys_name,
 	attr->type = PERF_TYPE_TRACEPOINT;
 	*strp = evt_name + evt_length;
 
+	attr->sample_type |= PERF_SAMPLE_RAW;
+	attr->sample_type |= PERF_SAMPLE_TIME;
+	attr->sample_type |= PERF_SAMPLE_CPU;
+
+	attr->sample_period = 1;
+
+
 	return EVT_HANDLED;
 }
 
-- 
1.6.2.3

