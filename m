Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2GYTa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:30:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2GYTaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:30:24 -0400
Date: Wed, 25 Jul 2012 12:30:03 -0700
From: "tip-bot for Kirill A. Shutemov" <kirill@shutemov.name>
Message-ID: <tip-4cc49d4dc82a39a542a31c1f51ead08a46fd33f1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        drepper@gmail.com, tglx@linutronix.de, kirill@shutemov.name
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, drepper@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, kirill@shutemov.name
In-Reply-To: <20120723210654.GA25248@shutemov.name>
References: <20120723210654.GA25248@shutemov.name>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  use XSI-complaint version of strerror_r() instead of GNU-specific
Git-Commit-ID: 4cc49d4dc82a39a542a31c1f51ead08a46fd33f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:30:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cc49d4dc82a39a542a31c1f51ead08a46fd33f1
Gitweb:     http://git.kernel.org/tip/4cc49d4dc82a39a542a31c1f51ead08a46fd33f1
Author:     Kirill A. Shutemov <kirill@shutemov.name>
AuthorDate: Tue, 24 Jul 2012 00:06:54 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:46:04 -0300

perf tools: use XSI-complaint version of strerror_r() instead of GNU-specific

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
 
