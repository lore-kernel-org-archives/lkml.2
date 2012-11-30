Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031705Ab2K3Stm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:49:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:57450 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031634Ab2K3St1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/37] sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()
Date: Fri, 30 Nov 2012 10:46:09 -0800
Message-Id: <20121130183859.634524718@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/kernel/signal_64.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -309,9 +309,7 @@ void do_rt_sigreturn(struct pt_regs *reg
 		err |= restore_fpu_state(regs, fpu_save);
 
 	err |= __copy_from_user(&set, &sf->mask, sizeof(sigset_t));
-	err |= do_sigaltstack(&sf->stack, NULL, (unsigned long)sf);
-
-	if (err)
+	if (err || do_sigaltstack(&sf->stack, NULL, (unsigned long)sf) == -EFAULT)
 		goto segv;
 
 	err |= __get_user(rwin_save, &sf->rwin_save);


