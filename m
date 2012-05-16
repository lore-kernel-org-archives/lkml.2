Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2EPG7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759468Ab2EPG7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:59:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/7] perf, tool: Fix endianity trick for adds_features bitmask
Date: Wed, 16 May 2012 08:59:07 +0200
Message-Id: <1337151548-2396-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addons bitmask is stored as array of unsigned long values. The size
of the unsigned long is same as pointer size for architecture, so it
could differ for each architecture.

To handle the endianity for adds_features bitmask, we first swap the
bitmaks as u64 values and check for HEADER_HOSTNAME bit. If not set we
want to unswap the u64 values and swap the adds_features as u32 values.

This is currently buggy, since we swap just first 32bits of each u64
value. Adding swap of the next 32 bits as well.  Also adding & using
BITS_TO_U64 instead of BITS_TO_LONGS as counter max due to the different
size of unsigned longs per architecture.

Note, running following to test perf endianity handling:
test 1)
  - origin system:
    # perf record -a -- sleep 10 (any perf record will do)
    # perf report > report.origin
    # perf archive perf.data

  - copy the perf.data, report.origin and perf.data.tar.bz2
    to a target system and run:
    # tar xjvf perf.data.tar.bz2 -C ~/.debug
    # perf report > report.target
    # diff -u report.origin report.target

  - the diff should produce no output
    (besides some white space stuff and possibly different
     date/TZ output)

test 2)
  - origin system:
    # perf record -ag -fo /tmp/perf.data -- sleep 1
  - mount origin system root to the target system on /mnt/origin
  - target system:
    # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
     --kallsyms /mnt/origin/proc/kallsyms
  - complete perf.data header is displayed

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/header.c               |   21 ++++++++++++++++-----
 tools/perf/util/include/linux/bitops.h |    1 +
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5385980..f336f0a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1958,13 +1958,24 @@ int perf_file_header__read(struct perf_file_header *header,
 		 * file), punt and fallback to the original behavior --
 		 * clearing all feature bits and setting buildid.
 		 */
-		for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i)
-			header->adds_features[i] = bswap_64(header->adds_features[i]);
+
+		mem_bswap_64(&header->adds_features,
+			     BITS_TO_U64(HEADER_FEAT_BITS));
 
 		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
-			for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i) {
-				header->adds_features[i] = bswap_64(header->adds_features[i]);
-				header->adds_features[i] = bswap_32(header->adds_features[i]);
+			union {
+				union u64_swap *p;
+				unsigned long *adds_features;
+			} feat;
+
+			feat.adds_features = &header->adds_features[0];
+
+			for (i = 0; i < BITS_TO_U64(HEADER_FEAT_BITS); ++i) {
+				union u64_swap *u = &feat.p[i];
+
+				u->val64 = bswap_64(u->val64);
+				u->val32[0] = bswap_32(u->val32[0]);
+				u->val32[1] = bswap_32(u->val32[1]);
 			}
 		}
 
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index f1584833..10096cb 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -8,6 +8,7 @@
 #define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
-- 
1.7.7.6

