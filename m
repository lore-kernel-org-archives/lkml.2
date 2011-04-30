Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1D3PdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:33:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab1D3PcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:14 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=V-grUS7X2S8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_nZIa3NiYyTMYg-ZEFgA:9 a=gWuEGkenmg2FNGBa5eEA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153211.446711323@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/8] ftrace: Remove FTRACE_FL_CONVERTED flag
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Remove-FTRACE_FL_CONVERTED-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Since we disable all function tracer processing if we detect
that a modification of a instruction had failed, we do not need
to track that the record has failed. No more ftrace processing
is allowed, and the FTRACE_FL_CONVERTED flag is pointless.

The FTRACE_FL_CONVERTED flag was used to denote records that were
successfully converted from mcount calls into nops. But if a single
record fails, all of ftrace is disabled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    1 -
 kernel/trace/ftrace.c  |   12 ++++--------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 2a195ff..3204744 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -150,7 +150,6 @@ enum {
 	FTRACE_FL_FILTER	= (1 << 1),
 	FTRACE_FL_ENABLED	= (1 << 2),
 	FTRACE_FL_NOTRACE	= (1 << 3),
-	FTRACE_FL_CONVERTED	= (1 << 4),
 };
 
 struct dyn_ftrace {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index eb19fae..9abaaf4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1087,12 +1087,8 @@ static void ftrace_replace_code(int enable)
 		return;
 
 	do_for_each_ftrace_rec(pg, rec) {
-		/*
-		 * Skip over free records, records that have
-		 * failed and not converted.
-		 */
-		if (rec->flags & FTRACE_FL_FREE ||
-		    !(rec->flags & FTRACE_FL_CONVERTED))
+		/* Skip over free records */
+		if (rec->flags & FTRACE_FL_FREE)
 			continue;
 
 		failed = __ftrace_replace_code(rec, enable);
@@ -1280,10 +1276,10 @@ static int ftrace_update_code(struct module *mod)
 		 */
 		if (!ftrace_code_disable(mod, p)) {
 			ftrace_free_rec(p);
-			continue;
+			/* Game over */
+			break;
 		}
 
-		p->flags |= FTRACE_FL_CONVERTED;
 		ftrace_update_cnt++;
 
 		/*
-- 
1.7.2.3


