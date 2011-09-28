Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1I1I7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:59:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9431 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1I1I7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:59:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=OF/RemscRwEhpgpZiuox+ULk9c0+3SkSQmzMai/ITl5TFOIQLTzcRbYoOxEn6T3q0
	2BO/LOKFoy8DF8a/I8eTA==
Date: Wed, 28 Sep 2011 10:59:06 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, acme@redhat.com, dsahern@gmail.com, mingo@elte.hu
Subject: [PATCH] perf: fix perf.data endianness detection (v2b)
Message-ID: <20110928085906.GA6009@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The current version of perf detects whether or not
the perf.data file is written in a different endianness
using the attr_size field in the header of the file. This
field represents sizeof(struct perf_event) as known to perf
record. If the size does not match, then perf tries the
byte-swapped version. If they match, then the tool assumes
a different endianness.

The issue with the approach is that it assumes the size of
perf_event_attr always has to match between the file and the
tool. However, the kernel API is designed to make it possible
to extend perf_event_attr for new features. Consequently, it
is not possible to use attr_size to detect endianness.

This patch takes another approach by using the magic number
written at the beginning of the perf.data file to detect
endianness mismatch. The magic number is an eight-byte
signature. The patch introduces a new value for this
signature. The key difference is that the signature
is written differently in the file depending on the
endianness. Thus, by comparing the signature from the file
with the tool's own signature it is possible to detect if
the endianness matches. The new signature is "PERFILE2".

Backward compatiblity with existing perf.data file is
ensured.

The perf.data files created with this new magic number
(PERFILE2) cannot be read by former versions of perf
which use the old magic number (PERFFILE).

This second version fixes a bug in the case of the new
format whereby the u64 fields of the header were not
swapped when necessary. This new version also factorizes
the swapping on the u64 portion of the header.

Version 2b is simply updating the changelog.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
---

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b6c1ad1..4fa52d3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -57,9 +57,20 @@ char *perf_header__find_event(u64 id)
 	return NULL;
 }
 
-static const char *__perf_magic = "PERFFILE";
-
-#define PERF_MAGIC	(*(u64 *)__perf_magic)
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
+
+#define PERF_MAGIC	__perf_magic2
 
 struct perf_file_attr {
 	struct perf_event_attr	attr;
@@ -595,24 +606,59 @@ out_free:
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
@@ -824,8 +870,13 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
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
