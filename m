Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab1GOFr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:47:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:49897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778Ab1GOFrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:47:55 -0400
Date: Fri, 15 Jul 2011 05:47:50 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-73d382deccac186d103496bf10388bc2432a8384@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <20110710164424.GA20261@redhat.com>
References: <20110710164424.GA20261@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/signal] x86: Kill handle_signal()->set_fs()
Git-Commit-ID: 73d382deccac186d103496bf10388bc2432a8384
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 05:47:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73d382deccac186d103496bf10388bc2432a8384
Gitweb:     http://git.kernel.org/tip/73d382deccac186d103496bf10388bc2432a8384
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 10 Jul 2011 18:44:24 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 21:46:20 -0700

x86: Kill handle_signal()->set_fs()

handle_signal()->set_fs() has a nice comment which explains what
set_fs() is, but it doesn't explain why it is needed and why it
depends on CONFIG_X86_64.

Afaics, the history of this confusion is:

	1. I guess today nobody can explain why it was needed
	   in arch/i386/kernel/signal.c, perhaps it was always
	   wrong. This predates 2.4.0 kernel.

	2. then it was copy-and-past'ed to the new x86_64 arch.

	3. then it was removed from i386 (but not from x86_64)
	   by b93b6ca3 "i386: remove unnecessary code".

	4. then it was reintroduced under CONFIG_X86_64 when x86
	   unified i386 and x86_64, because the patch above didn't
	   touch x86_64.

Remove it. ->addr_limit should be correct. Even if it was possible
that it is wrong, it is too late to fix it after setup_rt_frame().

Linus commented in:
http://lkml.kernel.org/r/alpine.LFD.0.999.0707170902570.19166@woody.linux-foundation.org

... about the equivalent bit from i386:

Heh. I think it's entirely historical.

Please realize that the whole reason that function is called "set_fs()" is 
that it literally used to set the %fs segment register, not 
"->addr_limit".

So I think the "set_fs(USER_DS)" is there _only_ to match the other

        regs->xds = __USER_DS;
        regs->xes = __USER_DS;
        regs->xss = __USER_DS;
        regs->xcs = __USER_CS;

things, and never mattered. And now it matters even less, and has been 
copied to all other architectures where it is just totally insane.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20110710164424.GA20261@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/signal.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 8c55f97..54ddaeb2 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -720,15 +720,6 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_X86_64
-	/*
-	 * This has nothing to do with segment registers,
-	 * despite the name.  This magic affects uaccess.h
-	 * macros' behavior.  Reset it to the normal setting.
-	 */
-	set_fs(USER_DS);
-#endif
-
 	/*
 	 * Clear the direction flag as per the ABI for function entry.
 	 */
