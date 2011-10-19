Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1JSSYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:24:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:33418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1JSSXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/7] perf tools: handle endianness of feature bitmap
Date: Wed, 19 Oct 2011 16:23:36 -0200
Message-Id: <1319048618-9790-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319048618-9790-1-git-send-email-acme@infradead.org>
References: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Feature bitmap is declared as an array of unsigned longs -- not good
since its size can differ between the host that generated the data file
and the host analyzing the file.

We need to handle endianness, but we don't know the size of the unsigned
long where the file was generated. Take a best guess at determining it:
try 64-bit swap first (ie., file created on a 64-bit host), and check if
the hostname feature bit is set (this feature bit is forced on as of
fbe96f2).  If the bit is not, undo the 64-bit swap and try a 32-bit
swap. If the hostname bit is still not set (e.g., older data file), punt
and fallback to the original behavior -- clearing all feature bits and
setting buildid.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1318980841-12616-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   42 +++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3724707..6a9c041 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1703,21 +1703,41 @@ int perf_file_header__read(struct perf_file_header *header,
 			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
 		else
 			return -1;
+	} else if (ph->needs_swap) {
+		unsigned int i;
+		/*
+		 * feature bitmap is declared as an array of unsigned longs --
+		 * not good since its size can differ between the host that
+		 * generated the data file and the host analyzing the file.
+		 *
+		 * We need to handle endianness, but we don't know the size of
+		 * the unsigned long where the file was generated. Take a best
+		 * guess at determining it: try 64-bit swap first (ie., file
+		 * created on a 64-bit host), and check if the hostname feature
+		 * bit is set (this feature bit is forced on as of fbe96f2).
+		 * If the bit is not, undo the 64-bit swap and try a 32-bit
+		 * swap. If the hostname bit is still not set (e.g., older data
+		 * file), punt and fallback to the original behavior --
+		 * clearing all feature bits and setting buildid.
+		 */
+		for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i)
+			header->adds_features[i] = bswap_64(header->adds_features[i]);
+
+		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
+			for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i) {
+				header->adds_features[i] = bswap_64(header->adds_features[i]);
+				header->adds_features[i] = bswap_32(header->adds_features[i]);
+			}
+		}
+
+		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
+			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
+			set_bit(HEADER_BUILD_ID, header->adds_features);
+		}
 	}
 
 	memcpy(&ph->adds_features, &header->adds_features,
 	       sizeof(ph->adds_features));
-	/*
-	 * FIXME: hack that assumes that if we need swap the perf.data file
-	 * may be coming from an arch with a different word-size, ergo different
-	 * DEFINE_BITMAP format, investigate more later, but for now its mostly
-	 * safe to assume that we have a build-id section. Trace files probably
-	 * have several other issues in this realm anyway...
-	 */
-	if (ph->needs_swap) {
-		memset(&ph->adds_features, 0, sizeof(ph->adds_features));
-		perf_header__set_feat(ph, HEADER_BUILD_ID);
-	}
 
 	ph->event_offset = header->event_types.offset;
 	ph->event_size   = header->event_types.size;
-- 
1.6.2.5

