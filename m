Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2GYRlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:41:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:45482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab2GYRlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/19] perf tools: use XSI-complaint version of strerror_r() instead of GNU-specific
Date: Wed, 25 Jul 2012 14:41:30 -0300
Message-Id: <1343238094-12481-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Perf uses GNU-specific version of strerror_r(). The GNU-specific strerror_r()
returns a pointer to a string containing the error message.  This may be either
a pointer to a string that the function stores in buf, or a pointer to some
(immutable) static string (in which case buf is unused).

In glibc-2.16 GNU version was marked with attribute warn_unused_result.  It
triggers few warnings in perf:

util/target.c: In function ‘perf_target__strerror’:
util/target.c:114:13: error: ignoring return value of ‘strerror_r’, declared with attribute warn_unused_result [-Werror=unused-result]
ui/browsers/hists.c: In function ‘hist_browser__dump’:
ui/browsers/hists.c:981:13: error: ignoring return value of ‘strerror_r’, declared with attribute warn_unused_result [-Werror=unused-result]

They are bugs.

Let's fix strerror_r() usage.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Ulrich Drepper <drepper@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/20120723210654.GA25248@shutemov.name
[ committer note: s/assert/BUG_ON/g ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |    4 ++--
 tools/perf/util/target.c       |   11 ++++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 482f051..413bd62 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -978,8 +978,8 @@ static int hist_browser__dump(struct hist_browser *browser)
 	fp = fopen(filename, "w");
 	if (fp == NULL) {
 		char bf[64];
-		strerror_r(errno, bf, sizeof(bf));
-		ui_helpline__fpush("Couldn't write to %s: %s", filename, bf);
+		const char *err = strerror_r(errno, bf, sizeof(bf));
+		ui_helpline__fpush("Couldn't write to %s: %s", filename, err);
 		return -1;
 	}
 
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 1064d5b..3f59c49 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -110,8 +110,17 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 	int idx;
 	const char *msg;
 
+	BUG_ON(buflen > 0);
+
 	if (errnum >= 0) {
-		strerror_r(errnum, buf, buflen);
+		const char *err = strerror_r(errnum, buf, buflen);
+
+		if (err != buf) {
+			size_t len = strlen(err);
+			char *c = mempcpy(buf, err, min(buflen - 1, len));
+			*c = '\0';
+		}
+
 		return 0;
 	}
 
-- 
1.7.1

