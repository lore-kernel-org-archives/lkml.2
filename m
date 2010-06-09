Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0FIFZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:25:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:40292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0FIFZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:25:36 -0400
Date: Wed, 9 Jun 2010 05:24:45 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, roland@redhat.com, rostedt@goodmis.org,
       akpm@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
       oleg@redhat.com, jbaron@redhat.com, mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, roland@redhat.com, rostedt@goodmis.org,
       akpm@linux-foundation.org, stable@kernel.org, jbaron@redhat.com,
       tglx@linutronix.de, oleg@redhat.com, mhiramat@redhat.com
In-Reply-To: <20100603213409.GA8307@redhat.com>
References: <20100603213409.GA8307@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix null pointer deref with SEND_SIG_FORCED
Message-ID: <tip-b9b76dfaac6fa2c289ee8a005be637afd2da7e2f@git.kernel.org>
Git-Commit-ID: b9b76dfaac6fa2c289ee8a005be637afd2da7e2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 05:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9b76dfaac6fa2c289ee8a005be637afd2da7e2f
Gitweb:     http://git.kernel.org/tip/b9b76dfaac6fa2c289ee8a005be637afd2da7e2f
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 3 Jun 2010 23:34:09 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 8 Jun 2010 23:51:32 +0200

tracing: Fix null pointer deref with SEND_SIG_FORCED

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
Cc: 2.6.33.x-2.6.34.x <stable@kernel.org>
LKML-Reference: <20100603213409.GA8307@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/signal.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 814566c..17df434 100644
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
