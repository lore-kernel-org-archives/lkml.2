Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab0FQJf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:35:26 -0400
Received: from claw.goop.org ([74.207.240.146]:35288 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305Ab0FQJfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:35:24 -0400
Message-ID: <4C19EC57.3000409@goop.org>
Date: Thu, 17 Jun 2010 10:35:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com> <4C19AABA.8000706@jp.fujitsu.com> <4C19BA9A.4010300@zytor.com>
In-Reply-To: <4C19BA9A.4010300@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 07:03 AM, H. Peter Anvin wrote:
> On 06/16/2010 09:55 PM, Kenji Kaneshige wrote:
>   
>>> I think they might be. Kenji?
>>>       
>> No. My addresses are in the 44-bits range (around fc000000000). So it is
>> not required for my problem. This change assumes that phys_addr can be
>> above 44-bits (up to 52-bits (and higher in the future?)).
>>
>> By the way, is there linux kernel limit regarding above 44-bits physical
>> address in x86_32 PAE? For example, pfn above 32-bits is not supported?
>>
>>     

That's an awkward situation.  I would tend to suggest that you not
support this type of machine with a 32-bit kernel.  Is it a sparse
memory system, or is there a device mapped in that range?

I guess it would be possible to special-case ioremap to allow the
creation of such mappings, but I don't know what kind of system-wide
fallout would happen as a result.  The consequences of something trying
to extract a pfn from one of those ptes would be

> There are probably places at which PFNs are held in 32-bit numbers,
> although it would be good to track them down if it isn't too expensive
> to fix them (i.e. doesn't affect generic code.)
>   

There are many places which hold pfns in 32 bit variables on 32 bit
systems; the standard type for pfns is "unsigned long", pretty much
everywhere in the kernel.  It might be worth defining a pfn_t and
converting usage over to that, but it would be a pervasive change.

> This also affects paravirt systems, i.e. right now Xen has to locate all
> 32-bit guests below 64 GB, which limits its usefulness.
>   

I don't think the limit is 64GB.  A 32-bit PFN limits us to 2^44, which
is 16TB.  (32-bit PV Xen guests have another unrelated limit of around
160GB physical memory because that as much m2p table will fit into the
Xen hole in the kernel mapping.)

>> #ifdef CONFIG_X86_PAE
>> /* 44=32+12, the limit we can fit into an unsigned long pfn */
>> #define __PHYSICAL_MASK_SHIFT   44
>> #define __VIRTUAL_MASK_SHIFT    32
>>
>> If there is 44-bits physical address limit, I think it's better to use
>> PHYSICAL_PAGE_MASK for masking physical address, instead of "(phys_addr
>>     
>>>> PAGE_SHIFT) << PAGE_SHIFT)". The PHYSICAL_PAGE_MASK would become
>>>>         
>> greater value when 44-bits physical address limit is eliminated. And
>> maybe we need to change phys_addr_valid() returns error if physical
>> address is above (1 << __PHYSICAL_MASK_SHIFT)?
>>     
> The real question is how much we can fix without an unreasonable cost.
>   

I think it would be a pretty large change.  From the Xen's perspective,
any machine even approximately approaching the 2^44 limit will be
capable of running Xen guests in hvm mode, so PV isn't really a concern.

    J
