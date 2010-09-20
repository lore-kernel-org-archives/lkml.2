Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0ITONi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:13:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592Ab0ITONf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:13:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/5] frv: double syscall restarts,
	syscall restart in sigreturn()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Date: Mon, 20 Sep 2010 15:13:25 +0100
Message-ID: <20100920141324.11066.43742.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
References: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

We need to make sure that only the first do_signal() to be handled
on the way out syscall will bother with syscall restarts; additionally,
the check on the "signal has user handler" path had been wrong -
compare with restart prevention in sigreturn()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/signal.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index bd13b57..bab0129 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -446,7 +446,7 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 	int ret;
 
 	/* Are we from a system call? */
-	if (in_syscall(__frame)) {
+	if (__frame->syscallno != -1) {
 		/* If so, check system call restarting.. */
 		switch (__frame->gr8) {
 		case -ERESTART_RESTARTBLOCK:
@@ -465,6 +465,7 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 			__frame->gr8 = __frame->orig_gr8;
 			__frame->pc -= 4;
 		}
+		__frame->syscallno = -1;
 	}
 
 	/* Set up the stack frame */
@@ -551,6 +552,7 @@ no_signal:
 			__frame->pc -= 4;
 			break;
 		}
+		__frame->syscallno = -1;
 	}
 
 	/* if there's no signal to deliver, we just put the saved sigmask

