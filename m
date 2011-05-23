Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1EWLGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:06:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54964 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1EWLGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dLwgb/sWD038aHEXwC9hpZQjBk2qb7kvL14kJVEZa4RjiohAR8UkKn8rpWmNsszos1
         QxNgX25Bpm6A8Gv2veHb7BC4BZkRtebZGwx8+m1zU43C8mIKTxZxV3EeYH624HDaujo6
         hT1+Z4HBrn02VgpRlOIoLeI7hNxx7jho0nr3A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tools: Fix ommitted mmap data update on remap
Date: Mon, 23 May 2011 13:06:28 +0200
Message-Id: <1306148788-6179-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
References: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eac9eacee16
"perf tools: Check we are able to read the event size on mmap"
brought a check to ensure we can read the size of the event
before dereferencing it, and do a remap otherwise to move
the buffer forward.

However that remap was ommitting all the necessary work to update
the new page offset, head, and to unmap previous pages, etc...

To fix this, gather all the code that fetches the event in a
seperate helper which does all the necessary checks about the
header/event size and tells us anytime a remap is needed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 948327d..64500fc 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -960,6 +960,30 @@ out_err:
 	return err;
 }
 
+static union perf_event *
+fetch_mmaped_event(struct perf_session *session,
+		   u64 head, size_t mmap_size, char *buf)
+{
+	union perf_event *event;
+
+	/*
+	 * Ensure we have enough space remaining to read
+	 * the size of the event in the headers.
+	 */
+	if (head + sizeof(event->header) > mmap_size)
+		return NULL;
+
+	event = (union perf_event *)(buf + head);
+
+	if (session->header.needs_swap)
+		perf_event_header__bswap(&event->header);
+
+	if (head + event->header.size > mmap_size)
+		return NULL;
+
+	return event;
+}
+
 int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_event_ops *ops)
@@ -1014,19 +1038,8 @@ remap:
 	file_pos = file_offset + head;
 
 more:
-	/*
-	 * Ensure we have enough space remaining to read
-	 * the size of the event in the headers.
-	 */
-	if (head + sizeof(event->header) > mmap_size)
-		goto remap;
-
-	event = (union perf_event *)(buf + head);
-
-	if (session->header.needs_swap)
-		perf_event_header__bswap(&event->header);
-
-	if (head + event->header.size > mmap_size) {
+	event = fetch_mmaped_event(session, head, mmap_size, buf);
+	if (!event) {
 		if (mmaps[map_idx]) {
 			munmap(mmaps[map_idx], mmap_size);
 			mmaps[map_idx] = NULL;
-- 
1.7.3.2

