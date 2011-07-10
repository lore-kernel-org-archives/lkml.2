Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1GJQrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:47:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1GJQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:47:14 -0400
Date: Sun, 10 Jul 2011 18:44:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kill handle_signal()->set_fs()
Message-ID: <20110710164424.GA20261@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/signal.c |    9 ---------
 1 file changed, 9 deletions(-)

--- ptrace/arch/x86/kernel/signal.c~1_kill_set_fs	2011-05-22 16:27:28.000000000 +0200
+++ ptrace/arch/x86/kernel/signal.c	2011-07-10 18:06:30.000000000 +0200
@@ -717,15 +717,6 @@ handle_signal(unsigned long sig, siginfo
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

