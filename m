Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1AXPc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:32:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64456 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1AXPc1 convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 24 Jan 2011 10:32:27 -0500
Date: Mon, 24 Jan 2011 10:31:09 -0500
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
Message-ID: <20110124153109.GA970@dumpdata.com>
References: <20110120150618.GC5092@dumpdata.com>
 <1295537856.14780.54.camel@zakaz.uk.xensource.com>
 <20110120190531.GA9687@dumpdata.com>
 <4D3899AB.60207@free.fr>
 <20110120210436.GA1810@dumpdata.com>
 <20110120211939.GA32262@dumpdata.com>
 <20110120215556.GA29700@dumpdata.com>
 <4D39FDA2.2000305@free.fr>
 <20110122051134.GA6905@dumpdata.com>
 <4D3C3ADB.1020609@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D3C3ADB.1020609@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 03:27:39PM +0100, matthieu castet wrote:
> Konrad Rzeszutek Wilk a écrit :
> >On Fri, Jan 21, 2011 at 10:41:54PM +0100, matthieu castet wrote:
> >>Konrad Rzeszutek Wilk a écrit :
> >>>>-	 * .data and .bss should always be writable.
> >>>>+	 * .data and .bss should always be writable, but xen won't like
> >>>>+	 * if we make page table rw (that live in .data or .bss)
> >>>> 	 */
> >>>>+#ifdef CONFIG_X86_32
> >>>> 	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
> >>>>-	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
> >>>>-		pgprot_val(required) |= _PAGE_RW;
> >>>>+	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop)) {
> >>>>+		unsigned int level;
> >>>>+		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
> >>>>+			pgprot_val(forbidden) |= _PAGE_RW;
> >>>>+	}
> >>>>+#endif
> >>>>  #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
> >>>>
> >>>>fyi, it does make it boot.
> >>>Hold it.. ccache is a wonderful tool but I think I've just "rebuilt" the
> >>>binaries with the .bss HPAGE_ALIGN aligment by mistake, so this path got never
> >>>taken.
> >>>
> >>>
> >>Ok,
> >>
> >>ATM I saw the following solution to solve the problem :
> >>1) remove the data/bss check in static_protections, it was introduced by NX patches (64edc8ed). But I am not sure it
> >>is really needed anymore.
> >>2) add ". = ALIGN(HPAGE_SIZE)" somewhere after init section. But if we want not to be allocated in image we
> >>should put it before bss. And if we want to be freed after init, we should put before .init.end.
> >>This mean moving .smp_locks (and .data_nosave when x86 will be added) before init section. I have no idea of the impact.
> >>3) add some logic in arch/x86/xen/mmu.c, that will ignore RW page setting for the page table marked RO.
> >>4) make static_protections take and old_prot argument, and only apply RW .data/.bss requirement if page is already RW.
> >>
> >>If possible I will go for 1).
> >
> >Sounds good. Just send me the patch and I will test it.
> 
> Ok, what give you the attached patch.
> 
> I don't know if I should give the printk or not. 

I would say get rid of the printk. It does not really help the users. Here is an excerpt of
2.6.38-rc2 with this patch:

   7.247448] NX-protecting the kernel data: 2412k
[    7.252489] RO page for 0xc15a0000 in bss/data.
[    7.253052] RO page for 0xc15a1000 in bss/data.
[    7.253052] RO page for 0xc15a3000 in bss/data.
[    7.365104] mv used greatest stack depth: 6616 bytes left

So Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

(I tested on baremetal x86,x86_64 and Xen x86 and x86_64)
> 
> 
> Matthieu


> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 8b830ca..eec93c5 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -256,7 +256,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  				   unsigned long pfn)
>  {
>  	pgprot_t forbidden = __pgprot(0);
> -	pgprot_t required = __pgprot(0);
>  
>  	/*
>  	 * The BIOS area between 640k and 1Mb needs to be executable for
> @@ -283,11 +282,13 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
>  		pgprot_val(forbidden) |= _PAGE_RW;
>  	/*
> -	 * .data and .bss should always be writable.
> +	 * .data and .bss should always be writable, but xen won't like
> +	 * if we make page table rw (that live in .data or .bss)
>  	 */
>  	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
>  	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
> -		pgprot_val(required) |= _PAGE_RW;
> +		if ((pgprot_val(prot) & _PAGE_RW) == 0)
> +			printk(KERN_INFO "RO page for 0x%lx in bss/data.\n", address);
>  
>  #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
>  	/*
> @@ -327,7 +328,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  #endif
>  
>  	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
> -	prot = __pgprot(pgprot_val(prot) | pgprot_val(required));
>  
>  	return prot;
>  }

