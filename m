Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1D3Pc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab1D3PcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:14 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Mov1lI9UpHoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=oDMD0tQwDcpc44lMjiUA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153211.698739202@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/8] ftrace: Move record update for normal and modules into a separate function
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Move-record-update-for-normal-and-modules-int.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The updating of a function record is moved to a single function. This will allow
us to add specific changes in one location for both modules and kernel
functions.

Later patches will determine if the function record itself needs to be updated
(which enables the mcount caller), or just the ftrace_ops needs the update.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9abaaf4..5b758ea 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1743,6 +1743,15 @@ static int ftrace_match(char *str, char *regex, int len, int type)
 	return matched;
 }
 
+static void
+update_record(struct dyn_ftrace *rec, unsigned long flag, int not)
+{
+	if (not)
+		rec->flags &= ~flag;
+	else
+		rec->flags |= flag;
+}
+
 static int
 ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
 {
@@ -1772,10 +1781,7 @@ static int ftrace_match_records(char *buff, int len, int enable)
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (ftrace_match_record(rec, search, search_len, type)) {
-			if (not)
-				rec->flags &= ~flag;
-			else
-				rec->flags |= flag;
+			update_record(rec, flag, not);
 			found = 1;
 		}
 		/*
@@ -1846,10 +1852,7 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 
 		if (ftrace_match_module_record(rec, mod,
 					       search, search_len, type)) {
-			if (not)
-				rec->flags &= ~flag;
-			else
-				rec->flags |= flag;
+			update_record(rec, flag, not);
 			found = 1;
 		}
 		if (enable && (rec->flags & FTRACE_FL_FILTER))
-- 
1.7.2.3


