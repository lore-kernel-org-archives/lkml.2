Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1FCM6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:58:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab1FCM6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:58:08 -0400
Date: Fri, 3 Jun 2011 12:57:50 GMT
From: tip-bot for Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <tip-ef26f20cd117eb3c185038ed7cbf7b235575751d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sebastian@breakpoint.cc, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sebastian@breakpoint.cc
In-Reply-To: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc>
References: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Print threaded handler in spurious debug output
Git-Commit-ID: ef26f20cd117eb3c185038ed7cbf7b235575751d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 12:57:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef26f20cd117eb3c185038ed7cbf7b235575751d
Gitweb:     http://git.kernel.org/tip/ef26f20cd117eb3c185038ed7cbf7b235575751d
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Tue, 31 May 2011 08:56:10 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 3 Jun 2011 14:53:15 +0200

genirq: Print threaded handler in spurious debug output

In forced threaded mode (or with an explicit threaded handler) we only
see the primary handler, but not the threaded handler.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Link: http://lkml.kernel.org/r/1306824972-27067-1-git-send-email-sebastian@breakpoint.cc
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dfbd550..c9a78ba 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -201,10 +201,11 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	while (action) {
-		printk(KERN_ERR "[<%p>]", action->handler);
-		print_symbol(" (%s)",
-			(unsigned long)action->handler);
-		printk("\n");
+		printk(KERN_ERR "[<%p>] %pf", action->handler, action->handler);
+		if (action->thread_fn)
+			printk(KERN_CONT " threaded [<%p>] %pf",
+					action->thread_fn, action->thread_fn);
+		printk(KERN_CONT "\n");
 		action = action->next;
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
