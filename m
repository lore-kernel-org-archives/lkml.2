Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1LWVym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:54:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:50746 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab1LWVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/15] perf tools: Unify handling of features when writing feature section
Date: Fri, 23 Dec 2011 19:53:16 -0200
Message-Id: <1324677198-5191-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

The features HEADER_TRACE_INFO and HEADER_BUILD_ID are handled
different when writing the feature section. All other features are
simply disabled on failure and writing the section goes on without
returning an error. There is no reason for these special cases. This
patch unifies handling of the features.

This should be ok since all features can be parsed independently.
Offset and size of a feature's block is stored in struct perf_file_
section right after the data block of perf.data (see perf_session__
write_header()). Thus, if a feature does not exist then other features
can be processed anyway.

Also moving special code for HEADER_BUILD_ID out to write_build_id().

v2:
* perf record throws an error now if buildids may not be generated,
  which can be disabled with the --no-buildid option.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323248577-11268-6-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    7 +++++++
 tools/perf/util/header.c    |   14 +++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e873ae2..0abfb18 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -503,6 +503,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			return err;
 	}
 
+	if (!!rec->no_buildid
+	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
+		pr_err("Couldn't generating buildids. "
+		       "Use --no-buildid to profile anyway.\n");
+		return -1;
+	}
+
 	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
 
 	machine = perf_session__find_host_machine(session);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 609d79b..7132683 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -445,6 +445,9 @@ static int write_build_id(int fd, struct perf_header *h,
 
 	session = container_of(h, struct perf_session, header);
 
+	if (!perf_session__read_build_ids(session, true))
+		return -1;
+
 	err = dsos__write_buildid_table(h, fd);
 	if (err < 0) {
 		pr_debug("failed to write buildid table\n");
@@ -1417,10 +1420,6 @@ static int perf_header__adds_write(struct perf_header *header,
 
 	session = container_of(header, struct perf_session, header);
 
-	if (perf_header__has_feat(header, HEADER_BUILD_ID &&
-	    !perf_session__read_build_ids(session, true)))
-		perf_header__clear_feat(header, HEADER_BUILD_ID);
-
 	nr_sections = bitmap_weight(header->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
 		return 0;
@@ -1436,13 +1435,11 @@ static int perf_header__adds_write(struct perf_header *header,
 
 	err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
 	if (err)
-		goto out_free;
+		perf_header__clear_feat(header, HEADER_TRACE_INFO);
 
 	err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
-	if (err) {
+	if (err)
 		perf_header__clear_feat(header, HEADER_BUILD_ID);
-		goto out_free;
-	}
 
 	err = do_write_feat(fd, header, HEADER_HOSTNAME, &p, evlist);
 	if (err)
@@ -1500,7 +1497,6 @@ static int perf_header__adds_write(struct perf_header *header,
 	err = do_write(fd, feat_sec, sec_size);
 	if (err < 0)
 		pr_debug("failed to write feature section\n");
-out_free:
 	free(feat_sec);
 	return err;
 }
-- 
1.7.8.rc0.35.gee6df

