Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab2D0MjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:39:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35390 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916Ab2D0MjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120427123434.GF18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	<1333390758-10893-7-git-send-email-robert.richter@amd.com>
	<1334398906.2528.49.camel@twins>
	<20120423095659.GS9747@erda.amd.com>
	<20120427123434.GF18810@erda.amd.com>
Date: Fri, 27 Apr 2012 14:39:21 +0200
Message-ID: <CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 2:34 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 23.04.12 11:56:59, Robert Richter wrote:
>> On 14.04.12 12:21:46, Peter Zijlstra wrote:
>> > On Mon, 2012-04-02 at 20:19 +0200, Robert Richter wrote:
>> > > + * We map IBS sampling to following precise levels:
>> > > + *
>> > > + *  1: RIP taken from IBS sample or (if invalid) from stack
>> > > + *  2: RIP always taken from IBS sample, samples with an invalid rip
>> > > + *     are dropped. Thus samples of an event containing two precise
>> > > + *     modifiers (e.g. r076:pp) only contain (precise) addresses
>> > > + *     detected with IBS.
>> >
>> >             /*
>> >              * precise_ip:
>> >              *
>> >              *  0 - SAMPLE_IP can have arbitrary skid
>> >              *  1 - SAMPLE_IP must have constant skid
>> >              *  2 - SAMPLE_IP requested to have 0 skid
>> >              *  3 - SAMPLE_IP must have 0 skid
>> >              *
>> >              *  See also PERF_RECORD_MISC_EXACT_IP
>> >              */
>> >
>> > your 1 doesn't have constant skid. I would suggest only supporting 2 and
>> > letting userspace drop !PERF_RECORD_MISC_EXACT_IP records if so desired.
>>
>> Ah, didn't notice the PERF_RECORD_MISC_EXACT_IP flag. Will set this
>> flag for precise events.
>
Why not use 2? IBS has 0 skid, unless I am mistaken.

> Peter,
>
> I have a patch on top that implements the support of the
> PERF_RECORD_MISC_EXACT_IP flag. But I am not quite sure about how to
> use the precise levels. What do you suggest?
>
> Thanks,
>
> -Robert
>
>>
>> Problem is that this flag is not yet well supported, only perf-top
>> uses it to count the total number of exact samples. Esp. perf-annotate
>> and perf-report do not support it, and there are no modifiers to
>> select precise-only sampling (or is this level 3?).
>>
>> Both might be useful: You might need only precise-rip samples (perf-
>> annotate usage), on the other side you want samples with every
>> clock/ops count overflow (e.g. to get a counting statistic). The
>> p-modifier specification (see perf-list) is not sufficient to select
>> both of it.
>>
>> Another question I have: Isn't precise level 2 a special case of level
>> 1 where the skid is constant and 0? The problem I see is, if people
>> want to measure precise rip, they simply use r076:p. Level 2 (r076:pp)
>> is actually better than 1, but they might think not to be able to
>> sample precise-rip if we throw an error for r076:p. Thus, I would
>> prefer to also allow level 1.
>>
>> > That said, mixing the IBS pmu into the regular core pmu isn't exactly
>> > pretty..
>>
>> IBS is currently the only way to do precise-rip sampling on amd cpus.
>> IBS events fit well with its corresponding perfctr events (0x76/
>> 0xc1). So what don't you like with this approach? I will also post IBS
>> perf tool support where IBS can be directly used.
>>
>> -Robert
>>
>> --
>> Advanced Micro Devices, Inc.
>> Operating System Research Center
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
