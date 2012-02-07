Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2BGLHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:07:16 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61670 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754899Ab2BGLHP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:07:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120207104952.GB4328@elte.hu>
References: <20120206205354.GA31186@quad>
	<1328603689.2476.15.camel@edumazet-laptop>
	<20120207084156.GA15359@elte.hu>
	<1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
	<20120207104952.GB4328@elte.hu>
Date: Tue, 7 Feb 2012 12:07:13 +0100
Message-ID: <CABPqkBRLEH+r61Qi+xZj6uAyJ=Zd-qK7tyM7ysrPR7+CEtW0JA@mail.gmail.com>
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 11:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Tue, Feb 7, 2012 at 11:25 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le mardi 07 février 2012 à 09:41 +0100, Ingo Molnar a écrit :
>> >
>> >> Were these messages introduced by:
>> >>
>> >>  e050e3f0a71b: perf: Fix broken interrupt rate throttling
>> >>
>> >> as well?
>> >>
>> >> In any case I'm holding off on applying the patch before this is
>> >> resolved.
>> >
>> > Reverting e050e3f0a71b solves all my problems, no more warnings.
>> >
>> > $ perf record -a -g hackbench 10 thread 4000
>> > Running with 10*40 (== 400) tasks.
>> > Time: 13.181
>> > [ perf record: Woken up 59 times to write data ]
>> > [ perf record: Captured and wrote 16.874 MB perf.data (~737228 samples)
>> > ]
>> >
>> > $ perf record -a -g hackbench 10 thread 4000
>> > Running with 10*40 (== 400) tasks.
>> > Time: 13.124
>> > [ perf record: Woken up 61 times to write data ]
>> > [ perf record: Captured and wrote 16.533 MB perf.data (~722349 samples)
>> > ]
>> >
>>
>> What system is this running on?
>> The problem is that without e050e3f0a71b interrupt throttling does not work.
>
> Fixes are not supposed to regress, so if we cannot resolve this
> within a couple of days we'll have to revert e050e3f0a71b and
> re-try it later.
>
I suspect in the case of Eric's system, the fact that we do not
stop the PMU when adjusting frequency anymore may expose a side-effect
of his BIOS "sharing" the PMU with perf_events. But the config value reported
by the kernel does not include the INT bit, i.e., the counter does not generate
interrupts on overflow, so it should not conflict.

>> I think the key difference is that without the patch,
>> frequency adjustment happens with the PMU completely stopped
>> whereas with my patch it does not. I suspect this may be the
>> issue. I can rework the patch to disable the PMU completely
>> while retaining the same workflow.
>
> Would be nice to try that.
>
> Thanks,
>
>        Ingo
