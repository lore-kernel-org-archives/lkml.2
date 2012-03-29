Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2C2J72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:59:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935Ab2C2J7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:59:10 -0400
Message-ID: <4F743247.5080407@redhat.com>
Date: Thu, 29 Mar 2012 11:58:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com> <4F73568D.7000703@linux.vnet.ibm.com>
In-Reply-To: <4F73568D.7000703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 08:21 PM, Raghavendra K T wrote:
>
>>
>>
>>         Looks like a good baseline on which to build the KVM
>>         implementation.  We
>>         might need some handshake to prevent interference on the host
>>         side with
>>         the PLE code.
>>
>
> I think I still missed some point in Avi's comment. I agree that PLE
> may be interfering with above patches (resulting in less performance
> advantages). but we have not seen performance degradation with the
> patches in earlier benchmarks. [ theoretically since patch has very
> slight advantage over PLE that atleast it knows who should run next ].

The advantage grows with the vcpu counts and overcommit ratio.  If you
have N vcpus and M:1 overcommit, PLE has to guess from N/M queued vcpus
while your patch knows who to wake up.

>
> So TODO in my list on this is:
> 1. More analysis of performance on PLE mc.
> 2. Seeing how to implement handshake to increase performance (if PLE +
> patch combination have slight negative effect).

I can think of two options:
- from the PLE handler, don't wake up a vcpu that is sleeping because it
is waiting for a kick
- look at other sources of pause loops (I guess smp_call_function() is
the significant source) and adjust them to use the same mechanism, and
ask the host to disable PLE exiting.

This can be done incrementally later.

>
> Sorry that, I could not do more analysis on PLE (as promised last time)
> because of machine availability.
>
> I 'll do some work on this and comeback. But in the meantime, I do not
> see it as blocking for next merge window.

-- 
error compiling committee.c: too many arguments to function

