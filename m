Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0KZISJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:18:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0KZISH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:18:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wqsQKoBhvaj3ZY4lPPQL8YTgUj0hWMmGFjZaVP8c0i0wCtpa0tgobtTPlxFuF+d+5n
         Zgc5sQ5Dyb8vYVwKOuhg==
MIME-Version: 1.0
In-Reply-To: <AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
References: <1290340877.2245.124.camel@localhost>
	<AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
	<AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
Date: Fri, 26 Nov 2010 09:18:03 +0100
Message-ID: <AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <lin@ming.vg>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 6:15 AM, Lin Ming <lin@ming.vg> wrote:
> On Tue, Nov 23, 2010 at 6:17 PM, Stephane Eranian <eranian@google.com> wrote:
>> Lin,
>>
>> On Sun, Nov 21, 2010 at 1:01 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>>> +static void uncore_pmu_enable_all(void)
>>> +{
>>> +       u64 ctrl;
>>> +
>>> +       /*
>>> +        * (0xFULL << 48): 1 of the 4 cores can receive NMI each time
>>> +        * but we don't know which core will receive the NMI when overflow happens
>>> +        */
>>
>> That does not sound right. If you set bit 48-51 to 1, then all 4 cores
>> will receive EVERY
>> interrupt, i.e., it's a broadcast. That seems to contradict your
>> comment: 1 of the 4. Unless
>> you meant, they all get the interrupt and one will handle it, the
>> other will find nothing to
>> process. But I don't see the atomic op that would make this true in
>> uncore_handle_irq().
>
> Stephane,
>
> The interrupt model is strange, it behaves differently when HT on/off.
>
> If HT is off, all 4 cores will receive every interrupt, i.e., it's a broadcast.
>
That's if yo set the mask to 0xf, right?

In the perf_event model, given that any one of the 4 cores can be used
to program uncore events, you have no choice but to broadcast to all
4 cores. Each has to demultiplex and figure out which of its counters
have overflowed.

> If HT is on, only 1 of the 4 cores will receive the interrupt(both
> Threads in that core receive the interrupt),
> and it can't be determined which core will receive the interrupt.
>
> Did you ever observe this?
>
No because I never set more than one bit in the mask.

> I tried to set the mask 0xff when HT is on, but kernel panics, because
> the reserve bits are set.

Let me check on this. It would seem to imply that in HT mode, both threads
necessarily receive the interrupts.

Was that on Nehalem or Westmere?
