Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2BBM4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:56:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37265 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2BBM4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:56:39 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v5 18/18] perf: make perf able to read file from older ABIs
Date: Thu,  2 Feb 2012 13:54:48 +0100
Message-Id: <1328187288-24395-19-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328187288-24395-1-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches provides a way to handle legacy perf.data
files.  Legacy files are those using the older PERFFILE
signature.

For those, it is still necessary to detect endianness but
without comparing their header->attr_size with the
tool's own version as it may be different. Instead, we use
a reference table for all known sizes from the legacy era.

We try all the combinations for sizes and endianness. If we find
a match, we proceed, otherwise we return: "incompatible file format".
This is also done for the pipe-mode file format.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/header.c |  125 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 97 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1fb365d..487605a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1630,35 +1630,101 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 	return err;
 }
 
-static int check_magic_endian(u64 *magic, struct perf_file_header *header,
-			      struct perf_header *ph)
+static const int attr_file_abi_sizes[] = {
+	[0] = PERF_ATTR_SIZE_VER0,
+	[1] = PERF_ATTR_SIZE_VER1,
+	0,
+};
+
+/*
+ * In the legacy file format, the magic number is not used to encode endianness.
+ * hdr_sz was used to encode endianness. But given that hdr_sz can vary based
+ * on ABI revisions, we need to try all combinations for all endianness to
+ * detect the endianness.
+ */
+static int try_all_file_abis(uint64_t hdr_sz, struct perf_header *ph)
 {
-	int ret;
+	uint64_t ref_size, attr_size;
+	int i;
 
-	/* check for legacy format */
-	ret = memcmp(magic, __perf_magic1, sizeof(*magic));
-	if (ret == 0) {
-		pr_debug("legacy perf.data format\n");
-		if (!header)
-			return -1;
+	for (i = 0 ; attr_file_abi_sizes[i]; i++) {
+		ref_size = attr_file_abi_sizes[i]
+			 + sizeof(struct perf_file_section);
+		if (hdr_sz != ref_size) {
+			attr_size = bswap_64(hdr_sz);
+			if (attr_size != ref_size)
+				continue;
 
-		if (header->attr_size != sizeof(struct perf_file_attr)) {
-			u64 attr_size = bswap_64(header->attr_size);
+			ph->needs_swap = true;
+		}
+		pr_debug("ABI%d perf.data file detected, need_swap=%d\n",
+			 i,
+			 ph->needs_swap);
+		return 0;
+	}
+	/* could not determine endianness */
+	return -1;
+}
 
-			if (attr_size != sizeof(struct perf_file_attr))
-				return -1;
+#define PERF_PIPE_HDR_VER0	16
+
+static const size_t attr_pipe_abi_sizes[] = {
+	[0] = PERF_PIPE_HDR_VER0,
+	0,
+};
+
+/*
+ * In the legacy pipe format, there is an implicit assumption that endiannesss
+ * between host recording the samples, and host parsing the samples is the
+ * same. This is not always the case given that the pipe output may always be
+ * redirected into a file and analyzed on a different machine with possibly a
+ * different endianness and perf_event ABI revsions in the perf tool itself.
+ */
+static int try_all_pipe_abis(uint64_t hdr_sz, struct perf_header *ph)
+{
+	u64 attr_size;
+	int i;
+
+	for (i = 0 ; attr_pipe_abi_sizes[i]; i++) {
+		if (hdr_sz != attr_pipe_abi_sizes[i]) {
+			attr_size = bswap_64(hdr_sz);
+			if (attr_size != hdr_sz)
+				continue;
 
 			ph->needs_swap = true;
 		}
+		pr_debug("Pipe ABI%d perf.data file detected\n", i);
 		return 0;
 	}
+	return -1;
+}
+
+static int check_magic_endian(u64 magic, uint64_t hdr_sz,
+			      bool is_pipe, struct perf_header *ph)
+{
+	int ret;
+
+	/* check for legacy format */
+	ret = memcmp(&magic, __perf_magic1, sizeof(magic));
+	if (ret == 0) {
+		pr_debug("legacy perf.data format\n");
+		if (is_pipe)
+			return try_all_pipe_abis(hdr_sz, ph);
+
+		return try_all_file_abis(hdr_sz, ph);
+	}
+	/*
+	 * the new magic number serves two purposes:
+	 * - unique number to identify actual perf.data files
+	 * - encode endianness of file
+	 */
 
-	/* check magic number with same endianness */
-	if (*magic == __perf_magic2)
+	/* check magic number with one endianness */
+	if (magic == __perf_magic2)
 		return 0;
 
-	/* check magic number but opposite endianness */
-	if (*magic != __perf_magic2_sw)
+	/* check magic number with opposite endianness */
+	if (magic != __perf_magic2_sw)
 		return -1;
 
 	ph->needs_swap = true;
@@ -1677,8 +1743,11 @@ int perf_file_header__read(struct perf_file_header *header,
 	if (ret <= 0)
 		return -1;
 
-	if (check_magic_endian(&header->magic, header, ph) < 0)
+	if (check_magic_endian(header->magic,
+			       header->attr_size, false, ph) < 0) {
+		pr_debug("magic/endian check failed\n");
 		return -1;
+	}
 
 	if (ph->needs_swap) {
 		mem_bswap_64(header, offsetof(struct perf_file_header,
@@ -1924,21 +1993,17 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 	if (ret <= 0)
 		return -1;
 
-	 if (check_magic_endian(&header->magic, NULL, ph) < 0)
+	if (check_magic_endian(header->magic, header->size, true, ph) < 0) {
+		pr_debug("endian/magic failed\n");
 		return -1;
+	}
+
+	if (ph->needs_swap)
+		header->size = bswap_64(header->size);
 
 	if (repipe && do_write(STDOUT_FILENO, header, sizeof(*header)) < 0)
 		return -1;
 
-	if (header->size != sizeof(*header)) {
-		u64 size = bswap_64(header->size);
-
-		if (size != sizeof(*header))
-			return -1;
-
-		ph->needs_swap = true;
-	}
-
 	return 0;
 }
 
@@ -1975,6 +2040,10 @@ static int read_attr(int fd, struct perf_header *ph,
 
 	/* on file perf_event_attr size */
 	sz = attr->size;
+	if (sz != our_sz)
+		pr_debug("on file attr=%zu vs. %zu bytes,"
+			 " ignoring extra fields\n", sz, our_sz);
+
 	if (ph->needs_swap)
 		sz = bswap_32(sz);
 
-- 
1.7.4.1

