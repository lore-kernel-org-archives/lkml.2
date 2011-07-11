Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1GKOFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:05:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab1GKOFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:05:35 -0400
Message-ID: <4E1B031C.1000604@redhat.com>
Date: Mon, 11 Jul 2011 11:05:16 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 4/9] KVM-HV: KVM Steal time implementation
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-5-git-send-email-glommer@redhat.com> <20110707105113.GA3986@amt.cnet> <4E15E7E5.6020909@redhat.com> <4E1AF36A.2060605@redhat.com>
In-Reply-To: <4E1AF36A.2060605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 09:58 AM, Avi Kivity wrote:
> On 07/07/2011 08:07 PM, Glauber Costa wrote:
>>>> +static void record_steal_time(struct kvm_vcpu *vcpu)
>>>> +{
>>>> + u64 delta;
>>>> +
>>>> + if (!(vcpu->arch.st.msr_val& KVM_MSR_ENABLED))
>>>> + return;
>>>> +
>>>> + if (unlikely(kvm_read_guest_cached(vcpu->kvm,&vcpu->arch.st.stime,
>>>> + &vcpu->arch.st.steal, sizeof(struct kvm_steal_time))))
>>>> + return;
>>>
>>> The guest memory page is not pinned, sleeping via
>>> __copy_from_user/to_user is not allowed in vcpu_load context. Either pin
>>> it or use atomic acessors.
>>
>>
>> I do recognize the problem.
>> Avi, what's your take here?
>>
>
> The easiest solution is to set a KVM_REQ bit in atomic context, and move
> the sleepy code to vcpu_enter_guest().

Or I can move it all inside vcpu_run, or close enough to it. This will 
account more hypervisor time as steal time, but it seemed to be what 
some people wanted in the first place.

Given the simplification we would win - not needing a REQ set, it might 
be worth it.

>>>> + case MSR_KVM_STEAL_TIME:
>>>> + vcpu->arch.st.msr_val = data;
>>>> +
>>>> + if (!(data& KVM_MSR_ENABLED)) {
>>>> + break;
>>>> + }
>>>
>>> On failure below this point, msr_val should be cleared of
>>> KVM_MSR_ENABLED?
>> No, msr_val has to hold whatever the guest wrote into it.
>> We should probably use an independent variable here to indicate that
>> we failed to activate it.
>
> If we fail, we return a #GP to the guest (and don't write any value into
> the msr).
>

