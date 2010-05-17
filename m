Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0EQOyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab0EQOyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:54:38 -0400
Date: Mon, 17 May 2010 11:54:21 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: mingo@elte.hu, lkml <linux-kernel@vger.kernel.org>
Subject: Re: perf tool build error
Message-ID: <20100517145421.GD29052@ghostprotocols.net>
References: <1274066504.10439.3.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1274066504.10439.3.camel@minggr.sh.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 17, 2010 at 11:21:44AM +0800, Lin Ming escreveu:
> Build perf tool in latest tip tree(17efbf4) fails,
> 
> $ gcc --version
> gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
 
> cc1: warnings being treated as errors
> util/newt.c: In function ‘objdump_line__show’:
> util/newt.c:252: error: passing argument 1 of ‘SLsmg_printf’ discards qualifiers from pointer target type
> util/newt.c:258: error: passing argument 1 of ‘SLsmg_write_nstring’ discards qualifiers from pointer target type

What distribution is this?

The problem here lies in the slang-devel package, I guess we'll have
to have the following patch, please apply and see if it cures the issue.

The problem doesn't happen at least in slang >= 2.1.4 when we define 
ENABLE_SLFUTURE_CONST, as we do in tools/perf/Makefile, but since we
want to have perf building in as many scenarios as possible, the patch
is needed, please let me know if it works for you and I'll queue it up.

- Arnaldo

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
