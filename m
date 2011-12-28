Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1L1GzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 01:55:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50921 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1L1Gyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 01:54:53 -0500
MIME-Version: 1.0
In-Reply-To: <4EF9AA59.7050003@oss.ntt.co.jp>
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com>
	<1324975139-8836-1-git-send-email-kernelfans@gmail.com>
	<4EF9AA59.7050003@oss.ntt.co.jp>
Date: Wed, 28 Dec 2011 14:54:52 +0800
Message-ID: <CAFgQCTu+qO=_Pc3Nps5N+esB0a9xYu83nRUT4Q6JepM6pAZYAA@mail.gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/27 Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>:
> (2011/12/27 17:38), Liu Ping Fan wrote:
>> From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>>
>> Currently, vcpu can be destructed only when kvm instance destroyed.
>> Change this to vcpu's destruction before kvm instance, so vcpu MUST
>> and CAN be destroyed before kvm's destroy.
>
> I really don't understand why this big change can be justified by only
> 3 lines.
>
I think just recording what this patch does, not the whole story about
it. Right?
>>
>> Signed-off-by: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>> ---
>>   arch/x86/kvm/i8254.c     |   10 +++--
>>   arch/x86/kvm/i8259.c     |   17 +++++--
>>   arch/x86/kvm/x86.c       |   53 +++++++++++-----------
>>   include/linux/kvm_host.h |   20 +++-----
>>   virt/kvm/irq_comm.c      |    6 ++-
>>   virt/kvm/kvm_main.c      |  110 +++++++++++++++++++++++++++++++++++-----------
>>   6 files changed, 140 insertions(+), 76 deletions(-)
>>
>
> You are introducing kvm_arch_vcpu_zap().
>
> Then, apart from the "zap" naming issue I mentioned last time,
Yes, I will correct "zap", as you said, its meaning is quite different
from destroy. :-)

> what about other architectures than x86?
>
Have not considered it in detail yet. At first step, I just want to
figure out the whole frame, then, I will push them on other arch.
Maybe you foresee some problem when extending this onto other arch,
please tell me, thanks ：-).
>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 900c763..b88d418d 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -117,6 +117,7 @@ enum {
>>
>>   struct kvm_vcpu {
>>       struct kvm *kvm;
>> +     struct list_head list;
>>   #ifdef CONFIG_PREEMPT_NOTIFIERS
>>       struct preempt_notifier preempt_notifier;
>>   #endif
>> @@ -251,12 +252,14 @@ struct kvm {
>>       struct mm_struct *mm; /* userspace tied to this vm */
>>       struct kvm_memslots *memslots;
>>       struct srcu_struct srcu;
>> +     struct srcu_struct srcu_vcpus;
>> +
>
> Another srcu.  This alone is worth explaining in the changelog IMO.
>
Sorry, but why? I think it is just a srcu, and because it has
different aim and want a independent grace period, so not multiplex
kvm->srcu.

thanks and regards,
ping fan

>        Takuya
>
>>   #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>>       u32 bsp_vcpu_id;
>>   #endif
>> -     struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>> +     struct list_head vcpus;
>>       atomic_t online_vcpus;
>> -     int last_boosted_vcpu;
>> +     int last_boosted_vcpu_id;
>>       struct list_head vm_list;
>>       struct mutex lock;
>>       struct kvm_io_bus *buses[KVM_NR_BUSES];
