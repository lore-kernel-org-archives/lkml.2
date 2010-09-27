Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0I0KsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab0I0KsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:48:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] mn10300: Prevent double syscall restarts
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Date: Mon, 27 Sep 2010 11:47:54 +0100
Message-ID: <20100927104754.6377.97402.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100927104749.6377.46813.stgit@warthog.procyon.org.uk>
References: <20100927104749.6377.46813.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

We need to make sure that only the first do_signal() to be handled on
the way out of the syscall handler will bother with syscall restarts.

We do this by setting orig_d0 to -1 as sigreturn does.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
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

