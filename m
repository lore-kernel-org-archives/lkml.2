Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2H0RCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:02:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2H0RCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:02:07 -0400
Date: Mon, 27 Aug 2012 10:01:41 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e1aa7c30c599e99b4544f9e5b4c275c8a5325bdc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, kirill@shutemov.name
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, kirill@shutemov.name
In-Reply-To: <1345618831-9148-5-git-send-email-namhyung@kernel.org>
References: <1345618831-9148-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Fix strerror_r()
  use in pevent_strerror
Git-Commit-ID: e1aa7c30c599e99b4544f9e5b4c275c8a5325bdc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:01:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1aa7c30c599e99b4544f9e5b4c275c8a5325bdc
Gitweb:     http://git.kernel.org/tip/e1aa7c30c599e99b4544f9e5b4c275c8a5325bdc
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 22 Aug 2012 16:00:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 16:04:05 -0300

tools lib traceevent: Fix strerror_r() use in pevent_strerror

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
