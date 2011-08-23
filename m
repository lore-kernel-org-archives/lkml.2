Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1HWUOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:14:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60434 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab1HWUOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:14:46 -0400
Message-ID: <4E540AB4.6060905@cn.fujitsu.com>
Date: Wed, 24 Aug 2011 04:16:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E4A10E8.5090705@cn.fujitsu.com> <4E4A1257.5080204@cn.fujitsu.com> <20110823080024.GA2297@amt.cnet> <4E53872B.3070407@cn.fujitsu.com> <20110823123818.GB4261@amt.cnet> <4E53D620.9030304@cn.fujitsu.com> <20110823190939.GA10220@amt.cnet>
In-Reply-To: <20110823190939.GA10220@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-24 04:13:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-24 04:13:44,
	Serialize complete at 2011-08-24 04:13:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 03:09 AM, Marcelo Tosatti wrote:
> On Wed, Aug 24, 2011 at 12:32:32AM +0800, Xiao Guangrong wrote:
>> On 08/23/2011 08:38 PM, Marcelo Tosatti wrote:
>>
>>>> And, i think there are not problems since: if the spte without accssed bit is
>>>> written frequently, it means the guest page table is accessed infrequently or
>>>> during the writing, the guest page table is not accessed, in this time, zapping
>>>> this shadow page is not bad.
>>>
>>> Think of the following scenario:
>>>
>>> 1) page fault, spte with accessed bit is created from gpte at gfnA+indexA.
>>> 2) write to gfnA+indexA, spte has accessed bit set, write_flooding_count
>>> is not increased.
>>> 3) repeat
>>>
>>
>> I think the result is just we hoped, we do not want to zap the shadow page
>> because the spte is currently used by the guest, it also will be used in the
>> next repetition. So do not increase 'write_flooding_count' is a good choice.
> 
> Its not used. Step 2) is write to write protected shadow page at
> gfnA.
> 
>> Let's consider what will happen if we increase 'write_flooding_count':
>> 1: after three repetitions, zap the shadow page
>> 2: in step 1, we will alloc a new shadow page for gpte at gfnA+indexA
>> 3: in step 2, the flooding count is creased, so after 3 repetitions, the
>>    shadow page can be zapped again, repeat 1 to 3.
> 
> The shadow page will not be zapped because the spte created from
> gfnA+indexA has the accessed bit set:
> 
>        if (spte && !(*spte & shadow_accessed_mask))
>                sp->write_flooding_count++;
>        else
>                sp->write_flooding_count = 0;
> 

Ah, i see, i thought it was "repeat"ed on the same spte, it was my wrong.

Yes, in this case, the sp is not zapped, but it is hardly to know the gfn
is not used as gpte just depends on writing, for example, the guest can
change the mapping address or the status bit, and so on...The sp can be
zapped if the guest write it again(on the same address), i think it is
acceptable, anymore, it is just the speculative way to zap the unused
shadow page...your opinion?

>> The result is the shadow page for gfnA is alloced and zapped again and again,
>> yes?
> 
> The point is you cannot rely on the accessed bit of sptes that have been
> instantiated with the accessed bit set to decide whether or not to zap.
> Because the accessed bit will only be cleared on host memory pressure.
> 

Yes, accessed bit is the cursory way to track gpte accessed, however,
at least, the accessed bit can indicate whether the gfn is accessed
for a period of time in the most case, for example, from it is
speculated to it is written, or from it is zapped to it is written,
i thinks it is not too bad.

Do you have ideas to improve this?
