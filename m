Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0EQPsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:48:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0EQPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:48:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/3] perf tui: Add workaround for slang < 2.1.4
Date: Mon, 17 May 2010 12:47:58 -0300
Message-Id: <1274111278-2838-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274111278-2838-1-git-send-email-acme@infradead.org>
References: <1274111278-2838-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Older versions of the slang library didn't used the 'const' specifier,
causing problems with modern compilers of this kind:

util/newt.c:252: error: passing argument 1 of ‘SLsmg_printf’ discards
qualifiers from pointer target type

Fix it by using some wrappers that when needed const the affected
parameters back to plain (char *).

Reported-by: Lin Ming <ming.m.lin@intel.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20100517145421.GD29052@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 2001d26..ccb7c5b 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -14,6 +14,17 @@
 #include "sort.h"
 #include "symbol.h"
 
+#if SLANG_VERSION < 20104
+#define slsmg_printf(msg, args...) SLsmg_printf((char *)msg, ##args)
+#define slsmg_write_nstring(msg, len) SLsmg_write_nstring((char *)msg, len)
+#define sltt_set_color(obj, name, fg, bg) SLtt_set_color(obj,(char *)name,\
+							 (char *)fg, (char *)bg)
+#else
+#define slsmg_printf SLsmg_printf
+#define slsmg_write_nstring SLsmg_write_nstring
+#define sltt_set_color SLtt_set_color
+#endif
+
 struct ui_progress {
 	newtComponent form, scale;
 };
@@ -292,21 +303,21 @@ static int objdump_line__show(struct objdump_line *self, struct list_head *head,
 
 		color = ui_browser__percent_color(percent, current_entry);
 		SLsmg_set_color(color);
-		SLsmg_printf(" %7.2f ", percent);
+		slsmg_printf(" %7.2f ", percent);
 		if (!current_entry)
 			SLsmg_set_color(HE_COLORSET_CODE);
 	} else {
 		int color = ui_browser__percent_color(0, current_entry);
 		SLsmg_set_color(color);
-		SLsmg_write_nstring(" ", 9);
+		slsmg_write_nstring(" ", 9);
 	}
 
 	SLsmg_write_char(':');
-	SLsmg_write_nstring(" ", 8);
+	slsmg_write_nstring(" ", 8);
 	if (!*self->line)
-		SLsmg_write_nstring(" ", width - 18);
+		slsmg_write_nstring(" ", width - 18);
 	else
-		SLsmg_write_nstring(self->line, width - 18);
+		slsmg_write_nstring(self->line, width - 18);
 
 	return 0;
 }
@@ -1054,11 +1065,11 @@ void setup_browser(void)
 	newtInit();
 	newtCls();
 	ui_helpline__puts(" ");
-	SLtt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
-	SLtt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
-	SLtt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
-	SLtt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
-	SLtt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
+	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
+	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
+	sltt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
+	sltt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
+	sltt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
 }
 
 void exit_browser(bool wait_for_ok)
-- 
1.6.2.5

