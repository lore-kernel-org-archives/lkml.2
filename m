Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1AMPHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab1AMPHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:07:08 -0500
Message-ID: <4D2F1510.3000809@redhat.com>
Date: Thu, 13 Jan 2011 10:06:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v4 PATCH 3/3] kvm: use yield_to instead of sleep in kvm_vcpu_on_spin
References: <20110113002108.3abdf953@annuminas.surriel.com> <20110113002745.51190252@annuminas.surriel.com> <4D2EFB44.2060906@redhat.com>
In-Reply-To: <4D2EFB44.2060906@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 08:16 AM, Avi Kivity wrote:

>> + for (pass = 0; pass< 2&& !yielded; pass++) {
>> + kvm_for_each_vcpu(i, vcpu, kvm) {
>> + struct task_struct *task = vcpu->task;
>> + if (!pass&& i< last_boosted_vcpu) {
>> + i = last_boosted_vcpu;
>> + continue;
>> + } else if (pass&& i> last_boosted_vcpu)
>> + break;
>> + if (vcpu == me)
>> + continue;
>> + if (!task)
>> + continue;
>> + if (waitqueue_active(&vcpu->wq))
>> + continue;
>
> Suppose the vcpu exits at this point, and its task terminates.

Arghh, good point.

> I think the first patch needs some reference counting... I'd move it to
> the outermost KVM_RUN loop to reduce the performance impact.

I don't see how refcounting from that other thread could
possibly help, and I now see that the task_struct_cachep
does not have SLAB_DESTROY_BY_LRU, either :(

What do you have in mind here that would both work and
be acceptable to you as KVM maintainer?

-- 
All rights reversed
