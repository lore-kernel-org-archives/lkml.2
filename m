Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1IWU1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:27:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35540 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1IWU06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/12] perf symbols: Fix issue with binaries using 16-bytes buildids (v2)
Date: Fri, 23 Sep 2011 17:26:24 -0300
Message-Id: <1316809586-28529-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

Buildid can vary in size. According to the man page of ld, buildid can
be 160 bits (sha1) or 128 bits (md5, uuid). Perf assumes buildid size of
20 bytes (160 bits) regardless. When dealing with md5 buildids, it would
thus read more than needed and that would cause mismatches and samples
without symbols.

This patch fixes this by taking into account the actual buildid size as
encoded int he section header. The leftover bytes are also cleared.

This second version fixes a minor issue with the memset() base position.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@gmail.com>
Link: http://lkml.kernel.org/r/4cc1af3c.8ee7d80a.5a28.ffff868e@mx.google.com
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 870b3b8..40eeaf0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1170,8 +1170,7 @@ static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 	if (dso->has_build_id) {
 		u8 build_id[BUILD_ID_SIZE];
 
-		if (elf_read_build_id(elf, build_id,
-				      BUILD_ID_SIZE) != BUILD_ID_SIZE)
+		if (elf_read_build_id(elf, build_id, BUILD_ID_SIZE) < 0)
 			goto out_elf_end;
 
 		if (!dso__build_id_equal(dso, build_id))
@@ -1443,8 +1442,8 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
 	ptr = data->d_buf;
 	while (ptr < (data->d_buf + data->d_size)) {
 		GElf_Nhdr *nhdr = ptr;
-		int namesz = NOTE_ALIGN(nhdr->n_namesz),
-		    descsz = NOTE_ALIGN(nhdr->n_descsz);
+		size_t namesz = NOTE_ALIGN(nhdr->n_namesz),
+		       descsz = NOTE_ALIGN(nhdr->n_descsz);
 		const char *name;
 
 		ptr += sizeof(*nhdr);
@@ -1453,8 +1452,10 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
 		if (nhdr->n_type == NT_GNU_BUILD_ID &&
 		    nhdr->n_namesz == sizeof("GNU")) {
 			if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
-				memcpy(bf, ptr, BUILD_ID_SIZE);
-				err = BUILD_ID_SIZE;
+				size_t sz = min(size, descsz);
+				memcpy(bf, ptr, sz);
+				memset(bf + sz, 0, size - sz);
+				err = descsz;
 				break;
 			}
 		}
@@ -1506,7 +1507,7 @@ int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
 	while (1) {
 		char bf[BUFSIZ];
 		GElf_Nhdr nhdr;
-		int namesz, descsz;
+		size_t namesz, descsz;
 
 		if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
 			break;
@@ -1515,15 +1516,16 @@ int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
 		descsz = NOTE_ALIGN(nhdr.n_descsz);
 		if (nhdr.n_type == NT_GNU_BUILD_ID &&
 		    nhdr.n_namesz == sizeof("GNU")) {
-			if (read(fd, bf, namesz) != namesz)
+			if (read(fd, bf, namesz) != (ssize_t)namesz)
 				break;
 			if (memcmp(bf, "GNU", sizeof("GNU")) == 0) {
-				if (read(fd, build_id,
-				    BUILD_ID_SIZE) == BUILD_ID_SIZE) {
+				size_t sz = min(descsz, size);
+				if (read(fd, build_id, sz) == (ssize_t)sz) {
+					memset(build_id + sz, 0, size - sz);
 					err = 0;
 					break;
 				}
-			} else if (read(fd, bf, descsz) != descsz)
+			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
 				break;
 		} else {
 			int n = namesz + descsz;
-- 
1.6.2.5

