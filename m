Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1EWLbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:31:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:34799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab1EWLbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:31:16 -0400
Date: Mon, 23 May 2011 11:30:55 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-998bedc8c56c6869de457c845cbd328592e5e82e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1306148788-6179-3-git-send-email-fweisbec@gmail.com>
References: <1306148788-6179-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix ommitted mmap data update on remap
Git-Commit-ID: 998bedc8c56c6869de457c845cbd328592e5e82e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 May 2011 11:30:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  998bedc8c56c6869de457c845cbd328592e5e82e
Gitweb:     http://git.kernel.org/tip/998bedc8c56c6869de457c845cbd328592e5e82e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 May 2011 13:06:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 May 2011 13:22:57 +0200

perf tools: Fix ommitted mmap data update on remap

Commit eac9eacee16 "perf tools: Check we are able to read the event
size on mmap" brought a check to ensure we can read the size of the
event before dereferencing it, and do a remap otherwise to move the
buffer forward.

However that remap was ommitting all the necessary work to
update the new page offset, head, and to unmap previous pages,
etc...

To fix this, gather all the code that fetches the event in a
seperate helper which does all the necessary checks about the
header/event size and tells us anytime a remap is needed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1306148788-6179-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
