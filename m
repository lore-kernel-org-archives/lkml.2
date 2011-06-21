Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1FUPki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:40:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:41577 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1FUPkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:40:35 -0400
Message-Id: <20110621151725.705140475@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 17:17:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de
Subject: [PATCH 0/4] printk: Remove lockdep_off() and wakeups -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last iteration of the printk() rework which removes the lockdep_off() hackery
and removes the need for printk() to issue wakeups, thereby increasing
reliability from variuos contexts.

Patch 0b5e1c5255 from -tip needs to be reverted (or better dropped), due
us discovering why doing up() under logbuf_lock was important -- thanks 
Andrew, Ingo!

This series was tested on a lockdep enabled kernel with the below hack
included, which generated a nice splat.

---
 kernel/printk.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -930,6 +930,11 @@ asmlinkage int vprintk(const char *fmt, 
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
+	if (panic_timeout) {
+		panic_timeout = 0;
+		local_irq_enable();
+	}
+
 	if (recursion_bug) {
 		recursion_bug = 0;
 		strcpy(printk_buf, recursion_bug_msg);

