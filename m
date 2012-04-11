Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2DKJDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:03:24 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35029 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2DKJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:03:21 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, dsahern@gmail.com,
        namhyung.kim@lge.com
Subject: [PATCH 1/5] perf inject: fix broken perf inject -b
Date: Wed, 11 Apr 2012 11:01:25 +0200
Message-Id: <1334134889-20312-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1334134889-20312-1-git-send-email-eranian@google.com>
References: <1334134889-20312-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf inject -b was broken. It would not inject any build_id
into the stream. Furthermore, it would strip samples from the
stream.

The reason was a missing initialization of the event attribute
structure. The perf_tool.tool.attr() callback was pointing to
a simple repipe. But there was no initialization of the internal
data structures to keep track of events and event ids. That later
caused event id lookups to fail, and sample would get removed.

The patch simply adds back the call to perf_event__process_attr()
to initialize the evlist structure and now build_ids are again
injected.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-inject.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 09c1061..3beab48 100644
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
 
-- 
1.7.4.1

