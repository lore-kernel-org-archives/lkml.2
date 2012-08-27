Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2H0PuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:50:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:44069 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab2H0Pt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:49:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,321,1344236400"; 
   d="scan'208";a="191857504"
From: "Gross, Mark" <mark.gross@intel.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
CC: "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH RESEND] x86_dump_trace: avoiding endless " <IRQ> " is
 printed
Thread-Topic: [PATCH RESEND] x86_dump_trace: avoiding endless " <IRQ> " is
 printed
Thread-Index: Ac2D9xtDBkCP/QDsRbSYlkNzzpgV2AAcy6GQ
Date: Mon, 27 Aug 2012 15:49:55 +0000
Message-ID: <BD75D217E5BAC84080F8EFB25829763746C926C7@ORSMSX101.amr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A16FBD5@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A16FBD5@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you think we should add the same change to dumpstack_64.c too.

Looks like you addressed Alan's comments already (i.e. use of unlikely not needed, us %p, and use pr_warn instead of printk)

--mark

> -----Original Message-----
> From: Liu, Chuansheng
> Sent: Sunday, August 26, 2012 6:56 PM
> To: 'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)
> Cc: hpa@linux.intel.com; Gross, Mark; alan@linux.intel.com
> Subject: [PATCH RESEND] x86_dump_trace: avoiding endless " <IRQ> " is
> printed
> 
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] x86_dump_trace: avoiding endless " <IRQ> " is printed
> 
> Found the case that endless " <IRQ> " printing in dump_trace, and no real
> meaningful stack traces are output, so there should be one rare case that
> possibly context->previous_esp = context or other cases.
> 
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
> This patch aim is:
> 1/ Limiting the " <IRQ> " outputing, currently the max IRQ contexts is
> 2(softirq+harirq combination); 2/ When the max IRQ contexts 2 is reached,
> print the context content to confirm;
> 
> Change-Id: I6d72aa71c4c5ff8f9e6ae133b3f6bfec8887750d
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  arch/x86/kernel/dumpstack_32.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_32.c
> b/arch/x86/kernel/dumpstack_32.c index 1038a41..410fa38 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -22,6 +22,7 @@ void dump_trace(struct task_struct *task, struct pt_regs
> *regs,
>                 const struct stacktrace_ops *ops, void *data)  {
>         int graph = 0;
> +       int dump_irq_count = 0;
> 
>         if (!task)
>                 task = current;
> @@ -47,8 +48,18 @@ void dump_trace(struct task_struct *task, struct
> pt_regs *regs,
>                 stack = (unsigned long *)context->previous_esp;
>                 if (!stack)
>                         break;
> +
> +               if (dump_irq_count > 2) {
> +                       pr_warn("break multi-IRQ print,"
> +                               "context=%p, stack=%p\n",
> +                               context,
> +                               stack);
> +                       break;
> +               }
> +
>                 if (ops->stack(data, "IRQ") < 0)
>                         break;
> +               dump_irq_count++;
>                 touch_nmi_watchdog();
>         }
>  }
> --
> 1.7.0.4
