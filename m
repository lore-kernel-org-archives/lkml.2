Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2AaNZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:25:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55203 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2AaNZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:25:17 -0500
Date: Tue, 31 Jan 2012 05:24:54 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-d8d9c282a1abbe2baf6d22f959e6adf4c90629bf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120120094912.GA4882@quad>
References: <20120120094912.GA4882@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix strlen()
  bug in perf_event__synthesize_event_type()
Git-Commit-ID: d8d9c282a1abbe2baf6d22f959e6adf4c90629bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:24:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d9c282a1abbe2baf6d22f959e6adf4c90629bf
Gitweb:     http://git.kernel.org/tip/d8d9c282a1abbe2baf6d22f959e6adf4c90629bf
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 20 Jan 2012 10:49:12 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 22:29:12 -0200

perf tools: Fix strlen() bug in perf_event__synthesize_event_type()

The event_type record has a max length for the event name.

It's called MAX_EVENT_NAME.

The name may be truncated to fit the max length. But the header.size still
reflects the original name length. If that length is > MAX_EVENT_NAME, then the
header.size field is bogus. Fix this by using the length of the name after the
potential truncation.

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120120094912.GA4882@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3e7e0b0..ecd7f4d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2105,7 +2105,7 @@ int perf_event__synthesize_event_type(struct perf_tool *tool,
 	strncpy(ev.event_type.event_type.name, name, MAX_EVENT_NAME - 1);
 
 	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
-	size = strlen(name);
+	size = strlen(ev.event_type.event_type.name);
 	size = ALIGN(size, sizeof(u64));
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
