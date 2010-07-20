Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967445Ab0GTAq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:46:59 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13668 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967391Ab0GTAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:46:55 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 1/2] trace-cmd: Don't try to read unmapped memory (v2).
Date: Mon, 19 Jul 2010 17:46:49 -0700
Message-Id: <1279586810-29859-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279586810-29859-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279586810-29859-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 20 Jul 2010 00:46:54.0997 (UTC) FILETIME=[0CEA7450:01CB27A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under some circumstances, I'm not sure exactly which, a trace.dat file
may contain a bunch of zeros at the end of one or more of the trace
logs.  This can lead to tracecmd_peek_data() attempting to read past
the end of the mmaped log, causing SIGSEGV.

This is a two part fix.

1) For 'new format' data, we always try to read 8 bytes of data.  Make
sure that they are all on the current page.

2) In pevent_print_event(), if record->size is negative, warn and then
skip attempting to print it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 parse-events.c |    5 +++++
 trace-input.c  |    3 ++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 16fff12..52b68f0 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -3881,6 +3881,11 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	usecs = record->ts - secs * NSECS_PER_SEC;
 	usecs = (usecs + 500) / NSECS_PER_USEC;
 
+	if (record->size < 0) {
+		do_warning("ug! negative record size %d", record->size);
+		return;
+	}
+
 	type = trace_parse_common_type(pevent, data);
 
 	event = pevent_find_event(pevent, type);
diff --git a/trace-input.c b/trace-input.c
index 398d0f9..7241197 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -1511,7 +1511,8 @@ read_again:
 	if (index < 0)
 		die("negative index on cpu record %d", cpu);
 
-	if (index >= handle->cpu_data[cpu].page_size + pevent->header_page_data_offset) {
+	if (index + (pevent->old_format ? 0 : 4) >=
+	    handle->cpu_data[cpu].page_size + pevent->header_page_data_offset) {
 		if (get_next_page(handle, cpu))
 			return NULL;
 		return tracecmd_peek_data(handle, cpu);
-- 
1.7.1.1

