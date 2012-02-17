Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2BQJyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:54:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2BQJx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:53:59 -0500
Date: Fri, 17 Feb 2012 01:53:10 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-850f8127fa3666737881aecb3b16e8ede85e58f4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1327674868-10486-5-git-send-email-jolsa@redhat.com>
References: <1327674868-10486-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add bitmap_or function into bitmap object
Git-Commit-ID: 850f8127fa3666737881aecb3b16e8ede85e58f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:53:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  850f8127fa3666737881aecb3b16e8ede85e58f4
Gitweb:     http://git.kernel.org/tip/850f8127fa3666737881aecb3b16e8ede85e58f4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 27 Jan 2012 15:34:23 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:28:10 -0200

perf tools: Add bitmap_or function into bitmap object

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
