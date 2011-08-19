Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1HSQsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:48:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57391 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357Ab1HSQsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:33 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: [PATCH v2 37/43] xtensa: No need to reset handler if SA_ONESHOT
Date: Fri, 19 Aug 2011 17:46:53 +0100
Message-Id: <1313772419-21951-38-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

get_signal_to_deliver() already resets the signal handler if
SA_ONESHOT is set in ka->sa.sa_flags, there's no need to do it again
in handle_signal(). Furthermore, because we were modifying
ka->sa.sa_handler (which is a copy of sighand->action[]) instead of
sighand->action[] the original code actually had no effect on signal
delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/xtensa/kernel/signal.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 4f53770..24655e3 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -536,9 +536,6 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 		/* Set up the stack frame */
 		setup_frame(signr, &ka, &info, oldset, regs);
 
-		if (ka.sa.sa_flags & SA_ONESHOT)
-			ka.sa.sa_handler = SIG_DFL;
-
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked, &ka.sa.sa_mask);
 		if (!(ka.sa.sa_flags & SA_NODEFER))
-- 
1.7.4.4

