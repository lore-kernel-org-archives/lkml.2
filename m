Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab0GAVFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:05:00 -0400
Received: from kroah.org ([198.145.64.141]:47837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab0GAUvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:10 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:37 2010
Message-Id: <20100701173437.424292198@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 126/164] tracing: Fix null pointer deref with SEND_SIG_FORCED
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b9b76dfaac6fa2c289ee8a005be637afd2da7e2f upstream.

BUG: unable to handle kernel NULL pointer dereference at
	0000000000000006
IP: [<ffffffff8107bd37>] ftrace_raw_event_signal_generate+0x87/0x140

TP_STORE_SIGINFO() forgets about SEND_SIG_FORCED, fix.

We should probably export is_si_special() and change TP_STORE_SIGINFO()
to use it in the longer term.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <20100603213409.GA8307@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/trace/events/signal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -10,7 +10,8 @@
 
 #define TP_STORE_SIGINFO(__entry, info)				\
 	do {							\
-		if (info == SEND_SIG_NOINFO) {			\
+		if (info == SEND_SIG_NOINFO ||			\
+		    info == SEND_SIG_FORCED) {			\
 			__entry->errno	= 0;			\
 			__entry->code	= SI_USER;		\
 		} else if (info == SEND_SIG_PRIV) {		\


