Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2FMPae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:30:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2FMP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:29:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf tools: Fix endianity swapping for adds_features bitmask
Date: Wed, 13 Jun 2012 12:29:25 -0300
Message-Id: <1339601367-17834-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1339601367-17834-1-git-send-email-acme@infradead.org>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Based on Jiri's latest attempt:
https://lkml.org/lkml/2012/5/16/61

Basically, adds_features should be byte swapped assuming unsigned
longs are either 8-bytes (u64) or 4-bytes (u32).

    Fixes 32-bit ppc dumping 64-bit x86 feature data:
     ========
     captured on: Sun May 20 19:23:23 2012
     hostname : nxos-vdc-dev3
     os release : 3.4.0-rc7+
     perf version : 3.4.rc4.137.g978da3
     arch : x86_64
     nrcpus online : 16
     nrcpus avail : 16
     cpudesc : Intel(R) Xeon(R) CPU E5540 @ 2.53GHz
     cpuid : GenuineIntel,6,26,5
     total memory : 24680324 kB
    ...

Verified 64-bit x86 can still dump feature data for 32-bit ppc.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/4FBBB539.5010805@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c               |   16 +++++++++-------
 tools/perf/util/include/linux/bitops.h |    2 ++
 tools/perf/util/session.c              |   10 ++++++++++
 tools/perf/util/session.h              |    1 +
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2dd5edf..4f9b247 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1942,7 +1942,6 @@ int perf_file_header__read(struct perf_file_header *header,
 		else
 			return -1;
 	} else if (ph->needs_swap) {
-		unsigned int i;
 		/*
 		 * feature bitmap is declared as an array of unsigned longs --
 		 * not good since its size can differ between the host that
@@ -1958,14 +1957,17 @@ int perf_file_header__read(struct perf_file_header *header,
 		 * file), punt and fallback to the original behavior --
 		 * clearing all feature bits and setting buildid.
 		 */
-		for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i)
-			header->adds_features[i] = bswap_64(header->adds_features[i]);
+		mem_bswap_64(&header->adds_features,
+			    BITS_TO_U64(HEADER_FEAT_BITS));
 
 		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
-			for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i) {
-				header->adds_features[i] = bswap_64(header->adds_features[i]);
-				header->adds_features[i] = bswap_32(header->adds_features[i]);
-			}
+			/* unswap as u64 */
+			mem_bswap_64(&header->adds_features,
+				    BITS_TO_U64(HEADER_FEAT_BITS));
+
+			/* unswap as u32 */
+			mem_bswap_32(&header->adds_features,
+				    BITS_TO_U32(HEADER_FEAT_BITS));
 		}
 
 		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index f158483..587a230 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -8,6 +8,8 @@
 #define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+#define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2600916..c3e399b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -442,6 +442,16 @@ static void perf_tool__fill_defaults(struct perf_tool *tool)
 			tool->finished_round = process_finished_round_stub;
 	}
 }
+ 
+void mem_bswap_32(void *src, int byte_size)
+{
+	u32 *m = src;
+	while (byte_size > 0) {
+		*m = bswap_32(*m);
+		byte_size -= sizeof(u32);
+		++m;
+	}
+}
 
 void mem_bswap_64(void *src, int byte_size)
 {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a5434c..0c702e3 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -80,6 +80,7 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 void mem_bswap_64(void *src, int byte_size);
+void mem_bswap_32(void *src, int byte_size);
 void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
-- 
1.7.1

