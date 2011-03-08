Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1CHJn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:43:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:46143 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1CHJn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:43:57 -0500
Date: Tue, 8 Mar 2011 09:43:31 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Handle browsing empty hists tree
Message-ID: <tip-60098917c06d154d06ce030c125266eab9e60768@git.kernel.org>
Git-Commit-ID: 60098917c06d154d06ce030c125266eab9e60768
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Mar 2011 09:43:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60098917c06d154d06ce030c125266eab9e60768
Gitweb:     http://git.kernel.org/tip/60098917c06d154d06ce030c125266eab9e60768
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 4 Mar 2011 21:19:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 6 Mar 2011 13:10:05 -0300

perf hists browser: Handle browsing empty hists tree

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index c27ab35..c98e6f8 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -639,6 +639,9 @@ static void ui_browser__hists_seek(struct ui_browser *self,
 	struct rb_node *nd;
 	bool first = true;
 
+	if (self->nr_entries == 0)
+		return;
+
 	switch (whence) {
 	case SEEK_SET:
 		nd = hists__filter_entries(rb_first(self->entries));
@@ -820,8 +823,8 @@ int hists__browse(struct hists *self, const char *helpline,
 	hists__browser_title(self, msg, sizeof(msg), ev_name,
 			     dso_filter, thread_filter);
 	while (1) {
-		const struct thread *thread;
-		const struct dso *dso;
+		const struct thread *thread = NULL;
+		const struct dso *dso = NULL;
 		char *options[16];
 		int nr_options = 0, choice = 0, i,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
@@ -829,8 +832,10 @@ int hists__browse(struct hists *self, const char *helpline,
 
 		key = hist_browser__run(browser, msg);
 
-		thread = hist_browser__selected_thread(browser);
-		dso = browser->selection->map ? browser->selection->map->dso : NULL;
+		if (browser->he_selection != NULL) {
+			thread = hist_browser__selected_thread(browser);
+			dso = browser->selection->map ? browser->selection->map->dso : NULL;
+		}
 
 		switch (key) {
 		case NEWT_KEY_TAB:
@@ -841,7 +846,8 @@ int hists__browse(struct hists *self, const char *helpline,
 			 */
 			goto out_free_stack;
 		case 'a':
-			if (browser->selection->map == NULL &&
+			if (browser->selection == NULL ||
+			    browser->selection->map == NULL ||
 			    browser->selection->map->dso->annotate_warned)
 				continue;
 			goto do_annotate;
@@ -887,7 +893,8 @@ int hists__browse(struct hists *self, const char *helpline,
 			goto out_free_stack;
 		}
 
-		if (browser->selection->sym != NULL &&
+		if (browser->selection != NULL &&
+		    browser->selection->sym != NULL &&
 		    !browser->selection->map->dso->annotate_warned &&
 		    asprintf(&options[nr_options], "Annotate %s",
 			     browser->selection->sym->name) > 0)
@@ -906,7 +913,8 @@ int hists__browse(struct hists *self, const char *helpline,
 			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
 			zoom_dso = nr_options++;
 
-		if (browser->selection->map != NULL &&
+		if (browser->selection != NULL &&
+		    browser->selection->map != NULL &&
 		    asprintf(&options[nr_options], "Browse map details") > 0)
 			browse_map = nr_options++;
 
