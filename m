Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab2LTPtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:49:25 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57303 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2LTPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:49:00 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v4 16/18] perf tools: detect data vs. text mappings
Date: Thu, 20 Dec 2012 16:41:46 +0100
Message-Id: <1356018108-6081-17-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356018108-6081-1-git-send-email-eranian@google.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leverages the PERF_RECORD_MISC_MMAP_DATA bit in
the RECORD_MMAP record header. When the bit is set
then the mapping type is set to MAP__VARIABLE.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/machine.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 1f09d05..d1c3e48 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -379,6 +379,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread;
 	struct map *map;
+	enum map_type type;
 	int ret = 0;
 
 	if (dump_trace)
@@ -395,10 +396,17 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	thread = machine__findnew_thread(machine, event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
+
+	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		type = MAP__VARIABLE;
+	else
+		type = MAP__FUNCTION;
+
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, event->mmap.filename,
-			MAP__FUNCTION);
+			type);
+
 	if (map == NULL)
 		goto out_problem;
 
-- 
1.7.9.5

