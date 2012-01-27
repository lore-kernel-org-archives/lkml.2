Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2A0OfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:35:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab2A0Oe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:34:59 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/9] perf, tool: Add bitmap_or function into bitmap object
Date: Fri, 27 Jan 2012 15:34:23 +0100
Message-Id: <1327674868-10486-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1327674868-10486-1-git-send-email-jolsa@redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding implementation os bitmap_or function to the bitmap
object. It is stolen from the kernel lib/bitmap.o object.

It is used in upcomming patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.4.4

