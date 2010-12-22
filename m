Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0LVLbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:31:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:34748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab0LVLbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:31:51 -0500
Date: Wed, 22 Dec 2010 11:31:35 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1292854685-8230-5-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-5-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix line range description since a single file is allowed
Message-ID: <tip-9d95b580a8d64ef4d1660a21a9de0658fe29f041@git.kernel.org>
Git-Commit-ID: 9d95b580a8d64ef4d1660a21a9de0658fe29f041
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:31:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d95b580a8d64ef4d1660a21a9de0658fe29f041
Gitweb:     http://git.kernel.org/tip/9d95b580a8d64ef4d1660a21a9de0658fe29f041
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Mon, 20 Dec 2010 15:18:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 16:20:12 -0200

perf probe: Fix line range description since a single file is allowed

	$ perf-probe -L sched.c

is currently allowed but not documented.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1292854685-8230-5-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-event.c           |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 4e23232..86b797a 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -117,7 +117,7 @@ LINE SYNTAX
 -----------
 Line range is described by following syntax.
 
- "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]"
+ "FUNC[:RLN[+NUM|-RLN2]]|SRC[:ALN[+NUM|-ALN2]]"
 
 FUNC specifies the function name of showing lines. 'RLN' is the start line
 number from function entry line, and 'RLN2' is the end line number. As same as
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b812f14..3ba9c53 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -515,15 +515,18 @@ int show_available_vars(struct perf_probe_event *pevs __unused,
 }
 #endif
 
+/*
+ * Stuff 'lr' according to the line range described by 'arg'.
+ * The line range syntax is described by:
+ *
+ *         SRC[:SLN[+NUM|-ELN]]
+ *         FNC[:SLN[+NUM|-ELN]]
+ */
 int parse_line_range_desc(const char *arg, struct line_range *lr)
 {
 	const char *ptr;
 	char *tmp;
-	/*
-	 * <Syntax>
-	 * SRC:SLN[+NUM|-ELN]
-	 * FUNC[:SLN[+NUM|-ELN]]
-	 */
+
 	ptr = strchr(arg, ':');
 	if (ptr) {
 		lr->start = (int)strtoul(ptr + 1, &tmp, 0);
