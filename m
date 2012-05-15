Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933Ab2EOCQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:16:53 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52746 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798Ab2EOCP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:15:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 001/179] ftrace: Only update the function code on write to filter files
Date: Mon, 14 May 2012 22:11:37 -0400
Message-ID: <1337048075-6132-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 058e297d34a404caaa5ed277de15698d8dc43000 upstream.

If function tracing is enabled, a read of the filter files will
cause the call to stop_machine to update the function trace sites.
It should only call stop_machine on write.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/trace/ftrace.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e28af02..7dd746c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2355,14 +2355,16 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
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
-- 
1.7.9.6

