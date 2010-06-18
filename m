Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab0FRAdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 20:33:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55606 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab0FRAdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 20:33:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C1ABEA5.9090701@jp.fujitsu.com>
Date: Fri, 18 Jun 2010 09:32:37 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Matthew Wilcox <matthew@wil.cx>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, macro@linux-mips.org,
       kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com> <4C19AABA.8000706@jp.fujitsu.com> <4C19BA9A.4010300@zytor.com> <4C19EC57.3000409@goop.org> <4C1A2735.304@zytor.com>
In-Reply-To: <4C1A2735.304@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/17 22:46), H. Peter Anvin wrote:
> On 06/17/2010 02:35 AM, Jeremy Fitzhardinge wrote:
>>>>
>>>> By the way, is there linux kernel limit regarding above 44-bits physical
>>>> address in x86_32 PAE? For example, pfn above 32-bits is not supported?
>>
>> That's an awkward situation.  I would tend to suggest that you not
>> support this type of machine with a 32-bit kernel.  Is it a sparse
>> memory system, or is there a device mapped in that range?
>>
>> I guess it would be possible to special-case ioremap to allow the
>> creation of such mappings, but I don't know what kind of system-wide
>> fallout would happen as a result.  The consequences of something trying
>> to extract a pfn from one of those ptes would be
>>
>>> There are probably places at which PFNs are held in 32-bit numbers,
>>> although it would be good to track them down if it isn't too expensive
>>> to fix them (i.e. doesn't affect generic code.)
>>>
>>
>> There are many places which hold pfns in 32 bit variables on 32 bit
>> systems; the standard type for pfns is "unsigned long", pretty much
>> everywhere in the kernel.  It might be worth defining a pfn_t and
>> converting usage over to that, but it would be a pervasive change.
>>
>
> I think you're right, and just making 2^44 work correctly would be good
> enough.  Doing special forwarding of all 52 bits of the real physical
> address in the paravirt case (where it is self-contained and doesn't
> spill into the rest of the kernel) would probably be a good thing, though.
>
> 	-hpa
>

I'll focus on making 2^44 work correctly. Then, I'll do the following
change in the next version of my patch.

- The v.2 patch uses resource_size_t for pfn. I'll keep using
   resource_size_t for pfn also in v.3, because there is no reason to
   leave it being "unsigned long".

- Use PHYSICAL_PAGE_MASK for masking physical address as v.1 patch
   did. I think changing the definition of PAGE_MASK is a little risky.

Thanks,
Kenji Kaneshige


