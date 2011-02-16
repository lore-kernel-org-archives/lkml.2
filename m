Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1BPWzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:55:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:60613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab1BPWzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:55:02 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Franck Bui-Huu <fbuihuu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] perf probe: Support function@filename syntax for --line
Date: Wed, 16 Feb 2011 20:54:46 -0200
Message-Id: <1297896887-9983-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297896887-9983-1-git-send-email-acme@infradead.org>
References: <1297896887-9983-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.6.2.5

