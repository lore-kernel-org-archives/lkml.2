Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab1LFKdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:33:32 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:27798
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933286Ab1LFKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:33:17 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVS2MT-01-BNQ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/10] perf tool: Unify handling of features when writing feature section
Date: Tue, 6 Dec 2011 11:32:38 +0100
Message-ID: <1323167560-2282-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index dda3c5f..5cfe06a 100644
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
@@ -1413,10 +1416,6 @@ static int perf_header__adds_write(struct perf_header *header,
 
 	session = container_of(header, struct perf_session, header);
 
-	if (perf_header__has_feat(header, HEADER_BUILD_ID &&
-	    !perf_session__read_build_ids(session, true)))
-		perf_header__clear_feat(header, HEADER_BUILD_ID);
-
 	nr_sections = bitmap_weight(header->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
 		return 0;
@@ -1432,13 +1431,11 @@ static int perf_header__adds_write(struct perf_header *header,
 
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
@@ -1496,7 +1493,6 @@ static int perf_header__adds_write(struct perf_header *header,
 	err = do_write(fd, feat_sec, sec_size);
 	if (err < 0)
 		pr_debug("failed to write feature section\n");
-out_free:
 	free(feat_sec);
 	return err;
 }
-- 
1.7.7


