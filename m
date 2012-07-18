Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2GRCbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:31:00 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60043 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2GRCa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:30:28 -0400
Message-ID: <50061F35.4050305@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 07:58:05 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
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
References: <20120716082445.23477.15128.sendpatchset@codeblue.in.ibm.com> <20120716082529.23477.91096.sendpatchset@codeblue.in.ibm.com> <5003E7ED.2030701@redhat.com> <50043CF3.8020903@redhat.com> <50052272.5020803@redhat.com> <50052BB5.2040909@linux.vnet.ibm.com>
In-Reply-To: <50052BB5.2040909@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071716-6102-0000-0000-000001E4E899
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 02:39 PM, Raghavendra K T wrote:
[...]
>
> But
>> if vcpu A is spinning for x% of its time and processing on the other,
>> then vcpu B will flip its dy_eligible for those x%, and not flip it when
>> it's processing. I don't understand how this is useful.
>
> Suppose A is doing really good job and and has not done pause loop
> exit, we will not touch it's dy_eligible flag. Also dy_eligible flag
> will not prevent B doing yield_to to A.
>
> Suppose A has started spinning in the beginning itself, it will do pause
> loop exit if it crosses threshold, and we will now start toggling
> dy_eligible.
>
> Was that you were referring?
>
> And it seems we may still have to set dy_eligible flag to false at the
> beginning of vcpu_on_spin along with cpu_relax_intercepted = true, like
> below, so that we do not have spill-over status from previous PL exits.
>
> vcpu_on_spin()
> {
> cpu_relax_intercepted = true;
> dy_eligible = false;
> .
> .
> .
>
> cpu_relax_intercepted = false;
> }
>
> Let me know if that addresses your concern.
>

Thought you brought in is miraculous. taking care of not having 
spill-over dy_eligible status is needed for making algorithm technically 
more correct. will spin V5 with all these changes.

>>
>> I guess this is an attempt to impose fairness on yielding, and it makes
>> sense to do this, but I don't know if this is the best way to achieve it.
>>
>

