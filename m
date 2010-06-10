Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab0FJQGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:06:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0FJQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:06:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/1] perf record: Don't call newt functions when not initialized
Date: Thu, 10 Jun 2010 13:05:56 -0300
Message-Id: <1276185956-19099-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276185956-19099-1-git-send-email-acme@infradead.org>
References: <1276185956-19099-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When processing events we want to give visual feedback to the user when
using the newt browser, so there are ui_progress calls in
__perf_session__process_events, but those should check if newt is being
used.

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20100609123530.GB9471@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index cf182ca..7537ca1 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -43,6 +43,9 @@ struct ui_progress *ui_progress__new(const char *title, u64 total)
 
 	if (self != NULL) {
 		int cols;
+
+		if (use_browser <= 0)	
+			return self;
 		newtGetScreenSize(&cols, NULL);
 		cols -= 4;
 		newtCenteredWindow(cols, 1, title);
@@ -67,14 +70,22 @@ out_free_self:
 
 void ui_progress__update(struct ui_progress *self, u64 curr)
 {
+	/*
+	 * FIXME: We should have a per UI backend way of showing progress,
+	 * stdio will just show a percentage as NN%, etc.
+	 */
+	if (use_browser <= 0)
+		return;
 	newtScaleSet(self->scale, curr);
 	newtRefresh();
 }
 
 void ui_progress__delete(struct ui_progress *self)
 {
-	newtFormDestroy(self->form);
-	newtPopWindow();
+	if (use_browser > 0) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
 	free(self);
 }
 
-- 
1.6.2.5

