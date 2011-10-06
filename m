Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224Ab1JFR0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:26:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:44292 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703Ab1JFRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/15] perf annotate browser: Use -> to navigate on assembly lines
Date: Thu,  6 Oct 2011 14:22:34 -0300
Message-Id: <1317921758-4154-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And add better explanations when the line isn't actionable, like non
assembly lines and on other instructions.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-375n844b5wra7lgq08ou153j@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 77421ba..674b55e 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -184,8 +184,8 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	int key;
 
 	if (ui_browser__show(&self->b, sym->name,
-			     "<-, -> or ESC: exit, TAB/shift+TAB: "
-			     "cycle hottest lines, H: Hottest") < 0)
+			     "<- or ESC: exit, TAB/shift+TAB: "
+			     "cycle hottest lines, H: Hottest, -> Line action") < 0)
 		return -1;
 
 	ui_browser__add_exit_keys(&self->b, exit_keys);
@@ -245,24 +245,39 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			nd = self->curr_hot;
 			break;
 		case NEWT_KEY_ENTER:
-			if (self->selection != NULL) {
+		case NEWT_KEY_RIGHT:
+			if (self->selection == NULL) {
+				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
+				continue;
+			}
+
+			if (self->selection->offset == -1) {
+				ui_helpline__puts("Actions are only available for assembly lines.");
+				continue;
+			} else {
 				char *s = strstr(self->selection->line, "callq ");
 				struct annotation *notes;
 				struct symbol *target;
 				u64 ip;
 
-				if (s == NULL)
+				if (s == NULL) {
+					ui_helpline__puts("Actions are only available for the 'callq' instruction.");
 					continue;
+				}
 
 				s = strchr(s, ' ');
-				if (s++ == NULL)
+				if (s++ == NULL) {
+					ui_helpline__puts("Invallid callq instruction.");
 					continue;
+				}
 
 				ip = strtoull(s, NULL, 16);
 				ip = ms->map->map_ip(ms->map, ip);
 				target = map__find_symbol(ms->map, ip, NULL);
-				if (target == NULL)
+				if (target == NULL) {
+					ui_helpline__puts("The called function was not found.");
 					continue;
+				}
 
 				notes = symbol__annotation(target);
 				pthread_mutex_lock(&notes->lock);
-- 
1.6.2.5

