Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1D3C5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 22:57:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab1D3C5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 22:57:16 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=RvxEdtNnrcQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=FqVyP-TMSJpr_HRYuKgA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL][v2.6.39] ftrace: Only update the function code on write
 to filter files
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable <stable@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Apr 2011 22:57:13 -0400
Message-ID: <1304132233.25414.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Steven Rostedt (1):
      ftrace: Only update the function code on write to filter files

----
 kernel/trace/ftrace.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)
---------------------------
commit 058e297d34a404caaa5ed277de15698d8dc43000
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Apr 29 22:35:33 2011 -0400

    ftrace: Only update the function code on write to filter files
    
    If function tracing is enabled, a read of the filter files will
    cause the call to stop_machine to update the function trace sites.
    It should only call stop_machine on write.
    
    Cc: stable@kernel.org
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ee24fa1..666880d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2413,14 +2413,16 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		ftrace_match_records(parser->buffer, parser->idx, enable);
 	}
 
-	mutex_lock(&ftrace_lock);
-	if (ftrace_start_up && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-	mutex_unlock(&ftrace_lock);
-
 	trace_parser_put(parser);
 	kfree(iter);
 
+	if (file->f_mode & FMODE_WRITE) {
+		mutex_lock(&ftrace_lock);
+		if (ftrace_start_up && ftrace_enabled)
+			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		mutex_unlock(&ftrace_lock);
+	}
+
 	mutex_unlock(&ftrace_regex_lock);
 	return 0;
 }


