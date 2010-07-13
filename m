Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0GMPQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:16:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39028 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0GMPQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:16:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xfRx6/d4eZQ24i+MqbEOvjAtue+e0obBUoZP0XBR3Bbf5z3GswzjITICU7CbWoTmP
	uXuEVEHCCrw512/DtuPJA==
MIME-Version: 1.0
In-Reply-To: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
References: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
Date: Tue, 13 Jul 2010 17:16:15 +0200
Message-ID: <AANLkTilu4fi68DQpbzsKJrrAVUq_ZFbm2AVNvaPK7VKu@mail.gmail.com>
Subject: Re: perf failed with kernel 2.6.35-rc
From: Stephane Eranian <eranian@google.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 10:14 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> Peter,
>
> perf doesn't work on my Nehalem EX machine.
> 1) The 1st start of 'perf top' is ok;
> 2) Kill the 1st perf and restart it. It doesn't work. No data is showed.
>
> I located below commit:
> commit 1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Mar 26 14:08:44 2010 +0100
>
>    perf, x86: Add Nehelem PMU programming errata workaround
>
>    workaround From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>    Date: Fri Mar 26 13:59:41 CET 2010
>
>    Implement the workaround for Intel Errata AAK100 and AAP53.
>
>    Also, remove the Core-i7 name for Nehalem events since there are
>    also Westmere based i7 chips.
>
>
> If I comment out the workaround in function intel_pmu_nhm_enable_all,
> perf could work.
>
> A quick glance shows:
> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> should be:
> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
>
>
> I triggered sysrq to dump PMU registers and found the last bit of
> global status register is 1. I added a status reset operation like below patch:
>
What do you call the last bit? bit0 or bit63?

> --- linux-2.6.35-rc5/arch/x86/kernel/cpu/perf_event_intel.c     2010-07-14 09:38:11.000000000 +0800
> +++ linux-2.6.35-rc5_fork/arch/x86/kernel/cpu/perf_event_intel.c        2010-07-14 14:41:42.000000000 +0800
> @@ -505,8 +505,13 @@ static void intel_pmu_nhm_enable_all(int
>                wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
>                wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
>
> -               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> +               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
>                wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> +               /*
> +                * Reset the last 3 bits of global status register in case
> +                * previous enabling causes overflows.
> +                */

The workaround cannot cause on overflow because the associated counters
won't count anything given their umask value is 0 (which does not correspond
to anything for event 0xB1, event 0xB5 is undocumented). This is for the events
described in table A.2. If NHM-EX has a different definition for 0xB1, 0xB5,
then that's another story.


> +               wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
>
>                for (i = 0; i < 3; i++) {
>                        struct perf_event *event = cpuc->events[i];
>
>
>
> However, it still doesn't work. Current right way is to comment out
> the workaround.
>
> Yanmin
>
>
>
