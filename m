Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2HPBFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:05:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:40886 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2HPBFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,775,1336374000"; 
   d="scan'208";a="209076669"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH] x86_dump_trace: avoiding endless " <IRQ> " is printed
Thread-Topic: [PATCH] x86_dump_trace: avoiding endless " <IRQ> " is printed
Thread-Index: Ac15MsI6ncx2OLFBSBevzwjQUyIXXgCF2Qlg
Date: Thu, 16 Aug 2012 01:04:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A138403@SHSMSX101.ccr.corp.intel.com>
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


> The endless " <IRQ> " is as below:
> ...
> [   82.215244,0]  <IRQ>
> [   82.215399,0]  <IRQ>
> [   82.215554,0]  <IRQ>
> [   82.215710,0]  <IRQ>
> [   82.215865,0]  <IRQ>
> [   82.216022,0]  <IRQ>
> [   82.216178,0]  <IRQ>
> [   82.216333,0]  <IRQ>
> [   82.216488,0]  <IRQ>
> [   82.216643,0]  <IRQ>
> [   82.216798,0]  <IRQ>
> [   82.216953,0]  <IRQ>
> ...
> 
Anyone can give some help for the above logs? It is the real case we meet on our x86_32 platform.
I checked the code, the tons of " <IRQ> " should be printed from the below code in dumpstack_32.c:
[if (ops->stack(data, "IRQ") < 0)] will print " <IRQ> ", as for the endless printing, it should be for(;;) is not
broken, so I guess in this case context->previous_esp == context.

But from code review, previous_esp is just set at hardirq. No possible this case happening.
Who can give help? Thanks.

void dump_trace(struct task_struct *task, struct pt_regs *regs,
		unsigned long *stack, unsigned long bp,
		const struct stacktrace_ops *ops, void *data)
{
	for (;;) {
		struct thread_info *context;

		context = (struct thread_info *)
			((unsigned long)stack & (~(THREAD_SIZE - 1)));
		bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);

		stack = (unsigned long *)context->previous_esp;
		if (!stack)
			break;
		if (ops->stack(data, "IRQ") < 0) == > Here printing the " <IRQ> "
			break;
		touch_nmi_watchdog();
	}
}

