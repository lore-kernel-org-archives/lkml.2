Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab0K1Ie2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 03:34:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:57053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0K1IeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 03:34:24 -0500
Date: Sun, 28 Nov 2010 08:33:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Add option to disable collecting build-ids
Message-ID: <tip-baa2f6cedbfae962f04281a31f08ec29667d31a0@git.kernel.org>
Git-Commit-ID: baa2f6cedbfae962f04281a31f08ec29667d31a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Nov 2010 08:33:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  baa2f6cedbfae962f04281a31f08ec29667d31a0
Gitweb:     http://git.kernel.org/tip/baa2f6cedbfae962f04281a31f08ec29667d31a0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 26 Nov 2010 19:39:15 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Nov 2010 19:39:15 -0200

perf record: Add option to disable collecting build-ids

Collecting build-ids for long running sessions may take a long time
because it needs to traverse the whole just collected perf.data stream
of events, marking the DSOs that had hits and then looking for the
.note.gnu.build-id ELF section.

For things like the 'trace' tool that records and right away consumes
the data on systems where its unlikely that the DSOs being monitored
will change while 'trace' runs, it is desirable to remove build id
collection, so add a -B/--no-buildid option to perf record to allow such
use case.

Longer term we'll avoid all this if we, at DSO load time, in the kernel,
take advantage of this slow code path to collect the build-id and stash
it somewhere, so that we can insert it in the PERF_RECORD_MMAP event.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c            |   14 +++++++++++---
 tools/perf/util/header.c               |   11 +++++++++--
 tools/perf/util/header.h               |    1 +
 tools/perf/util/include/linux/bitops.h |    5 +++++
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3d2cb48..024e144 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -61,6 +61,7 @@ static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
 static bool			no_buildid			=  false;
+static bool			no_buildid_cache		=  false;
 
 static long			samples				=      0;
 static u64			bytes_written			=      0;
@@ -437,7 +438,8 @@ static void atexit_header(void)
 	if (!pipe_output) {
 		session->header.data_size += bytes_written;
 
-		process_buildids();
+		if (!no_buildid)
+			process_buildids();
 		perf_header__write(&session->header, output, true);
 		perf_session__delete(session);
 		symbol__exit();
@@ -557,6 +559,9 @@ static int __cmd_record(int argc, const char **argv)
 		return -1;
 	}
 
+	if (!no_buildid)
+		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
+
 	if (!file_new) {
 		err = perf_header__read(session, output);
 		if (err < 0)
@@ -831,8 +836,10 @@ const struct option record_options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
-	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid,
+	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
 		    "do not update the buildid cache"),
+	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
+		    "do not collect buildids in perf.data"),
 	OPT_END()
 };
 
@@ -857,7 +864,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	}
 
 	symbol__init();
-	if (no_buildid)
+
+	if (no_buildid_cache || no_buildid)
 		disable_buildid_cache();
 
 	if (!nr_counters) {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d7e67b1..f65d7dc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -152,6 +152,11 @@ void perf_header__set_feat(struct perf_header *self, int feat)
 	set_bit(feat, self->adds_features);
 }
 
+void perf_header__clear_feat(struct perf_header *self, int feat)
+{
+	clear_bit(feat, self->adds_features);
+}
+
 bool perf_header__has_feat(const struct perf_header *self, int feat)
 {
 	return test_bit(feat, self->adds_features);
@@ -431,8 +436,10 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 	int idx = 0, err;
 
 	session = container_of(self, struct perf_session, header);
-	if (perf_session__read_build_ids(session, true))
-		perf_header__set_feat(self, HEADER_BUILD_ID);
+
+	if (perf_header__has_feat(self, HEADER_BUILD_ID &&
+	    !perf_session__read_build_ids(session, true)))
+		perf_header__clear_feat(self, HEADER_BUILD_ID);
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 402ac24..ed550bf 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -84,6 +84,7 @@ u64 perf_header__sample_type(struct perf_header *header);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
 void perf_header__set_feat(struct perf_header *self, int feat);
+void perf_header__clear_feat(struct perf_header *self, int feat);
 bool perf_header__has_feat(const struct perf_header *self, int feat);
 
 int perf_header__process_sections(struct perf_header *self, int fd,
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index bb4ac2e..8be0b96 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -13,6 +13,11 @@ static inline void set_bit(int nr, unsigned long *addr)
 	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
 }
 
+static inline void clear_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
+}
+
 static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
