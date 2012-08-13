Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab2HMJF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:05:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:20284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2HMJF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:05:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,758,1336374000"; 
   d="scan'208";a="179900842"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: [PATCH] x86_dump_trace: avoiding endless " <IRQ> " is printed
Thread-Topic: [PATCH] x86_dump_trace: avoiding endless " <IRQ> " is printed
Thread-Index: Ac15MsI6ncx2OLFBSBevzwjQUyIXXg==
Date: Mon, 13 Aug 2012 09:05:23 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A13679F@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] x86_dump_trace: avoiding endless " <IRQ> " is printed

Found the case that endless " <IRQ> " printing in dump_trace,
and no real meaningful stack traces are output, so there should
one rare case that possibly context->previous_esp = context or
other cases.

The endless " <IRQ> " is as below:
...
[   82.215244,0]  <IRQ>
[   82.215399,0]  <IRQ>
[   82.215554,0]  <IRQ>
[   82.215710,0]  <IRQ>
[   82.215865,0]  <IRQ>
[   82.216022,0]  <IRQ>
[   82.216178,0]  <IRQ>
[   82.216333,0]  <IRQ>
[   82.216488,0]  <IRQ>
[   82.216643,0]  <IRQ>
[   82.216798,0]  <IRQ>
[   82.216953,0]  <IRQ>
...

This patch aim is:
1/ Limiting the " <IRQ> " outputing, currently the max IRQ contexts
is 2(softirq+harirq combination);
2/ When the max IRQ contexts 2 is reached, print the context content
to confirm;

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/dumpstack_32.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 1038a41..5387429 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -22,6 +22,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
                const struct stacktrace_ops *ops, void *data)
 {
        int graph = 0;
+       int dump_irq = 0;
 
        if (!task)
                task = current;
@@ -47,8 +48,18 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
                stack = (unsigned long *)context->previous_esp;
                if (!stack)
                        break;
+
+               if (unlikely(dump_irq > 2)) {
+                       printk(KERN_WARNING "break multi-IRQ print,"
+                               "context=%08lx, stack=%08lx\n",
+                               (unsigned long)context,
+                               (unsigned long)stack);
+                       break;
+               }
+
                if (ops->stack(data, "IRQ") < 0)
                        break;
+               dump_irq++;
                touch_nmi_watchdog();
        }
 }
-- 
1.7.0.4
