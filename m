Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2DQAFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:05:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2DQAFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:05:35 -0400
Date: Mon, 16 Apr 2012 17:05:11 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-089f9fba56faf33cc6dd2a6442b7ac92c58b8209@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jan.kratochvil@redhat.com,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, jan.kratochvil@redhat.com,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <20120416204815.GB24884@redhat.com>
References: <20120416204815.GB24884@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] i387: ptrace breaks the lazy-fpu-restore logic
Git-Commit-ID: 089f9fba56faf33cc6dd2a6442b7ac92c58b8209
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Apr 2012 17:05:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  089f9fba56faf33cc6dd2a6442b7ac92c58b8209
Gitweb:     http://git.kernel.org/tip/089f9fba56faf33cc6dd2a6442b7ac92c58b8209
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 16 Apr 2012 22:48:15 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 Apr 2012 16:23:59 -0700

i387: ptrace breaks the lazy-fpu-restore logic

Starting from 7e16838d "i387: support lazy restore of FPU state"
we assume that fpu_owner_task doesn't need restore_fpu_checking()
on the context switch, its FPU state should match what we already
have in the FPU on this CPU.

However, debugger can change the tracee's FPU state, in this case
we should reset fpu.last_cpu to ensure fpu_lazy_restore() can't
return true.

Change init_fpu() to do this, it is called by user_regset->set()
methods.

Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20120416204815.GB24884@redhat.com
Cc: <stable@vger.kernel.org> v3.3
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/i387.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 7734bcb..2d6e649 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -235,6 +235,7 @@ int init_fpu(struct task_struct *tsk)
 	if (tsk_used_math(tsk)) {
 		if (HAVE_HWFP && tsk == current)
 			unlazy_fpu(tsk);
+		tsk->thread.fpu.last_cpu = ~0;
 		return 0;
 	}
 
