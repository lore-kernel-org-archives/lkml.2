Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1AUVmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:42:10 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:37374 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1AUVmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:42:08 -0500
Message-ID: <4D39FDA2.2000305@free.fr>
Date: Fri, 21 Jan 2011 22:41:54 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
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
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
References: <20110119211432.GA20535@dumpdata.com> <20110119235957.6ea35dc8@mat-laptop> <20110119233824.GA2869@dumpdata.com> <1295522306.4d381a02b1e10@imp.free.fr> <20110120150618.GC5092@dumpdata.com> <1295537856.14780.54.camel@zakaz.uk.xensource.com> <20110120190531.GA9687@dumpdata.com> <4D3899AB.60207@free.fr> <20110120210436.GA1810@dumpdata.com> <20110120211939.GA32262@dumpdata.com> <20110120215556.GA29700@dumpdata.com>
In-Reply-To: <20110120215556.GA29700@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk a écrit :
>> -	 * .data and .bss should always be writable.
>> +	 * .data and .bss should always be writable, but xen won't like
>> +	 * if we make page table rw (that live in .data or .bss)
>>  	 */
>> +#ifdef CONFIG_X86_32
>>  	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
>> -	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
>> -		pgprot_val(required) |= _PAGE_RW;
>> +	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop)) {
>> +		unsigned int level;
>> +		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
>> +			pgprot_val(forbidden) |= _PAGE_RW;
>> +	}
>> +#endif
>>  
>>  #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
>>
>> fyi, it does make it boot.
> 
> Hold it.. ccache is a wonderful tool but I think I've just "rebuilt" the
> binaries with the .bss HPAGE_ALIGN aligment by mistake, so this path got never
> taken.
> 
> 
Ok,

ATM I saw the following solution to solve the problem :
1) remove the data/bss check in static_protections, it was introduced by NX patches (64edc8ed). But I am not sure it
is really needed anymore.
2) add ". = ALIGN(HPAGE_SIZE)" somewhere after init section. But if we want not to be allocated in image we
should put it before bss. And if we want to be freed after init, we should put before .init.end.
This mean moving .smp_locks (and .data_nosave when x86 will be added) before init section. I have no idea of the impact.
3) add some logic in arch/x86/xen/mmu.c, that will ignore RW page setting for the page table marked RO.
4) make static_protections take and old_prot argument, and only apply RW .data/.bss requirement if page is already RW.

If possible I will go for 1).

Matthieu
