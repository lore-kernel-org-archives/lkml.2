Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0HQGaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:30:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36779 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0HQGay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:30:54 -0400
Message-ID: <4C6A2C98.4060605@zytor.com>
Date: Mon, 16 Aug 2010 23:30:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: akataria@vmware.com
CC: the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Skip cpu_calibrate for kernel running under	hypervisors.
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>	 <4C69D02F.6090601@zytor.com> <1282024311.20786.2.camel@ank32.eng.vmware.com>
In-Reply-To: <1282024311.20786.2.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 10:51 PM, Alok Kataria wrote:
>>
>> I'm somewhat reluctant to take this one, since it assumes all the
>> hypervisors act the same.  This seems rather inherently wrong.  In fact,
>> the whole statement is fishy as heck... instead of being dependent on
>> AMD and so on, 
> 
> The check about being on AMD is something that was already there. 
> 

I know it was... and calibrate_cpu() seems to be an AMD-specific
function, but that's rather crappy.  I'm thinking that perhaps we should
make it an x86_init function, then the AMD CPU detection can install it
and the vmware hypervisor detection can uninstall it.

>> this should either be a function pointer or a CPU
>> (mis)feature bit.
> 
> In any case, I agree that my previous patch did assume all hypervisors
> to be same, which might be wrong. How about using the
> X86_FEATURE_TSC_RELIABLE bit for this too ? i.e. Skip cpu_calibrate call
> if TSC_RELIABLE bit is set. As of now that bit is set for vmware only. 
> 
> Something like the below.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> 
> Index: linux-x86-tree.git/arch/x86/kernel/tsc.c
> ===================================================================
> --- linux-x86-tree.git.orig/arch/x86/kernel/tsc.c	2010-08-03 12:21:20.000000000 -0700
> +++ linux-x86-tree.git/arch/x86/kernel/tsc.c	2010-08-16 21:59:32.000000000 -0700
> @@ -927,7 +927,8 @@ void __init tsc_init(void)
>  	}
>  
>  	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> -			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
> +	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
> +	    !(cpu_has(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE)))
>  		cpu_khz = calibrate_cpu();
>  
>  	printk("Detected %lu.%03lu MHz processor.\n",
> 

That seems like a much better approach.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

