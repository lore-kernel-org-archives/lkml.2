Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab2J2OW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:22:57 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:25069 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab2J2OWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:22:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAG6Zu08YNPuJ/2dsb2JhbAANN4UtsgEBAQEBAyMEUQEQCw4GBAICBRYLAgIJAwIBAgE0EQYNAQUCAQGIFacDknuBJolihCiBFAOWKoldiAmBQw
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="203066637"
Message-ID: <508E913D.2080104@teksavvy.com>
Date: Mon, 29 Oct 2012 10:22:53 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
References: <508E002B.4090200@teksavvy.com> <20121029064643.GE574@1wt.eu>
In-Reply-To: <20121029064643.GE574@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-29 02:46 AM, Willy Tarreau wrote:
> On Mon, Oct 29, 2012 at 12:03:55AM -0400, Mark Lord wrote:
>> My server here runs the 3.4.xx series of "stable" kernels.
>> Until today, it was running 3.4.9.
>> Today I tried to upgrade it to 3.4.16.
>> It hangs in setup.c.
>>
>> I've isolated the fault down to this specific change
>> that was made between 3.4.9 and 3.4.16.
>> Reverting this change allows the system to boot/run normally again.
>>
>>
>> --- linux-3.4.9/arch/x86/kernel/setup.c	2012-08-15 11:17:17.000000000 -0400
>> +++ linux-3.4.16/arch/x86/kernel/setup.c	2012-10-28 13:36:33.000000000 -0400
>> @@ -927,8 +927,21 @@
>>
>>  #ifdef CONFIG_X86_64
>>  	if (max_pfn > max_low_pfn) {
>> -		max_pfn_mapped = init_memory_mapping(1UL<<32,
>> -						     max_pfn<<PAGE_SHIFT);
>> +		int i;
>> +		for (i = 0; i < e820.nr_map; i++) {
>> +			struct e820entry *ei = &e820.map[i];
>> +
>> +			if (ei->addr + ei->size <= 1UL << 32)
>> +				continue;
>> +
>> +			if (ei->type == E820_RESERVED)
>> +				continue;
>> +
>> +			max_pfn_mapped = init_memory_mapping(
>> +				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
>> +				ei->addr + ei->size);
>> +		}
>> +
>>  		/* can we preseve max_low_pfn ?*/
>>  		max_low_pfn = max_pfn;
>>  	}
> 
> For the record, it is this commit introduced in 3.4.16 :
> 
> commit efd5fa0c1a1d1b46846ea6e8d1a783d0d8a6a721
> Author: Jacob Shin <jacob.shin@amd.com>
> Date:   Thu Oct 20 16:15:26 2011 -0500
> 
>     x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
>     
>     commit 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a upstream.
>     
>     On systems with very large memory (1 TB in our case), BIOS may report a
>     reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
>     these from the direct mapping.
>     
>     [ hpa: this should be done not just for > 4 GB but for everything above the legacy
>       region (1 MB), at the very least.  That, however, turns out to require significant
>       restructuring.  That work is well underway, but is not suitable for rc/stable. ]
>     
>     Signed-off-by: Jacob Shin <jacob.shin@amd.com>
>     Link: http://lkml.kernel.org/r/1319145326-13902-1-git-send-email-jacob.shin@amd.com
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Willy


Thanks, Willy.

I've also now downloaded linux-3.7.0-rc3, and it boots/runs without need for patching.
So there's a fix somewhere in between that perhaps could also get backported to -stable.

-ml

