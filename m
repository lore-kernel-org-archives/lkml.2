Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab2KNG2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:28:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2KNG2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:28:22 -0500
Date: Tue, 13 Nov 2012 22:28:09 -0800
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-f787d9519fb10411f2948f5b9957a1669879ba84@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, drjones@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, drjones@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1350999890-6920-2-git-send-email-namhyung@kernel.org>
References: <1350999890-6920-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix strbuf_addf()
  when the buffer needs to grow
Git-Commit-ID: f787d9519fb10411f2948f5b9957a1669879ba84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:28:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f787d9519fb10411f2948f5b9957a1669879ba84
Gitweb:     http://git.kernel.org/tip/f787d9519fb10411f2948f5b9957a1669879ba84
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 23 Oct 2012 22:44:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Oct 2012 10:32:56 -0200

perf tools: Fix strbuf_addf() when the buffer needs to grow

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
 1 files changed, 4 insertions(+), 4 deletions(-)

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
