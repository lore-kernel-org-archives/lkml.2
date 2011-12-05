Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1LENR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:17:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1LENR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:17:56 -0500
Date: Mon, 5 Dec 2011 05:17:34 -0800
From: tip-bot for Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Message-ID: <tip-69682b625a043b567873e6cda397969b502f0054@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rdunlap@xenotime.net, tglx@linutronix.de, mingo@elte.hu,
        mitsuo.hayasaka.hu@hitachi.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rdunlap@xenotime.net,
        mitsuo.hayasaka.hu@hitachi.com, mingo@elte.hu
In-Reply-To: <20111129060821.11076.55315.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060821.11076.55315.stgit@ltc219.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Add user_mode_vm check in stack_overflow_check
Git-Commit-ID: 69682b625a043b567873e6cda397969b502f0054
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:17:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69682b625a043b567873e6cda397969b502f0054
Gitweb:     http://git.kernel.org/tip/69682b625a043b567873e6cda397969b502f0054
Author:     Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
AuthorDate: Tue, 29 Nov 2011 15:08:21 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 11:28:25 +0100

x86: Add user_mode_vm check in stack_overflow_check

The kernel stack overflow is checked in stack_overflow_check(),
which may wrongly detect the overflow if the stack pointer in
user space points to the kernel stack intentionally or
accidentally. So, the actual overflow is never detected after
this misdetection because WARN_ONCE() is used on the detection
of it.

This patch adds user-mode-vm checking before it to avoid this
problem and bails out early if the user stack is used.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Randy Dunlap <rdunlap@xenotime.net>
Link: http://lkml.kernel.org/r/20111129060821.11076.55315.stgit@ltc219.sdl.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/irq_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index acf8fbf..69bca46 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -38,6 +38,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	u64 curbase = (u64)task_stack_page(current);
 
+	if (user_mode_vm(regs))
+		return;
+
 	WARN_ONCE(regs->sp >= curbase &&
 		  regs->sp <= curbase + THREAD_SIZE &&
 		  regs->sp <  curbase + sizeof(struct thread_info) +
