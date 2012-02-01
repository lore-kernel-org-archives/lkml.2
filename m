Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab2BAVsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:48:09 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48111 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932437Ab2BAVIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:45 -0500
X-Sasl-enc: Mq8uuBsAW29eQtrWP4iwycnuM+nFzAr4Fm46cV/FFDLW 1328130524
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:38 2012
Message-Id: <20120201205738.621347571@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:55:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>
Subject: [13/65] ftrace: Update filter when tracing enabled in set_ftrace_filter()
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 072126f4529196f71a97960248bca54fd4554c2d upstream.

Currently, if set_ftrace_filter() is called when the ftrace_ops is
active, the function filters will not be updated. They will only be updated
when tracing is disabled and re-enabled.

Update the functions immediately during set_ftrace_filter().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2901,6 +2901,10 @@ ftrace_set_regex(struct ftrace_ops *ops,
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
+	if (!ret && ops->flags & FTRACE_OPS_FL_ENABLED
+	    && ftrace_enabled)
+		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+
 	mutex_unlock(&ftrace_lock);
 
 	mutex_unlock(&ftrace_regex_lock);


