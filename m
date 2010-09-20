Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0ITONR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:13:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab0ITONQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:13:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/5] frv: restart_block.fn needs to be reset on sigreturn
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Date: Mon, 20 Sep 2010 15:13:04 +0100
Message-ID: <20100920141304.11066.51314.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

Reset restart_block.fn on executing a sigreturn such that any currently pending
system call restarts will be forced to return -EINTR.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 0974c0e..7fc2961 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -121,6 +121,9 @@ static int restore_sigcontext(struct sigcontext __user *sc, int *_gr8)
 	struct user_context *user = current->thread.user;
 	unsigned long tbr, psr;
 
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
 	tbr = user->i.tbr;
 	psr = user->i.psr;
 	if (copy_from_user(user, &sc->sc_context, sizeof(sc->sc_context)))

