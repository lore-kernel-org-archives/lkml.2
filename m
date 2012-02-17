Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2BQJoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:44:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38559 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2BQJoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:44:02 -0500
Date: Fri, 17 Feb 2012 01:42:45 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-73323f541fe5f55a3b8a5c3d565bfc1efd64abf6@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com,
        peterz@infradead.org, robert.richter@amd.com, ravitillo@lbl.gov,
        ming.m.lin@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, asharma@fb.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        khandual@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, eranian@google.com, acme@redhat.com,
        peterz@infradead.org, robert.richter@amd.com, ravitillo@lbl.gov,
        ming.m.lin@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, asharma@fb.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        khandual@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1328187288-24395-15-git-send-email-eranian@google.com>
References: <1328187288-24395-15-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: fix endianness detection in perf.data
Git-Commit-ID: 73323f541fe5f55a3b8a5c3d565bfc1efd64abf6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:42:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73323f541fe5f55a3b8a5c3d565bfc1efd64abf6
Gitweb:     http://git.kernel.org/tip/73323f541fe5f55a3b8a5c3d565bfc1efd64abf6
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 2 Feb 2012 13:54:44 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Feb 2012 12:28:10 -0200

perf tools: fix endianness detection in perf.data

The current version of perf detects whether or not the perf.data file is
written in a different endianness using the attr_size field in the
header of the file. This field represents sizeof(struct perf_event_attr)
as known to perf record. If the sizes do not match, then perf tries the
byte-swapped version. If they match, then the tool assumes a different
endianness.

The issue with the approach is that it assumes the size of
perf_event_attr always has to match between perf record and perf report.
However, the kernel perf_event ABI is extensible.  New fields can be
added to struct perf_event_attr. Consequently, it is not possible to use
attr_size to detect endianness.

This patch takes another approach by using the magic number written at
the beginning of the perf.data file to detect endianness. The magic
number is an eight-byte signature.  It's primary purpose is to identify
(signature) a perf.data file. But it could also be used to encode the
endianness.

The patch introduces a new value for this signature. The key difference
is that the signature is written differently in the file depending on
the endianness. Thus, by comparing the signature from the file with the
tool's own signature it is possible to detect endianness. The new
signature is "PERFILE2".

Backward compatiblity with existing perf.data file is ensured.

Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roberto Agostino Vitillo <ravitillo@lbl.gov>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>
Link: http://lkml.kernel.org/r/1328187288-24395-15-git-send-email-eranian@google.com
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   77 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ecd7f4d..6f4187d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -63,9 +63,20 @@ char *perf_header__find_event(u64 id)
 	return NULL;
 }
 
-static const char *__perf_magic = "PERFFILE";
+/*
+ * magic2 = "PERFILE2"
+ * must be a numerical value to let the endianness
+ * determine the memory layout. That way we are able
+ * to detect endianness when reading the perf.data file
+ * back.
+ *
+ * we check for legacy (PERFFILE) format.
+ */
+static const char *__perf_magic1 = "PERFFILE";
+static const u64 __perf_magic2    = 0x32454c4946524550ULL;
+static const u64 __perf_magic2_sw = 0x50455246494c4532ULL;
 
-#define PERF_MAGIC	(*(u64 *)__perf_magic)
+#define PERF_MAGIC	__perf_magic2
 
 struct perf_file_attr {
 	struct perf_event_attr	attr;
@@ -1620,24 +1631,59 @@ out_free:
 	return err;
 }
 
+static int check_magic_endian(u64 *magic, struct perf_file_header *header,
+			      struct perf_header *ph)
+{
+	int ret;
+
+	/* check for legacy format */
+	ret = memcmp(magic, __perf_magic1, sizeof(*magic));
+	if (ret == 0) {
+		pr_debug("legacy perf.data format\n");
+		if (!header)
+			return -1;
+
+		if (header->attr_size != sizeof(struct perf_file_attr)) {
+			u64 attr_size = bswap_64(header->attr_size);
+
+			if (attr_size != sizeof(struct perf_file_attr))
+				return -1;
+
+			ph->needs_swap = true;
+		}
+		return 0;
+	}
+
+	/* check magic number with same endianness */
+	if (*magic == __perf_magic2)
+		return 0;
+
+	/* check magic number but opposite endianness */
+	if (*magic != __perf_magic2_sw)
+		return -1;
+
+	ph->needs_swap = true;
+
+	return 0;
+}
+
 int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd)
 {
+	int ret;
+
 	lseek(fd, 0, SEEK_SET);
 
-	if (readn(fd, header, sizeof(*header)) <= 0 ||
-	    memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
+	ret = readn(fd, header, sizeof(*header));
+	if (ret <= 0)
 		return -1;
 
-	if (header->attr_size != sizeof(struct perf_file_attr)) {
-		u64 attr_size = bswap_64(header->attr_size);
-
-		if (attr_size != sizeof(struct perf_file_attr))
-			return -1;
+	if (check_magic_endian(&header->magic, header, ph) < 0)
+		return -1;
 
+	if (ph->needs_swap) {
 		mem_bswap_64(header, offsetof(struct perf_file_header,
-					    adds_features));
-		ph->needs_swap = true;
+			     adds_features));
 	}
 
 	if (header->size != sizeof(*header)) {
@@ -1873,8 +1919,13 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 				       struct perf_header *ph, int fd,
 				       bool repipe)
 {
-	if (readn(fd, header, sizeof(*header)) <= 0 ||
-	    memcmp(&header->magic, __perf_magic, sizeof(header->magic)))
+	int ret;
+
+	ret = readn(fd, header, sizeof(*header));
+	if (ret <= 0)
+		return -1;
+
+	 if (check_magic_endian(&header->magic, NULL, ph) < 0)
 		return -1;
 
 	if (repipe && do_write(STDOUT_FILENO, header, sizeof(*header)) < 0)
