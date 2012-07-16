Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2GPRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:09:58 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34283 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2GPRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:09:53 -0400
Message-ID: <50044A54.2090005@linux.vnet.ibm.com>
Date: Mon, 16 Jul 2012 22:37:32 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V4 3/3] kvm: Choose better candidate for directed
 yield
References: <20120716082445.23477.15128.sendpatchset@codeblue.in.ibm.com> <20120716082529.23477.91096.sendpatchset@codeblue.in.ibm.com> <5003E7ED.2030701@redhat.com> <50043CF3.8020903@redhat.com>
In-Reply-To: <50043CF3.8020903@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071606-9264-0000-0000-000001ECCCE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 09:40 PM, Rik van Riel wrote:
> On 07/16/2012 06:07 AM, Avi Kivity wrote:
>
>>> +{
>>> + bool eligible;
>>> +
>>> + eligible = !vcpu->ple.cpu_relax_intercepted ||
>>> + (vcpu->ple.cpu_relax_intercepted&&
>>> + vcpu->ple.dy_eligible);
>>> +
>>> + if (vcpu->ple.cpu_relax_intercepted)
>>> + vcpu->ple.dy_eligible = !vcpu->ple.dy_eligible;
>>
>> Probably should assign 'true', since the previous value is essentially
>> random.
>
> I suspect the intended purpose of this conditional is to
> flip the eligibility of a vcpu for being selected as a
> direct yield target.
>
> In other words, that bit of the code is correct.

Yes, That is the intention.

The first intention was to make sure, not to select previously selected
pause loop exited guy.
But second intention was not to make a vcpu permanently eligible after
skipping once.

The problem is when several PL exits happen simultaneously, (most
possible in large vcpu guest), it is very much probable that same vcpu
is tried as target of directed yield slowing down yielding to a
eligible guy.

But I 'll test one more time to make sure that.

(if we can make dy_eligible true as suggested, that means probably we 
can live with only one bool variable.)

