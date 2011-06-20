Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1FTCx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 22:53:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1FTCxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 22:53:25 -0400
Message-ID: <4DFEB61A.4070204@redhat.com>
Date: Sun, 19 Jun 2011 23:53:14 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v2 3/7] KVM-HV: KVM Steal time implementation
References: <1308262856-5779-1-git-send-email-glommer@redhat.com> <1308262856-5779-4-git-send-email-glommer@redhat.com> <4DFDC821.2090905@redhat.com>
In-Reply-To: <4DFDC821.2090905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2011 06:57 AM, Avi Kivity wrote:
> On 06/17/2011 01:20 AM, Glauber Costa wrote:
>> To implement steal time, we need the hypervisor to pass the guest
>> information
>> about how much time was spent running other processes outside the VM.
>> This is per-vcpu, and using the kvmclock structure for that is an abuse
>> we decided not to make.
>>
>> In this patchset, I am introducing a new msr, KVM_MSR_STEAL_TIME, that
>> holds the memory area address containing information about steal time
>>
>> This patch contains the hypervisor part for it. I am keeping it
>> separate from
>> the headers to facilitate backports to people who wants to backport
>> the kernel
>> part but not the hypervisor, or the other way around.
>>
>>
>>
>> +#define KVM_STEAL_ALIGNMENT_BITS 5
>> +#define KVM_STEAL_VALID_BITS ((-1ULL<< (KVM_STEAL_ALIGNMENT_BITS + 1)))
>> +#define KVM_STEAL_RESERVED_MASK (((1<< KVM_STEAL_ALIGNMENT_BITS) - 1
>> )<< 1)
>
> Clumsy, but okay.
>
>> +static void record_steal_time(struct kvm_vcpu *vcpu)
>> +{
>> + u64 delta;
>> +
>> + if (vcpu->arch.st.stime&& vcpu->arch.st.this_time_out) {
>
> 0 is a valid value for stime.

how exactly? stime is a guest physical address...


>> +
>> + if (unlikely(kvm_read_guest(vcpu->kvm, vcpu->arch.st.stime,
>> + &vcpu->arch.st.steal, sizeof(struct kvm_steal_time)))) {
>> +
>> + vcpu->arch.st.stime = 0;
>> + return;
>> + }
>> +
>> + delta = (get_kernel_ns() - vcpu->arch.st.this_time_out);
>> +
>> + vcpu->arch.st.steal.steal += delta;
>> + vcpu->arch.st.steal.version += 2;
>> +
>> + if (unlikely(kvm_write_guest(vcpu->kvm, vcpu->arch.st.stime,
>> + &vcpu->arch.st.steal, sizeof(struct kvm_steal_time)))) {
>> +
>> + vcpu->arch.st.stime = 0;
>> + return;
>> + }
>> + }
>> +
>> +}
>> +
>>
>> @@ -2158,6 +2206,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu,
>> int cpu)
>> kvm_migrate_timers(vcpu);
>> vcpu->cpu = cpu;
>> }
>> +
>> + record_steal_time(vcpu);
>> }
>
> This records time spent in userspace in the vcpu thread as steal time.
> Is this what we want? Or just time preempted away?

There are arguments either way.

Right now, the way it is, it does account our iothread as steal time, 
which is not 100 % accurate if we think steal time as "whatever takes 
time away from our VM". I tend to think it as "whatever takes time away 
from this CPU", which includes other cpus in the same VM. So thinking 
this way, in a 1-1 phys-to-virt cpu mapping, if the iothread is taking 
80 % cpu for whatever reason, we have 80 % steal time the cpu that is 
sharing the physical cpu with the iothread.

Maybe we could account that as iotime ?
Questions like that are one of the reasons behind me leaving extra 
fields in the steal time structure. We could do a more fine grained 
accounting and differentiate between the multiple entities that can do
work (of various kinds) in our behalf.

