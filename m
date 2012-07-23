Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2GWVGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:06:05 -0400
Received: from shutemov.name ([176.9.204.213]:44246 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab2GWVGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:06:03 -0400
Date: Tue, 24 Jul 2012 00:06:54 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf: use XSI-complaint version of strerror_r()
 instead of GNU-specific
Message-ID: <20120723210654.GA25248@shutemov.name>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
 <1343055645-24083-2-git-send-email-kirill@shutemov.name>
 <CAOPLpQe7=Gv7ToM8cqe1rNCP+vX5=gVppA1=gfaO0LSdqMhqMQ@mail.gmail.com>
 <20120723203120.GA25072@shutemov.name>
 <CAOPLpQdcSw6KGT=odFSAUScd44mUdkYpR6hQM_zg81Y88T=VHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOPLpQdcSw6KGT=odFSAUScd44mUdkYpR6hQM_zg81Y88T=VHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 04:48:22PM -0400, Ulrich Drepper wrote:
> On Mon, Jul 23, 2012 at 4:31 PM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
> > +               const char *err = strerror_r(errnum, buf, buflen);
> > +
> > +               if (err != buf && buflen > 0) {
> > +                       size_t len = strlen(err);
> > +                       char *c = mempcpy(buf, err, min(buflen - 1, len));
> > +                       *c = '\0';
> > +               }
> 
> No need to check for err == NULL.

There's no such check.

> buflen == 0 is a possibility given
> the interface but I'd say this is an error and should be tested for at
> the beginning of the function and the call should fail or even abort
> the program.

>From 11d62205ee3c534aa9b0e9a24a312438ac726ffb Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Mon, 23 Jul 2012 17:41:05 +0300
Subject: [PATCH 2/2] perf: fix strerror_r() usage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Perf uses GNU-specific version of strerror_r(). The GNU-specific
strerror_r() returns a pointer to a string containing the error message.
This may be either a pointer to a string that the function stores in
buf, or a pointer to some (immutable) static string (in which case buf
is unused).

In glibc-2.16 GNU version was marked with attribute warn_unused_result.
It triggers few warnings in perf:

util/target.c: In function ‘perf_target__strerror’:
util/target.c:114:13: error: ignoring return value of ‘strerror_r’, declared with attribute warn_unused_result [-Werror=unused-result]
ui/browsers/hists.c: In function ‘hist_browser__dump’:
ui/browsers/hists.c:981:13: error: ignoring return value of ‘strerror_r’, declared with attribute warn_unused_result [-Werror=unused-result]

They are bugs.

Let's fix strerror_r() usage.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 tools/perf/ui/browsers/hists.c |  4 ++--
 tools/perf/util/target.c       | 12 +++++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

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
index 1064d5b..5c4b3b1 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -9,6 +9,7 @@
 #include "target.h"
 #include "debug.h"
 
+#include <assert.h>
 #include <pwd.h>
 #include <string.h>
 
@@ -110,8 +111,17 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 	int idx;
 	const char *msg;
 
+	assert(buflen > 0);
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
 Kirill A. Shutemov
