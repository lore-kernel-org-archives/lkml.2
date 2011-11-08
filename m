Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab1KHFGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 00:06:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53134 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1KHFGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 00:06:38 -0500
Date: Tue, 8 Nov 2011 13:02:59 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
Message-ID: <20111108050259.GA13225@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
 <20111103211000.GA17895@elte.hu>
 <1320721740.10668.23.camel@work-vm>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1320721740.10668.23.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Nov 07, 2011 at 07:09:00PM -0800, John Stultz wrote:
> Yong: Can you also give this a test run to make sure you don't see any
> problems?

Still get warning (3.2-rc1 + your patch):

[    0.017009] ------------[ cut here ]------------
[    0.022156] WARNING: at /build/linux/kernel/time/timekeeping.c:828 do_timer+0x402/0x4e0()
[    0.035917] Adjusting jiffies more then 11% (1024068096 vs 1024064000)
[    0.043189] Modules linked in:
[    0.046600] Pid: 0, comm: swapper Not tainted 3.2.0-rc1-10884-g63c2ac8-dirty #17
[    0.054841] Call Trace:
[    0.057563]  <IRQ>  [<ffffffff81050edf>] warn_slowpath_common+0x7f/0xc0
[    0.064949]  [<ffffffff81050fd6>] warn_slowpath_fmt+0x46/0x50
[    0.071352]  [<ffffffff810829e2>] do_timer+0x402/0x4e0
[    0.077078]  [<ffffffff81088a8a>] tick_periodic+0x5a/0x70
[    0.083094]  [<ffffffff81088ac4>] tick_handle_periodic+0x24/0x80
[    0.089789]  [<ffffffff8100482d>] timer_interrupt+0x1d/0x30
[    0.096000]  [<ffffffff810cb9bd>] handle_irq_event_percpu+0x8d/0x360
[    0.103080]  [<ffffffff810cbcd8>] handle_irq_event+0x48/0x70
[    0.109386]  [<ffffffff810cf0be>] ? handle_level_irq+0x1e/0xe0
[    0.115886]  [<ffffffff810cf112>] handle_level_irq+0x72/0xe0
[    0.122191]  [<ffffffff81004002>] handle_irq+0x22/0x30
[    0.127917]  [<ffffffff815f256d>] do_IRQ+0x5d/0xe0
[    0.133256]  [<ffffffff815ef6b0>] common_interrupt+0x70/0x70
[    0.139561]  <EOI>  [<ffffffff810425de>] ? sub_preempt_count+0xe/0xe0
[    0.146751]  [<ffffffff815ef4a8>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[    0.154315]  [<ffffffff81052136>] ? vprintk+0x316/0x4d0
[    0.160139]  [<ffffffff815e146d>] ? calibrate_delay+0x4e4/0x504
[    0.166727]  [<ffffffff815ea3d0>] printk+0x68/0x70
[    0.172067]  [<ffffffff81acc9ce>] pidmap_init+0x6e/0xbd
[    0.177891]  [<ffffffff81ab7be7>] start_kernel+0x312/0x38a
[    0.184004]  [<ffffffff81ab7321>] x86_64_start_reservations+0x131/0x135
[    0.191375]  [<ffffffff81ab7412>] x86_64_start_kernel+0xed/0xf4
[    0.198109] ---[ end trace 4eaa2a86a8e2da22 ]---

Full dmesg is attached.

Thanks,
Yong

> 
> thanks
> -john
> 
> >From 82c5b70fc5074b6bb6e05514afb6e9c73c740422 Mon Sep 17 00:00:00 2001
> From: John Stultz <john.stultz@linaro.org>
> Date: Mon, 31 Oct 2011 17:06:35 -0400
> Subject: [PATCH] clocksource: Avoid selecting mult values that might overflow when adjusted
> 
> For some frequqencies, the clocks_calc_mult_shift() function will
> unfortunately select mult values very close to 0xffffffff.  This
> has the potential to overflow when NTP adjusts the clock, adding
> to the mult value.
> 
> This patch adds a clocksource.maxadj value, which provides
> an approximation of an 11% adjustment(NTP limits adjustments to
> 500ppm and the tick adjustment is limited to 10%), which could
> be made to the clocksource.mult value. This is then used to both
> check that the current mult value won't overflow/underflow, as
> well as warning us if the timekeeping_adjust() code pushes over
> that 11% boundary.
> 
> v2: Fix max_adjustment calculation, and improve WARN_ONCE
> messages.
> 
> CC: Yong Zhang <yong.zhang0@gmail.com>
> CC: David Daney <ddaney.cavm@gmail.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Reported-by: Chen Jie <chenj@lemote.com>
> Reported-by: zhangfx <zhangfx@lemote.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  include/linux/clocksource.h |    3 +-
>  kernel/time/clocksource.c   |   58 +++++++++++++++++++++++++++++++++++-------
>  kernel/time/timekeeping.c   |    6 ++++
>  3 files changed, 56 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 139c4db..c86c940 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -156,6 +156,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
>   * @mult:		cycle to nanosecond multiplier
>   * @shift:		cycle to nanosecond divisor (power of two)
>   * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
> + * @maxadj		maximum adjustment value to mult (~11%)
>   * @flags:		flags describing special properties
>   * @archdata:		arch-specific data
>   * @suspend:		suspend function for the clocksource, if necessary
> @@ -172,7 +173,7 @@ struct clocksource {
>  	u32 mult;
>  	u32 shift;
>  	u64 max_idle_ns;
> -
> +	u32 maxadj;
>  #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
>  	struct arch_clocksource_data archdata;
>  #endif
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index cf52fda..cfc65e1 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -492,6 +492,22 @@ void clocksource_touch_watchdog(void)
>  }
>  
>  /**
> + * clocksource_max_adjustment- Returns max adjustment amount
> + * @cs:         Pointer to clocksource
> + *
> + */
> +static u32 clocksource_max_adjustment(struct clocksource *cs)
> +{
> +	u64 ret;
> +	/*
> +	 * We won't try to correct for more then 11% adjustments (110,000 ppm),
> +	 */
> +	ret = (u64)cs->mult * 11;
> +	do_div(ret,100);
> +	return (u32)ret;
> +}
> +
> +/**
>   * clocksource_max_deferment - Returns max time the clocksource can be deferred
>   * @cs:         Pointer to clocksource
>   *
> @@ -503,25 +519,28 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
>  	/*
>  	 * Calculate the maximum number of cycles that we can pass to the
>  	 * cyc2ns function without overflowing a 64-bit signed result. The
> -	 * maximum number of cycles is equal to ULLONG_MAX/cs->mult which
> -	 * is equivalent to the below.
> -	 * max_cycles < (2^63)/cs->mult
> -	 * max_cycles < 2^(log2((2^63)/cs->mult))
> -	 * max_cycles < 2^(log2(2^63) - log2(cs->mult))
> -	 * max_cycles < 2^(63 - log2(cs->mult))
> -	 * max_cycles < 1 << (63 - log2(cs->mult))
> +	 * maximum number of cycles is equal to ULLONG_MAX/(cs->mult+cs->maxadj)
> +	 * which is equivalent to the below.
> +	 * max_cycles < (2^63)/(cs->mult + cs->maxadj)
> +	 * max_cycles < 2^(log2((2^63)/(cs->mult + cs->maxadj)))
> +	 * max_cycles < 2^(log2(2^63) - log2(cs->mult + cs->maxadj))
> +	 * max_cycles < 2^(63 - log2(cs->mult + cs->maxadj))
> +	 * max_cycles < 1 << (63 - log2(cs->mult + cs->maxadj))
>  	 * Please note that we add 1 to the result of the log2 to account for
>  	 * any rounding errors, ensure the above inequality is satisfied and
>  	 * no overflow will occur.
>  	 */
> -	max_cycles = 1ULL << (63 - (ilog2(cs->mult) + 1));
> +	max_cycles = 1ULL << (63 - (ilog2(cs->mult + cs->maxadj) + 1));
>  
>  	/*
>  	 * The actual maximum number of cycles we can defer the clocksource is
>  	 * determined by the minimum of max_cycles and cs->mask.
> +	 * Note: Here we subtract the maxadj to make sure we don't sleep for
> +	 * too long if there's a large negative adjustment.
>  	 */
>  	max_cycles = min_t(u64, max_cycles, (u64) cs->mask);
> -	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult, cs->shift);
> +	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult - cs->maxadj,
> +					cs->shift);
>  
>  	/*
>  	 * To ensure that the clocksource does not wrap whilst we are idle,
> @@ -640,7 +659,6 @@ static void clocksource_enqueue(struct clocksource *cs)
>  void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>  {
>  	u64 sec;
> -
>  	/*
>  	 * Calc the maximum number of seconds which we can run before
>  	 * wrapping around. For clocksources which have a mask > 32bit
> @@ -661,6 +679,20 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>  
>  	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
>  			       NSEC_PER_SEC / scale, sec * scale);
> +
> +	/*
> +	 * for clocksources that have large mults, to avoid overflow.
> +	 * Since mult may be adjusted by ntp, add an safety extra margin
> +	 *
> +	 */
> +	cs->maxadj = clocksource_max_adjustment(cs);
> +	while ((cs->mult + cs->maxadj < cs->mult)
> +		|| (cs->mult - cs->maxadj > cs->mult)) {
> +		cs->mult >>= 1;
> +		cs->shift--;
> +		cs->maxadj = clocksource_max_adjustment(cs);
> +	}
> +
>  	cs->max_idle_ns = clocksource_max_deferment(cs);
>  }
>  EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
> @@ -701,6 +733,12 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
>   */
>  int clocksource_register(struct clocksource *cs)
>  {
> +	/* calculate max adjustment for given mult/shift */
> +	cs->maxadj = clocksource_max_adjustment(cs);
> +	WARN_ONCE(cs->mult + cs->maxadj < cs->mult,
> +		"Clocksource %s might overflow on 11%% adjustment\n",
> +		cs->name);
> +
>  	/* calculate max idle time permitted for this clocksource */
>  	cs->max_idle_ns = clocksource_max_deferment(cs);
>  
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 2b021b0e..2c04610 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -820,6 +820,12 @@ static void timekeeping_adjust(s64 offset)
>  	} else
>  		return;
>  
> +	WARN_ONCE(timekeeper.mult+adj >
> +			timekeeper.clock->mult + timekeeper.clock->maxadj,
> +			"Adjusting %s more then 11%% (%ld vs %ld)\n",
> +			timekeeper.clock->name, (long)timekeeper.mult+adj,
> +			(long)timekeeper.clock->mult +
> +				timekeeper.clock->maxadj);
>  	timekeeper.mult += adj;
>  	timekeeper.xtime_interval += interval;
>  	timekeeper.xtime_nsec -= offset;
> -- 
> 1.7.3.2.146.gca209
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="3.2-rc1.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-rc1-10884-g63c2ac8-dirty #17 SMP PREEMPT Tue Nov 8 12:48:41 CST 2011
[    0.000000] Command line: root=/dev/sda1 console=ttyS0,115200
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f4cf000 (usable)
[    0.000000]  BIOS-e820: 000000007f4cf000 - 000000007f62f000 (reserved)
[    0.000000]  BIOS-e820: 000000007f62f000 - 000000007f77f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f77f000 - 000000007f800000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f800000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000a0000000 - 00000000b0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fc000000 - 00000000fd000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI:  , BIOS Txx080_CRB 
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f4cf max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000fd5a0] fd5a0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-000000007f4cf000
[    0.000000]  0000000000 - 0040000000 page 1G
[    0.000000]  0040000000 - 007f400000 page 2M
[    0.000000]  007f400000 - 007f4cf000 page 4k
[    0.000000] kernel direct mapping tables up to 7f4cf000 @ 1fffd000-20000000
[    0.000000] ACPI: RSDP 00000000000f03f0 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007f7fd120 0006C (v01 INTEL  THRLY    00000000      01000013)
[    0.000000] ACPI: FACP 000000007f7fc000 000F4 (v04 INTEL  THRLY    00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 000000007f7f4000 075C1 (v02 INTEL  THRLY    00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 000000007f697000 00040
[    0.000000] ACPI: APIC 000000007f7f3000 001CC (v02 INTEL  THRLY    00000000 MSFT 0100000D)
[    0.000000] ACPI: MCFG 000000007f7f2000 0003C (v01 INTEL  THRLY    00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 000000007f7f1000 00038 (v01 INTEL  THRLY    00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 000000007f7f0000 00030 (v01 INTEL  THRLY    00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 000000007f7ef000 00430 (v02 INTEL  THRLY    00000001 MSFT 0100000D)
[    0.000000] ACPI: WDDT 000000007f7ee000 00040 (v01 INTEL  THRLY    00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000000007f7ce000 1FDDC (v01  INTEL SSDT  PM 00004000 INTL 20061109)
[    0.000000] ACPI: DMAR 000000007f7cd000 001D0 (v01 INTEL  THRLY    00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007cc00000-ffff88007e7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0007f4cf
[    0.000000] On node 0 totalpages: 521308
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 9 pages reserved
[    0.000000]   DMA zone: 3916 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7073 pages used for memmap
[    0.000000]   DMA32 zone: 510254 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec90000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec90000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] Allocating PCI resources starting at b0000000 (gap: b0000000:4c000000)
[    0.000000] setup_percpu: NR_CPUS:24 nr_cpumask_bits:24 nr_cpu_ids:24 nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880079c00000 s1912064 r8192 d21248 u2097152
[    0.000000] pcpu-alloc: s1912064 r8192 d21248 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15 
[    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19 [0] 20 [0] 21 [0] 22 [0] 23 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514170
[    0.000000] Kernel command line: root=/dev/nfs nfsroot=128.224.165.20:/export/pxeboot/vlm-boards/18775/rootfs rw ip=128.224.178.131::128.224.178.1:255.255.255.0:18775:eth0:off console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1984824k/2085692k available (6098k kernel code, 460k absent, 100408k reserved, 2998k data, 2548k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1280 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] kmemleak: Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 31 of 31 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2400.283 MHz processor.
[    0.000010] Calibrating delay loop (skipped), value calculated using timer frequency.. 4800.56 BogoMIPS (lpj=9601132)
[    0.011869] pid_max: default: 32768 minimum: 301
[    0.017009] ------------[ cut here ]------------
[    0.022156] WARNING: at /build/linux/kernel/time/timekeeping.c:828 do_timer+0x402/0x4e0()
[    0.035917] Adjusting jiffies more then 11% (1024068096 vs 1024064000)
[    0.043189] Modules linked in:
[    0.046600] Pid: 0, comm: swapper Not tainted 3.2.0-rc1-10884-g63c2ac8-dirty #17
[    0.054841] Call Trace:
[    0.057563]  <IRQ>  [<ffffffff81050edf>] warn_slowpath_common+0x7f/0xc0
[    0.064949]  [<ffffffff81050fd6>] warn_slowpath_fmt+0x46/0x50
[    0.071352]  [<ffffffff810829e2>] do_timer+0x402/0x4e0
[    0.077078]  [<ffffffff81088a8a>] tick_periodic+0x5a/0x70
[    0.083094]  [<ffffffff81088ac4>] tick_handle_periodic+0x24/0x80
[    0.089789]  [<ffffffff8100482d>] timer_interrupt+0x1d/0x30
[    0.096000]  [<ffffffff810cb9bd>] handle_irq_event_percpu+0x8d/0x360
[    0.103080]  [<ffffffff810cbcd8>] handle_irq_event+0x48/0x70
[    0.109386]  [<ffffffff810cf0be>] ? handle_level_irq+0x1e/0xe0
[    0.115886]  [<ffffffff810cf112>] handle_level_irq+0x72/0xe0
[    0.122191]  [<ffffffff81004002>] handle_irq+0x22/0x30
[    0.127917]  [<ffffffff815f256d>] do_IRQ+0x5d/0xe0
[    0.133256]  [<ffffffff815ef6b0>] common_interrupt+0x70/0x70
[    0.139561]  <EOI>  [<ffffffff810425de>] ? sub_preempt_count+0xe/0xe0
[    0.146751]  [<ffffffff815ef4a8>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[    0.154315]  [<ffffffff81052136>] ? vprintk+0x316/0x4d0
[    0.160139]  [<ffffffff815e146d>] ? calibrate_delay+0x4e4/0x504
[    0.166727]  [<ffffffff815ea3d0>] printk+0x68/0x70
[    0.172067]  [<ffffffff81acc9ce>] pidmap_init+0x6e/0xbd
[    0.177891]  [<ffffffff81ab7be7>] start_kernel+0x312/0x38a
[    0.184004]  [<ffffffff81ab7321>] x86_64_start_reservations+0x131/0x135
[    0.191375]  [<ffffffff81ab7412>] x86_64_start_kernel+0xed/0xf4
[    0.198109] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.203536] Security Framework initialized
[    0.208112] SELinux:  Disabled at boot.
[    0.212530] Mount-cache hash table entries: 256
[    0.219102] Initializing cgroup subsys debug
[    0.223867] Initializing cgroup subsys cpuacct
[    0.228840] Initializing cgroup subsys memory
[    0.233801] Initializing cgroup subsys devices
[    0.238767] Initializing cgroup subsys freezer
[    0.243729] Initializing cgroup subsys net_cls
[    0.248772] CPU: Physical Processor ID: 0
[    0.253249] CPU: Processor Core ID: 0
[    0.257343] mce: CPU supports 9 MCE banks
[    0.261827] CPU0: Thermal monitoring enabled (TM1)
[    0.267205] using mwait in idle threads.
[    0.271663] ACPI: Core revision 20110623
[    0.328706] ftrace: allocating 20698 entries in 82 pages
[    0.341877] Switched APIC routing to physical flat.
[    0.348026] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.394350] CPU0: Intel(R) Xeon(R) CPU           E5645  @ 2.40GHz stepping 02
[    0.506819] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.514918] ... version:                3
[    0.519387] ... bit width:              48
[    0.523944] ... generic registers:      4
[    0.528412] ... value mask:             0000ffffffffffff
[    0.534334] ... max period:             000000007fffffff
[    0.540255] ... fixed-purpose events:   3
[    0.544723] ... event mask:             000000070000000f
[    0.567757] NMI watchdog enabled, takes one hw-pmu counter.
[    0.582781] lockdep: fixing up alternatives.
[    0.590924] Booting Node   0, Processors  #1
[    0.595511] smpboot cpu 1: start_ip = 94000
[    0.706823] NMI watchdog enabled, takes one hw-pmu counter.
[    0.722529] lockdep: fixing up alternatives.
[    0.727343]  #2
[    0.729088] smpboot cpu 2: start_ip = 94000
[    0.838494] NMI watchdog enabled, takes one hw-pmu counter.
[    0.854326] lockdep: fixing up alternatives.
[    0.859150]  #3
[    0.860905] smpboot cpu 3: start_ip = 94000
[    0.970292] NMI watchdog enabled, takes one hw-pmu counter.
[    0.986144] lockdep: fixing up alternatives.
[    0.990960]  #4
[    0.992715] smpboot cpu 4: start_ip = 94000
[    1.102128] NMI watchdog enabled, takes one hw-pmu counter.
[    1.117919] lockdep: fixing up alternatives.
[    1.122743]  #5
[    1.124499] smpboot cpu 5: start_ip = 94000
[    1.233885] NMI watchdog enabled, takes one hw-pmu counter.
[    1.249714] lockdep: fixing up alternatives.
[    1.254527]  #6
[    1.256273] smpboot cpu 6: start_ip = 94000
[    1.365693] NMI watchdog enabled, takes one hw-pmu counter.
[    1.381513] lockdep: fixing up alternatives.
[    1.386350]  #7
[    1.388106] smpboot cpu 7: start_ip = 94000
[    1.497495] NMI watchdog enabled, takes one hw-pmu counter.
[    1.513312] lockdep: fixing up alternatives.
[    1.518127]  #8
[    1.519883] smpboot cpu 8: start_ip = 94000
[    1.629294] NMI watchdog enabled, takes one hw-pmu counter.
[    1.645115] lockdep: fixing up alternatives.
[    1.649944]  #9
[    1.651699] smpboot cpu 9: start_ip = 94000
[    1.761071] NMI watchdog enabled, takes one hw-pmu counter.
[    1.776901] lockdep: fixing up alternatives.
[    1.781717]  #10
[    1.783568] smpboot cpu 10: start_ip = 94000
[    1.892878] NMI watchdog enabled, takes one hw-pmu counter.
[    1.908699] lockdep: fixing up alternatives.
[    1.913524]  #11
[    1.915375] smpboot cpu 11: start_ip = 94000
[    2.024653] NMI watchdog enabled, takes one hw-pmu counter.
[    2.040494] lockdep: fixing up alternatives.
[    2.045315]  #12
[    2.047168] smpboot cpu 12: start_ip = 94000
[    2.156530] NMI watchdog enabled, takes one hw-pmu counter.
[    2.172292] lockdep: fixing up alternatives.
[    2.177123]  #13
[    2.178967] smpboot cpu 13: start_ip = 94000
[    2.288303] NMI watchdog enabled, takes one hw-pmu counter.
[    2.304091] lockdep: fixing up alternatives.
[    2.308909]  #14
[    2.310760] smpboot cpu 14: start_ip = 94000
[    2.420096] NMI watchdog enabled, takes one hw-pmu counter.
[    2.435890] lockdep: fixing up alternatives.
[    2.440722]  #15
[    2.442573] smpboot cpu 15: start_ip = 94000
[    2.551866] NMI watchdog enabled, takes one hw-pmu counter.
[    2.567679] lockdep: fixing up alternatives.
[    2.572501]  #16
[    2.574353] smpboot cpu 16: start_ip = 94000
[    2.683674] NMI watchdog enabled, takes one hw-pmu counter.
[    2.699477] lockdep: fixing up alternatives.
[    2.704308]  #17
[    2.706151] smpboot cpu 17: start_ip = 94000
[    2.815457] NMI watchdog enabled, takes one hw-pmu counter.
[    2.831272] lockdep: fixing up alternatives.
[    2.836092]  #18
[    2.837945] smpboot cpu 18: start_ip = 94000
[    2.947271] NMI watchdog enabled, takes one hw-pmu counter.
[    2.963081] lockdep: fixing up alternatives.
[    2.967914]  #19
[    2.969767] smpboot cpu 19: start_ip = 94000
[    3.079076] NMI watchdog enabled, takes one hw-pmu counter.
[    3.094870] lockdep: fixing up alternatives.
[    3.099690]  #20
[    3.101542] smpboot cpu 20: start_ip = 94000
[    3.210863] NMI watchdog enabled, takes one hw-pmu counter.
[    3.226668] lockdep: fixing up alternatives.
[    3.231501]  #21
[    3.233353] smpboot cpu 21: start_ip = 94000
[    3.342593] NMI watchdog enabled, takes one hw-pmu counter.
[    3.358463] lockdep: fixing up alternatives.
[    3.363284]  #22
[    3.365136] smpboot cpu 22: start_ip = 94000
[    3.474484] NMI watchdog enabled, takes one hw-pmu counter.
[    3.490256] lockdep: fixing up alternatives.
[    3.495080]  #23 Ok.
[    3.497513] smpboot cpu 23: start_ip = 94000
[    3.606198] NMI watchdog enabled, takes one hw-pmu counter.
[    3.614049] Brought up 24 CPUs
[    3.617452] Total of 24 processors activated (115205.20 BogoMIPS).
[    3.644588] devtmpfs: initialized
[    3.650431] NET: Registered protocol family 16
[    3.656100] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    3.664561] ACPI: bus type pci registered
[    3.669161] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xa0000000-0xafffffff] (base 0xa0000000)
[    3.679544] PCI: MMCONFIG at [mem 0xa0000000-0xafffffff] reserved in E820
[    3.765496] PCI: Using configuration type 1 for base access
[    3.776432] bio: create slab <bio-0> at 0
[    3.781429] ACPI: Added _OSI(Module Device)
[    3.786092] ACPI: Added _OSI(Processor Device)
[    3.791051] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.796301] ACPI: Added _OSI(Processor Aggregator Device)
[    3.818672] ACPI: EC: Look up EC in DSDT
[    3.819537] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20110623/dsopcode-236)
[    3.830061] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88007e878d80), AE_AML_BUFFER_LIMIT (20110623/psparse-536)
[    3.997261] ACPI: Interpreter enabled
[    4.001350] ACPI: (supports S0 S1 S3 S5)
[    4.005906] ACPI: Using IOAPIC for interrupt routing
[    4.037382] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    4.049869] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fd])
[    4.059288] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    4.059291] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    4.059294] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    4.059297] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000cbfff] (ignored)
[    4.059300] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfedfffff] (ignored)
[    4.059302] pci_root PNP0A08:00: host bridge window [mem 0xb0000000-0xfdffffff] (ignored)
[    4.059351] pci 0000:00:00.0: [8086:3406] type 0 class 0x000600
[    4.059502] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    4.059600] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    4.059641] pci 0000:00:01.0: PME# disabled
[    4.059689] pci 0000:00:02.0: [8086:3409] type 1 class 0x000604
[    4.059787] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    4.059794] pci 0000:00:02.0: PME# disabled
[    4.059840] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    4.059939] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    4.059946] pci 0000:00:03.0: PME# disabled
[    4.059993] pci 0000:00:04.0: [8086:340b] type 1 class 0x000604
[    4.060091] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    4.060097] pci 0000:00:04.0: PME# disabled
[    4.060144] pci 0000:00:05.0: [8086:340c] type 1 class 0x000604
[    4.060243] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    4.060250] pci 0000:00:05.0: PME# disabled
[    4.060297] pci 0000:00:06.0: [8086:340d] type 1 class 0x000604
[    4.060394] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    4.060401] pci 0000:00:06.0: PME# disabled
[    4.060447] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    4.060546] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    4.060553] pci 0000:00:07.0: PME# disabled
[    4.060601] pci 0000:00:08.0: [8086:340f] type 1 class 0x000604
[    4.060698] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    4.060705] pci 0000:00:08.0: PME# disabled
[    4.060751] pci 0000:00:09.0: [8086:3410] type 1 class 0x000604
[    4.060850] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    4.060857] pci 0000:00:09.0: PME# disabled
[    4.060903] pci 0000:00:0a.0: [8086:3411] type 1 class 0x000604
[    4.061001] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    4.061007] pci 0000:00:0a.0: PME# disabled
[    4.061053] pci 0000:00:0d.0: [8086:343a] type 0 class 0x000600
[    4.061166] pci 0000:00:0d.1: [8086:343b] type 0 class 0x000600
[    4.061278] pci 0000:00:0d.2: [8086:343c] type 0 class 0x000600
[    4.061402] pci 0000:00:0d.3: [8086:343d] type 0 class 0x000600
[    4.061519] pci 0000:00:0d.4: [8086:3418] type 0 class 0x000600
[    4.061632] pci 0000:00:0d.5: [8086:3419] type 0 class 0x000600
[    4.061743] pci 0000:00:0d.6: [8086:341a] type 0 class 0x000600
[    4.061855] pci 0000:00:0d.7: [8086:341b] type 0 class 0x000600
[    4.061958] pci 0000:00:0e.0: [8086:341c] type 0 class 0x000600
[    4.062070] pci 0000:00:0e.1: [8086:341d] type 0 class 0x000600
[    4.062182] pci 0000:00:0e.2: [8086:341e] type 0 class 0x000600
[    4.062306] pci 0000:00:0e.3: [8086:341f] type 0 class 0x000600
[    4.062418] pci 0000:00:0e.4: [8086:3439] type 0 class 0x000600
[    4.062528] pci 0000:00:0f.0: [8086:3424] type 0 class 0x001101
[    4.062678] pci 0000:00:10.0: [8086:3425] type 0 class 0x000800
[    4.062813] pci 0000:00:10.1: [8086:3426] type 0 class 0x000800
[    4.062945] pci 0000:00:11.0: [8086:3427] type 0 class 0x000800
[    4.063080] pci 0000:00:11.1: [8086:3428] type 0 class 0x000800
[    4.063215] pci 0000:00:13.0: [8086:342d] type 0 class 0x000800
[    4.063237] pci 0000:00:13.0: reg 10: [mem 0xb1a03000-0xb1a03fff]
[    4.063333] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    4.063340] pci 0000:00:13.0: PME# disabled
[    4.063397] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    4.063534] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    4.063670] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    4.063800] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    4.063922] pci 0000:00:15.0: [8086:342f] type 0 class 0x000800
[    4.064058] pci 0000:00:16.0: [8086:3430] type 0 class 0x000880
[    4.064083] pci 0000:00:16.0: reg 10: [mem 0xfdf1c000-0xfdf1ffff 64bit]
[    4.064220] pci 0000:00:16.1: [8086:3431] type 0 class 0x000880
[    4.064245] pci 0000:00:16.1: reg 10: [mem 0xfdf18000-0xfdf1bfff 64bit]
[    4.064381] pci 0000:00:16.2: [8086:3432] type 0 class 0x000880
[    4.064406] pci 0000:00:16.2: reg 10: [mem 0xfdf14000-0xfdf17fff 64bit]
[    4.064543] pci 0000:00:16.3: [8086:3433] type 0 class 0x000880
[    4.064568] pci 0000:00:16.3: reg 10: [mem 0xfdf10000-0xfdf13fff 64bit]
[    4.064705] pci 0000:00:16.4: [8086:3429] type 0 class 0x000880
[    4.064730] pci 0000:00:16.4: reg 10: [mem 0xfdf0c000-0xfdf0ffff 64bit]
[    4.064867] pci 0000:00:16.5: [8086:342a] type 0 class 0x000880
[    4.064892] pci 0000:00:16.5: reg 10: [mem 0xfdf08000-0xfdf0bfff 64bit]
[    4.065028] pci 0000:00:16.6: [8086:342b] type 0 class 0x000880
[    4.065054] pci 0000:00:16.6: reg 10: [mem 0xfdf04000-0xfdf07fff 64bit]
[    4.065190] pci 0000:00:16.7: [8086:342c] type 0 class 0x000880
[    4.065215] pci 0000:00:16.7: reg 10: [mem 0xfdf00000-0xfdf03fff 64bit]
[    4.065368] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    4.065449] pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
[    4.065541] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
[    4.065621] pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
[    4.065708] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    4.065788] pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
[    4.065891] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    4.065924] pci 0000:00:1a.7: reg 10: [mem 0xb1a02000-0xb1a023ff]
[    4.066048] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    4.066056] pci 0000:00:1a.7: PME# disabled
[    4.066097] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    4.066204] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    4.066212] pci 0000:00:1c.0: PME# disabled
[    4.066265] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    4.066372] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    4.066379] pci 0000:00:1c.4: PME# disabled
[    4.066424] pci 0000:00:1c.5: [8086:3a4a] type 1 class 0x000604
[    4.066530] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    4.066537] pci 0000:00:1c.5: PME# disabled
[    4.066586] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    4.066667] pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
[    4.066754] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    4.066834] pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
[    4.066921] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    4.067001] pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
[    4.067105] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    4.067138] pci 0000:00:1d.7: reg 10: [mem 0xb1a01000-0xb1a013ff]
[    4.067262] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    4.067270] pci 0000:00:1d.7: PME# disabled
[    4.067306] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    4.067420] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    4.067558] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    4.075998] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    4.084446] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 001f)
[    4.092961] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    4.092994] pci 0000:00:1f.2: reg 10: [io  0x2108-0x210f]
[    4.093009] pci 0000:00:1f.2: reg 14: [io  0x2114-0x2117]
[    4.093024] pci 0000:00:1f.2: reg 18: [io  0x2100-0x2107]
[    4.093039] pci 0000:00:1f.2: reg 1c: [io  0x2110-0x2113]
[    4.093054] pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
[    4.093069] pci 0000:00:1f.2: reg 24: [mem 0xb1a00000-0xb1a007ff]
[    4.093130] pci 0000:00:1f.2: PME# supported from D3hot
[    4.093137] pci 0000:00:1f.2: PME# disabled
[    4.093169] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    4.093198] pci 0000:00:1f.3: reg 10: [mem 0xfdf20000-0xfdf200ff 64bit]
[    4.093238] pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
[    4.093412] pci 0000:01:00.0: [8086:10a7] type 0 class 0x000200
[    4.093435] pci 0000:01:00.0: reg 10: [mem 0xb1920000-0xb193ffff]
[    4.093470] pci 0000:01:00.0: reg 18: [io  0x1020-0x103f]
[    4.093487] pci 0000:01:00.0: reg 1c: [mem 0xb1944000-0xb1947fff]
[    4.093582] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    4.093590] pci 0000:01:00.0: PME# disabled
[    4.093651] pci 0000:01:00.1: [8086:10a7] type 0 class 0x000200
[    4.093673] pci 0000:01:00.1: reg 10: [mem 0xb1900000-0xb191ffff]
[    4.093702] pci 0000:01:00.1: reg 18: [io  0x1000-0x101f]
[    4.093718] pci 0000:01:00.1: reg 1c: [mem 0xb1940000-0xb1943fff]
[    4.093813] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    4.093821] pci 0000:01:00.1: PME# disabled
[    4.093861] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    4.099695] pci 0000:00:01.0:   bridge window [io  0x1000-0x1fff]
[    4.099701] pci 0000:00:01.0:   bridge window [mem 0xb1900000-0xb19fffff]
[    4.099787] pci 0000:00:02.0: PCI bridge to [bus 02-02]
[    4.105705] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    4.111628] pci 0000:00:04.0: PCI bridge to [bus 04-04]
[    4.117549] pci 0000:00:05.0: PCI bridge to [bus 05-05]
[    4.123469] pci 0000:00:06.0: PCI bridge to [bus 06-06]
[    4.129387] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    4.135317] pci 0000:00:08.0: PCI bridge to [bus 08-08]
[    4.141242] pci 0000:00:09.0: PCI bridge to [bus 09-09]
[    4.147161] pci 0000:00:0a.0: PCI bridge to [bus 0a-0a]
[    4.153082] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    4.159045] pci 0000:0c:00.0: [102b:0522] type 0 class 0x000300
[    4.159083] pci 0000:0c:00.0: reg 10: [mem 0xb0000000-0xb0ffffff pref]
[    4.159111] pci 0000:0c:00.0: reg 14: [mem 0xb1800000-0xb1803fff]
[    4.159139] pci 0000:0c:00.0: reg 18: [mem 0xb1000000-0xb17fffff]
[    4.159243] pci 0000:0c:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    4.159353] pci 0000:00:1c.4: PCI bridge to [bus 0c-0c]
[    4.165192] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[    4.165202] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    4.165283] pci 0000:00:1c.5: PCI bridge to [bus 0d-0d]
[    4.171260] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    4.179138] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    4.179141] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffffff] (subtractive decode)
[    4.179240] pci_bus 0000:00: on NUMA node 0
[    4.179247] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    4.203034] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP1._PRT]
[    4.203289] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP3._PRT]
[    4.203477] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP5._PRT]
[    4.203664] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP7._PRT]
[    4.203852] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP9._PRT]
[    4.204498] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    4.204743] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    4.205392]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    4.350352] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus fe])
[    4.357078] pci 0000:fe:00.0: [8086:2c70] type 0 class 0x000600
[    4.357149] pci 0000:fe:00.1: [8086:2d81] type 0 class 0x000600
[    4.357227] pci 0000:fe:02.0: [8086:2d90] type 0 class 0x000600
[    4.357292] pci 0000:fe:02.1: [8086:2d91] type 0 class 0x000600
[    4.357357] pci 0000:fe:02.2: [8086:2d92] type 0 class 0x000600
[    4.357422] pci 0000:fe:02.3: [8086:2d93] type 0 class 0x000600
[    4.357486] pci 0000:fe:02.4: [8086:2d94] type 0 class 0x000600
[    4.357551] pci 0000:fe:02.5: [8086:2d95] type 0 class 0x000600
[    4.357622] pci 0000:fe:03.0: [8086:2d98] type 0 class 0x000600
[    4.357687] pci 0000:fe:03.1: [8086:2d99] type 0 class 0x000600
[    4.357751] pci 0000:fe:03.2: [8086:2d9a] type 0 class 0x000600
[    4.357817] pci 0000:fe:03.4: [8086:2d9c] type 0 class 0x000600
[    4.357888] pci 0000:fe:04.0: [8086:2da0] type 0 class 0x000600
[    4.357952] pci 0000:fe:04.1: [8086:2da1] type 0 class 0x000600
[    4.358016] pci 0000:fe:04.2: [8086:2da2] type 0 class 0x000600
[    4.358084] pci 0000:fe:04.3: [8086:2da3] type 0 class 0x000600
[    4.358157] pci 0000:fe:05.0: [8086:2da8] type 0 class 0x000600
[    4.358221] pci 0000:fe:05.1: [8086:2da9] type 0 class 0x000600
[    4.358286] pci 0000:fe:05.2: [8086:2daa] type 0 class 0x000600
[    4.358350] pci 0000:fe:05.3: [8086:2dab] type 0 class 0x000600
[    4.358423] pci 0000:fe:06.0: [8086:2db0] type 0 class 0x000600
[    4.358487] pci 0000:fe:06.1: [8086:2db1] type 0 class 0x000600
[    4.358552] pci 0000:fe:06.2: [8086:2db2] type 0 class 0x000600
[    4.358616] pci 0000:fe:06.3: [8086:2db3] type 0 class 0x000600
[    4.358729] pci_bus 0000:fe: on NUMA node 0
[    4.358735] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
[    4.359278]  pci0000:fe: Unable to request _OSC control (_OSC support mask: 0x19)
[    4.369484] ACPI: PCI Root Bridge [PCI2] (domain 0000 [bus ff])
[    4.376188] pci 0000:ff:00.0: [8086:2c70] type 0 class 0x000600
[    4.376252] pci 0000:ff:00.1: [8086:2d81] type 0 class 0x000600
[    4.376331] pci 0000:ff:02.0: [8086:2d90] type 0 class 0x000600
[    4.376393] pci 0000:ff:02.1: [8086:2d91] type 0 class 0x000600
[    4.376455] pci 0000:ff:02.2: [8086:2d92] type 0 class 0x000600
[    4.376518] pci 0000:ff:02.3: [8086:2d93] type 0 class 0x000600
[    4.376580] pci 0000:ff:02.4: [8086:2d94] type 0 class 0x000600
[    4.376642] pci 0000:ff:02.5: [8086:2d95] type 0 class 0x000600
[    4.376708] pci 0000:ff:03.0: [8086:2d98] type 0 class 0x000600
[    4.376770] pci 0000:ff:03.1: [8086:2d99] type 0 class 0x000600
[    4.376832] pci 0000:ff:03.2: [8086:2d9a] type 0 class 0x000600
[    4.376906] pci 0000:ff:03.4: [8086:2d9c] type 0 class 0x000600
[    4.376974] pci 0000:ff:04.0: [8086:2da0] type 0 class 0x000600
[    4.377062] pci 0000:ff:04.1: [8086:2da1] type 0 class 0x000600
[    4.377138] pci 0000:ff:04.2: [8086:2da2] type 0 class 0x000600
[    4.377203] pci 0000:ff:04.3: [8086:2da3] type 0 class 0x000600
[    4.377273] pci 0000:ff:05.0: [8086:2da8] type 0 class 0x000600
[    4.377335] pci 0000:ff:05.1: [8086:2da9] type 0 class 0x000600
[    4.377397] pci 0000:ff:05.2: [8086:2daa] type 0 class 0x000600
[    4.377459] pci 0000:ff:05.3: [8086:2dab] type 0 class 0x000600
[    4.377529] pci 0000:ff:06.0: [8086:2db0] type 0 class 0x000600
[    4.377591] pci 0000:ff:06.1: [8086:2db1] type 0 class 0x000600
[    4.377653] pci 0000:ff:06.2: [8086:2db2] type 0 class 0x000600
[    4.377715] pci 0000:ff:06.3: [8086:2db3] type 0 class 0x000600
[    4.377824] pci_bus 0000:ff: on NUMA node 0
[    4.377830] ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
[    4.378377]  pci0000:ff: Unable to request _OSC control (_OSC support mask: 0x19)
[    4.388869] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    4.397276] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    4.405681] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    4.414082] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    4.422482] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    4.432165] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    4.440561] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    4.450240] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    4.459223] vgaarb: device added: PCI:0000:0c:00.0,decodes=io+mem,owns=io+mem,locks=none
[    4.468390] vgaarb: loaded
[    4.471412] vgaarb: bridge control possible 0000:0c:00.0
[    4.477850] SCSI subsystem initialized
[    4.482197] libata version 3.00 loaded.
[    4.482319] usbcore: registered new interface driver usbfs
[    4.488499] usbcore: registered new interface driver hub
[    4.494535] usbcore: registered new device driver usb
[    4.500440] PCI: Using ACPI for IRQ routing
[    4.514685] PCI: pci_cache_line_size set to 64 bytes
[    4.515728] reserve RAM buffer: 000000000009d000 - 000000000009ffff 
[    4.515740] reserve RAM buffer: 000000007f4cf000 - 000000007fffffff 
[    4.516703] Switching to clocksource hpet
[    4.574887] pnp: PnP ACPI init
[    4.578341] ACPI: bus type pnp registered
[    4.583935] pnp 00:00: [bus 00-fd]
[    4.583939] pnp 00:00: [io  0x0cf8-0x0cff]
[    4.583945] pnp 00:00: [io  0x0000-0x0cf7 window]
[    4.583947] pnp 00:00: [io  0x0d00-0xffff window]
[    4.583950] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    4.583953] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    4.583955] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    4.583958] pnp 00:00: [mem 0xb0000000-0xfdffffff window]
[    4.583960] pnp 00:00: [mem 0x00000000 window]
[    4.584203] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.584233] pnp 00:01: [mem 0xfec00000-0xfecfffff]
[    4.584327] pnp 00:01: Plug and Play ACPI device, IDs PNP0003 (active)
[    4.585187] pnp 00:02: [io  0x0000-0x000f]
[    4.585190] pnp 00:02: [io  0x0081-0x0083]
[    4.585192] pnp 00:02: [io  0x0087]
[    4.585195] pnp 00:02: [io  0x0089-0x008b]
[    4.585197] pnp 00:02: [io  0x008f]
[    4.585199] pnp 00:02: [io  0x00c0-0x00df]
[    4.585202] pnp 00:02: [dma 4]
[    4.585387] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    4.585414] pnp 00:03: [io  0x0070-0x0071]
[    4.585417] pnp 00:03: [io  0x0074-0x0077]
[    4.585434] pnp 00:03: [irq 8]
[    4.585613] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.585650] pnp 00:04: [io  0x00f0]
[    4.585662] pnp 00:04: [irq 13]
[    4.585847] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    4.585882] pnp 00:05: [io  0x0061]
[    4.586067] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    4.586196] pnp 00:06: [mem 0xfed00000-0xfed003ff]
[    4.586391] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.586420] pnp 00:07: [io  0x0500-0x053f]
[    4.586423] pnp 00:07: [io  0x0400-0x047f]
[    4.586425] pnp 00:07: [io  0x0092]
[    4.586427] pnp 00:07: [io  0x0010-0x001f]
[    4.586429] pnp 00:07: [io  0x0072-0x0073]
[    4.586432] pnp 00:07: [io  0x0080]
[    4.586434] pnp 00:07: [io  0x0084-0x0086]
[    4.586436] pnp 00:07: [io  0x0088]
[    4.586441] pnp 00:07: [io  0x008c-0x008e]
[    4.586444] pnp 00:07: [io  0x0090-0x009f]
[    4.586446] pnp 00:07: [io  0x0800-0x081f]
[    4.586448] pnp 00:07: [io  0x02f8-0x02ff]
[    4.586450] pnp 00:07: [mem 0xfed1c000-0xfed8bffe]
[    4.586453] pnp 00:07: [mem 0xff000000-0xffffffff]
[    4.586455] pnp 00:07: [mem 0xfee00000-0xfeefffff]
[    4.586457] pnp 00:07: [mem 0xfe900000-0xfe90001f]
[    4.586459] pnp 00:07: [mem 0xfea00000-0xfea0001f]
[    4.586462] pnp 00:07: [mem 0xfed1b000-0xfed1bfff]
[    4.587034] system 00:07: [io  0x0500-0x053f] has been reserved
[    4.593648] system 00:07: [io  0x0400-0x047f] has been reserved
[    4.600256] system 00:07: [io  0x0800-0x081f] has been reserved
[    4.606865] system 00:07: [io  0x02f8-0x02ff] has been reserved
[    4.613480] system 00:07: [mem 0xfed1c000-0xfed8bffe] could not be reserved
[    4.621252] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
[    4.629022] system 00:07: [mem 0xfee00000-0xfeefffff] has been reserved
[    4.636396] system 00:07: [mem 0xfe900000-0xfe90001f] has been reserved
[    4.643780] system 00:07: [mem 0xfea00000-0xfea0001f] has been reserved
[    4.651162] system 00:07: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    4.658547] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.658986] pnp 00:08: [io  0xffff-0x10004 disabled]
[    4.658989] pnp 00:08: [io  0xffff]
[    4.658992] pnp 00:08: [irq 0 disabled]
[    4.658994] pnp 00:08: [dma 0 disabled]
[    4.659240] pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
[    4.659574] pnp 00:09: [io  0xffff-0x10006 disabled]
[    4.659576] pnp 00:09: [irq 0 disabled]
[    4.659826] pnp 00:09: Plug and Play ACPI device, IDs PNP0400 (active)
[    4.660287] pnp 00:0a: [io  0xffff-0x10006 disabled]
[    4.660289] pnp 00:0a: [irq 0 disabled]
[    4.660550] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.660800] pnp 00:0b: [bus fe]
[    4.661038] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a03 (active)
[    4.661066] pnp 00:0c: [bus ff]
[    4.661285] pnp 00:0c: Plug and Play ACPI device, IDs PNP0a03 (active)
[    4.661367] pnp: PnP ACPI: found 13 devices
[    4.666044] ACPI: ACPI bus type pnp unregistered
[    4.684798] pci 0000:0c:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    4.694555] PCI: max bus depth: 1 pci_try_num: 2
[    4.694723] pci 0000:00:09.0: BAR 14: assigned [mem 0xb1b00000-0xb1cfffff]
[    4.702399] pci 0000:00:09.0: BAR 15: assigned [mem 0xb1d00000-0xb1efffff 64bit pref]
[    4.711140] pci 0000:00:09.0: BAR 13: assigned [io  0x3000-0x3fff]
[    4.718040] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    4.723873] pci 0000:00:01.0:   bridge window [io  0x1000-0x1fff]
[    4.730670] pci 0000:00:01.0:   bridge window [mem 0xb1900000-0xb19fffff]
[    4.738255] pci 0000:00:02.0: PCI bridge to [bus 02-02]
[    4.744101] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    4.749947] pci 0000:00:04.0: PCI bridge to [bus 04-04]
[    4.755793] pci 0000:00:05.0: PCI bridge to [bus 05-05]
[    4.761639] pci 0000:00:06.0: PCI bridge to [bus 06-06]
[    4.767483] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    4.773329] pci 0000:00:08.0: PCI bridge to [bus 08-08]
[    4.779174] pci 0000:00:09.0: PCI bridge to [bus 09-09]
[    4.785008] pci 0000:00:09.0:   bridge window [io  0x3000-0x3fff]
[    4.791813] pci 0000:00:09.0:   bridge window [mem 0xb1b00000-0xb1cfffff]
[    4.799389] pci 0000:00:09.0:   bridge window [mem 0xb1d00000-0xb1efffff 64bit pref]
[    4.808036] pci 0000:00:0a.0: PCI bridge to [bus 0a-0a]
[    4.813886] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    4.819738] pci 0000:0c:00.0: BAR 6: assigned [mem 0xb1810000-0xb181ffff pref]
[    4.827798] pci 0000:00:1c.4: PCI bridge to [bus 0c-0c]
[    4.833636] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[    4.841214] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    4.849860] pci 0000:00:1c.5: PCI bridge to [bus 0d-0d]
[    4.855708] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    4.861584] pci 0000:00:01.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    4.869059] pci 0000:00:01.0: setting latency timer to 64
[    4.869083] pci 0000:00:02.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
[    4.876565] pci 0000:00:02.0: setting latency timer to 64
[    4.876589] pci 0000:00:03.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[    4.884071] pci 0000:00:03.0: setting latency timer to 64
[    4.884098] pci 0000:00:04.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
[    4.891578] pci 0000:00:04.0: setting latency timer to 64
[    4.891602] pci 0000:00:05.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    4.899084] pci 0000:00:05.0: setting latency timer to 64
[    4.899112] pci 0000:00:06.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
[    4.906593] pci 0000:00:06.0: setting latency timer to 64
[    4.906618] pci 0000:00:07.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    4.914100] pci 0000:00:07.0: setting latency timer to 64
[    4.914125] pci 0000:00:08.0: PCI INT A -> GSI 31 (level, low) -> IRQ 31
[    4.921607] pci 0000:00:08.0: setting latency timer to 64
[    4.921631] pci 0000:00:09.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    4.929113] pci 0000:00:09.0: setting latency timer to 64
[    4.929137] pci 0000:00:0a.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
[    4.936620] pci 0000:00:0a.0: setting latency timer to 64
[    4.936645] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.944131] pci 0000:00:1c.0: setting latency timer to 64
[    4.944143] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.951624] pci 0000:00:1c.4: setting latency timer to 64
[    4.951648] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.959131] pci 0000:00:1c.5: setting latency timer to 64
[    4.959144] pci 0000:00:1e.0: setting latency timer to 64
[    4.959150] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    4.959152] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffff]
[    4.959155] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    4.959157] pci_bus 0000:01: resource 1 [mem 0xb1900000-0xb19fffff]
[    4.959160] pci_bus 0000:09: resource 0 [io  0x3000-0x3fff]
[    4.959162] pci_bus 0000:09: resource 1 [mem 0xb1b00000-0xb1cfffff]
[    4.959165] pci_bus 0000:09: resource 2 [mem 0xb1d00000-0xb1efffff 64bit pref]
[    4.959168] pci_bus 0000:0c: resource 1 [mem 0xb1000000-0xb18fffff]
[    4.959171] pci_bus 0000:0c: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
[    4.959174] pci_bus 0000:0e: resource 4 [io  0x0000-0xffff]
[    4.959176] pci_bus 0000:0e: resource 5 [mem 0x00000000-0xffffffffff]
[    4.959178] pci_bus 0000:fe: resource 0 [io  0x0000-0xffff]
[    4.959181] pci_bus 0000:fe: resource 1 [mem 0x00000000-0xffffffffff]
[    4.959184] pci_bus 0000:ff: resource 0 [io  0x0000-0xffff]
[    4.959186] pci_bus 0000:ff: resource 1 [mem 0x00000000-0xffffffffff]
[    4.959595] NET: Registered protocol family 2
[    4.964732] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    4.973690] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    4.983794] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[    4.994904] TCP: Hash tables configured (established 262144 bind 32768)
[    5.002312] TCP reno registered
[    5.005840] UDP hash table entries: 1024 (order: 5, 196608 bytes)
[    5.012922] UDP-Lite hash table entries: 1024 (order: 5, 196608 bytes)
[    5.021142] NET: Registered protocol family 1
[    5.026620] RPC: Registered named UNIX socket transport module.
[    5.033235] RPC: Registered udp transport module.
[    5.038488] RPC: Registered tcp transport module.
[    5.043738] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.051644] pci 0000:01:00.0: Disabling L0s
[    5.056325] pci 0000:01:00.1: Disabling L0s
[    5.060999] pci 0000:0c:00.0: Boot video device
[    5.061235] PCI: CLS 64 bytes, default 64
[    5.073225] microcode: CPU0 sig=0x206c2, pf=0x1, revision=0x5
[    5.079653] microcode: CPU1 sig=0x206c2, pf=0x1, revision=0x5
[    5.086074] microcode: CPU2 sig=0x206c2, pf=0x1, revision=0x5
[    5.092497] microcode: CPU3 sig=0x206c2, pf=0x1, revision=0x5
[    5.098931] microcode: CPU4 sig=0x206c2, pf=0x1, revision=0x5
[    5.105353] microcode: CPU5 sig=0x206c2, pf=0x1, revision=0x5
[    5.111764] microcode: CPU6 sig=0x206c2, pf=0x1, revision=0x5
[    5.118214] microcode: CPU7 sig=0x206c2, pf=0x1, revision=0x5
[    5.124635] microcode: CPU8 sig=0x206c2, pf=0x1, revision=0x5
[    5.131058] microcode: CPU9 sig=0x206c2, pf=0x1, revision=0x5
[    5.137480] microcode: CPU10 sig=0x206c2, pf=0x1, revision=0x5
[    5.143997] microcode: CPU11 sig=0x206c2, pf=0x1, revision=0x5
[    5.150508] microcode: CPU12 sig=0x206c2, pf=0x1, revision=0x5
[    5.157041] microcode: CPU13 sig=0x206c2, pf=0x1, revision=0x5
[    5.163561] microcode: CPU14 sig=0x206c2, pf=0x1, revision=0x5
[    5.170081] microcode: CPU15 sig=0x206c2, pf=0x1, revision=0x5
[    5.176597] microcode: CPU16 sig=0x206c2, pf=0x1, revision=0x5
[    5.183115] microcode: CPU17 sig=0x206c2, pf=0x1, revision=0x5
[    5.189622] microcode: CPU18 sig=0x206c2, pf=0x1, revision=0x5
[    5.196141] microcode: CPU19 sig=0x206c2, pf=0x1, revision=0x5
[    5.202658] microcode: CPU20 sig=0x206c2, pf=0x1, revision=0x5
[    5.209175] microcode: CPU21 sig=0x206c2, pf=0x1, revision=0x5
[    5.215691] microcode: CPU22 sig=0x206c2, pf=0x1, revision=0x5
[    5.222209] microcode: CPU23 sig=0x206c2, pf=0x1, revision=0x5
[    5.228839] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.239198] audit: initializing netlink socket (disabled)
[    5.245283] type=2000 audit(1320693245.492:1): initialized
[    5.259253] VFS: Disk quotas dquot_6.5.2
[    5.263773] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.274222] Btrfs loaded
[    5.277070] msgmni has been set to 3876
[    5.282584] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    5.290863] io scheduler noop registered
[    5.295246] io scheduler deadline registered
[    5.300181] io scheduler cfq registered (default)
[    5.305437] start plist test
[    5.309514] end plist test
[    5.314451] pcieport 0000:00:1c.0: setting latency timer to 64
[    5.314595] pcieport 0000:00:1c.0: irq 64 for MSI/MSI-X
[    5.314732] pcieport 0000:00:1c.4: setting latency timer to 64
[    5.314814] pcieport 0000:00:1c.4: irq 65 for MSI/MSI-X
[    5.314939] pcieport 0000:00:1c.5: setting latency timer to 64
[    5.315017] pcieport 0000:00:1c.5: irq 66 for MSI/MSI-X
[    5.315358] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.321776] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.329163] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    5.337799] acpiphp: Slot [2] registered
[    5.403343] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    5.431040] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.500115] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.547951] serial 00:0a: disabled
[    5.557806] brd: module loaded
[    5.561564] ahci 0000:00:1f.2: version 3.0
[    5.561612] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.569285] ahci 0000:00:1f.2: irq 67 for MSI/MSI-X
[    5.569479] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    5.578609] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    5.587465] ahci 0000:00:1f.2: setting latency timer to 64
[    5.629366] scsi0 : ahci
[    5.632770] scsi1 : ahci
[    5.635846] scsi2 : ahci
[    5.638886] scsi3 : ahci
[    5.641959] scsi4 : ahci
[    5.645032] scsi5 : ahci
[    5.648680] ata1: SATA max UDMA/133 abar m2048@0xb1a00000 port 0xb1a00100 irq 67
[    5.656939] ata2: SATA max UDMA/133 abar m2048@0xb1a00000 port 0xb1a00180 irq 67
[    5.665194] ata3: SATA max UDMA/133 abar m2048@0xb1a00000 port 0xb1a00200 irq 67
[    5.673445] ata4: SATA max UDMA/133 abar m2048@0xb1a00000 port 0xb1a00280 irq 67
[    5.681699] ata5: SATA max UDMA/133 abar m2048@0xb1a00000 port 0xb1a00300 irq 67
[    5.689952] ata6: SATA max UDMA/133 abar m2048@0xb1a00000 port 0xb1a00380 irq 67
[    5.698719] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    5.705232] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.711996] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[    5.719381] Copyright (c) 2007-2011 Intel Corporation.
[    5.725205] igb 0000:01:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    5.732696] igb 0000:01:00.0: setting latency timer to 64
[    5.733058] igb 0000:01:00.0: irq 68 for MSI/MSI-X
[    5.733074] igb 0000:01:00.0: irq 69 for MSI/MSI-X
[    5.733090] igb 0000:01:00.0: irq 70 for MSI/MSI-X
[    5.733110] igb 0000:01:00.0: irq 71 for MSI/MSI-X
[    5.733126] igb 0000:01:00.0: irq 72 for MSI/MSI-X
[    5.733142] igb 0000:01:00.0: irq 73 for MSI/MSI-X
[    5.733158] igb 0000:01:00.0: irq 74 for MSI/MSI-X
[    5.733174] igb 0000:01:00.0: irq 75 for MSI/MSI-X
[    5.733190] igb 0000:01:00.0: irq 76 for MSI/MSI-X
[    5.939644] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[    5.947324] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:13:20:f7:89:b4
[    5.955362] igb 0000:01:00.0: eth0: PBA No: 1010FF-0FF
[    5.961097] igb 0000:01:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    5.969590] igb 0000:01:00.1: PCI INT B -> GSI 40 (level, low) -> IRQ 40
[    5.977081] igb 0000:01:00.1: setting latency timer to 64
[    5.977453] igb 0000:01:00.1: irq 77 for MSI/MSI-X
[    5.977469] igb 0000:01:00.1: irq 78 for MSI/MSI-X
[    5.977485] igb 0000:01:00.1: irq 79 for MSI/MSI-X
[    5.977501] igb 0000:01:00.1: irq 80 for MSI/MSI-X
[    5.977517] igb 0000:01:00.1: irq 81 for MSI/MSI-X
[    5.977534] igb 0000:01:00.1: irq 82 for MSI/MSI-X
[    5.977550] igb 0000:01:00.1: irq 83 for MSI/MSI-X
[    5.977569] igb 0000:01:00.1: irq 84 for MSI/MSI-X
[    5.977585] igb 0000:01:00.1: irq 85 for MSI/MSI-X
[    6.014842] ata2: SATA link down (SStatus 0 SControl 300)
[    6.020914] ata3: SATA link down (SStatus 0 SControl 300)
[    6.026978] ata4: SATA link down (SStatus 0 SControl 300)
[    6.033044] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.039983] ata5: SATA link down (SStatus 0 SControl 300)
[    6.046050] ata6: SATA link down (SStatus 0 SControl 300)
[    6.052314] ata1.00: ATA-6: WDC WD800JD-75HKA1, 14.03G14, max UDMA/133
[    6.058834] Refined TSC clocksource calibration: 2400.085 MHz.
[    6.058903] Switching to clocksource tsc
[    6.070525] ata1.00: 156250000 sectors, multi 0: LBA 
[    6.077179] ata1.00: configured for UDMA/133
[    6.082888] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JD-75HK 14.0 PQ: 0 ANSI: 5
[    6.093100] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    6.093263] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.107745] sd 0:0:0:0: [sda] Write Protect is off
[    6.113096] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.113170] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.150080]  sda: sda1 sda2 sda3
[    6.155336] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.179141] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[    6.186818] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:13:20:f7:89:b5
[    6.194859] igb 0000:01:00.1: eth1: PBA No: 1010FF-0FF
[    6.200599] igb 0000:01:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    6.209148] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.216539] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.224523] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.224528] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.230940] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.239259] ehci_hcd 0000:00:1a.7: debug port 1
[    6.248209] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    6.248262] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xb1a02000
[    6.270446] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.277849] hub 1-0:1.0: USB hub found
[    6.282112] hub 1-0:1.0: 6 ports detected
[    6.287805] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.295792] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.295797] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.301655] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.309965] ehci_hcd 0000:00:1d.7: debug port 1
[    6.318896] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.318945] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xb1a01000
[    6.338327] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.345217] hub 2-0:1.0: USB hub found
[    6.349428] hub 2-0:1.0: 6 ports detected
[    6.354698] uhci_hcd: USB Universal Host Controller Interface driver
[    6.361943] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.369919] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.369924] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.375794] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.384118] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    6.391285] hub 3-0:1.0: USB hub found
[    6.395500] hub 3-0:1.0: 2 ports detected
[    6.400685] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.408659] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.408664] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.414523] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.422848] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    6.429778] hub 4-0:1.0: USB hub found
[    6.433987] hub 4-0:1.0: 2 ports detected
[    6.439151] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    6.447128] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.447133] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.453136] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.461458] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    6.468344] hub 5-0:1.0: USB hub found
[    6.472552] hub 5-0:1.0: 2 ports detected
[    6.477711] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.485689] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.485694] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.491558] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.499899] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    6.506815] hub 6-0:1.0: USB hub found
[    6.511028] hub 6-0:1.0: 2 ports detected
[    6.516174] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.524215] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.524220] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.530078] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.538417] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    6.545310] hub 7-0:1.0: USB hub found
[    6.549517] hub 7-0:1.0: 2 ports detected
[    6.554818] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.562899] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.562905] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.568837] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.577128] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    6.584041] hub 8-0:1.0: USB hub found
[    6.588249] hub 8-0:1.0: 2 ports detected
[    6.593582] Initializing USB Mass Storage driver...
[    6.599100] usbcore: registered new interface driver usb-storage
[    6.605805] USB Mass Storage support registered.
[    6.611118] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    6.619560] i8042: No controller found
[    6.624075] mousedev: PS/2 mouse device common for all mice
[    6.630560] rtc_cmos 00:03: RTC can wake from S4
[    6.636131] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    6.642981] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.650603] md: linear personality registered for level -1
[    6.656726] md: raid0 personality registered for level 0
[    6.662658] md: raid1 personality registered for level 1
[    6.668587] md: raid10 personality registered for level 10
[    6.674711] md: multipath personality registered for level -4
[    6.681122] md: faulty personality registered for level -5
[    6.687830] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    6.697712] cpuidle: using governor ladder
[    6.702302] cpuidle: using governor menu
[    6.706824] usbcore: registered new interface driver usbhid
[    6.713047] usbhid: USB HID core driver
[    6.717654] TCP cubic registered
[    6.721265] NET: Registered protocol family 17

--LQksG6bCIzRHxTLp--
