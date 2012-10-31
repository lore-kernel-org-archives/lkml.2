Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab2JaEio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 00:38:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51450 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2JaEin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 00:38:43 -0400
Message-ID: <5090AB3C.5050405@zytor.com>
Date: Tue, 30 Oct 2012 21:38:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Zhang, Jun" <jun.zhang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com> <50909120.3040101@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 08:39 PM, Zhang, Jun wrote:
> Hello, Anvin
> Thanks!
>
> Hello, all
> Next is my the latest version, please review it.
> Thanks!

You're still starting in the wrong end which is confusing for the reader.

What you probably want to say is something more like:

"We are doing a crash dump, so remove all RAM ranges as they are the 
ones that need to be dumped.  We still need all non-RAM information in 
order to do I/O."

At that point it should be pretty obvious that the patch is wrong.  What 
if we are *not* doing a crash dump?  Just because crash dump is compiled 
in doesn't mean that that is what we are doing right now.

	-hpa

>  From 141546c77ff7be523a9e72f5259df4a6827f2c1a Mon Sep 17 00:00:00 2001
> From: jzha144 <jun.zhang@intel.com>
> Date: Wed, 31 Oct 2012 08:51:18 +0800
> Subject: [PATCH] If we are doing a crash dump, we still need non-E820_RAM
>   memory type address information, which come from BIOS or
>   firmware. for example: PCI_MMCONFIG check this address.
>
> Signed-off-by: jzha144 <jun.zhang@intel.com>
> ---
>   arch/x86/kernel/e820.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index df06ade..f8672d0 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -851,6 +851,15 @@ static int __init parse_memmap_opt(char *p)
>   		 * reset.
>   		 */
>   		saved_max_pfn = e820_end_of_ram_pfn();
> +
> +		/*
> +		 * If we are doing a crash dump, we still need non-E820_RAM
> +		 * memory type address information. so we only remove
> +		 * E820_RAM type.
> +		 */
> +		e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
> +		userdef = 1;
> +		return 0;
>   #endif
>   		e820.nr_map = 0;
>   		userdef = 1;
>


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

