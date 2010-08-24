Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0HXJuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:50:25 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33481 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0HXJuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nosx+q65KHi1va44KWoCOEv3gD7WlD1eHpRiNCcPmvcUlBTWMpoZr90oqFCPep7qBt
         QB2xVdMVQt1T6OjsYYgDAwvA7ntgg3ifdl/QQDdQ9JhpdfYy6RJ9DVFarDOEUXzke711
         Ojk4/ozUD49ZLw1bQ5+j5wjB837I2POe64rPs=
MIME-Version: 1.0
In-Reply-To: <20100824020721.GA14726@amt.cnet>
References: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
	<4C724BDB.8020604@redhat.com>
	<4C724D13.6000807@redhat.com>
	<AANLkTi=7HdLqm-g1F+ezhDN4n+vPo2jAo2cgn-M6_wMJ@mail.gmail.com>
	<20100824020721.GA14726@amt.cnet>
Date: Tue, 24 Aug 2010 17:50:20 +0800
Message-ID: <AANLkTi=Kj_8O_bTDQ26uPceg=u+pQU7hY6vp-gHG6CbC@mail.gmail.com>
Subject: Re: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
From: Xiaotian Feng <xtfeng@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:07 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Aug 23, 2010 at 07:11:11PM +0800, Xiaotian Feng wrote:
>> On Mon, Aug 23, 2010 at 6:27 PM, Avi Kivity <avi@redhat.com> wrote:
>> >  On 08/23/2010 01:22 PM, Avi Kivity wrote:
>> >>
>> >>
>> >> I see a lot of soft lockups with this patchset:
>> >
>> > This is running the emulator.flat test case, with shadow paging.  This test
>> > triggers a lot (millions) of mmu mode switches.
>> >
>>
>> Does following patch fix your issue?
>>
>> Latest kvm mmu_shrink code rework makes kernel changes
>> kvm->arch.n_used_mmu_pages/
>> kvm->arch.n_max_mmu_pages at kvm_mmu_free_page/kvm_mmu_alloc_page,
>> which is called
>> by kvm_mmu_commit_zap_page. So the kvm->arch.n_used_mmu_pages or
>> kvm_mmu_available_pages(vcpu->kvm) is unchanged after kvm_mmu_commit_zap_page(),
>> This caused kvm_mmu_change_mmu_pages/__kvm_mmu_free_some_pages looping forever.
>> Moving kvm_mmu_commit_zap_page would make the while loop performs as normal.
>>
>> ---
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index f52a965..7e09a21 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1726,8 +1726,8 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm,
>> unsigned int goal_nr_mmu_pages)
>>                                             struct kvm_mmu_page, link);
>>                         kvm_mmu_prepare_zap_page(kvm, page,
>>                                                                &invalid_list);
>> +                       kvm_mmu_commit_zap_page(kvm, &invalid_list);
>>                 }
>> -               kvm_mmu_commit_zap_page(kvm, &invalid_list);
>>                 goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
>>         }
>>
>> @@ -2976,9 +2976,9 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
>>                 sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
>>                                   struct kvm_mmu_page, link);
>>                 kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
>> +               kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
>>                 ++vcpu->kvm->stat.mmu_recycled;
>>         }
>> -       kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
>>  }
>>
>>  int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
>
> Please resend with a signed-off-by, and proper subject for the patch.

It's available at: https://patchwork.kernel.org/patch/125431/

Thanks
Xiaotian

>
> Thanks
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
