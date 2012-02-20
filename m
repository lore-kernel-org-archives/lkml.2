Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2BTLsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:48:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33359 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2BTLsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:48:22 -0500
Date: Mon, 20 Feb 2012 03:47:08 -0800
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-45d5a1683c04be28abdf5c04c27b1417e0374486@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1329687817.1561.27.camel@acer.local.home>
References: <1329687817.1561.27.camel@acer.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/nmi:
  Test saved %cs in NMI to determine nested NMI case
Git-Commit-ID: 45d5a1683c04be28abdf5c04c27b1417e0374486
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 03:47:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45d5a1683c04be28abdf5c04c27b1417e0374486
Gitweb:     http://git.kernel.org/tip/45d5a1683c04be28abdf5c04c27b1417e0374486
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Sun, 19 Feb 2012 16:43:37 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 20 Feb 2012 09:09:57 +0100

x86/nmi: Test saved %cs in NMI to determine nested NMI case

Currently, the NMI handler tests if it is nested by checking the
special variable saved on the stack (set during NMI handling)
and whether the saved stack is the NMI stack as well (to prevent
the race when the variable is set to zero).

But userspace may set their %rsp to any value as long as they do
not derefence it, and it may make it point to the NMI stack,
which will prevent NMIs from triggering while the userspace app
is running. (I tested this, and it is indeed the case)

Add another check to determine nested NMIs by looking at the
saved %cs (code segment register) and making sure that it is the
kernel code segment.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1329687817.1561.27.camel@acer.local.home
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..debd851 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1532,6 +1532,13 @@ ENTRY(nmi)
 	pushq_cfi %rdx
 
 	/*
+	 * If %cs was not the kernel segment, then the NMI triggered in user
+	 * space, which means it is definitely not nested.
+	 */
+	cmp $__KERNEL_CS, 16(%rsp)
+	jne first_nmi
+
+	/*
 	 * Check the special variable on the stack to see if NMIs are
 	 * executing.
 	 */
