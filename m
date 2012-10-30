Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab2J3NCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:02:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:55796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2J3NCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf tools: Fix strbuf_addf() when the buffer needs to grow
Date: Tue, 30 Oct 2012 11:02:39 -0200
Message-Id: <1351602159-10340-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351602159-10340-1-git-send-email-acme@infradead.org>
References: <1351602159-10340-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

This was found during chasing down the header output regression.  The
strbuf_addf() was checking buffer length with a result of vscnprintf()
which cannot be greater than that of strbuf_avail().

Since numa topology and pmu mapping info in header were converted to use
strbuf, it sometimes caused uninteresting behaviors with the broken
strbuf.

Fix it by using vsnprintf() which returns desired output string length
regardless of the available buffer size and grow the buffer if needed.

Reported-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andrew Jones <drjones@redhat.com>
Link: http://lkml.kernel.org/r/1350999890-6920-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/strbuf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 2eeb51b..cfa9068 100644
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
1.7.9.2.358.g22243

