Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2DEJIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab2DEJIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:08:24 -0400
Message-ID: <4F7D5F5B.2020209@redhat.com>
Date: Thu, 05 Apr 2012 12:01:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Alan Meadows <alan.meadows@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com> <4F73568D.7000703@linux.vnet.ibm.com> <4F743247.5080407@redhat.com> <4F74A405.2040609@linux.vnet.ibm.com> <4F7585EE.7060203@linux.vnet.ibm.com> <4F7855A1.80107@redhat.com> <4F785CC9.7070204@linux.vnet.ibm.com> <4F785DCF.7020809@redhat.com> <4F7976B6.5050000@linux.vnet.ibm.com>
In-Reply-To: <4F7976B6.5050000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 12:51 PM, Raghavendra K T wrote:
> On 04/01/2012 07:23 PM, Avi Kivity wrote:
> > On 04/01/2012 04:48 PM, Raghavendra K T wrote:
> >>>> I have patch something like below in mind to try:
> >>>>
> >>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >>>> index d3b98b1..5127668 100644
> >>>> --- a/virt/kvm/kvm_main.c
> >>>> +++ b/virt/kvm/kvm_main.c
> >>>> @@ -1608,15 +1608,18 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
> >>>>         * else and called schedule in __vcpu_run.  Hopefully that
> >>>>         * VCPU is holding the lock that we need and will release it.
> >>>>         * We approximate round-robin by starting at the last boosted
> >>>> VCPU.
> >>>> +     * Priority is given to vcpu that are unhalted.
> >>>>         */
> >>>> -    for (pass = 0; pass<   2&&   !yielded; pass++) {
> >>>> +    for (pass = 0; pass<   3&&   !yielded; pass++) {
> >>>>            kvm_for_each_vcpu(i, vcpu, kvm) {
> >>>>                struct task_struct *task = NULL;
> >>>>                struct pid *pid;
> >>>> -            if (!pass&&   i<   last_boosted_vcpu) {
> >>>> +            if (!pass&&   !vcpu->pv_unhalted)
> >>>> +                continue;
> >>>> +            else if (pass == 1&&   i<   last_boosted_vcpu) {
> >>>>                    i = last_boosted_vcpu;
> >>>>                    continue;
> >>>> -            } else if (pass&&   i>   last_boosted_vcpu)
> >>>> +            } else if (pass == 2&&   i>   last_boosted_vcpu)
> >>>>                    break;
> >>>>                if (vcpu == me)
> >>>>                    continue;
> >>>>
> >>>
> >>> Actually I think this is unneeded.  The loops tries to find vcpus
> that
> >>> are runnable but not running (vcpu_active(vcpu->wq)), and halted
> vcpus
> >>> don't match this condition.
> >>>
>
> Oh! I think I misinterpreted your statement. hmm I got it. you told to
> remove if (vcpu == me) condition.

No, the entire patch is unneeded.  My original comment was:

> from the PLE handler, don't wake up a vcpu that is sleeping because it
is waiting for a kick

But the PLE handler never wakes up sleeping vcpus anyway.

There's still a conflict with PLE in that it may trigger during the spin
phase and send a random yield_to() somewhere.  Maybe it's sufficient to
tune the PLE timeout to be longer than the spinlock timeout.


-- 
error compiling committee.c: too many arguments to function

