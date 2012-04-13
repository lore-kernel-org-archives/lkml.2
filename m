Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2DMSJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:09:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2DMSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:09:03 -0400
Date: Fri, 13 Apr 2012 11:08:23 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-i98elvmix2cw6t8stu1iagfd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui annotate browser:
  Move callq handling to separate function
Git-Commit-ID: 6052170249d6696bc297d61e83b78fcfe64532d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:08:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6052170249d6696bc297d61e83b78fcfe64532d8
Gitweb:     http://git.kernel.org/tip/6052170249d6696bc297d61e83b78fcfe64532d8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Apr 2012 13:58:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 16:10:50 -0300

perf ui annotate browser: Move callq handling to separate function

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
 1 files changed, 48 insertions(+), 46 deletions(-)

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
