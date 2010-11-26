Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab0KZFPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 00:15:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38968 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0KZFPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 00:15:18 -0500
MIME-Version: 1.0
X-Originating-IP: [192.102.204.37]
In-Reply-To: <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
References: <1290340877.2245.124.camel@localhost>
	<AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
Date: Fri, 26 Nov 2010 13:15:16 +0800
Message-ID: <AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <lin@ming.vg>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 6:17 PM, Stephane Eranian <eranian@google.com> wrote:
> Lin,
>
> On Sun, Nov 21, 2010 at 1:01 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>> +static void uncore_pmu_enable_all(void)
>> +{
>> +       u64 ctrl;
>> +
>> +       /*
>> +        * (0xFULL << 48): 1 of the 4 cores can receive NMI each time
>> +        * but we don't know which core will receive the NMI when overflow happens
>> +        */
>
> That does not sound right. If you set bit 48-51 to 1, then all 4 cores
> will receive EVERY
> interrupt, i.e., it's a broadcast. That seems to contradict your
> comment: 1 of the 4. Unless
> you meant, they all get the interrupt and one will handle it, the
> other will find nothing to
> process. But I don't see the atomic op that would make this true in
> uncore_handle_irq().

Stephane,

The interrupt model is strange, it behaves differently when HT on/off.

If HT is off, all 4 cores will receive every interrupt, i.e., it's a broadcast.

If HT is on, only 1 of the 4 cores will receive the interrupt(both
Threads in that core receive the interrupt),
and it can't be determined which core will receive the interrupt.

Did you ever observe this?

>
> I also think that if you want all processors to receive the
> interrupts, then the mask should
> be 0xff when HT is on. The manual is rather obscure on this, but it
> does make sense.

I tried to set the mask 0xff when HT is on, but kernel panics, because
the reserve bits are set.

Thanks,
Lin Ming

>
>
>> +       ctrl = ((1 << UNCORE_NUM_GENERAL_COUNTERS) - 1) | (0xFULL << 48);
>> +       ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0;
>> +
>> +       /*
>> +        * Freeze the uncore pmu on overflow of any uncore counter.
>> +        * This makes unocre NMI handling easier.
>> +        */
>> +       ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_FRZ;
>> +
>> +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
>> +}
>> +
> --
