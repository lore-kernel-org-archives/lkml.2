Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab1AVFVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 00:21:41 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:10526 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1AVFVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 00:21:40 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jan 2011 00:21:40 EST
Date: Sat, 22 Jan 2011 00:11:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kees Cook <kees.cook@canonical.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "keir.fraser@eu.citrix.com" <keir.fraser@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "sliakh.lkml@gmail.com" <sliakh.lkml@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "ak@muc.de" <ak@muc.de>, "davej@redhat.com" <davej@redhat.com>,
        "jiang@cs.ncsu.edu" <jiang@cs.ncsu.edu>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Stefan Bader <stefan.bader@canonical.com>, konrad@kernel.org
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <20110122051134.GA6905@dumpdata.com>
References: <20110119233824.GA2869@dumpdata.com> <1295522306.4d381a02b1e10@imp.free.fr> <20110120150618.GC5092@dumpdata.com> <1295537856.14780.54.camel@zakaz.uk.xensource.com> <20110120190531.GA9687@dumpdata.com> <4D3899AB.60207@free.fr> <20110120210436.GA1810@dumpdata.com> <20110120211939.GA32262@dumpdata.com> <20110120215556.GA29700@dumpdata.com> <4D39FDA2.2000305@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D39FDA2.2000305@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 10:41:54PM +0100, matthieu castet wrote:
> Konrad Rzeszutek Wilk a écrit :
>>> -	 * .data and .bss should always be writable.
>>> +	 * .data and .bss should always be writable, but xen won't like
>>> +	 * if we make page table rw (that live in .data or .bss)
>>>  	 */
>>> +#ifdef CONFIG_X86_32
>>>  	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
>>> -	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
>>> -		pgprot_val(required) |= _PAGE_RW;
>>> +	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop)) {
>>> +		unsigned int level;
>>> +		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
>>> +			pgprot_val(forbidden) |= _PAGE_RW;
>>> +	}
>>> +#endif
>>>   #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
>>>
>>> fyi, it does make it boot.
>>
>> Hold it.. ccache is a wonderful tool but I think I've just "rebuilt" the
>> binaries with the .bss HPAGE_ALIGN aligment by mistake, so this path got never
>> taken.
>>
>>
> Ok,
>
> ATM I saw the following solution to solve the problem :
> 1) remove the data/bss check in static_protections, it was introduced by NX patches (64edc8ed). But I am not sure it
> is really needed anymore.
> 2) add ". = ALIGN(HPAGE_SIZE)" somewhere after init section. But if we want not to be allocated in image we
> should put it before bss. And if we want to be freed after init, we should put before .init.end.
> This mean moving .smp_locks (and .data_nosave when x86 will be added) before init section. I have no idea of the impact.
> 3) add some logic in arch/x86/xen/mmu.c, that will ignore RW page setting for the page table marked RO.
> 4) make static_protections take and old_prot argument, and only apply RW .data/.bss requirement if page is already RW.
>
> If possible I will go for 1).

Sounds good. Just send me the patch and I will test it.
