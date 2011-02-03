Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1BCWLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:11:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1BCWLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:11:39 -0500
Message-ID: <4D4B27F5.8020701@zytor.com>
Date: Thu, 03 Feb 2011 14:11:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: castet.matthieu@free.fr, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
References: <4D473FD5.1090903@free.fr> <20110201080223.GB20372@elte.hu> <1296566732.4d4809cc1f963@imp.free.fr> <20110202062632.GA12256@elte.hu>
In-Reply-To: <20110202062632.GA12256@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 10:26 PM, Ingo Molnar wrote:
> 
> * castet.matthieu@free.fr <castet.matthieu@free.fr> wrote:
> 
>> Quoting Ingo Molnar <mingo@elte.hu>:
>>
>>>
>>> * matthieu castet <castet.matthieu@free.fr> wrote:
>>>
>>>>  static inline int is_kernel_text(unsigned long addr)
>>>>  {
>>>> +#if defined(CONFIG_X86_32) && defined(CONFIG_ACPI_SLEEP)
>>>> +	/*
>>>> +	 * We need to make the wakeup trampoline in first 1MB !NX
>>>> +	 */
>>>> +	if (addr >= PAGE_OFFSET && addr <= (PAGE_OFFSET + (1<<20)))
>>>> +		return 1;
>>>> +#endif
>>>
>>> That's pretty ugly. Why not use set_memory_x()/set_memory_nx(), and only for
>>> the
>>> trampoline itself? Does the whole 1MB need to be marked X?
>>
>> The previous code was doing that.
> 
> So why not call set_memory_x() in your patch? Mind trying that?
> 

OK, there seems to be considerable duplication between
static_protections() and local invocation.  Consider PCI BIOS, which is
another X-needed region.

In static_protections() we have:

>         /*
>          * The BIOS area between 640k and 1Mb needs to be executable for
>          * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
>          */
> #ifdef CONFIG_PCI_BIOS
>         if (pcibios_enabled && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
>                 pgprot_val(forbidden) |= _PAGE_NX;
> #endif

... however, in arch/x86/pci/pcbios.c:

> static inline void set_bios_x(void)
> {
>         pcibios_enabled = 1;
>         set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
>         if (__supported_pte_mask & _PAGE_NX)
>                 printk(KERN_INFO "PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.\n");
> }

This is blatant and insanely ugly code duplication!  In particular,
static_protections() is "action at a distance" which has no business
existing at all.

What I want to know is if static_protections() can somehow override
set_bios_x() in this context (in which case it's a serious design
error), or if it is plain redundant -- in the latter case we should
simply use the same technique elsewhere.

	-hpa
