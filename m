Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2LMOH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab2LMOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 116/241] sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()
Date: Thu, 13 Dec 2012 11:58:01 -0200
Message-Id: <1355407206-17100-117-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit fae2ae2a900a5c7bb385fe4075f343e7e2d5daa2 upstream.

If a signal handler is executed on altstack and another signal comes,
we will end up with rt_sigreturn() on return from the second handler
getting -EPERM from do_sigaltstack().  It's perfectly OK, since we
are not asking to change the settings; in fact, they couldn't have been
changed during the second handler execution exactly because we'd been
on altstack all along.  64bit sigreturn on sparc treats any error from
do_sigaltstack() as "SIGSEGV now"; we need to switch to the same semantics
we are using on other architectures.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/sparc/kernel/signal_64.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 867de2f..689e1ba 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -295,9 +295,7 @@ void do_rt_sigreturn(struct pt_regs *regs)
 		err |= restore_fpu_state(regs, fpu_save);
 
 	err |= __copy_from_user(&set, &sf->mask, sizeof(sigset_t));
-	err |= do_sigaltstack(&sf->stack, NULL, (unsigned long)sf);
-
-	if (err)
+	if (err || do_sigaltstack(&sf->stack, NULL, (unsigned long)sf) == -EFAULT)
 		goto segv;
 
 	err |= __get_user(rwin_save, &sf->rwin_save);
-- 
1.7.9.5

