Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0C2Uaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab0C2Uax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:30:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/7] perf probe: Use the last field name as the argument
	name
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 29 Mar 2010 16:38:04 -0400
Message-ID: <20100329203804.2577.14597.stgit@localhost6.localdomain6>
In-Reply-To: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the last field name to the argument name when the argument
is refering a data-structure member.

e.g.
 ./perf probe --add 'vfs_read file->f_mode'
 Add new event:
   probe:vfs_read       (on vfs_read with f_mode=file->f_mode)

 This probe records file->f_mode, but the argument name becomes "f_mode".

This enables perf-trace command to parse trace event format correctly.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-event.c           |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 0657cf4..d781fc5 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -87,7 +87,7 @@ Each probe argument follows below syntax.
 
  [NAME=]LOCALVAR|$retval|%REG|@SYMBOL
 
-'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), or kprobe-tracer argument format (e.g. $retval, %ax, etc).
+'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
 
 LINE SYNTAX
 -----------
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ab6f53d..19de8b7 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -481,6 +481,10 @@ static void parse_perf_probe_arg(const char *str, struct perf_probe_arg *arg)
 	} while (tmp);
 	(*fieldp)->name = xstrdup(str);
 	pr_debug("%s(%d)\n", (*fieldp)->name, (*fieldp)->ref);
+
+	/* If no name is specified, set the last field name */
+	if (!arg->name)
+		arg->name = xstrdup((*fieldp)->name);
 }
 
 /* Parse perf-probe event command */


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
