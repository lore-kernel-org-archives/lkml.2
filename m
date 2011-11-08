Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab1KHWkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:40:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59355 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab1KHWkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:40:06 -0500
Message-ID: <4EB9AFC0.4010206@suse.cz>
Date: Tue, 08 Nov 2011 23:40:00 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Greg KH <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Linux 2.6.32.47
References: <20111107213431.GA8483@kroah.com>  <1320708564@msgid.manchmal.in-ulm.de>  <20111108003024.GA6610@suse.de> <1320736973.16747.55.camel@dagon.hellion.org.uk>
In-Reply-To: <1320736973.16747.55.camel@dagon.hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 08:22 AM, Ian Campbell wrote:
> On Mon, 2011-11-07 at 16:30 -0800, Greg KH wrote:
>> On Tue, Nov 08, 2011 at 12:43:49AM +0100, Christoph Biedl wrote:
>>> Greg KH wrote...
>>>
>>>> I'm announcing the release of the 2.6.32.47 kernel.
>>>
>>> Unfortunately this does not build anymore on ARM (Debian armel):
>>>
>>>    CHK     include/linux/version.h
>>>    SYMLINK include/asm ->  include/asm-arm
>>> make[1]: `include/asm-arm/mach-types.h' is up to date.
>>>    CHK     include/linux/utsrelease.h
>>>    CALL    scripts/checksyscalls.sh
>>>    CHK     include/linux/compile.h
>>>    GEN     .version
>>>    CHK     include/linux/compile.h
>>>    UPD     include/linux/compile.h
>>>    CC      init/version.o
>>>    LD      init/built-in.o
>>>    LD      .tmp_vmlinux1
>>> drivers/built-in.o: In function `sysdev_resume':
>>> ledtrig-default-on.c:(.text+0x2a97c): undefined reference to `irq_pm_syscore_resume'
>>> make: *** [.tmp_vmlinux1] Error 1
>>>
>>>
>>> The most likely culprit is
>>>
>>>      commit 0f12a6ad9fa3a03f2bcee36c9cb704821e244c40
>>>      Author: Ian Campbell<ian.campbell@citrix.com>
>>>      Date:   Mon Oct 3 15:37:00 2011 +0100
>>>
>>> 	genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier
>>>
>>> as reverting that commit made the error go away.
>>>
>>> The .config used is attached. FWIW, the target system is a DockStar.
>>>
>>> Sorry for not having checked during the review period, I should have
>>> done so.
>>
>> Not good.
>>
>> Ian, Konrad, any thoughts as to how to fix this?
>
> Looks like I got the wrong CONFIG symbol for the function, or more
> importantly the dummy version of it. Sorry about this.
>
> Ian.
>
> 8<--------------------------------------------------------------
>
>> From 33a64cf4a184b47493ef312b08468aca3361e112 Mon Sep 17 00:00:00 2001
> From: Ian Campbell<ian.campbell@citrix.com>
> Date: Tue, 8 Nov 2011 07:19:06 +0000
> Subject: [PATCH] irq: fix build error due to missing irq_pm_syscore_resume
>
> irq_pm_syscore_resume is only available iff CONFIG_PM_SLEEP (kernel/irq/pm.o is
> only built if this is true). Move the definition (and the dummy definition)
> under that umbrella.
>
> Introduced by the backport of upstream 9bab0b7fbaceec47d32db51cd9e59c82fb071f5a
> as 0f12a6ad9fa3a03f2bcee36c9cb704821e244c40.
>
> Signed-off-by: Ian Campbell<ian.campbell@citrix.com>
> Reported-by: Christoph Biedl<linux-kernel.bfrz@manchmal.in-ulm.de>
> Reported-by: Antoine Martin<antoine@nagafix.co.uk>
> ---
>   include/linux/interrupt.h |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index c7e1aa5..a65ef60 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -199,16 +199,16 @@ extern void enable_irq(unsigned int irq);
>   #ifdef CONFIG_GENERIC_HARDIRQS
>   extern void suspend_device_irqs(void);
>   extern void resume_device_irqs(void);
> -extern void irq_pm_syscore_resume(void);
>   #ifdef CONFIG_PM_SLEEP
>   extern int check_wakeup_irqs(void);
> +extern void irq_pm_syscore_resume(void);
>   #else
>   static inline int check_wakeup_irqs(void) { return 0; }
> +static inline void irq_pm_syscore_resume(void) { };
>   #endif
>   #else
>   static inline void suspend_device_irqs(void) { };
>   static inline void resume_device_irqs(void) { };
> -static inline void irq_pm_syscore_resume(void) { };
>   static inline int check_wakeup_irqs(void) { return 0; }
>   #endif

Hmm, sparc doesn't have generic irqs. So:
drivers/base/sys.c: In function 'sysdev_resume':
drivers/base/sys.c:478: error: implicit declaration of function 
'irq_pm_syscore_resume'

regards,
-- 
js
suse labs
