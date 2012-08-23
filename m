Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2HWPKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:10:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:57459 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2HWPK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/12] tools lib traceevent: Fix strerror_r() use in pevent_strerror
Date: Thu, 23 Aug 2012 12:09:55 -0300
Message-Id: <1345734596-7601-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345734596-7601-1-git-send-email-acme@infradead.org>
References: <1345734596-7601-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

glibc-2.16 starts to mark the function with attribute warn_unused_result
so that it can cause a build warning.

Since GNU version of strerror_r() can return a pointer to a string
without setting @buf, check the return value and copy/truncate it to our
buffer if needed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1345618831-9148-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    7 ++++++-
 tools/lib/traceevent/event-utils.h |    6 ++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1373e4c..f978c59 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4809,7 +4809,12 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
 	const char *msg;
 
 	if (errnum >= 0) {
-		strerror_r(errnum, buf, buflen);
+		msg = strerror_r(errnum, buf, buflen);
+		if (msg != buf) {
+			size_t len = strlen(msg);
+			char *c = mempcpy(buf, msg, min(buflen-1, len));
+			*c = '\0';
+		}
 		return 0;
 	}
 
diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
index 0829638..bc07500 100644
--- a/tools/lib/traceevent/event-utils.h
+++ b/tools/lib/traceevent/event-utils.h
@@ -39,6 +39,12 @@ void __vdie(const char *fmt, ...);
 void __vwarning(const char *fmt, ...);
 void __vpr_stat(const char *fmt, ...);
 
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
 static inline char *strim(char *string)
 {
 	char *ret;
-- 
1.7.1

