Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946011Ab2KNXeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:34:07 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55976 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945974Ab2KNXeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:34:04 -0500
Message-ID: <50A42A5E.5070905@linux.vnet.ibm.com>
Date: Thu, 15 Nov 2012 07:33:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, owasserm@redhat.com, quintela@redhat.com,
        pbonzini@redhat.com, chegu_vinod@hp.com, yamahata@valinux.co.jp
Subject: Re: [PATCH] KVM: MMU: lazily drop large spte
References: <50978DFE.1000005@linux.vnet.ibm.com> <20121112231032.GB5798@amt.cnet> <20121114003350.d6e8ff85658fccbf41183f05@gmail.com> <20121114144410.GB7054@amt.cnet>
In-Reply-To: <20121114144410.GB7054@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12111423-5140-0000-0000-0000025CDD8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 10:44 PM, Marcelo Tosatti wrote:
> On Wed, Nov 14, 2012 at 12:33:50AM +0900, Takuya Yoshikawa wrote:
>> Ccing live migration developers who should be interested in this work,
>>
>> On Mon, 12 Nov 2012 21:10:32 -0200
>> Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>
>>> On Mon, Nov 05, 2012 at 05:59:26PM +0800, Xiao Guangrong wrote:
>>>> Do not drop large spte until it can be insteaded by small pages so that
>>>> the guest can happliy read memory through it
>>>>
>>>> The idea is from Avi:
>>>> | As I mentioned before, write-protecting a large spte is a good idea,
>>>> | since it moves some work from protect-time to fault-time, so it reduces
>>>> | jitter.  This removes the need for the return value.
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/x86/kvm/mmu.c |   34 +++++++++-------------------------
>>>>  1 files changed, 9 insertions(+), 25 deletions(-)
>>>
>>> Its likely that other 4k pages are mapped read-write in the 2mb range 
>>> covered by a read-only 2mb map. Therefore its not entirely useful to
>>> map read-only. 
>>>
>>> Can you measure an improvement with this change?
>>
>> What we discussed at KVM Forum last week was about the jitter we could
>> measure right after starting live migration: both Isaku and Chegu reported
>> such jitter.
>>
>> So if this patch reduces such jitter for some real workloads, by lazily
>> dropping largepage mappings and saving read faults until that point, that
>> would be very nice!
>>
>> But sadly, what they measured included interactions with the outside of the
>> guest, and the main cause was due to the big QEMU lock problem, they guessed.
>> The order is so different that an improvement by a kernel side effort may not
>> be seen easily.
>>
>> FWIW: I am now changing the initial write protection by
>> kvm_mmu_slot_remove_write_access() to rmap based as I proposed at KVM Forum.
>> ftrace said that 1ms was improved to 250-350us by the change for 10GB guest.
>> My code still drops largepage mappings, so the initial write protection time
>> itself may not be a such big issue here, I think.
>>
>> Again, if we can eliminate read faults to such an extent that guests can see
>> measurable improvement, that should be very nice!
>>
>> Any thoughts?
>>
>> Thanks,
>> 	Takuya
> 
> OK, makes sense. I'm worried about shadow / oos interactions 
> with large read-only mappings (trying to remember what was the 
> case exactly, it might be non-existant now).

Marcelo, i guess commit 38187c830cab84daecb41169948467f1f19317e3 is what you
mentioned, but i do not know how it can "Simplifies out of sync shadow."  :(

