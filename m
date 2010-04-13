Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab0DMTfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:35:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0DMTfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:35:16 -0400
Date: Tue, 13 Apr 2010 19:33:54 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, andi@firstfloor.org, peterz@infradead.org,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net, torvalds@osdl.org,
       gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, peterz@infradead.org,
       alan@lxorguk.ukuu.org.uk, davem@davemloft.net, torvalds@osdl.org,
       gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100326000405.758579387@linutronix.de>
References: <20100326000405.758579387@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Run irq handlers with interrupts disabled
Message-ID: <tip-e58aa3d2d0cc01ad8d6f7f640a0670433f794922@git.kernel.org>
Git-Commit-ID: e58aa3d2d0cc01ad8d6f7f640a0670433f794922
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 13 Apr 2010 19:33:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e58aa3d2d0cc01ad8d6f7f640a0670433f794922
Gitweb:     http://git.kernel.org/tip/e58aa3d2d0cc01ad8d6f7f640a0670433f794922
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 26 Mar 2010 00:06:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 13 Apr 2010 16:36:40 +0200

genirq: Run irq handlers with interrupts disabled

Running interrupt handlers with interrupts enabled can cause stack
overflows. That has been observed with multiqueue NICs delivering all
their interrupts to a single core. We might band aid that somehow by
checking the interrupt stacks, but the real safe fix is to run the irq
handlers with interrupts disabled.

Drivers for whacky hardware still can reenable them in the handler
itself, if the need arises. (They do already due to lockdep)

The risk of doing this is rather low:

 - lockdep already enforces this
 - CONFIG_NOHZ has shaken out the drivers which relied on jiffies updates
 - time keeping is not longer sensitive to the timer interrupt being delayed

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>
LKML-Reference: <20100326000405.758579387@linutronix.de>

---
 kernel/irq/handle.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..27e5c69 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -370,9 +370,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	if (!(action->flags & IRQF_DISABLED))
-		local_irq_enable_in_hardirq();
-
 	do {
 		trace_irq_handler_entry(irq, action);
 		ret = action->handler(irq, action->dev_id);
