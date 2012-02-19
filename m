Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2BSINf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 03:13:35 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50696 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2BSINe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 03:13:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gilad@benyossef.com designates 10.220.116.73 as permitted sender) smtp.mail=gilad@benyossef.com
MIME-Version: 1.0
X-Originating-IP: [109.64.24.177]
In-Reply-To: <20120217120146.GB25601@elte.hu>
References: <1329298204-5026-1-git-send-email-gilad@benyossef.com>
	<20120217120146.GB25601@elte.hu>
Date: Sun, 19 Feb 2012 10:13:32 +0200
Message-ID: <CAOtvUMer63pC8C_QMyk_J56v6g8uk14OGYE7sJG1K6nAW+MoGg@mail.gmail.com>
Subject: Re: [PATCH] x86: drop false warning of empty cpumask in IPI
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Milton Miller <miltonm@bga.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 2:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>> With current generic SMP infrastructure, it is feasible
>> for the target CPUs to begin processing an IPI work item
>> even before we sent them the actual IPI in the case that
>> an IPI from another CPU woke them first.
>>
>> This can lead to generating a false warning in a valid
>> state of trying to send IPI with an empty cpumask when
>> multiple concurrent IPIs are being sent.
>>
>> This patch was triggered by the following LKML discussion:
>> https://lkml.org/lkml/2012/1/13/308
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: Milton Miller <miltonm@bga.com>
>> CC: x86@kernel.org
>> ---
>>  arch/x86/kernel/apic/ipi.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
>> index cce91bf..00b68a3 100644
>> --- a/arch/x86/kernel/apic/ipi.c
>> +++ b/arch/x86/kernel/apic/ipi.c
>> @@ -106,7 +106,10 @@ void default_send_IPI_mask_logical(const struct cpumask *cpumask, int vector)
>>       unsigned long mask = cpumask_bits(cpumask)[0];
>>       unsigned long flags;
>>
>> -     if (WARN_ONCE(!mask, "empty IPI mask"))
>> +     if (!mask)
>> +             /* The target CPUs must have already processed the
>> +              * work items due to a concurrent IPI
>> +              */
>>               return;
>
> This could potentially hide real bugs on other callsites.
>
> So why not do the checking at the call site? In almost every
> other scenario it's invalid to send an empty mask.

hmm... isn't that racy? Also, none of the other send_IPI_maks
implementations do the check.

I can obviously add a warning at the "zero not OK" call sites, though.

Actually, the code is racy right now as well. I think we're
trying to program the APIC with a zero dest field from time to
time. How bad is that? :-)

Thanks,
Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
