Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1HKOBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:01:51 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60145 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab1HKN6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:10 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 26/41] sh: No need to reset handler if SA_ONESHOT
Date: Thu, 11 Aug 2011 14:57:00 +0100
Message-Id: <1313071035-12047-27-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

get_signal_to_deliver() already resets the signal handler if
SA_ONESHOT is set in ka->sa.sa_flags, there's no need to do it again
in handle_signal(). Furthermore, because we were modifying
ka->sa.sa_handler without holding ->sighand->siglock there's the
potential we can race with another thread if it modifies the signal
handlers.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/sh/kernel/signal_32.c |    3 ---
 arch/sh/kernel/signal_64.c |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 579cd2c..7a00304 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -548,9 +548,6 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
 	if (ret == 0) {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 5a9f1f1..c0e7d10 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -738,9 +738,6 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
 	if (ret == 0) {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-- 
1.7.4.4

