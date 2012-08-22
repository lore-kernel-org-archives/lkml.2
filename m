Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2HVHH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:07:58 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59969 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2HVHHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:07:24 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-03-50348527e79f
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 4/4] tools lib traceevent: Fix strerror_r() use in pevent_strerror
Date: Wed, 22 Aug 2012 16:00:31 +0900
Message-Id: <1345618831-9148-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345618831-9148-1-git-send-email-namhyung@kernel.org>
References: <1345618831-9148-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

glibc-2.16 starts to mark the function with attribute
warn_unused_result so that it can cause a build warning.

Since GNU version of strerror_r() can return a pointer to a string
without setting @buf, check the return value and copy/truncate it to
our buffer if needed.

Cc: Fredereic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 7 ++++++-
 tools/lib/traceevent/event-utils.h | 6 ++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1373e4cf109e..f978c59f67bf 100644
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
index 08296383d1e6..bc075006966e 100644
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
1.7.11.4

