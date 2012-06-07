Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264Ab2FGSOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:14:01 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3690 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757032Ab2FGSN7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:13:59 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432Izz1202hzzz2dh668h839h93fhd25hf0ah)
X-WSS-ID: 0M59EN5-01-7L5-02
X-M-MSG: 
Date: Thu, 7 Jun 2012 20:14:14 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 5/5] x86: mce: Add cmci poll mode
Message-ID: <20120607181414.GH16941@aftab.osrc.amd.com>
References: <20120606214941.104735929@linutronix.de>
 <20120606215116.757323156@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20120606215116.757323156@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 09:53:24PM +0000, Thomas Gleixner wrote:

[ … ]

> Index: tip/arch/x86/kernel/cpu/mcheck/mce_intel.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ tip/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -15,6 +15,8 @@
>  #include <asm/msr.h>
>  #include <asm/mce.h>
>  
> +#include "mce-internal.h"
> +
>  /*
>   * Support for Intel Correct Machine Check Interrupts. This allows
>   * the CPU to raise an interrupt when a corrected machine check happened.
> @@ -30,7 +32,22 @@ static DEFINE_PER_CPU(mce_banks_t, mce_b
>   */
>  static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
>  
> -#define CMCI_THRESHOLD 1
> +#define CMCI_THRESHOLD		1
> +#define CMCI_POLL_INTERVAL	(30 * HZ)
> +#define CMCI_STORM_INTERVAL	(1 * HZ)
> +#define CMCI_STORM_TRESHOLD	5

Just a spelling correction:

	CMCI_STORM_THRESHOLD

> +
> +static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
> +static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
> +static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
> +
> +enum {
> +	CMCI_STORM_NONE,
> +	CMCI_STORM_ACTIVE,
> +	CMCI_STORM_SUBSIDED,
> +};
> +
> +static atomic_t cmci_storm_on_cpus;
>  
>  static int cmci_supported(int *banks)
>  {
> @@ -53,6 +70,73 @@ static int cmci_supported(int *banks)
>  	return !!(cap & MCG_CMCI_P);
>  }
>  
> +void mce_intel_cmci_poll(void)
> +{
> +	if (__this_cpu_read(cmci_storm_state) == CMCI_STORM_NONE)
> +		return;
> +	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
> +}
> +
> +unsigned long mce_intel_adjust_timer(unsigned long interval)
> +{
> +	if (interval < CMCI_POLL_INTERVAL)
> +		return interval;
> +
> +	switch (__this_cpu_read(cmci_storm_state)) {
> +	case CMCI_STORM_ACTIVE:
> +		/*
> +		 * We switch back to interrupt mode once the poll timer has
> +		 * silenced itself. That means no events recorded and the
> +		 * timer interval is back to our poll interval.
> +		 */
> +		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
> +		atomic_dec(&cmci_storm_on_cpus);
> +
> +	case CMCI_STORM_SUBSIDED:
> +		/*
> +		 * We wait for all cpus to go back to SUBSIDED
> +		 * state. When that happens we switch back to
> +		 * interrupt mode.
> +		 */
> +		if (!atomic_read(&cmci_storm_on_cpus)) {
> +			__this_cpu_write(cmci_storm_state, CMCI_STORM_NONE);
> +			cmci_reenable();
> +			cmci_recheck();
> +		}
> +		return CMCI_POLL_INTERVAL;
> +	default:
> +		/*
> +		 * We have shiny wheather, let the poll do whatever it
> +		 * thinks.
> +		 */
> +		return interval;
> +	}
> +}
> +
> +static bool cmci_storm_detect(void)
> +{
> +	unsigned int cnt = __this_cpu_read(cmci_storm_cnt);
> +	unsigned long ts = __this_cpu_read(cmci_time_stamp);
> +	unsigned long now = jiffies;
> +
> +	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) {
> +		cnt++;
> +	} else {
> +		cnt = 1;
> +		__this_cpu_write(cmci_time_stamp, now);
> +	}
> +	__this_cpu_write(cmci_storm_cnt, cnt);
> +
> +	if (cnt <= CMCI_STORM_TRESHOLD)

and here too.

> +		return false;
> +
> +	cmci_clear();
> +	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
> +	atomic_inc(&cmci_storm_on_cpus);
> +	mce_timer_kick(CMCI_POLL_INTERVAL);
> +	return true;
> +}
> +
>  /*
>   * The interrupt handler. This is called on every event.
>   * Just call the poller directly to log any events.
> @@ -61,6 +145,8 @@ static int cmci_supported(int *banks)
>   */
>  static void intel_threshold_interrupt(void)
>  {
> +	if (cmci_storm_detect())
> +		return;
>  	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
>  	mce_notify_irq();
>  }
> 
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

