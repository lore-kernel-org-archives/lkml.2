Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1JRXeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 19:34:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60635 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1JRXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 19:34:09 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, eranian@google.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: handle endianness of feature bitmap
Date: Tue, 18 Oct 2011 17:34:01 -0600
Message-Id: <1318980841-12616-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feature bitmap is declared as an array of unsigned longs --
not good since its size can differ between the host that
generated the data file and the host analyzing the file.

We need to handle endianness, but we don't know the size of
the unsigned long where the file was generated. Take a best
guess at determining it: try 64-bit swap first (ie., file
created on a 64-bit host), and check if the hostname feature
bit is set (this feature bit is forced on as of fbe96f2).
If the bit is not, undo the 64-bit swap and try a 32-bit
swap. If the hostname bit is still not set (e.g., older data
file), punt and fallback to the original behavior --
clearing all feature bits and setting buildid.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/header.c |   42 +++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2143a32..65627a3 100644
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
1.7.6.4

