Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2KRUVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 15:21:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab2KRUVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 15:21:15 -0500
Date: Sun, 18 Nov 2012 21:21:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ptrace: introduce PTRACE_O_EXITKILL
Message-ID: <20121118202140.GB20360@redhat.com>
References: <20121107150934.GA27606@redhat.com> <20121108062935.BFF3A592024@miso.sublimeip.com> <20121108123716.GA20917@redhat.com> <20121118202108.GA20360@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118202108.GA20360@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ptrace jailers want to be sure that the tracee can never escape
from the control. However if the tracer dies unexpectedly the
tracee continues to run in potentially unsafe mode.

Add the new ptrace option PTRACE_O_EXITKILL. If the tracer exits
it sends SIGKILL to every tracee which has this bit set.

Note that the new option is not equal to the last-option << 1.
Because currently all options have the event, and the new one
starts the eventless group. It uses the random 20 bit, so we have
the room for 12 more events, but we can also add the new eventless
options below this one.

Suggested-and-tested-by: Amnon Shiloh <u3557@miso.sublimeip.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ptrace.h      |    2 ++
 include/uapi/linux/ptrace.h |    5 ++++-
 kernel/ptrace.c             |    3 +++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index e0ff468..62db1a1 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -32,6 +32,8 @@
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
 #define PT_TRACE_SECCOMP	PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
 
+#define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
+
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
 #define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 1ef6c05..022ab18 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -73,7 +73,10 @@
 #define PTRACE_O_TRACEEXIT	(1 << PTRACE_EVENT_EXIT)
 #define PTRACE_O_TRACESECCOMP	(1 << PTRACE_EVENT_SECCOMP)
 
-#define PTRACE_O_MASK		0x000000ff
+/* eventless options */
+#define PTRACE_O_EXITKILL	(1 << 20)
+
+#define PTRACE_O_MASK		(0x000000ff | PTRACE_O_EXITKILL)
 
 #include <asm/ptrace.h>
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1f5e55d..ec8118a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -457,6 +457,9 @@ void exit_ptrace(struct task_struct *tracer)
 		return;
 
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
+		if (unlikely(p->ptrace & PT_EXITKILL))
+			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
+
 		if (__ptrace_detach(tracer, p))
 			list_add(&p->ptrace_entry, &ptrace_dead);
 	}
-- 
1.5.5.1


