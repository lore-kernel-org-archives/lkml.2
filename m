Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1LEF3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:29:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51137 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1LEF3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:29:18 -0500
MIME-Version: 1.0
In-Reply-To: <4EDB4A0D.1000609@redhat.com>
References: <4ED212A1.3060300@redhat.com>
	<1322807192-14147-1-git-send-email-kernelfans@gmail.com>
	<4EDB4A0D.1000609@redhat.com>
Date: Mon, 5 Dec 2011 13:29:17 +0800
Message-ID: <CAFgQCTujv7Ez23GySc4Bds8x9Pv8Ny59EohpN22de9wicztWrw@mail.gmail.com>
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        gleb@redhat.com, jan.kiszka@web.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB55TVP3004222

On Sun, Dec 4, 2011 at 6:23 PM, Avi Kivity <avi@redhat.com> wrote:
> On 12/02/2011 08:26 AM, Liu Ping Fan wrote:
>> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>>
>> Currently, vcpu can be destructed only when kvm instance destroyed.
>> Change this to vcpu's destruction taken when its refcnt is zero,
>> and then vcpu MUST and CAN be destroyed before kvm's destroy.
>>
>>
>> @@ -315,9 +315,17 @@ static void pit_do_work(struct work_struct *work)
>>                * LVT0 to NMI delivery. Other PIC interrupts are just sent to
>>                * VCPU0, and only if its LVT0 is in EXTINT mode.
>>                */
>> -             if (kvm->arch.vapics_in_nmi_mode > 0)
>> -                     kvm_for_each_vcpu(i, vcpu, kvm)
>> +             if (kvm->arch.vapics_in_nmi_mode > 0) {
>> +                     rcu_read_lock();
>> +                     kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
>> +                             vcpu = kvm_get_vcpu(kvm, i);
>> +                             if (vcpu == NULL)
>> +                                     continue;
>> +                             cnt++;
>>                               kvm_apic_nmi_wd_deliver(vcpu);
>> +                     }
>> +                     rcu_read_unlock();
>> +             }
>>       }
>>  }
>
> This pattern keeps repeating, please fold it into kvm_for_each_vcpu().
>
What about folding
kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
              vcpu = kvm_get_vcpu(kvm, i);
              if (vcpu == NULL)
                        continue;
              cnt++;

like this,
#define kvm_for_each_vcpu(idx, cnt, vcpup, kvm) \
	for (idx = 0, cnt = 0, vcpup = kvm_get_vcpu(kvm, idx); \
	     cnt < atomic_read(&kvm->online_vcpus) && \
	     idx < KVM_MAX_VCPUS; \
	     idx++, (vcpup == NULL)?:cnt++, vcpup = kvm_get_vcpu(kvm, idx)) \
	     if (vcpup == NULL) \
	          continue; \
	     else


A little ugly, but have not thought a better way out :-)

Thanks,
ping fan
> --
> error compiling committee.c: too many arguments to function
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
