Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2LTJOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:14:20 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47725 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2LTJOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:14:15 -0500
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 2/5] perf tools: Add xyarray__realloc function in xyarray.c to expend xyarray.
Date: Thu, 20 Dec 2012 17:05:50 +0800
Message-Id: <1355994350-13622-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xyarray__realloc() could be used if we wish extend the evsel->fd,
evsel->sample_id or any other xyarray on-the-fly.

Cc: David Ahern <dsahern@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
---
 tools/perf/util/xyarray.c |   26 ++++++++++++++++++++++++++
 tools/perf/util/xyarray.h |    2 ++
 2 files changed, 28 insertions(+)

diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
index 22afbf6..4e76377 100644
--- a/tools/perf/util/xyarray.c
+++ b/tools/perf/util/xyarray.c
@@ -18,3 +18,29 @@ void xyarray__delete(struct xyarray *xy)
 {
 	free(xy);
 }
+
+int xyarray__realloc(struct xyarray **xy_old, int xlen_old, int xlen_new,
+		      int ylen_new)
+{
+	size_t row_size_new = ylen_new * (*xy_old)->entry_size;
+	struct xyarray *xy_new = zalloc(sizeof(*xy_new) + xlen_new
+					* row_size_new);
+	int x;
+
+	if (xy_new != NULL) {
+		for (x = 0; x < xlen_old; x++)
+			memcpy(&xy_new->contents[x * row_size_new],
+			       &((*xy_old)->contents[x * (*xy_old)->row_size]),
+			       (*xy_old)->row_size);
+
+		xy_new->row_size = row_size_new;
+		xy_new->entry_size = (*xy_old)->entry_size;
+
+		xyarray__delete(*xy_old);
+
+		*xy_old = xy_new;
+
+		return 0;
+	}
+
+	return -1;
+}
+
diff --git a/tools/perf/util/xyarray.h b/tools/perf/util/xyarray.h
index c488a07..ad41649 100644
--- a/tools/perf/util/xyarray.h
+++ b/tools/perf/util/xyarray.h
@@ -11,6 +11,8 @@ struct xyarray {
 
 struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size);
 void xyarray__delete(struct xyarray *xy);
+int xyarray__realloc(struct xyarray **xy_old, int xlen_old, int xlen_new,
+		     int ylen_new);
 
 static inline void *xyarray__entry(struct xyarray *xy, int x, int y)
 {
-- 
1.7.9.5

