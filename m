Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0IVVIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:08:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34105 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0IVVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:08:19 -0400
Message-ID: <4C9A6FF4.2060201@kernel.org>
Date: Wed, 22 Sep 2010 14:07:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221253.01049.bjorn.helgaas@hp.com> <4C9A51DC.5020009@zytor.com> <201009221311.19567.bjorn.helgaas@hp.com>
In-Reply-To: <201009221311.19567.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 12:11 PM, Bjorn Helgaas wrote:
> On Wednesday, September 22, 2010 12:58:36 pm H. Peter Anvin wrote:
>> On 09/22/2010 11:53 AM, Bjorn Helgaas wrote:
>>>
>>> It's true, they don't (well, everything below 4G still lines up, but
>>> not above that).  Do you like this any better?
>>>
>>
>> That's fine with me.  I don't mind the [mem ] bracket either if you
>> think it's useful.
> 
> I took out "[mem" because it made the "(reserved)" lines wider than
> 80 columns.  But maybe I should just remove the parens around the
> E820 type instead, like this:
> 
> commit d2338b08303439b23d4909eab3744b3f29f09874
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Tue Sep 21 12:32:34 2010 -0600
> 
>     x86: tidy e820 output
>     
>     This tidies e820 output by adding an "e820" prefix and printing ranges
>     similarly to the way we print struct resource with %pR, e.g.:
>     
>         - BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>         + BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
>     
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 0d6fc71..2bd464f 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -108,7 +108,9 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
>  	int x = e820x->nr_map;
>  
>  	if (x >= ARRAY_SIZE(e820x->map)) {
> -		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
> +		printk(KERN_ERR "e820: too many entries; ignoring [mem %#010llx-%#010llx]\n",
> +		       (unsigned long long) start,
> +		       (unsigned long long) (start + size - 1));
>  		return;
>  	}
>  
> @@ -123,29 +125,22 @@ void __init e820_add_region(u64 start, u64 size, int type)
>  	__e820_add_region(&e820, start, size, type);
>  }
>  
> -static void __init e820_print_type(u32 type)
> +static char * __init e820_type_name(u32 type)
>  {
>  	switch (type) {
>  	case E820_RAM:
>  	case E820_RESERVED_KERN:
> -		printk(KERN_CONT "(usable)");
> -		break;
> +		return "usable";
>  	case E820_RESERVED:
> -		printk(KERN_CONT "(reserved)");
> -		break;
> +		return "reserved";
>  	case E820_ACPI:
> -		printk(KERN_CONT "(ACPI data)");
> -		break;
> +		return "ACPI data";
>  	case E820_NVS:
> -		printk(KERN_CONT "(ACPI NVS)");
> -		break;
> +		return "ACPI NVS";
>  	case E820_UNUSABLE:
> -		printk(KERN_CONT "(unusable)");
> -		break;
> -	default:
> -		printk(KERN_CONT "type %u", type);
> -		break;
> +		return "unusable";
>  	}
> +	return "(unknown)";
>  }

type value?

Yinghai
