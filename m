Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0FHW3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:29:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53330 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab0FHW3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=IBDwrTdKY5NaAz9q47vj6cp5+aFGtkbSM1pvExzPP9U/DtcR3fTLNmKYZuesjX+5yG
         QyMSbSmRYmliTPpEO9heeGNmh/NEsByHkv84pv0ajZUQkLA2rkfWlEeuclSRgnlObQQC
         2ucUm75vaxd238omYiKCRwotRDRpn0ExvnM80=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "2 . 6 . 33 . x-2 . 6 . 34 . x" <stable@kernel.org>
Subject: [GIT PULL] tracing fix
Date: Wed,  9 Jun 2010 00:29:49 +0200
Message-Id: <1276036189-10354-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Oleg Nesterov (1):
      tracing: Fix null pointer deref with SEND_SIG_FORCED


 include/trace/events/signal.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

---
commit b9b76dfaac6fa2c289ee8a005be637afd2da7e2f
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Thu Jun 3 23:34:09 2010 +0200

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
