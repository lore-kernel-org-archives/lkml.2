Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab2JWNqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:46:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45670 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2JWNqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:46:01 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf tools: Fix strbuf_addf() when the buffer needs to grow
Date: Tue, 23 Oct 2012 22:44:50 +0900
Message-Id: <1350999890-6920-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1350999890-6920-1-git-send-email-namhyung@kernel.org>
References: <20121023072702.GB2772@turtle.usersys.redhat.com>
 <1350999890-6920-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was found during chasing down the header output regression.
The strbuf_addf() was checking buffer length with a result of
vscnprintf() which cannot be greater than that of strbuf_avail().

Since numa topology and pmu mapping info in header were converted
to use strbuf, it sometimes caused uninteresting behaviors with the
broken strbuf.

Fix it by using vsnprintf() which returns desired output string
length regardless of the available buffer size and grow the buffer
if needed.

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/strbuf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 2eeb51baf077..cfa906882e2c 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -90,17 +90,17 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 	if (!strbuf_avail(sb))
 		strbuf_grow(sb, 64);
 	va_start(ap, fmt);
-	len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 	va_end(ap);
 	if (len < 0)
-		die("your vscnprintf is broken");
+		die("your vsnprintf is broken");
 	if (len > strbuf_avail(sb)) {
 		strbuf_grow(sb, len);
 		va_start(ap, fmt);
-		len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 		va_end(ap);
 		if (len > strbuf_avail(sb)) {
-			die("this should not happen, your snprintf is broken");
+			die("this should not happen, your vsnprintf is broken");
 		}
 	}
 	strbuf_setlen(sb, sb->len + len);
-- 
1.7.9.2

