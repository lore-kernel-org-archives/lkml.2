Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2LCOgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43800 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283Ab2LCOgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:32 -0500
Message-Id: <20121203143155.865207484@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 60/89] sparc64: not any error from do_sigaltstack() should fail
 rt_sigreturn()
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


