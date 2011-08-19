Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1HSQsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:48:55 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57415 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756374Ab1HSQst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:49 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 43/43] ncpfs: Use set_current_blocked()
Date: Fri, 19 Aug 2011 17:46:59 +0100
Message-Id: <1313772419-21951-44-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Also, there's no need to hold sighand->siglock while reading
sighand->action[] because the lock is dropped across the call to
do_ncp_rpc_call() during which time another thread could modify
->action[].

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/ncpfs/sock.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index 3a15872..850768a 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -749,10 +749,9 @@ static int ncp_do_request(struct ncp_server *server, int size,
 		return -EIO;
 	}
 	{
-		sigset_t old_set;
-		unsigned long mask, flags;
+		sigset_t old_set, blocked;
+		unsigned long mask;
 
-		spin_lock_irqsave(&current->sighand->siglock, flags);
 		old_set = current->blocked;
 		if (current->flags & PF_EXITING)
 			mask = 0;
@@ -769,16 +768,12 @@ static int ncp_do_request(struct ncp_server *server, int size,
 			if (current->sighand->action[SIGQUIT - 1].sa.sa_handler == SIG_DFL)
 				mask |= sigmask(SIGQUIT);
 		}
-		siginitsetinv(&current->blocked, mask);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		siginitsetinv(&blocked, mask);
+		set_current_blocked(&blocked);
 		
 		result = do_ncp_rpc_call(server, size, reply, max_reply_size);
 
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		current->blocked = old_set;
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		set_current_blocked(&old_set);
 	}
 
 	DDPRINTK("do_ncp_rpc_call returned %d\n", result);
-- 
1.7.4.4

