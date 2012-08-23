Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab2HWQG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:06:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63892 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030574Ab2HWQGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:06:25 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120823154346.GB2465@linux.vnet.ibm.com>
References: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
	<alpine.LFD.2.02.1208231245510.2856@ionos>
	<20120823154346.GB2465@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2012 18:06:23 +0200
Message-ID: <CA+icZUXq9p4yOuse5dzCb2FGmgSKdU8ufDkDcTjWJ0dE79tvUg@mail.gmail.com>
Subject: Re: [next-20120823] NOHZ: local_softirq_pending 200 on s/r
From: Sedat Dilek <sedat.dilek@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 5:43 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Aug 23, 2012 at 12:46:37PM +0200, Thomas Gleixner wrote:
>> On Thu, 23 Aug 2012, Sedat Dilek wrote:
>>
>> > Hi,
>> >
>> > this week I was seeing the below NOHZ messages in my logs especially
>> > when suspending and resuming.
>> >
>> > Currently, I am using linux-next (next-20120823) on Ubuntu/precise
>> > AMD64 with a Intel S(a)N(dy)B(ridge)-CPU.
>> >
>> > $ dmesg | grep -A1 -B1 -i nohz
>> > [  720.331819] Disabling non-boot CPUs ...
>> > [  720.332035] NOHZ: local_softirq_pending 200
>> > [  720.434312] smpboot: CPU 1 is now offline
>> > [  720.434825] NOHZ: local_softirq_pending 200
>> > [  720.538237] smpboot: CPU 2 is now offline
>> > [  720.538676] NOHZ: local_softirq_pending 200
>> > [  720.642162] smpboot: CPU 3 is now offline
>> >
>> > If I manually disable the cpuX... First I did not see NOHZ messages
>> > but then there were some lines seen especially when cpuX went offline
>> > (here: cpu1)
>> >
>> > # echo 0 >/sys/devices/system/cpu/cpu1/online
>> >
>> > [ dmeg ]
>> > [ 2605.515771] smpboot: CPU 1 is now offline
>> >
>> > The same with cpu2 and cpu3.
>
> Hmmm...  RCU is actually relying on being able to prevent entry into idle
> by raising softirq.  This is needed for the aggressive energy-efficiency
> CONFIG_RCU_FAST_NO_HZ feature of RCU.  Therefore, I propose the patch
> shown below.
>
> Sedat, does this patch help?
>
>                                                         Thanx, Paul
>
>> > Jack Winter confirmed to see similiar NOHZ messages also on
>> > v3.4.9-rt17 kernel (CPU: Core2Duo when no suspend performed):
>> >
>> > [15223.171585] NOHZ: local_softirq_pending 08
>>
>> That's a different issue. That's a pending networking softirq when we
>> go idle. Unrelated to the RCU / hotplug issue you are observing.
>>
>> > So, the issue is seen on linux-next and -rt kernels.
>> >
>> > According to Thomas "softirq 0x200 is the RCU one" and he requested me
>> > to address the issue to Paul on #linux-rt.
>> >
>> > Regards,
>> > - Sedat -
>
> time: RCU permitted to stop idle entry via softirq
>
> RCU needs to be able to use softirq to stop idle entry in order to
> be able to drain RCU callbacks from the current CPU, which in turn
> enables faster entry into dyntick-idle mode, which in turn reduces power
> consumption.  This commit therefore silences the error message that is
> sometimes produced when the going-idle CPU suddenly finds that it has
> an RCU_SOFTIRQ to process.
>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index c5f856a..c0359d2 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -430,6 +430,8 @@ enum
>         NR_SOFTIRQS
>  };
>
> +const int softirq_stop_idle_mask = (~(1 << RCU_SOFTIRQ));
> +
>  /* map softirq index to softirq name. update 'softirq_to_name' in
>   * kernel/softirq.c when adding a new softirq.
>   */
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 024540f..84932cf 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -436,7 +436,8 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>         if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
>                 static int ratelimit;
>
> -               if (ratelimit < 10) {
> +               if (ratelimit < 10 &&
> +                   (local_softirq_pending() & softirq_stop_idle_mask)) {
>                         printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
>                                (unsigned int) local_softirq_pending());
>                         ratelimit++;
>

Applying this patch on top of my local GIT tree results in error-messages:

[...]
  CC      kernel/rcupdate.o
  AS      arch/x86/platform/efi/efi_stub_64.o
  CC      arch/x86/kernel/irqinit.o
  LD      arch/x86/platform/efi/built-in.o
arch/x86/platform/efi/efi_64.o:(.rodata+0x0): multiple definition of
`softirq_stop_idle_mask'
arch/x86/platform/efi/efi.o:(.rodata+0x50): first defined here
make[5]: *** [arch/x86/platform/efi/built-in.o] Error 1
make[4]: *** [arch/x86/platform/efi] Error 2
make[3]: *** [arch/x86/platform] Error 2
make[3]: *** Waiting for unfinished jobs....
[...]

$ LC_ALL=C grep softirq_stop_idle_mask -nr linux-next/arch/x86/platform/efi/
Binary file linux-next/arch/x86/platform/efi/efi.o matches
Binary file linux-next/arch/x86/platform/efi/efi_64.o matches

- Sedat -
