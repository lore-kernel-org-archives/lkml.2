Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1JKIvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:51:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59113 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1JKIvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <1318319852.14400.65.camel@laptop>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
	<CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
	<1318319852.14400.65.camel@laptop>
Date: Tue, 11 Oct 2011 10:51:37 +0200
Message-ID: <CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
Subject: Re: sched: ARM: arch_scale_freq_power
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linux-kernel@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 October 2011 09:57, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-10-11 at 12:46 +0530, Amit Kucheria wrote:
>> Adding Peter to the discussion..
>
> Right, CCing the folks who actually wrote the code you're asking
> questions about always helps ;-)
>
>> On Thu, Oct 6, 2011 at 5:06 PM, Vincent Guittot
>> <vincent.guittot@linaro.org> wrote:
>> > I work to link the cpu_power of ARM cores to their frequency by using
>> > arch_scale_freq_power.
>
> Why and how? In particular note that if you're using something like the
> on-demand cpufreq governor this isn't going to work.
>

I have several goals. The 1st one is that I need to put more load on
some cpus when I have packages with different cpu frequency.
I also study if I can follow the real cpu frequency but it seems to be
not so easy. I have noticed that the cpu_power is updated periodical
except when we have a lot of newly_idle events.
Then, I have some use cases which have several running tasks but a low
cpu load. In this case, the small tasks are spread on several cpu by
the load_balance whereas they could be easily handled by one cpu
without significant performance modification. If the cpu_power is
higher than 1024, the cpu is no more seen out of capacity by the
load_balance as soon as a short process is running and teh main result
is that the small tasks will stay on the same cpu. This configuration
is mainly usefull for ARM dual core system when we want to power gate
one cpu. I use cyclictest to simulate such use case.

>> It's explained in the kernel that cpu_power is
>> > used to distribute load on cpus and a cpu with more cpu_power will
>> > pick up more load. The default value is SCHED_POWER_SCALE and I
>> > increase the value if I want a cpu to have more load than another one.
>> > Is there an advised range for cpu_power value as well as some time
>> > scale constraints for updating the cpu_power value ?
>
> Basically 1024 is the unit and denotes the capacity of a full core at
> 'normal' speed.
>
> Typically cpufreq would down-clock a core and thus you'd end up with a
> smaller number (linearly proportional to the freq ratio etc. although if
> you want to go really fancy you could determine the actual
> throughput/freq curves).
>
> Things like x86 turbo mode would result in a >1024 value.
>
> Things like SMT would typically result in <1024 and the SMT sum over the
> core >1024 (if you're lucky).
>
>> > I'm also wondering why this scheduler feature is currently disable by default ?
>
> Because the only implementation in existence (x86) is broken and I
> haven't gotten around to fixing it. Arguable we should disable that for
> the time being, see below.
>
>> In discussions with Vincent regarding this, I've wondered whether
>> cpu_power wouldn't be better renamed to cpu_capacity since that is
>> what it really seems to describe.
>
> Possibly, but its been cpu_power for ages and we use capacity to
> describe something else.
>
> ---
>  arch/x86/kernel/cpu/sched.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sched.c b/arch/x86/kernel/cpu/sched.c
> index a640ae5..90ae68c 100644
> --- a/arch/x86/kernel/cpu/sched.c
> +++ b/arch/x86/kernel/cpu/sched.c
> @@ -6,7 +6,14 @@
>  #include <asm/cpufeature.h>
>  #include <asm/processor.h>
>
> -#ifdef CONFIG_SMP
> +#if 0 /* def CONFIG_SMP */
> +
> +/*
> + * Currently broken, we need to filter out idle time because the aperf/mperf
> + * ratio measures actual throughput, not capacity. This means that if a logical
> + * cpu idles it will report less capacity and receive less work, which isn't
> + * what we want.
> + */
>
>  static DEFINE_PER_CPU(struct aperfmperf, old_perf_sched);
>
>
>
>
