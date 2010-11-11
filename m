Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0KKM1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:27:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:41335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab0KKM07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:26:59 -0500
Subject: Re: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <9FCE46230501DF4D9461B9ACC152FD7104DDA26D@zmy16exm20.fsl.freescale.net>
Date: Thu, 11 Nov 2010 06:26:33 -0600
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, Li Yang-R58472 <R58472@freescale.com>,
        Gala Kumar-B11780 <B11780@freescale.com>,
        Zang Roy-R61911 <R61911@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A530CF80-F6B6-40BE-A465-18884B887432@kernel.crashing.org>
References: <1288777018-24259-1-git-send-email-b21989@freescale.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55201538B08@CORPEXCH1.na.ads.idt.com> <9FCE46230501DF4D9461B9ACC152FD7104DDA26D@zmy16exm20.fsl.freescale.net>
To: Xie Shaohui-B21989 <B21989@freescale.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 11, 2010, at 4:19 AM, Xie Shaohui-B21989 wrote:

> 
> 
> 
> Best Regards, 
> Shaohui Xie 
> 
> 
>> -----Original Message-----
>> From: Bounine, Alexandre [mailto:Alexandre.Bounine@idt.com]
>> Sent: Thursday, November 11, 2010 6:55 AM
>> To: Xie Shaohui-B21989; akpm@linux-foundation.org
>> Cc: linux-kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Li
> Yang-
>> R58472; Gala Kumar-B11780; Zang Roy-R61911
>> Subject: RE: [PATCH 3/4][v2] fsl_rio: move machine_check handler into
>> machine_check_e500 & machine_check_e500mc
>> 
>> Shaohui Xie <b21989@freescale.com> wrote:
>>> 
>>> diff --git a/arch/powerpc/kernel/traps.c
> b/arch/powerpc/kernel/traps.c
>>> index a45a63c..2a5fb9d 100644
>>> --- a/arch/powerpc/kernel/traps.c
>>> +++ b/arch/powerpc/kernel/traps.c
>>> @@ -55,6 +55,7 @@
>>> #endif
>>> #include <asm/kexec.h>
>>> #include <asm/ppc-opcode.h>
>>> +#include <linux/rio.h>
>>> 
>>> #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)  int
>>> (*__debugger)(struct pt_regs *regs) __read_mostly; @@ -500,6 +501,13
>>> @@ int machine_check_e500mc(struct pt_regs *regs)
>>> 		       reason & MCSR_MEA ? "Effective" : "Physical",
>> addr);
>>> 	}
>>> 
>>> +	if (reason & MCSR_BUS_RBERR) {
>>> +		printk("Bus - Read Data Bus Error\n"); #ifdef
> CONFIG_RAPIDIO
>>> +		recoverable = fsl_rio_mcheck_exception(regs); #endif
>>> +	}
>>> +
>>> 	mtspr(SPRN_MCSR, mcsr);
>>> 	return mfspr(SPRN_MCSR) == 0 && recoverable;  } @@ -527,8
> +535,12
>> @@
>>> int machine_check_e500(struct pt_regs *regs)
>>> 		printk("Bus - Write Address Error\n");
>>> 	if (reason & MCSR_BUS_IBERR)
>>> 		printk("Bus - Instruction Data Error\n");
>>> -	if (reason & MCSR_BUS_RBERR)
>>> +	if (reason & MCSR_BUS_RBERR) {
>>> 		printk("Bus - Read Data Bus Error\n");
>>> +#ifdef CONFIG_RAPIDIO
>>> +		fsl_rio_mcheck_exception(regs);
>>> +#endif
>>> +	}
>>> 	if (reason & MCSR_BUS_WBERR)
>>> 		printk("Bus - Read Data Bus Error\n");
>>> 	if (reason & MCSR_BUS_IPERR)
>> 
>> This implementation breaks an intended use of
>> fsl_rio_mcheck_exception():
>> 1. for e500 it does not check the return value of the rio handler and
>> crashes the system even after RIO Mchk was serviced. Looks like e500mc
>> version handles it better but I have no HW to test it.
>> 2. the RIO Mchk is expected to be handled quietly but here it has many
>> printk's. May be it is better to call the fsl_rio_mcheck_exception()
>> handler in very beginning and simply exit if it returns 1.
>> 
>> Alex.
> [Xie Shaohui-B21989] Hi Alex, seems your suggestion is some kind of
> conflict with Kumar, you can have a look at 
> http://patchwork.ozlabs.org/patch/67774/

I think Alex's comment is the fact we ignore the 'return' value in the machine_check_e500 case.

- k