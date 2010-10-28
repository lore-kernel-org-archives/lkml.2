Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab0J1UEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:04:38 -0400
Received: from king.tilera.com ([72.1.168.226]:23087 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761329Ab0J1UDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:03:32 -0400
Message-Id: <201010282003.o9SK3Sq9006823@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 28 Oct 2010 15:03:30 -0400
Subject: [PATCH] arch/tile: correct double syscall restart for nested signals
References: <20100923221141.GK19804@ZenIV.linux.org.uk> <9lYpY1#WLHA.1516@exchange1.tad.internal.tilera.com> <4CC89352.7020808@tilera.com> <20101027213745.GI19804@ZenIV.linux.org.uk>
In-Reply-To: <20101027213745.GI19804@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Oct 2010 20:03:29.0422 (UTC) FILETIME=[308662E0:01CB76DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is modelled on similar fixes for other architectures.
The pt_regs "faultnum" member is set to the trap (fault) number that
caused us to enter the kernel, and is INT_SWINT_1 for the syscall software
interrupt.  We already supported a pseudo value, INT_SWINT_1_SIGRETURN,
that we used for the rt_sigreturn syscall; it avoided the case where
one signal was handled, then we "tail-called" to another handler.

This change avoids the similar case where we start to call one handler,
then are preempted into another handler when we start trying to run
the first handler.  We clear ->faultnum after calling handle_signal(),
and to be paranoid also in the case where there was no signal to deliver.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/signal.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index fb28e85..704ce0b 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -330,7 +330,7 @@ void do_signal(struct pt_regs *regs)
 			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		}
 
-		return;
+		goto done;
 	}
 
 	/* Did we come from a system call? */
@@ -358,4 +358,8 @@ void do_signal(struct pt_regs *regs)
 		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
+
+done:
+	/* Avoid double syscall restart if there are nested signals. */
+	regs->faultnum = INT_SWINT_1_SIGRETURN;
 }
-- 
1.6.5.2

