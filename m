Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab0I0Ksx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758858Ab0I0Ksv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:48:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/5] mn10300: Check __get/put_user() results
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Date: Mon, 27 Sep 2010 11:48:09 +0100
Message-ID: <20100927104809.6377.48447.stgit@warthog.procyon.org.uk>
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

The results of calling __get/put_user() in sys_sigaction must be checked so
that EFAULT conditions don't go unreported.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/signal.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index ae36480..d4de05a 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -65,10 +65,10 @@ asmlinkage long sys_sigaction(int sig,
 		old_sigset_t mask;
 		if (verify_area(VERIFY_READ, act, sizeof(*act)) ||
 		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer) ||
+		    __get_user(new_ka.sa.sa_flags, &act->sa_flags) ||
+		    __get_user(mask, &act->sa_mask))
 			return -EFAULT;
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
 		siginitset(&new_ka.sa.sa_mask, mask);
 	}
 
@@ -77,10 +77,10 @@ asmlinkage long sys_sigaction(int sig,
 	if (!ret && oact) {
 		if (verify_area(VERIFY_WRITE, oact, sizeof(*oact)) ||
 		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer) ||
+		    __put_user(old_ka.sa.sa_flags, &oact->sa_flags) ||
+		    __put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask))
 			return -EFAULT;
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
 	}
 
 	return ret;

