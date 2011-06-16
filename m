Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab1FPHFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:05:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51486 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756110Ab1FPHFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:02 -0400
X-Sasl-enc: gtH5ijkIrfnAmrn3qAcij1bDlB3LQ323FXp+JPAMT2yW 1308207901
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:09 2011
Message-Id: <20110616001609.421140118@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:14:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [01/91] ftrace: Only update the function code on write to filter files
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 058e297d34a404caaa5ed277de15698d8dc43000 upstream.

If function tracing is enabled, a read of the filter files will
cause the call to stop_machine to update the function trace sites.
It should only call stop_machine on write.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ftrace.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2360,14 +2360,16 @@ ftrace_regex_release(struct inode *inode
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


