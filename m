Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0EQAKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:10:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0EQAKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:10:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf tui: Add help window to show key associations
Date: Sun, 16 May 2010 21:10:34 -0300
Message-Id: <1274055034-25634-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274055034-25634-1-git-send-email-acme@infradead.org>
References: <1274055034-25634-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 59a63e4..2001d26 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -167,6 +167,48 @@ out_destroy_form:
 	return rc;
 }
 
+static int ui__help_window(const char *text)
+{
+	struct newtExitStruct es;
+	newtComponent tb, form = newt_form__new();
+	int rc = -1;
+	int max_len = 0, nr_lines = 0;
+	const char *t;
+
+	if (form == NULL)
+		return -1;
+
+	t = text;
+	while (1) {
+		const char *sep = strchr(t, '\n');
+		int len;
+
+		if (sep == NULL)
+			sep = strchr(t, '\0');
+		len = sep - t;
+		if (max_len < len)
+			max_len = len;
+		++nr_lines;
+		if (*sep == '\0')
+			break;
+		t = sep + 1;
+	}
+
+	tb = newtTextbox(0, 0, max_len, nr_lines, 0);
+	if (tb == NULL)
+		goto out_destroy_form;
+
+	newtTextboxSetText(tb, text);
+	newtFormAddComponent(form, tb);
+	newtCenteredWindow(max_len, nr_lines, NULL);
+	newtFormRun(form, &es);
+	newtPopWindow();
+	rc = 0;
+out_destroy_form:
+	newtFormDestroy(form);
+	return rc;
+}
+
 static bool dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
@@ -756,6 +798,10 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	newtFormAddHotKey(self->form, 'd');
 	newtFormAddHotKey(self->form, 'T');
 	newtFormAddHotKey(self->form, 't');
+	newtFormAddHotKey(self->form, '?');
+	newtFormAddHotKey(self->form, 'H');
+	newtFormAddHotKey(self->form, 'h');
+	newtFormAddHotKey(self->form, NEWT_KEY_F1);
 	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
 	newtFormAddComponents(self->form, self->tree, NULL);
 	self->selection = newt__symbol_tree_get_current(self->tree);
@@ -842,6 +888,9 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 		dso = browser->selection->map ? browser->selection->map->dso : NULL;
 
 		if (es.reason == NEWT_EXIT_HOTKEY) {
+			if (es.u.key == NEWT_KEY_F1)
+				goto do_help;
+
 			switch (toupper(es.u.key)) {
 			case 'A':
 				goto do_annotate;
@@ -849,6 +898,17 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 				goto zoom_dso;
 			case 'T':
 				goto zoom_thread;
+			case 'H':
+			case '?':
+do_help:
+				ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
+						"<-        Zoom out\n"
+						"a         Annotate current symbol\n"
+						"h/?/F1    Show this window\n"
+						"d         Zoom into current DSO\n"
+						"t         Zoom into current Thread\n"
+						"q/CTRL+C  Exit browser");
+				continue;
 			default:;
 			}
 			if (toupper(es.u.key) == 'Q' ||
-- 
1.6.2.5

