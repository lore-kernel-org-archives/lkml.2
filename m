Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2BHSy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:54:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63065 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab2BHSy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:54:28 -0500
Date: Wed, 8 Feb 2012 10:54:25 -0800
From: Olof Johansson <olof@lixom.net>
To: Matt Fleming <matt.fleming@intel.com>
Cc: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit
 efi/kernel
Message-ID: <20120208185425.GA1486@quad.lixom.net>
References: <1328660732-27263-1-git-send-email-olof@lixom.net>
 <1328660732-27263-6-git-send-email-olof@lixom.net>
 <1328725914.3675.15.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328725914.3675.15.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 06:31:54PM +0000, Matt Fleming wrote:
> On Tue, 2012-02-07 at 16:25 -0800, Olof Johansson wrote: 
> > Traditionally the kernel has refused to setup EFI at all if there's been
> > a mismatch in 32/64-bit mode between EFI and the kernel.
> > 
> > On some platforms that boot natively through EFI (Chrome OS being one),
> > we still need to get at least some of the static data such as memory
> > configuration out of EFI. Runtime services aren't as critical, and
> > it's a significant amount of work to implement switching between the
> > operating modes to call between kernel and firmware for thise cases. So
> > I'm ignoring it for now.
> 
> Presumably with these patches in mainline you can get rid of the hacks
> that ChromeOS currently uses?

Yes, that's my personal objective for doing it. The main benefit of that is that it
makes it significantly easier for anyone working on the Chrome OS kernel to
contribute and test upstream if we can boot an unmodified mainline kernel on
our machines.

> > +
> > +		early_iounmap(systab64, sizeof(*systab64));
> > +#ifdef CONFIG_X86_32
> > +		if (tmp >> 32) {
> > +			pr_err("EFI data located above 4GB, disabling.\n");
> > +			return -EINVAL;
> > +		}
> > +#endif
> 
> You should really say "disabling EFI" here.

Sure, I'll change that.

> > +#ifdef CONFIG_X86_32
> > +			if (table64 >> 32) {
> > +				pr_cont("\n");
> > +				pr_err("Table located above 4GB, disabling.\n");
> > +				early_iounmap(config_tables,
> > +					      efi.systab->nr_tables * sz);
> > +				return -EINVAL;
> > +			}
> > +#endif
> 
> Likewise here, mention that you're disabling EFI.

No problem.

> [...]
> 
> > @@ -576,11 +670,19 @@ void __init efi_init(void)
> >  	void *tmp;
> >  
> >  #ifdef CONFIG_X86_32
> > +	if (boot_params.efi_info.efi_systab_hi ||
> > +	    boot_params.efi_info.efi_memmap_hi) {
> > +		pr_info("Table located above 4GB, disabling.\n");
> > +		efi_enabled = 0;
> > +		return;
> > +	}
> >  	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
> > +	efi_native = !efi_64bit;
> >  #else
> 
> ... and here

Yup.

> 
> > 	efi_phys.systab = (efi_system_table_t *)
> > -		(boot_params.efi_info.efi_systab |
> > -		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
> > +			  (boot_params.efi_info.efi_systab |
> > +			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
> > +	efi_native = efi_64bit;
> >  #endif
> >  
> >  	if (efi_systab_init(efi_phys.systab)) {
> > @@ -609,19 +711,26 @@ void __init efi_init(void)
> >  		return;
> >  	}
> >  
> > -	if (efi_runtime_init()) {
> > +	/*
> > +	 * Note: We currently don't support runtime services on an EFI
> > +	 * that doesn't match the kernel 32/64-bit mode.
> > +	 */
> > +
> > +	if (efi_native && efi_runtime_init()) {
> >  		efi_enabled = 0;
> >  		return;
> > -	}
> > +	} else
> > +		pr_info("No EFI runtime due to 32/64b mismatch with kernel\n");
> 
> Hmm... this isn't right. efi_runtime_init() returns 0 on success, so
> you're printing this warning in the native EFI success path. Also,
> please spell out "32/64-bit". 

Uh, yeah, that's obviously broken, I'll fix. And I'll expand the wording.

> >  
> > +	/* We don't do virtual mode, since we don't do runtime services, on
> > +	 * non-native EFI
> > +	 */
> > +
> > +	if (!efi_native)
> > +		goto out;
> > +
> 
> 	/*
> 	 * Multi-line comments should look like this.
> 	 */

D'oh, of course.

> > +} _efi_config_table_32_t;
> > +
> > +typedef struct {
> > +	efi_guid_t guid;
> >  	unsigned long table;
> >  } efi_config_table_t;
> 
> There's no need for the underscore prefix on these names.
> efi_config_table_64_t, etc, is fine. Normally you should try to avoid
> adding new typedefs, but I think these make sense because they're an
> extension of existing typedefs.

I just went with the existing convention in the file and added it as
a typedef.  The underbar is there, just as in many other cases around
the kernel, to indicate that it's an internal-only version that's not
supposed to be used unless you know what you're doing. But sure, I can
take them off if it makes you happy. ;)

> Actually, thinking about it some more, it would make more sense to just
> delete efi_config_table_t and efi_system_table_t and make everyone
> explicitly pick a size, not least because it will make people adding new
> code think long and hard about the mixed mode case.

I tried that approach and the end result was messier than this is, since
there's no way to know which data type you need until runtime. The
number of people adding code to this module is limited, I'm not so
worried about that.

So, I would prefer keeping the current implementation with the above (and
below) comments fixed.

> > +} _efi_system_table_64_t;
> 
> No underscore please.
> 
[...]
> > +} _efi_system_table_32_t;
> 
> Same here.

Sure.


-Olof
