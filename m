Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2AMOrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:47:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34772 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab2AMOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:47:35 -0500
Date: Fri, 13 Jan 2012 15:47:31 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com
Subject: [PATCH] perf: fix broken perf inject -b
Message-ID: <20120113144731.GA5458@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf inject -b was broken. It would not inject any build_ids
into the stream. Furthermore, it would strip samples from the
stream.

The reason was a missing initialization of the event attribute
structures. The perf_tool.tool.attr() callback was pointing to
a simple repipe. But there was no initialization of internal data
structures to keep track of events and event ids. That later caused
event id lookups to fail, and samples would get dropped.

The patch simply adds back the call to perf_event__process_attr()
to initialize the evlist structure. Build_ids are again injected.
The PID is also inject for PERF_RECORD_HEADER_BUILD_ID.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 09c1061..f38f370 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -60,6 +60,11 @@ static int perf_event__repipe_tracing_data_synth(union perf_event *event,
 static int perf_event__repipe_attr(union perf_event *event,
 				   struct perf_evlist **pevlist __used)
 {
+	int ret;
+	ret = perf_event__process_attr(event, pevlist);
+	if (ret)
+		return ret;
+
 	return perf_event__repipe_synth(NULL, event, NULL);
 }
 
@@ -173,6 +178,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 		       event->header.type);
 		goto repipe;
 	}
+	machine->pid = event->ip.pid;
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
 			      event->ip.ip, &al);
