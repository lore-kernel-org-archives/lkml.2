Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1A2CR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 21:17:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54971 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1A2CRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 21:17:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=P7kmGTnAGxdzHrPtzuwsgRT6YKObAP11Yf8AyFOrN22IwPH9mFU+uIFGLFQ2EWgeVT
         X9em0dOcwwIJmj36I+w8GYPo1StrXAO5xFevMEt+zL+7+PJbV1SL5whwS+YpsUX/D9/o
         vtYGiF89Ye6N+MkhhYUP0d1jEeTNRaMxnsx58=
MIME-Version: 1.0
In-Reply-To: <1296266504.29747.70.camel@sbsiddha-MOBL3.sc.intel.com>
References: <4D423360.6080408@kernel.org>
	<1296266504.29747.70.camel@sbsiddha-MOBL3.sc.intel.com>
Date: Fri, 28 Jan 2011 18:17:53 -0800
X-Google-Sender-Auth: qbWLJ1NEZFtn3R6yB5S_R-rsfdY
Message-ID: <AANLkTikm=pSoUsyBOF_L-eiw+B631G0fTEwNP7GZ2Gj1@mail.gmail.com>
Subject: Re: [PATCH -v2] x86, acpi: Handle xapic/x2apic entries in MADT at
 same time
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 6:01 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Thu, 2011-01-27 at 19:09 -0800, Yinghai Lu wrote:
>> One system have mixing xapic and x2apic entries in MADT and SRAT.
>> BIOS guys insist that ACPI 4.0 SPEC said so, if apic id < 255, even
>> the cpus are with x2apic mode pre-enabled, still need to use xapic entries
>> instead of x2apic entries.
>
> true. thats what the spec says.

I was thinking if cpus are with x2apic pre-enabled, we should have
x2apic entries for them.

>
>> on 8 socket system with x2apic pre-enabled, will get out of order sequence:
>> CPU0: socket0, core0, thread0.
>> CPU1 - CPU 40: socket 4 - socket 7, thread 0
>> CPU41 - CPU 80: socket 4 - socket 7, thread 1
>> CPU81 - CPU 119: socket 0 - socket 3, thread 0
>> CPU120 - CPU 159: socket 0 - socket 3, thread 1
>>
>> so max_cpus=80 will not get all thread0 now.
>>
>> Need to handle every entry in MADT at same time with xapic and x2apic.
>> so we can honor sequence in MADT.
>
> hmm few things.
>
> So is your bios listing like this:
>
> xapic entries for all thread-0
> x2apic entries for all thread-0
> xapic entries for all thread-1
> x2apic entries for all thread-1

Yes. that is required by BIOS write guide, it says all thread 0 should
come first.

>
> What happens if some other bios lists like:
>
> all xapic entries
> followed by all x2apic entries

assume should get

CPU0: socket0, core0, thread0.
 CPU1 - CPU 80: socket 4 - socket 7, thread 0 and thread 1
 CPU81 - CPU 159: socket 0 - socket 3, thread 0 and thread 1


>
> or
>
> all x2apic entries
> followed by all x2apic entries

all x2apic ?

>
> I am not sure if there is a strict recommendation by Intel bios writers
> guide to list all thread-0 first followed by thread-1. Even if there is
> a strict recommendation like that, I am sure there will be some bios's
> that don't follow the rules.

our bios follow the BWG guide.

>
> Anyways two things.
>
> a) I don't want to complicate the code too much and still doesn't get
> the desired behavior when some bios has a different silly ordering.

we have right ordering according to ACPI 4.0 spec and BWG

also i think that code is not that complicated.

>
> b) Also perhaps we need to make it more explicit. Like instead of
> relying on the "maxcpus=n/2" to boot all thread-0's, we should say it
> more explicitly like perhaps nosmt or noht (we used to have this kind of
> option before).  Or is it even worth to bother about this, given that we
> can boot all the cpu's and offline the SMT siblings.

interesting, if we have nosmt or noht, we still need to boot that cpu
to use cpuid to
find out thread idx?

Thanks

Yinghai Lu
