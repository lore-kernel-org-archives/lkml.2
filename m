Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0G2Cp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 22:45:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:37890 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab0G2Cp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 22:45:26 -0400
Message-ID: <4C50EC4E.6090004@windriver.com>
Date: Thu, 29 Jul 2010 10:49:50 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [GIT PULL] kgdb regression fixes for 2.6.35-rc5
References: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com>	<20100728211725.GF5394@nowhere>	<AANLkTikXGm0WK+N=YMWJc+hBgVAyLc0adu4K1iX5UMW=@mail.gmail.com>	<4C50C7F2.8020305@windriver.com> <20100729010607.GB13088@nowhere>
In-Reply-To: <20100729010607.GB13088@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2010 02:45:08.0149 (UTC) FILETIME=[0E7B4E50:01CB2EC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Jul 28, 2010 at 07:14:42PM -0500, Jason Wessel wrote:
>> On 07/28/2010 04:26 PM, Linus Torvalds wrote:
>>> On Wed, Jul 28, 2010 at 2:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>> I'm sorry I spot it a bit late.
>>>> There is a little issue in this patch, irqs won't
>>>> be restored:
>>>>
>>>> @@ -588,9 +588,10 @@ int kgdb_ll_trap(int cmd, const char *str,
>>>>        if (!kgdb_io_module_registered)
>>>>                return NOTIFY_DONE;
>>>>
>>>> +       local_irq_save(flags);
>>>>        return __kgdb_notify(&args, cmd);
>>>> +       local_irq_restore(flags);
>>>>  }
>>> Yeah, that's obviously crap. I also wonder why __kgdb_notify messes up
>>> the flags to begin with.
>>>
>> This should not be needed as the irqs should already be off while in the overflow handler.
> 
> 
> 
> Interrupts are not disabled in the debug exception handler.

Hi Frederic,

The debug was initialized as an intr gate, thus the interrupts have been 
disabled in the debug exception handler. :-)

arch/x86/kernel/traps.c:
820 /* Set of traps needed for early debugging. */
821 void __init early_trap_init(void)
822 {
823     set_intr_gate_ist(1, &debug, DEBUG_STACK);
824     /* int3 can be called from all */
825     set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
826     set_intr_gate(14, &page_fault);
827     load_idt(&idt_descr);
828 }

Thanks,
Dongdong

> 
> I'm not sure what would be the state of dr6 if a nested debug exception
> would happen while do_debug() is interrupted.
> 
> Perhaps the previous dr6 value is dropped. Intel manuals don't seem to say anything
> about that.
> 
> Anyway that's a separate issue. The current patch fixes a regression and
> it looks good.
> 
> Thanks.
> 
> 
> ------------------------------------------------------------------------------
> The Palm PDK Hot Apps Program offers developers who use the
> Plug-In Development Kit to bring their C/C++ apps to Palm for a share
> of $1 Million in cash or HP Products. Visit us here for more details:
> http://p.sf.net/sfu/dev2dev-palm
> _______________________________________________
> Kgdb-bugreport mailing list
> Kgdb-bugreport@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kgdb-bugreport
> 

