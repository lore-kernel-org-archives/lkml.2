Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1FMDgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:36:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab1FMDgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:36:10 -0400
Message-ID: <4DF58625.6090900@cn.fujitsu.com>
Date: Mon, 13 Jun 2011 11:38:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 14/15] KVM: MMU: mmio page fault support
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE2281.1000008@cn.fujitsu.com> <4DF07601.9060705@redhat.com> <4DF193BA.4060701@cn.fujitsu.com> <4DF47AE9.2020404@redhat.com>
In-Reply-To: <4DF47AE9.2020404@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 11:35:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-13 11:35:52,
	Serialize complete at 2011-06-13 11:35:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 04:38 PM, Avi Kivity wrote:
> On 06/10/2011 06:47 AM, Xiao Guangrong wrote:
>> >  Also, shadow walking is not significantly faster than guest page table walking.  And if we miss, we have to walk the guest page tables in any case.
>> >
>>
>> Um. i think walking guest page table is slower, it needs to walk memslots for many times
>> and it triggers page fault if the host page is swapped.
> 
> Well, if the page is swapped, we can't store anything in the spte.
> 

If we walk guest page table, we need to access guest page, and guest page can
be swapped out anytime, but shadow page table is the kernel page, it is not swapped,
that is why i think walking shadow page table is faster than guest page table.

> And if we only store the mmio/ram condition in the spte (via the two types of page faults) we don't need to walk the spte.  We know immediately if we need to search the slots or not.
> 
>> And it is hardly missed, since for tdp, it infrequency zaps shadow pages, for soft mmu,
>> the mmio spte is always unsync, and in guest, the mmio region is always mapped by kernel,
>> so it is infrequency to be update and lazily flushed.
> 
> We still get frequent mmio misses.
> 

I did the test, run three guests(4vcpu + 512M) on my box (4cores + 2G) and compile kernel
in guests, for 1 hour, no mmio is missed(hard mmu and soft mmu), it means that usually we
can catch almost all mmio by walking shadow page.

>> >>  +
>> >>  +static bool quickly_check_mmio_pf(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>> >>  +{
>> >>  +    if (direct&&   vcpu_match_mmio_gpa(vcpu, addr))
>> >>  +        return true;
>> >>  +
>> >>  +    if (vcpu_match_mmio_gva(vcpu, addr))
>> >>  +        return true;
>> >>  +
>> >>  +    return false;
>> >>  +}
>> >
>> >  There is also the case of nesting - it's not direct and it's not a gva.
>> >
>>
>> If it is direct, we only need to compare the pga, and direct=0, we only need to
>> compare gva, i'll fix the code to make it clear.
> 
> But for nested npt, we get the ngpa, not a gva.
> 

We treat nested npt as the 'direct' mmio:
	r = handle_mmio_page_fault(vcpu, addr, error_code, mmu_is_nested(vcpu));

also do not cache gva for nested npt:
	if (handle_abnormal_pfn(vcpu, mmu_is_nested(vcpu) ? 0 : addr,
				walker.gfn, pfn, walker.pte_access, &r))
