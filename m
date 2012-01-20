Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2ATJtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 04:49:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51519 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2ATJtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:49:15 -0500
Date: Fri, 20 Jan 2012 10:49:12 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH] perf: fix strlen() bug in
 perf_event__synthesize_event_type() (repost)
Message-ID: <20120120094912.GA4882@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[repost because of typo in Ingo's email address]

The event_type record has a max length for the event name.
It's called MAX_EVENT_NAME.
    
The name may be truncated to fit the max length. But the
header.size still reflects the original name length. If
that length is > MAX_EVENT_NAME, then the header.size
field is bogus. Fix this by using the length of the name
after the potential truncation.
    
Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
