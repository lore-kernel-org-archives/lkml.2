Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab1JFRXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:23:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50333 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab1JFRWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/15] perf hists browser: Update the browser.nr_entries after the timer
Date: Thu,  6 Oct 2011 14:22:37 -0300
Message-Id: <1317921758-4154-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Previously the hist_browser dealt with a static tree of entries, now it
needs to update the nr_entries in the browser after the timer runs.

A better solution will come when moving using another thread for the
collapse_resort, etc, but for now this is ok.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9eno2iq55sjr4iyo899buzaw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index ef6ccef..e64d952 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -332,6 +332,13 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 		case -1:
 			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
 			timer(arg);
+			/*
+			 * The timer may have changed the number of entries.
+			 * XXX: Find better way to keep this in synch, probably
+			 * removing this timer function altogether and just sync
+			 * using the hists->lock...
+			 */
+			self->b.nr_entries = self->hists->nr_entries;
 			hists__browser_title(self->hists, title, sizeof(title),
 					     ev_name, self->dso_filter,
 					     self->thread_filter);
-- 
1.6.2.5

