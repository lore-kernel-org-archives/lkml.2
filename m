Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab0LHAsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:09 -0500
Received: from kroah.org ([198.145.64.141]:58607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab0LHAsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:02 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:34 2010
Message-Id: <20101208004434.329515428@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [100/127] sparc: Prevent no-handler signal syscall restart recursion.
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit c27852597829128a9c9d96d79ec454a83c6b0da5 ]

Explicitly clear the "in-syscall" bit when we have no signal
handler and back up the program counters to back up the system
call.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/signal32.c  |    4 +++-
 arch/sparc/kernel/signal_32.c |    2 ++
 arch/sparc/kernel/signal_64.c |    2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -616,7 +616,7 @@ static int setup_frame32(struct k_sigact
 
 		flush_signal_insns(address);
 	}
-	return;
+	return 0;
 
 sigill:
 	do_exit(SIGILL);
@@ -840,12 +840,14 @@ void do_signal32(sigset_t *oldset, struc
 		regs->u_regs[UREG_I0] = orig_i0;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 	if (restart_syscall &&
 	    regs->u_regs[UREG_I0] == ERESTART_RESTARTBLOCK) {
 		regs->u_regs[UREG_G1] = __NR_restart_syscall;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 
 	/* If there's no signal to deliver, we just put the saved sigmask
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -580,12 +580,14 @@ static void do_signal(struct pt_regs *re
 		regs->u_regs[UREG_I0] = orig_i0;
 		regs->pc -= 4;
 		regs->npc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 	if (restart_syscall &&
 	    regs->u_regs[UREG_I0] == ERESTART_RESTARTBLOCK) {
 		regs->u_regs[UREG_G1] = __NR_restart_syscall;
 		regs->pc -= 4;
 		regs->npc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 
 	/* if there's no signal to deliver, we just put the saved sigmask
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -600,12 +600,14 @@ static void do_signal(struct pt_regs *re
 		regs->u_regs[UREG_I0] = orig_i0;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 	if (restart_syscall &&
 	    regs->u_regs[UREG_I0] == ERESTART_RESTARTBLOCK) {
 		regs->u_regs[UREG_G1] = __NR_restart_syscall;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 
 	/* If there's no signal to deliver, we just put the saved sigmask


