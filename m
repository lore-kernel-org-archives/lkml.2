Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2LKW6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:58:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43763 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab2LKWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/37] perf tools: Fix mmap limitations on 32-bit
Date: Tue, 11 Dec 2012 19:47:53 -0300
Message-Id: <1355266103-17238-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

This is a suggested patch to fix the bug I reported at:

	http://marc.info/?l=linux-kernel&m=135033028924652&w=2

Essentially, there is a hard requirement that when perf analyzes a
trace, it must have the entire thing mmap()'d.

Therefore the scheme used on 32-bit where we have a fixed (8) number of
32MB mmaps, and cycle through them, simply does not work.

One of the reasons this requirement exists is because the iterators
maintain references to perf entry objects and those references don't
just simply go away when this mmap code decides to cycle an old mmap
area out and reuse it.  At this point, those entry pointers now point to
garbage resulting in unpredictable behavior and crashes.

It is better to try to mmap() as much as we can and if we do actually
run into address space limitations, the failure of the mmap() call will
indicate that and stop processing.

I noticed that perf_session->mmap_window is set to a constant in one
location, and only used in one other location.  So I got rid of it
altogether.

So we adjust the size of the mmaps[] array to the maximum we could need.
On 64-bit we only need one slot.  On 32-bit we could need up to 128 (128
* 32MB == 4GB).

I've verified that this allows a large (~600MB) perf.data file to be
analyzed properly with a 32-bit perf binary, which previously was not
possible.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20121110.141219.582924082787523608.davem@davemloft.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   25 ++++++++++++++-----------
 tools/perf/util/session.h |    1 -
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d5fb607..aa5e582 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -128,15 +128,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		goto out;
 
 	memcpy(self->filename, filename, len);
-	/*
-	 * On 64bit we can mmap the data file in one go. No need for tiny mmap
-	 * slices. On 32bit we use 32MB.
-	 */
-#if BITS_PER_LONG == 64
-	self->mmap_window = ULLONG_MAX;
-#else
-	self->mmap_window = 32 * 1024 * 1024ULL;
-#endif
 	self->machines = RB_ROOT;
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples);
@@ -1386,6 +1377,18 @@ fetch_mmaped_event(struct perf_session *session,
 	return event;
 }
 
+/*
+ * On 64bit we can mmap the data file in one go. No need for tiny mmap
+ * slices. On 32bit we use 32MB.
+ */
+#if BITS_PER_LONG == 64
+#define MMAP_SIZE ULLONG_MAX
+#define NUM_MMAPS 1
+#else
+#define MMAP_SIZE (32 * 1024 * 1024ULL)
+#define NUM_MMAPS 128
+#endif
+
 int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_tool *tool)
@@ -1393,7 +1396,7 @@ int __perf_session__process_events(struct perf_session *session,
 	u64 head, page_offset, file_offset, file_pos, progress_next;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
-	char *buf, *mmaps[8];
+	char *buf, *mmaps[NUM_MMAPS];
 	union perf_event *event;
 	uint32_t size;
 
@@ -1408,7 +1411,7 @@ int __perf_session__process_events(struct perf_session *session,
 
 	progress_next = file_size / 16;
 
-	mmap_size = session->mmap_window;
+	mmap_size = MMAP_SIZE;
 	if (mmap_size > file_size)
 		mmap_size = file_size;
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index cea133a..c18fabd 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -30,7 +30,6 @@ struct ordered_samples {
 struct perf_session {
 	struct perf_header	header;
 	unsigned long		size;
-	unsigned long		mmap_window;
 	struct machine		host_machine;
 	struct rb_root		machines;
 	struct perf_evlist	*evlist;
-- 
1.7.9.2.358.g22243

