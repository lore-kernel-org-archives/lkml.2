Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1JTNGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:06:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1JTNGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:06:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf hists browser: Elide DSO column when it is set to just one DSO, ditto for threads
Date: Thu, 20 Oct 2011 11:05:48 -0200
Message-Id: <1319115948-12060-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319115948-12060-1-git-send-email-acme@infradead.org>
References: <1319115948-12060-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And also no leed to show the [.] (level: k, . for userspace) when
showing just one DSO.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4h3f6ro5o7ebepjbssxf0dd3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c              |    4 +++-
 tools/perf/util/ui/browsers/hists.c |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1ee8f1e..16da30d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -177,7 +177,9 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 				       BITS_PER_LONG / 4, self->ip, o);
 	}
 
-	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
+	if (!sort_dso.elide)
+		ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
+
 	if (self->ms.sym)
 		ret += repsep_snprintf(bf + ret, size - ret, "%s",
 				       self->ms.sym->name);
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 9e23bce..a06e7d9 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -1007,12 +1007,14 @@ zoom_dso:
 zoom_out_dso:
 				ui_helpline__pop();
 				browser->hists->dso_filter = NULL;
+				sort_dso.elide = false;
 			} else {
 				if (dso == NULL)
 					continue;
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
 				browser->hists->dso_filter = dso;
+				sort_dso.elide = true;
 				pstack__push(fstack, &browser->hists->dso_filter);
 			}
 			hists__filter_by_dso(self);
@@ -1024,11 +1026,13 @@ zoom_thread:
 zoom_out_thread:
 				ui_helpline__pop();
 				browser->hists->thread_filter = NULL;
+				sort_thread.elide = false;
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread->comm : "",
 						   thread->pid);
 				browser->hists->thread_filter = thread;
+				sort_thread.elide = true;
 				pstack__push(fstack, &browser->hists->thread_filter);
 			}
 			hists__filter_by_thread(self);
-- 
1.6.2.5

