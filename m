Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1LENUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:20:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1LENUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:20:05 -0500
Date: Mon, 5 Dec 2011 05:19:52 -0800
From: tip-bot for Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Message-ID: <tip-467e6b7a7c0eb792ebaf322ddb7363742b4ead40@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rdunlap@xenotime.net, tglx@linutronix.de, mingo@elte.hu,
        mitsuo.hayasaka.hu@hitachi.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rdunlap@xenotime.net,
        mitsuo.hayasaka.hu@hitachi.com, mingo@elte.hu
In-Reply-To: <20111129060845.11076.40916.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060845.11076.40916.stgit@ltc219.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Clean up the range of stack overflow checking
Git-Commit-ID: 467e6b7a7c0eb792ebaf322ddb7363742b4ead40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:19:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  467e6b7a7c0eb792ebaf322ddb7363742b4ead40
Gitweb:     http://git.kernel.org/tip/467e6b7a7c0eb792ebaf322ddb7363742b4ead40
Author:     Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
AuthorDate: Tue, 29 Nov 2011 15:08:45 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 11:37:48 +0100

x86: Clean up the range of stack overflow checking

The overflow checking of kernel stack checks if the stack
pointer points to the available kernel stack range, which is
derived from the original overflow checking.

It is clear that curbase address is always less than low
boundary of available kernel stack. So, this patch removes the
first condition that checks if the pointer is higher than
curbase.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Randy Dunlap <rdunlap@xenotime.net>
Link: http://lkml.kernel.org/r/20111129060845.11076.40916.stgit@ltc219.sdl.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/irq_64.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 42552b0..54e2b2b 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -46,10 +46,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 	if (user_mode_vm(regs))
 		return;
 
-	if (regs->sp >= curbase &&
-	    regs->sp <= curbase + THREAD_SIZE &&
-	    regs->sp >= curbase + sizeof(struct thread_info) +
-				  sizeof(struct pt_regs) + 128)
+	if (regs->sp >= curbase + sizeof(struct thread_info) +
+				  sizeof(struct pt_regs) + 128 &&
+	    regs->sp <= curbase + THREAD_SIZE)
 		return;
 
 	irq_stack_top = (u64)__get_cpu_var(irq_stack_union.irq_stack);
