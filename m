Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2EOL26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:28:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59850 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab2EOL2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:28:53 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, dsahern@gmail.com
Subject: [PATCH v2 5/5] perf: make perf buildid-list work better with pipe mode
Date: Tue, 15 May 2012 13:28:15 +0200
Message-Id: <1337081295-10303-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1337081295-10303-1-git-send-email-eranian@google.com>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for perf buildid-list to work with pipe-mode files,
it needs to process buildids and event attr structs.

$ perf record -o - noploop 2 | ./perf inject -b | perf buildid-list -i - -H
noploop for 2 seconds
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.084 MB - (~3678 samples) ]
0000000000000000000000000000000000000000 [kernel.kallsyms]
3a0d0629efe74a8da3eeba372cdbd74ad9b8f5d5 /usr/local/bin/noploop

The reason [kernel.kallsyms] shows a 0 build-id comes from the
way buildids are injected in the stream. The buildid for the kernel
is provided by a BUILD_ID record. The [kernel.kallsyms] is provided
by a MMAP record. There is no clean and obvious way to link the two,
unfortunately. In regular mode, the kernel buildid is generated from
reading the ELF image or kallsyms and perf knows to associate
[kernel.kallsyms] to it. Later on, when perf processes the
[kernel.kallsyms] MMAP record, it will already have a dso for it.

So for now, make sure perf buildid-list shows the buildids for
everything but the kernel image.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-buildid-list.c |    6 +++++-
 tools/perf/util/build-id.c        |    2 ++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 5248046..6b2bcfb 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -84,7 +84,11 @@ static int perf_session__list_build_ids(void)
 	if (filename__fprintf_build_id(session->filename, stdout))
 		goto out;
 
-	if (with_hits)
+	/*
+	 * in pipe-mode, the only way to get the buildids is to parse
+	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
+	 */
+	if (with_hits || session->fd_pipe)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index dff9c7a..fd9a594 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -65,6 +65,8 @@ struct perf_tool build_id__mark_dso_hit_ops = {
 	.mmap	= perf_event__process_mmap,
 	.fork	= perf_event__process_task,
 	.exit	= perf_event__exit_del_thread,
+	.attr		 = perf_event__process_attr,
+	.build_id	 = perf_event__process_build_id,
 };
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
-- 
1.7.4.1

