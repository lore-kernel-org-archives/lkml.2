Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2DGUzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:55:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:46278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2DGUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:54:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf ui annotate browser: Move callq handling to separate function
Date: Sat,  7 Apr 2012 17:54:05 -0300
Message-Id: <1333832049-2399-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333832049-2399-1-git-send-email-acme@infradead.org>
References: <1333832049-2399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can as well handle jumps. Later we'll move this to a proper
intruction table, etc.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-i98elvmix2cw6t8stu1iagfd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |   94 ++++++++++++++++----------------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 5cf9b78..dbf8d3f 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -245,6 +245,50 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 	return true;
 }
 
+static bool annotate_browser__callq(struct annotate_browser *browser,
+				    int evidx, void (*timer)(void *arg),
+				    void *arg, int delay_secs)
+{
+	struct map_symbol *ms = browser->b.priv;
+	struct symbol *sym = ms->sym;
+	struct annotation *notes;
+	struct symbol *target;
+	char *s = strstr(browser->selection->line, "callq ");
+	u64 ip;
+
+	if (s == NULL)
+		return false;
+
+	s = strchr(s, ' ');
+	if (s++ == NULL) {
+		ui_helpline__puts("Invallid callq instruction.");
+		return true;
+	}
+
+	ip = strtoull(s, NULL, 16);
+	ip = ms->map->map_ip(ms->map, ip);
+	target = map__find_symbol(ms->map, ip, NULL);
+	if (target == NULL) {
+		ui_helpline__puts("The called function was not found.");
+		return true;
+	}
+
+	notes = symbol__annotation(target);
+	pthread_mutex_lock(&notes->lock);
+
+	if (notes->src == NULL && symbol__alloc_hist(target) < 0) {
+		pthread_mutex_unlock(&notes->lock);
+		ui__warning("Not enough memory for annotating '%s' symbol!\n",
+			    target->name);
+		return true;
+	}
+
+	pthread_mutex_unlock(&notes->lock);
+	symbol__tui_annotate(target, ms->map, evidx, timer, arg, delay_secs);
+	ui_browser__show_title(&browser->b, sym->name);
+	return true;
+}
+
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				 void(*timer)(void *arg),
 				 void *arg, int delay_secs)
@@ -321,54 +365,12 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
-			if (self->selection == NULL) {
+			if (self->selection == NULL)
 				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
-				continue;
-			}
-
-			if (self->selection->offset == -1) {
+			else if (self->selection->offset == -1)
 				ui_helpline__puts("Actions are only available for assembly lines.");
-				continue;
-			} else {
-				char *s = strstr(self->selection->line, "callq ");
-				struct annotation *notes;
-				struct symbol *target;
-				u64 ip;
-
-				if (s == NULL) {
-					ui_helpline__puts("Actions are only available for the 'callq' instruction.");
-					continue;
-				}
-
-				s = strchr(s, ' ');
-				if (s++ == NULL) {
-					ui_helpline__puts("Invallid callq instruction.");
-					continue;
-				}
-
-				ip = strtoull(s, NULL, 16);
-				ip = ms->map->map_ip(ms->map, ip);
-				target = map__find_symbol(ms->map, ip, NULL);
-				if (target == NULL) {
-					ui_helpline__puts("The called function was not found.");
-					continue;
-				}
-
-				notes = symbol__annotation(target);
-				pthread_mutex_lock(&notes->lock);
-
-				if (notes->src == NULL && symbol__alloc_hist(target) < 0) {
-					pthread_mutex_unlock(&notes->lock);
-					ui__warning("Not enough memory for annotating '%s' symbol!\n",
-						    target->name);
-					continue;
-				}
-
-				pthread_mutex_unlock(&notes->lock);
-				symbol__tui_annotate(target, ms->map, evidx,
-						     timer, arg, delay_secs);
-				ui_browser__show_title(&self->b, sym->name);
-			}
+			else if (!annotate_browser__callq(self, evidx, timer, arg, delay_secs))
+				ui_helpline__puts("Actions are only available for the 'callq' instruction.");
 			continue;
 		case K_LEFT:
 		case K_ESC:
-- 
1.7.9.2.358.g22243

