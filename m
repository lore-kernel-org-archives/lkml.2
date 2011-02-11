Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1BKH4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:56:03 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55734 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1BKH4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:56:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D54EB6A.3010405@jp.fujitsu.com>
Date: Fri, 11 Feb 2011 16:55:22 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: TAKADA Yoshihito <takada@mbf.nifty.com>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org, matthew@wil.cx, macro@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de, jeremy@goop.org,
        linux-pci@vger.kernel.org
Subject: Re: [BUG][PATCH 0/2 (v.3)] x86: ioremap() problem in X86_32 PAE
References: <4C1AE64C.6040609@jp.fujitsu.com> <AANLkTinhN1+bM6qABR28fR41T0+X_xSN8C4R2Ev1g-Gt@mail.gmail.com>
In-Reply-To: <AANLkTinhN1+bM6qABR28fR41T0+X_xSN8C4R2Ev1g-Gt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know what version of kernel you're using. But I guess you
might also need 4302e0fb7fa5b071e30f3cfb68e85155b3d69d9b (PCI: fix
wrong memory address handling in MSI-X).

Regards,
Kenji Kaneshige

(2011/02/10 23:11), TAKADA Yoshihito wrote:
> Hi.
> I faced same probrem, too. I use x86_64 kernel.
> Your patch fix it. it's very effective.
> Thanks!
>
> 2010年6月18日12:21 Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>:
>> Hi,
>>
>> Here is a updated version (v.3) of patchset to fix ioremap() related
>> problem found in x86 32-bit mode. The problem is that ioremap() maps
>> wrong address for the device to which phisical addres higer than
>> 32-bit is assigned (ioat device in my case).
>>
>> The v.3 patches are:
>>
>> - [PATCH 1/2] x86: ioremap: fix wrong physical address handling
>> - [PATCH 2/2] x86: ioremap: fix normal ram range check
>>
>> Changelog
>> ---------
>> v.2=>v.3:
>> - Matthew Wilcox suggested changing PAGE_MASK definition. But I think
>>   it is a little risky. Instead of changing PAGE_MASK, v.3 patch uses
>>   PHYSICAL_PAGE_MASK(*) to mask physical address again, as v.1 patch
>>   did. The PHYSICAL_PAGE_MASK doesn't work for higher than 2^44
>>   physical address because __PHYSICAL_MASK_SHIFT is 44 in x86_32
>>   PAE(*). But this time, I focus on making 2^44 work correctly.
>>
>> (*) Current X86_32 PAE kernel would not work with physical address
>>     higher than 2^44, because PFNs are handled using 32-bit variable
>>     (unsigned long) probably in many places. This seems the reason why
>>     __PHYSICAL_MASK_SHIFT is limited to 44 (=32+12 is the limit we can
>>     fit into an unsigned long pfn). When x86 PAE linux becomes above
>>     2^44 physical address capable in someday, __PHYSICAL_MASK_SHIFT
>>     should become greater value than 44.
>>
>>
>> v.1=>v.2:
>> The v.1 patchset was based on my misunderstanding about architectural
>> limit and linux memory management limit of physical address. So some
>> patches in v.1 were totally wrong fixes and they are removed. Thanks
>> to the feedbacks for v.1 patchset, it turned out that phsical address
>> is handled improperly (higher 32-bits are cleared unexpectedly) also
>> in the other places than where v.1 patchset fixed. Here are summary of
>> changes.
>>
>> - Stop using PHYSICAL_PAGE_MASK to align physical address because
>>   PHYSICAL_PAGE_MASK would not work if physical address is higher than
>>   44-bit.
>> - Fix remaining bugs of physical address handling in ioremap() code
>>   path according to the feedbacks.
>> - Fix s_show() in vmalloc.c to show high physical address properly.
>> - Removed changes against phys_addr_valid() ([PATCH 2/4] in v.1).
>> - Removed changes against warning message in ioremap() ([PATCH 3/4] in
>>   v.1).
>>
>> Thanks,
>> Kenji Kaneshige
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


