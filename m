Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1BJJPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:15:25 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58020 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1BJJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:15:20 -0500
X-AuditID: b753bd60-a1d49ba0000001d0-ef-4d53aca64d34
X-AuditID: b753bd60-a1d49ba0000001d0-ef-4d53aca64d34
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 1/2] perf probe: Support function@filename
	syntax for --line
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Feb 2011 18:08:10 +0900
Message-ID: <20110210090810.1809.26913.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110210090754.1809.36678.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110210090754.1809.36678.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since "perf probe --add" supports function@filename syntax,
--line option should also support it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
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

