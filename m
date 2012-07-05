Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2GEP5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:57:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34043 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2GEP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <1341393205.23484.111.camel@twins>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	<1341300987.11663.15.camel@concordia>
	<1341306905.23484.53.camel@twins>
	<1341389237.22063.7.camel@concordia>
	<1341393205.23484.111.camel@twins>
Date: Thu, 5 Jul 2012 17:57:51 +0200
Message-ID: <CABPqkBS=eXZXXf6HKtw=LgaKMW9Pe2tfMiuD+FGw5CWkPY-SuA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw format
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 11:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-07-04 at 18:07 +1000, Michael Ellerman wrote:
>> Basically we have three registers which provide various information about
>> the instruction which caused an event to overflow.
>>
>> The first reports the address of the instruction, the second the data
>> address associated with the instruction, and the third reports "other
>> stuff".
>>
>> We use the first for SAMPLE_IP, and the second for SAMPLE_ADDR, but
>> currently we have no way of spitting out the third register.
>>
>> There's a whole bunch of info in there. I think the most interesting are
>> stuff like whether and where in the pipeline the instruction stalled, or
>> where a load was serviced from. I'm not sure to be honest, so I've asked
>> the HW guys what they're most interested in.
>>
>> So I can imagine us coming up with a generic sample type for "sample
>> other info at event overflow", but I'm struggling to see how we'd make
>> the content of the sample non architecture specific, or even processor
>> version specific.
>
> Right so we're working on a data-source like thing, the last attempt at
> adding something like that is in this thread:
>
>  http://marc.info/?l=linux-kernel&m=130987553915170&w=2
>  http://marc.info/?l=linux-kernel&m=131000375226044
>
> I think Stephane is currently trying to revive that, although he hasn't
> posted yet. Please have a look if that captures the possible PPC states
> as well. Stephane could you share your current stuff so Michael can have
> a look?
>
I am currently on vacation and with limited internet access.

But yes, the PEBS-LL patchset I have been working on
does abstract PEBS-LL and offers an abstracted data source
field. It uses:
PERF_SAMPLE_IP: for instr address
PERF_SAMPLE_ADDR: for the data address

It introduces:
PERF_SAMPLE_LATENCY: to capture the access latency
PERF_SAMPLE_DSRC: to encode the data source.

That latter value is a structured bitmask which covers:
- type of access (load, store, prefetch, instr)
- mem level: hit or miss in L1, LFB, L2, L3, LOC_RAM, REM_RAM, uncached, IO
- snoop access: hit, miss, none
- TLB access: hit or miss in L1, L2, HW walker, OS fault

Hopefully those are generic enough to cover all possible cases across
architectures. PPC would be a good test case.
Note that multiple bits per category may be set in case the HW cannot
disambiguate like this is the case on with PEBS-LL sometimes.

>
> Not quite sure what to do for your pipeline stage thing, I'm not sure
> I've seen that elsewhere.
>
>
> Anyway, yes PERF_SAMPLE_RAW is the 'other info at overflow' which is
> specific to the current cpu and phase of moon type field, and it does
> get (ab)used in various places, but I still cringe every time I see it
> used.
>
> The problem with that thing is that it gives people the data they need
> for their special tools and thus removes them from the incentive pool to
> help create more generic,useful tools.
>
> For AMD IBS we've given in since that thing is completely weird, IIRC
> Robert was going to grow perf-ibs to record and report the data it
> captures so we've at least got a useful open-source tool for it.
