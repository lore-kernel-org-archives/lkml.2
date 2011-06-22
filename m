Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1FVGWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:22:04 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:56219 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752019Ab1FVGWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:22:02 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jun 2011 02:22:01 EDT
Message-ID: <4E018897.7040707@ravellosystems.com>
Date: Wed, 22 Jun 2011 09:15:51 +0300
From: Izik Eidus <izik.eidus@ravellosystems.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Nai Xia <nai.xia@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        mtosatti@redhat.com
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte
 and mmu notifier to help KSM dirty bit tracking
References: <201106212055.25400.nai.xia@gmail.com> <201106212132.39311.nai.xia@gmail.com> <20110622002123.GP25383@sequoia.sous-sol.org>
In-Reply-To: <20110622002123.GP25383@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/2011 3:21 AM, Chris Wright wrote:
> * Nai Xia (nai.xia@gmail.com) wrote:
>> Introduced kvm_mmu_notifier_test_and_clear_dirty(), kvm_mmu_notifier_dirty_update()
>> and their mmu_notifier interfaces to support KSM dirty bit tracking, which brings
>> significant performance gain in volatile pages scanning in KSM.
>> Currently, kvm_mmu_notifier_dirty_update() returns 0 if and only if intel EPT is
>> enabled to indicate that the dirty bits of underlying sptes are not updated by
>> hardware.
> Did you test with each of EPT, NPT and shadow?
>
>> Signed-off-by: Nai Xia<nai.xia@gmail.com>
>> Acked-by: Izik Eidus<izik.eidus@ravellosystems.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |    1 +
>>   arch/x86/kvm/mmu.c              |   36 +++++++++++++++++++++++++++++
>>   arch/x86/kvm/mmu.h              |    3 +-
>>   arch/x86/kvm/vmx.c              |    1 +
>>   include/linux/kvm_host.h        |    2 +-
>>   include/linux/mmu_notifier.h    |   48 +++++++++++++++++++++++++++++++++++++++
>>   mm/mmu_notifier.c               |   33 ++++++++++++++++++++++++++
>>   virt/kvm/kvm_main.c             |   27 ++++++++++++++++++++++
>>   8 files changed, 149 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index d2ac8e2..f0d7aa0 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -848,6 +848,7 @@ extern bool kvm_rebooting;
>>   int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
>>   int kvm_age_hva(struct kvm *kvm, unsigned long hva);
>>   int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>> +int kvm_test_and_clear_dirty_hva(struct kvm *kvm, unsigned long hva);
>>   void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>>   int cpuid_maxphyaddr(struct kvm_vcpu *vcpu);
>>   int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index aee3862..a5a0c51 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -979,6 +979,37 @@ out:
>>   	return young;
>>   }
>>
>> +/*
>> + * Caller is supposed to SetPageDirty(), it's not done inside this.
>> + */
>> +static
>> +int kvm_test_and_clear_dirty_rmapp(struct kvm *kvm, unsigned long *rmapp,
>> +				   unsigned long data)
>> +{
>> +	u64 *spte;
>> +	int dirty = 0;
>> +
>> +	if (!shadow_dirty_mask) {
>> +		WARN(1, "KVM: do NOT try to test dirty bit in EPT\n");
>> +		goto out;
>> +	}
> This should never fire with the dirty_update() notifier test, right?
> And that means that this whole optimization is for the shadow mmu case,
> arguably the legacy case.
>

Hi Chris,
AMD npt does track the dirty bit in the nested page tables,
so the shadow_dirty_mask should not be 0 in that case...
