Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab1LFJm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:42:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab1LFJmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:42:24 -0500
Date: Tue, 6 Dec 2011 01:42:00 -0800
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-3596ff4e6b2aff8a28c69af389d5046090a53330@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111025141812.GA21225@linux.vnet.ibm.com>
References: <20111025141812.GA21225@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Call do_notify_resume() with interrupts enabled
Git-Commit-ID: 3596ff4e6b2aff8a28c69af389d5046090a53330
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:42:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3596ff4e6b2aff8a28c69af389d5046090a53330
Gitweb:     http://git.kernel.org/tip/3596ff4e6b2aff8a28c69af389d5046090a53330
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Oct 2011 19:48:12 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:20:34 +0100

x86: Call do_notify_resume() with interrupts enabled

do_notify_resume() gets called with interrupts disabled on x86_32. This
is different from the x86_64 behavior, where interrupts are enabled at
the time.

Queries on lkml on this issue hasn't yielded any clear answer. Lets make
x86_32 behave the same as x86_64, unless there is a real reason to
maintain status quo.

Please refer https://lkml.org/lkml/2011/9/27/130 for more
details.

A similar change was suggested in ARM:

	https://lkml.org/lkml/2011/8/25/231

My 32-bit machine works fine (tm) with this patch.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20111025141812.GA21225@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_32.S |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f3f6f53..22d0e21 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -625,6 +625,8 @@ work_notifysig:				# deal with pending signals and
 	movl %esp, %eax
 	jne work_notifysig_v86		# returning to kernel-space or
 					# vm86-space
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %edx, %edx
 	call do_notify_resume
 	jmp resume_userspace_sig
@@ -638,6 +640,8 @@ work_notifysig_v86:
 #else
 	movl %esp, %eax
 #endif
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %edx, %edx
 	call do_notify_resume
 	jmp resume_userspace_sig
