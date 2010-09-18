Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0IRTyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:54:31 -0400
Received: from kroah.org ([198.145.64.141]:51345 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab0IRTBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:38 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:56 2010
Message-Id: <20100918185956.675458854@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wright <chrisw@sous-sol.org>, Tavis Ormandy <taviso@google.com>,
        Eugene Teo <eugene@redhat.com>, vendor-sec@lst.de,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [045/123] tracing: Do not allow llseek to set_ftrace_filter
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=tracing-do-not-allow-llseek-to-set_ftrace_filter.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

commit 9c55cb12c1c172e2d51e85fbb5a4796ca86b77e7 upstream.

Reading the file set_ftrace_filter does three things.

1) shows whether or not filters are set for the function tracer
2) shows what functions are set for the function tracer
3) shows what triggers are set on any functions

3 is independent from 1 and 2.

The way this file currently works is that it is a state machine,
and as you read it, it may change state. But this assumption breaks
when you use lseek() on the file. The state machine gets out of sync
and the t_show() may use the wrong pointer and cause a kernel oops.

Luckily, this will only kill the app that does the lseek, but the app
dies while holding a mutex. This prevents anyone else from using the
set_ftrace_filter file (or any other function tracing file for that matter).

A real fix for this is to rewrite the code, but that is too much for
a -rc release or stable. This patch simply disables llseek on the
set_ftrace_filter() file for now, and we can do the proper fix for the
next major release.

Reported-by: Robert Swiecki <swiecki@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Tavis Ormandy <taviso@google.com>
Cc: Eugene Teo <eugene@redhat.com>
Cc: vendor-sec@lst.de
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2400,7 +2400,7 @@ static const struct file_operations ftra
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = no_llseek,
 	.release = ftrace_filter_release,
 };
 


