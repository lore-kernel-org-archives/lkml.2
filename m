Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab2C2SEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:04:47 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41443 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab2C2SEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:04:37 -0400
Message-ID: <4F74A405.2040609@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 23:33:49 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alan Meadows <alan.meadows@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com> <4F73568D.7000703@linux.vnet.ibm.com> <4F743247.5080407@redhat.com>
In-Reply-To: <4F743247.5080407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12032918-2000-0000-0000-000006F5F531
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 03:28 PM, Avi Kivity wrote:
> On 03/28/2012 08:21 PM, Raghavendra K T wrote:
>>
>>>
>>>
>>>          Looks like a good baseline on which to build the KVM
>>>          implementation.  We
>>>          might need some handshake to prevent interference on the host
>>>          side with
>>>          the PLE code.
>>>
>>
>> I think I still missed some point in Avi's comment. I agree that PLE
>> may be interfering with above patches (resulting in less performance
>> advantages). but we have not seen performance degradation with the
>> patches in earlier benchmarks. [ theoretically since patch has very
>> slight advantage over PLE that atleast it knows who should run next ].
>
> The advantage grows with the vcpu counts and overcommit ratio.  If you
> have N vcpus and M:1 overcommit, PLE has to guess from N/M queued vcpus
> while your patch knows who to wake up.
>

Yes. I agree.

>>
>> So TODO in my list on this is:
>> 1. More analysis of performance on PLE mc.
>> 2. Seeing how to implement handshake to increase performance (if PLE +
>> patch combination have slight negative effect).
>
> I can think of two options:

I really like below ideas. Thanks for that!.

> - from the PLE handler, don't wake up a vcpu that is sleeping because it
> is waiting for a kick

How about, adding another pass in the beginning of  kvm_vcpu_on_spin()
to check if any vcpu is already kicked. This would almost result in 
yield_to(kicked_vcpu). IMO this is also worth trying.

will try above ideas soon.

> - look at other sources of pause loops (I guess smp_call_function() is
> the significant source) and adjust them to use the same mechanism, and
> ask the host to disable PLE exiting.
>
> This can be done incrementally later.
>

Yes.. this can wait a bit.

