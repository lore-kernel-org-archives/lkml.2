Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2CAR0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:26:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:60903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2CARZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:25:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf probe: Ensure offset provided is not greater than function length without DWARF info too
Date: Thu,  1 Mar 2012 14:25:28 -0300
Message-Id: <1330622728-12759-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1330622728-12759-1-git-send-email-acme@infradead.org>
References: <1330622728-12759-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

The 'perf probe' command allows kprobe to be inserted at any offset from
a function start, which results in adding kprobes to unintended
location.  (example: perf probe do_fork+10000 is allowed even though
size of do_fork is ~904).

My previous patch https://lkml.org/lkml/2012/2/24/42 addressed the case
where DWARF info was available for the kernel. This patch fixes the
case where perf probe is used on a kernel without debuginfo available.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F4C544D.1010909@linux.vnet.ibm.com
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29cb654..e33554a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1867,6 +1867,12 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 			   tev->point.symbol);
 		ret = -ENOENT;
 		goto error;
+	} else if (tev->point.offset > sym->end - sym->start) {
+		pr_warning("Offset specified is greater than size of %s\n",
+			   tev->point.symbol);
+		ret = -ENOENT;
+		goto error;
+
 	}
 
 	return 1;
-- 
1.7.9.123.g65da0

