Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab0IZS2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:28:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50374 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab0IZS2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:28:43 -0400
Date: Sun, 26 Sep 2010 19:28:42 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] mn10300: prevent double syscall restarts
Cc: dhowells@redhat.com, torvalds@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ozvxq-0002ok-7j@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


set ->orig_d0 to -1, same as what sigreturn does

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/kernel/signal.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 57178a8..4ef9925 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -432,6 +432,12 @@ give_sigsegv:
 	return -EFAULT;
 }
 
+static inline void stepback(struct pt_regs *regs)
+{
+	regs->pc -= 2;
+	regs->orig_d0 = -1;
+}
+
 /*
  * handle the actual delivery of a signal to userspace
  */
@@ -459,7 +465,7 @@ static int handle_signal(int sig,
 			/* fallthrough */
 		case -ERESTARTNOINTR:
 			regs->d0 = regs->orig_d0;
-			regs->pc -= 2;
+			stepback(regs);
 		}
 	}
 
@@ -527,12 +533,12 @@ static void do_signal(struct pt_regs *regs)
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
 			regs->d0 = regs->orig_d0;
-			regs->pc -= 2;
+			stepback(regs);
 			break;
 
 		case -ERESTART_RESTARTBLOCK:
 			regs->d0 = __NR_restart_syscall;
-			regs->pc -= 2;
+			stepback(regs);
 			break;
 		}
 	}
-- 
1.5.6.5

