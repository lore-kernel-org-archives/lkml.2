Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab2EWP31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:29:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40979 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965236Ab2EWP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:29:24 -0400
Date: Wed, 23 May 2012 08:29:01 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-1a1ed1ba6778a5bc5702cebe276ab080a0b78115@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1337081295-10303-2-git-send-email-eranian@google.com>
References: <1337081295-10303-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject: Fix broken perf inject -b
Git-Commit-ID: 1a1ed1ba6778a5bc5702cebe276ab080a0b78115
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:29:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a1ed1ba6778a5bc5702cebe276ab080a0b78115
Gitweb:     http://git.kernel.org/tip/1a1ed1ba6778a5bc5702cebe276ab080a0b78115
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 15 May 2012 13:28:11 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:59:28 -0300

perf inject: Fix broken perf inject -b

perf inject -b was broken. It would not inject any build_id into the
stream. Furthermore, it would strip samples from the stream.

The reason was a missing initialization of the event attribute
structure. The perf_tool.tool.attr() callback was pointing to a simple
repipe. But there was no initialization of the internal data structures
to keep track of events and event ids. That later caused event id
lookups to fail, and sample would get removed.

The patch simply adds back the call to perf_event__process_attr() to
initialize the evlist structure and now build_ids are again injected.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1337081295-10303-2-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
 
