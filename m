Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab1BQPFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:05:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:60666 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab1BQPFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:05:04 -0500
Date: Thu, 17 Feb 2011 15:04:32 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110210090810.1809.26913.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110210090810.1809.26913.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Support function@filename syntax for --line
Message-ID: <tip-e116dfa1c357da49f55e1555767ec991225a8321@git.kernel.org>
Git-Commit-ID: e116dfa1c357da49f55e1555767ec991225a8321
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:04:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e116dfa1c357da49f55e1555767ec991225a8321
Gitweb:     http://git.kernel.org/tip/e116dfa1c357da49f55e1555767ec991225a8321
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 10 Feb 2011 18:08:10 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Feb 2011 17:03:23 -0200

perf probe: Support function@filename syntax for --line

Since "perf probe --add" supports function@filename syntax, --line
option should also support it.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
LKML-Reference: <20110210090810.1809.26913.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    7 ++++---
 tools/perf/util/probe-event.c           |   15 ++++++++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 81c3220..02bafce 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -16,7 +16,7 @@ or
 or
 'perf probe' --list
 or
-'perf probe' [options] --line='FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]'
+'perf probe' [options] --line='LINE'
 or
 'perf probe' [options] --vars='PROBEPOINT'
 
@@ -128,13 +128,14 @@ LINE SYNTAX
 -----------
 Line range is described by following syntax.
 
- "FUNC[:RLN[+NUM|-RLN2]]|SRC[:ALN[+NUM|-ALN2]]"
+ "FUNC[@SRC][:RLN[+NUM|-RLN2]]|SRC[:ALN[+NUM|-ALN2]]"
 
 FUNC specifies the function name of showing lines. 'RLN' is the start line
 number from function entry line, and 'RLN2' is the end line number. As same as
 probe syntax, 'SRC' means the source file path, 'ALN' is start line number,
 and 'ALN2' is end line number in the file. It is also possible to specify how
-many lines to show by using 'NUM'.
+many lines to show by using 'NUM'. Moreover, 'FUNC@SRC' combination is good
+for searching a specific function when several functions share same name.
 So, "source.c:100-120" shows lines between 100th to l20th in source.c file. And "func:10+20" shows 20 lines from 10th line of func function.
 
 LAZY MATCHING
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9d237e3..cbd7650 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -595,11 +595,11 @@ static int parse_line_num(char **ptr, int *val, const char *what)
  * The line range syntax is described by:
  *
  *         SRC[:SLN[+NUM|-ELN]]
- *         FNC[:SLN[+NUM|-ELN]]
+ *         FNC[@SRC][:SLN[+NUM|-ELN]]
  */
 int parse_line_range_desc(const char *arg, struct line_range *lr)
 {
-	char *range, *name = strdup(arg);
+	char *range, *file, *name = strdup(arg);
 	int err;
 
 	if (!name)
@@ -649,7 +649,16 @@ int parse_line_range_desc(const char *arg, struct line_range *lr)
 		}
 	}
 
-	if (strchr(name, '.'))
+	file = strchr(name, '@');
+	if (file) {
+		*file = '\0';
+		lr->file = strdup(++file);
+		if (lr->file == NULL) {
+			err = -ENOMEM;
+			goto err;
+		}
+		lr->function = name;
+	} else if (strchr(name, '.'))
 		lr->file = name;
 	else
 		lr->function = name;
