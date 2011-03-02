Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1CBIll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:41:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:45268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1CBIlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:41:40 -0500
Date: Wed, 2 Mar 2011 08:41:13 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tui: Make ui__warning modal
Message-ID: <tip-a1ceb741cf86ef433006379742db81c00b450bae@git.kernel.org>
Git-Commit-ID: a1ceb741cf86ef433006379742db81c00b450bae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 08:41:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1ceb741cf86ef433006379742db81c00b450bae
Gitweb:     http://git.kernel.org/tip/a1ceb741cf86ef433006379742db81c00b450bae
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Mar 2011 10:24:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 1 Mar 2011 10:24:43 -0300

perf tui: Make ui__warning modal

By taking the ui__lock so that no other screen updates take place while
waiting for the user.

That was happening when handling an invalid --vmlinux parameter in 'perf
top --tui', with the screen refresh routine repainting the screen and
removing the warning window.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/util.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 7b5a892..fdf1fc8 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -9,6 +9,7 @@
 #include "../debug.h"
 #include "browser.h"
 #include "helpline.h"
+#include "ui.h"
 #include "util.h"
 
 static void newt_form__set_exit_keys(newtComponent self)
@@ -118,10 +119,12 @@ void ui__warning(const char *format, ...)
 	va_list args;
 
 	va_start(args, format);
-	if (use_browser > 0)
+	if (use_browser > 0) {
+		pthread_mutex_lock(&ui__lock);
 		newtWinMessagev((char *)warning_str, (char *)ok,
 				(char *)format, args);
-	else
+		pthread_mutex_unlock(&ui__lock);
+	} else
 		vfprintf(stderr, format, args);
 	va_end(args);
 }
