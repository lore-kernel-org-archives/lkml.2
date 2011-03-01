Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab1CAREZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:04:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:49689 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab1CAREW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:04:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/6] perf tui: Make ui__warning modal
Date: Tue,  1 Mar 2011 14:03:45 -0300
Message-Id: <1298999027-30673-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298999027-30673-1-git-send-email-acme@infradead.org>
References: <1298999027-30673-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

