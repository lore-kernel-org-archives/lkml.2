Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1L2Uzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:55:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1L2Uzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:55:43 -0500
Date: Thu, 29 Dec 2011 12:55:25 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-e20960c0271f91aead94746872fd976326a703b3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1323248577-11268-6-git-send-email-robert.richter@amd.com>
References: <1323248577-11268-6-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Unify handling of features when writing feature section
Git-Commit-ID: e20960c0271f91aead94746872fd976326a703b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:55:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e20960c0271f91aead94746872fd976326a703b3
Gitweb:     http://git.kernel.org/tip/e20960c0271f91aead94746872fd976326a703b3
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 7 Dec 2011 10:02:55 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 17:02:22 -0200

perf tools: Unify handling of features when writing feature section

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
