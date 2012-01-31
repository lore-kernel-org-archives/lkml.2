Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2AaEva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:51:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:45760 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2AaEva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:51:30 -0500
Date: Mon, 30 Jan 2012 20:53:04 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org, arjanvandeven@gmail.com
Subject: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120130205304.0e10b05e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9f8dd2b15ff19ad73ee0eb235b4fdde9277185e8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 30 Jan 2012 20:38:09 -0800
Subject: [PATCH] x86: clean up smpboot.c's use of udelay+schedule

smpboot.c does a udelay() followed by a schedule(); to yield
the CPU to other threads. This comes from the time when the kernel
did not yet have usleep_*() style APIs...

... nowadays, the kernel can do better than this, and this
patch replaces this code sequence with a usleep_range(),
so that the CPU is actually yielded for some real time.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..0b794c6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -781,14 +781,13 @@ do_rest:
 		for (timeout = 0; timeout < 50000; timeout++) {
 			if (cpumask_test_cpu(cpu, cpu_callin_mask))
 				break;	/* It has booted */
-			udelay(100);
 			/*
 			 * Allow other tasks to run while we wait for the
 			 * AP to come online. This also gives a chance
 			 * for the MTRR work(triggered by the AP coming online)
 			 * to be completed in the stop machine context.
 			 */
-			schedule();
+			usleep_range(100, 200);
 		}
 
 		if (cpumask_test_cpu(cpu, cpu_callin_mask))
-- 
1.7.6.4



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
