Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab1CWWxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:53:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920Ab1CWWxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:53:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Avi Kivity <avi@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Zhang Yanmin <yanmin_zhang@linux.intel.com>, stable@kernel.org
Subject: [PATCH 2/3] perf build-id: Add quirk to deal with perf.data file format breakage
Date: Wed, 23 Mar 2011 19:52:46 -0300
Message-Id: <1300920767-936-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300920767-936-1-git-send-email-acme@infradead.org>
References: <1300920767-936-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The a1645ce1 changeset:

"perf: 'perf kvm' tool for monitoring guest performance from host"

Added a field to struct build_id_event that broke the file format.

Since the kernel build-id is the first entry, process the table using
the old format if the well known '[kernel.kallsyms]' string for the
kernel build-id has the first 4 characters chopped off (where the pid_t
sits).

Reported-by: Han Pingtian <phan@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: stable@kernel.org
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   57 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e5230c0..93862a8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -695,13 +695,50 @@ out:
 	return err;
 }
 
+static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
+						 int input, u64 offset, u64 size)
+{
+	struct perf_session *session = container_of(header, struct perf_session, header);
+	struct {
+		struct perf_event_header   header;
+		u8			   build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
+		char			   filename[0];
+	} old_bev;
+	struct build_id_event bev;
+	char filename[PATH_MAX];
+	u64 limit = offset + size;
+
+	while (offset < limit) {
+		ssize_t len;
+
+		if (read(input, &old_bev, sizeof(old_bev)) != sizeof(old_bev))
+			return -1;
+
+		if (header->needs_swap)
+			perf_event_header__bswap(&old_bev.header);
+
+		len = old_bev.header.size - sizeof(old_bev);
+		if (read(input, filename, len) != len)
+			return -1;
+
+		bev.header = old_bev.header;
+		bev.pid	   = 0;
+		memcpy(bev.build_id, old_bev.build_id, sizeof(bev.build_id));
+		__event_process_build_id(&bev, filename, session);
+
+		offset += bev.header.size;
+	}
+
+	return 0;
+}
+
 static int perf_header__read_build_ids(struct perf_header *header,
 				       int input, u64 offset, u64 size)
 {
 	struct perf_session *session = container_of(header, struct perf_session, header);
 	struct build_id_event bev;
 	char filename[PATH_MAX];
-	u64 limit = offset + size;
+	u64 limit = offset + size, orig_offset = offset;
 	int err = -1;
 
 	while (offset < limit) {
@@ -716,6 +753,24 @@ static int perf_header__read_build_ids(struct perf_header *header,
 		len = bev.header.size - sizeof(bev);
 		if (read(input, filename, len) != len)
 			goto out;
+		/*
+		 * The a1645ce1 changeset:
+		 *
+		 * "perf: 'perf kvm' tool for monitoring guest performance from host"
+		 *
+		 * Added a field to struct build_id_event that broke the file
+		 * format.
+		 *
+		 * Since the kernel build-id is the first entry, process the
+		 * table using the old format if the well known
+		 * '[kernel.kallsyms]' string for the kernel build-id has the
+		 * first 4 characters chopped off (where the pid_t sits).
+		 */
+		if (memcmp(filename, "nel.kallsyms]", 13) == 0) {
+			if (lseek(input, orig_offset, SEEK_SET) == (off_t)-1)
+				return -1;
+			return perf_header__read_build_ids_abi_quirk(header, input, offset, size);
+		}
 
 		__event_process_build_id(&bev, filename, session);
 
-- 
1.6.2.5

