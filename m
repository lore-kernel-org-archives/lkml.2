Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1FTGCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 02:02:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1FTGCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 02:02:47 -0400
Message-ID: <4DFEE276.9020403@redhat.com>
Date: Mon, 20 Jun 2011 09:02:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v2 3/7] KVM-HV: KVM Steal time implementation
References: <1308262856-5779-1-git-send-email-glommer@redhat.com> <1308262856-5779-4-git-send-email-glommer@redhat.com> <4DFDC821.2090905@redhat.com> <4DFEB61A.4070204@redhat.com>
In-Reply-To: <4DFEB61A.4070204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 05:53 AM, Glauber Costa wrote:
>
>>
>>> +static void record_steal_time(struct kvm_vcpu *vcpu)
>>> +{
>>> + u64 delta;
>>> +
>>> + if (vcpu->arch.st.stime&& vcpu->arch.st.this_time_out) {
>>
>> 0 is a valid value for stime.
>
>
> how exactly? stime is a guest physical address...

0 is a valid physical address.

>>>
>>> @@ -2158,6 +2206,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu,
>>> int cpu)
>>> kvm_migrate_timers(vcpu);
>>> vcpu->cpu = cpu;
>>> }
>>> +
>>> + record_steal_time(vcpu);
>>> }
>>
>> This records time spent in userspace in the vcpu thread as steal time.
>> Is this what we want? Or just time preempted away?
>
> There are arguments either way.
>
> Right now, the way it is, it does account our iothread as steal time, 
> which is not 100 % accurate if we think steal time as "whatever takes 
> time away from our VM". I tend to think it as "whatever takes time 
> away from this CPU", which includes other cpus in the same VM. So 
> thinking this way, in a 1-1 phys-to-virt cpu mapping, if the iothread 
> is taking 80 % cpu for whatever reason, we have 80 % steal time the 
> cpu that is sharing the physical cpu with the iothread.

I'm not talking about the iothread, rather the vcpu thread while running 
in userspace.

>
> Maybe we could account that as iotime ?
> Questions like that are one of the reasons behind me leaving extra 
> fields in the steal time structure. We could do a more fine grained 
> accounting and differentiate between the multiple entities that can do
> work (of various kinds) in our behalf.
>

What do other architectures do (xen, s390)?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

