Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1F2M1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:27:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59076 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab1F2M1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:27:06 -0400
Message-ID: <4E0B1A86.5000801@cn.fujitsu.com>
Date: Wed, 29 Jun 2011 20:28:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/22] KVM: MMU: mmio page fault support
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDE0.5080800@cn.fujitsu.com> <4E0AEEED.7020509@redhat.com>
In-Reply-To: <4E0AEEED.7020509@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 20:26:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 20:26:25,
	Serialize complete at 2011-06-29 20:26:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 05:22 PM, Avi Kivity wrote:
> On 06/22/2011 05:36 PM, Xiao Guangrong wrote:
>> The idea is from Avi:
>>
>> | We could cache the result of a miss in an spte by using a reserved bit, and
>> | checking the page fault error code (or seeing if we get an ept violation or
>> | ept misconfiguration), so if we get repeated mmio on a page, we don't need to
>> | search the slot list/tree.
>> | (https://lkml.org/lkml/2011/2/22/221)
>>
>> When the page fault is caused by mmio, we cache the info in the shadow page
>> table, and also set the reserved bits in the shadow page table, so if the mmio
>> is caused again, we can quickly identify it and emulate it directly
>>
>> Searching mmio gfn in memslots is heavy since we need to walk all memeslots, it
>> can be reduced by this feature, and also avoid walking guest page table for
>> soft mmu.
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 1319050..e69a47a 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -197,6 +197,41 @@ static u64 __read_mostly shadow_x_mask;    /* mutual exclusive with nx_mask */
>>   static u64 __read_mostly shadow_user_mask;
>>   static u64 __read_mostly shadow_accessed_mask;
>>   static u64 __read_mostly shadow_dirty_mask;
>> +static u64 __read_mostly shadow_mmio_mask = (0xffull<<  49 | 1ULL);
> 
> One bit is shifted out.   And it will fail with 52-bit MAXPHYADDR.
> 
> Please in addition, set the xwr bits to an invalid pattern on EPT (there is an MSR which specifies which patterns are valid; for example execute-only or write-only are invalid).  If all patterns are valid AND MAXPHYADDR == 52, then just set the mask to 0 and it the optimization will be disabled.
> 

OK, will fix, thanks!
