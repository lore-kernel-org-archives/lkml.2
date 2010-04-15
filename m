Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0DOH2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:28:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:38034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab0DOH2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:28:48 -0400
Date: Thu, 15 Apr 2010 07:28:10 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100412171700.3790.72961.stgit@localhost6.localdomain6>
References: <20100412171700.3790.72961.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Use the last field name as the argument name
Message-ID: <tip-df0faf4be02996135bc3a06b4f34360449c78084@git.kernel.org>
Git-Commit-ID: df0faf4be02996135bc3a06b4f34360449c78084
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:28:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df0faf4be02996135bc3a06b4f34360449c78084
Gitweb:     http://git.kernel.org/tip/df0faf4be02996135bc3a06b4f34360449c78084
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 12 Apr 2010 13:17:00 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:26:14 -0300

perf probe: Use the last field name as the argument name

Set the last field name to the argument name when the argument
is refering a data-structure member.

e.g.
 ./perf probe --add 'vfs_read file->f_mode'
 Add new event:
   probe:vfs_read       (on vfs_read with f_mode=file->f_mode)

 This probe records file->f_mode, but the argument name becomes "f_mode".

This enables perf-trace command to parse trace event format correctly.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100412171700.3790.72961.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-event.c           |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index e36ed4d..441324f 100644
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
