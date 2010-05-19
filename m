Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0ESA2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:28:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:50881 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0ESA2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:28:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/5] perf probe: Don't call die()
Date: Tue, 18 May 2010 21:28:00 -0300
Message-Id: <1274228881-8035-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274228881-8035-1-git-send-email-acme@infradead.org>
References: <1274228881-8035-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Functions that were calling xzalloc also returned -1 when, for other
reasons, it could fail, and the calleds are coping with failures, so
stop using die() and xzalloc().

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 61c6d70..99b1728 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -65,8 +65,10 @@ static int parse_probe_event(const char *str)
 	int ret;
 
 	pr_debug("probe-definition(%d): %s\n", params.nevents, str);
-	if (++params.nevents == MAX_PROBES)
-		die("Too many probes (> %d) are specified.", MAX_PROBES);
+	if (++params.nevents == MAX_PROBES) {
+		pr_err("Too many probes (> %d) were specified.", MAX_PROBES);
+		return -1;
+	}
 
 	/* Parse a perf-probe command into event */
 	ret = parse_perf_probe_command(str, pev);
@@ -84,7 +86,9 @@ static int parse_probe_event_argv(int argc, const char **argv)
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += strlen(argv[i]) + 1;
-	buf = xzalloc(len + 1);
+	buf = zalloc(len + 1);
+	if (buf == NULL)
+		return -1;
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += sprintf(&buf[len], "%s ", argv[i]);
-- 
1.6.2.5

