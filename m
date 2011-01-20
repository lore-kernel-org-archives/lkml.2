Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1ATV6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:58:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58988 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab1ATV6h (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 20 Jan 2011 16:58:37 -0500
Date: Thu, 20 Jan 2011 16:55:56 -0500
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
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <20110120215556.GA29700@dumpdata.com>
References: <20110119211432.GA20535@dumpdata.com>
 <20110119235957.6ea35dc8@mat-laptop>
 <20110119233824.GA2869@dumpdata.com>
 <1295522306.4d381a02b1e10@imp.free.fr>
 <20110120150618.GC5092@dumpdata.com>
 <1295537856.14780.54.camel@zakaz.uk.xensource.com>
 <20110120190531.GA9687@dumpdata.com>
 <4D3899AB.60207@free.fr>
 <20110120210436.GA1810@dumpdata.com>
 <20110120211939.GA32262@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120211939.GA32262@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	 * .data and .bss should always be writable.
> +	 * .data and .bss should always be writable, but xen won't like
> +	 * if we make page table rw (that live in .data or .bss)
>  	 */
> +#ifdef CONFIG_X86_32
>  	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
> -	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
> -		pgprot_val(required) |= _PAGE_RW;
> +	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop)) {
> +		unsigned int level;
> +		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
> +			pgprot_val(forbidden) |= _PAGE_RW;
> +	}
> +#endif
>  
>  #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
> 
> fyi, it does make it boot.

Hold it.. ccache is a wonderful tool but I think I've just "rebuilt" the
binaries with the .bss HPAGE_ALIGN aligment by mistake, so this path got never
taken.
