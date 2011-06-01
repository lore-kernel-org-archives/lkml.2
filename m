Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143Ab1FAIG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:06:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161108Ab1FAIGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:06:51 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:34 2011
Message-Id: <20110601080233.488601137@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:03 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [007/146] ftrace: Only update the function code on write to filter files
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2414,14 +2414,16 @@ ftrace_regex_release(struct inode *inode
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


