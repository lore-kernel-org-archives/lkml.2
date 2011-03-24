Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab1CXJBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:01:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:38272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab1CXJBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:01:36 -0400
Date: Thu, 24 Mar 2011 09:01:11 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        yanmin_zhang@linux.intel.com, peterz@infradead.org, efault@gmx.de,
        phan@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        avi@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, yanmin_zhang@linux.intel.com,
        fweisbec@gmail.com, phan@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        avi@redhat.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf build-id: Add quirk to deal with perf.data file format breakage
Message-ID: <tip-b25114817a73bbd2b84ce9dba02ee1ef8989a947@git.kernel.org>
Git-Commit-ID: b25114817a73bbd2b84ce9dba02ee1ef8989a947
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 09:01:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b25114817a73bbd2b84ce9dba02ee1ef8989a947
Gitweb:     http://git.kernel.org/tip/b25114817a73bbd2b84ce9dba02ee1ef8989a947
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 22 Mar 2011 13:36:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Mar 2011 19:29:40 -0300

perf build-id: Add quirk to deal with perf.data file format breakage

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
 
