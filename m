Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1HYHz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:55:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1HYHzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:55:24 -0400
Message-ID: <4E560062.40805@cn.fujitsu.com>
Date: Thu, 25 Aug 2011 15:57:22 +0800
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
 2011-08-25 15:54:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-25 15:54:19,
	Serialize complete at 2011-08-25 15:54:19
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

Marcelo, i am still confused with your example, in step 3), what is repeated?
it repeats step 2) or it repeats step 1) and 2)?

Only step 2) is repeated i guess, right? if it is yes, it works well:
when the guest writes gpte, the spte of corresponding shadow page is zapped
(level > 1) or it is speculatively fetched(level == 1), the accessed bit is
cleared in both case.

the later write can detect that the accessed bit is not set, and write_flooding_count
is increased. finally, the shadow page is zapped, the gpte is written directly.

>> The result is the shadow page for gfnA is alloced and zapped again and again,
>> yes?
> 
> The point is you cannot rely on the accessed bit of sptes that have been
> instantiated with the accessed bit set to decide whether or not to zap.
> Because the accessed bit will only be cleared on host memory pressure.
> 

But the accessed bit is also cleared after spte is written.
