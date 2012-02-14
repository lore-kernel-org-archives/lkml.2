Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2BNByH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:54:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:45738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab2BNBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/16] perf tools: Add bitmap_or function into bitmap object
Date: Mon, 13 Feb 2012 23:52:52 -0200
Message-Id: <1329184375-27911-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding implementation os bitmap_or function to the bitmap object. It is
stolen from the kernel lib/bitmap.o object.

It is used in upcomming patches.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1327674868-10486-5-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/bitmap.c               |   10 ++++++++++
 tools/perf/util/include/linux/bitmap.h |   11 +++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/bitmap.c b/tools/perf/util/bitmap.c
index 5e230ac..0a1adc1 100644
--- a/tools/perf/util/bitmap.c
+++ b/tools/perf/util/bitmap.c
@@ -19,3 +19,13 @@ int __bitmap_weight(const unsigned long *bitmap, int bits)
 
 	return w;
 }
+
+void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
+		 const unsigned long *bitmap2, int bits)
+{
+	int k;
+	int nr = BITS_TO_LONGS(bits);
+
+	for (k = 0; k < nr; k++)
+		dst[k] = bitmap1[k] | bitmap2[k];
+}
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
index eda4416..bb162e4 100644
--- a/tools/perf/util/include/linux/bitmap.h
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -5,6 +5,8 @@
 #include <linux/bitops.h>
 
 int __bitmap_weight(const unsigned long *bitmap, int bits);
+void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
+		 const unsigned long *bitmap2, int bits);
 
 #define BITMAP_LAST_WORD_MASK(nbits)					\
 (									\
@@ -32,4 +34,13 @@ static inline int bitmap_weight(const unsigned long *src, int nbits)
 	return __bitmap_weight(src, nbits);
 }
 
+static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
+			     const unsigned long *src2, int nbits)
+{
+	if (small_const_nbits(nbits))
+		*dst = *src1 | *src2;
+	else
+		__bitmap_or(dst, src1, src2, nbits);
+}
+
 #endif /* _PERF_BITOPS_H */
-- 
1.7.9.123.g65da0

