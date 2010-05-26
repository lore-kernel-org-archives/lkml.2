Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099Ab0EZVbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:31:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:43397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab0EZVbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:31:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf tui: Reset use_browser if stdout is not a tty
Date: Wed, 26 May 2010 18:30:48 -0300
Message-Id: <1274909449-10977-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274909449-10977-1-git-send-email-acme@infradead.org>
References: <1274909449-10977-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The newt initialization routines weren't being called because the output
was a file (perf annotate > /tmp/bla) but use_browser was still 1,
because ~/.perfconfig had it as 'on', so, later on newt routines
segfaulted.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/util/newt.c        |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 08278ed..96db524 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -343,7 +343,7 @@ find_next:
 			continue;
 		}
 
-		if (use_browser) {
+		if (use_browser > 0) {
 			key = hist_entry__tui_annotate(he);
 			if (is_exit_key(key))
 				break;
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index d54c540..cf182ca 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -1139,6 +1139,7 @@ void setup_browser(void)
 	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
 
 	if (!isatty(1) || !use_browser || dump_trace) {
+		use_browser = 0;
 		setup_pager();
 		return;
 	}
-- 
1.6.2.5

