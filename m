Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1C3TEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:04:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57791 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754847Ab1C3TE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:04:29 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [PATCH] avr32: Don't acquire siglock when reading sighand action
Date: Wed, 30 Mar 2011 20:04:16 +0100
Message-Id: <1301511856-9370-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

There's no need to acquire the siglock when simply reading the action
handler. We would need to lock it if we were modifying the handler or
we were protecting it from modification across function calls, but if
we're just reading it, there's no need to lock it

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 arch/avr32/kernel/traps.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index b91b204..82f47e6 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -106,9 +106,7 @@ void _exception(long signr, struct pt_regs *regs, int code,
 	if (is_global_init(current)) {
 		__sighandler_t handler;
 
-		spin_lock_irq(&current->sighand->siglock);
 		handler = current->sighand->action[signr-1].sa.sa_handler;
-		spin_unlock_irq(&current->sighand->siglock);
 		if (handler == SIG_DFL) {
 			/* init has generated a synchronous exception
 			   and it doesn't have a handler for the signal */
-- 
1.7.4

