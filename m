Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab2KSCfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:35:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52225 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2KSCfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:35:10 -0500
Date: Mon, 19 Nov 2012 02:35:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
Message-ID: <20121119023507.GK16916@ZenIV.linux.org.uk>
References: <20121118210253.GI16916@ZenIV.linux.org.uk>
 <20121118.161833.985081954687473276.davem@davemloft.net>
 <20121119011013.GJ16916@ZenIV.linux.org.uk>
 <20121118.203005.151867624663051294.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118.203005.151867624663051294.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 08:30:05PM -0500, David Miller wrote:
> > Er...  So which tree should that go through?  sparc or signal?  There's
> > a similar microblaze patch and a few more of the "do_sigaltstack() takes
> > userland pointer" variety, so I can put together a pile in
> > signal.git#for-linus, but if you prefer that to go through sparc tree,
> > I'm fine with that...
> 
> I'm happy to take it via my sparc tree, and I'll queue it up for
> -stable as well. Can you resend it to me with a proper commit message?

sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()

If a signal handler is executed on altstack and another signal comes,
we will end up with rt_sigreturn() on return from the second handler
getting -EPERM from do_sigaltstack().  It's perfectly OK, since we
are not asking to change the settings; in fact, they couldn't have been
changed during the second handler execution exactly because we'd been
on altstack all along.  64bit sigreturn on sparc treats any error from
do_sigaltstack() as "SIGSEGV now"; we need to switch to the same semantics
we are using on other architectures.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
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
