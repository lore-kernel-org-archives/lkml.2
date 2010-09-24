Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0IXFWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:22:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41077 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0IXFWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:22:34 -0400
Date: Fri, 24 Sep 2010 06:22:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 2/5] make m32r handle multiple pending signals
Message-ID: <20100924052230.GM19804@ZenIV.linux.org.uk>
References: <20100924052035.GL19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924052035.GL19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m32r/kernel/entry.S  |    4 ++--
 arch/m32r/kernel/signal.c |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/entry.S b/arch/m32r/kernel/entry.S
index 90149da..225412b 100644
--- a/arch/m32r/kernel/entry.S
+++ b/arch/m32r/kernel/entry.S
@@ -235,9 +235,9 @@ work_resched:
 work_notifysig:				; deal with pending signals and
 					; notify-resume requests
 	mv	r0, sp			; arg1 : struct pt_regs *regs
-	ldi	r1, r9			; arg2 : __u32 thread_info_flags
+	mv	r1, r9			; arg2 : __u32 thread_info_flags
 	bl	do_notify_resume
-	bra	restore_all
+	bra	resume_userspace
 
 	; perform syscall exit tracing
 	ALIGN
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index acd69f7..db15226 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -282,6 +282,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 					regs->bpc -= 2;
 				else
 					regs->bpc -= 4;
+				regs->syscall_nr = -1;
 		}
 	}
 
@@ -353,8 +354,8 @@ static int do_signal(struct pt_regs *regs)
 				regs->bpc -= 2;
 			else
 				regs->bpc -= 4;
-		}
-		if (regs->r0 == -ERESTART_RESTARTBLOCK){
+			regs->syscall_nr = -1;
+		} else if (regs->r0 == -ERESTART_RESTARTBLOCK){
 			regs->r0 = regs->orig_r0;
 			regs->r7 = __NR_restart_syscall;
 			inst = *(unsigned short *)(regs->bpc - 2);
@@ -362,6 +363,7 @@ static int do_signal(struct pt_regs *regs)
 				regs->bpc -= 2;
 			else
 				regs->bpc -= 4;
+			regs->syscall_nr = -1;
 		}
 	}
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-- 
1.5.6.5

