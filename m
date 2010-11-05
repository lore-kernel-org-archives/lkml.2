Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0KEQmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:42:35 -0400
Received: from smtp-out-084.synserver.de ([212.40.180.84]:1055 "HELO
	smtp-out-086.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752901Ab0KEQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:42:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 23285
Date: Fri, 5 Nov 2010 17:42:25 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101105164225.GA1594@arch.trippelsdorf.de>
References: <20101029081831.GA7149@liondog.tnic>
 <20101029083013.GA1553@arch.trippelsdorf.de>
 <20101029102713.GA21125@aftab>
 <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6>
 <20101029170040.GJ21125@aftab>
 <20101029172631.GA23546@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6>
 <20101101184512.GA1589@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6>
 <20101105160919.GC25704@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105160919.GC25704@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 05:09:19PM +0100, Borislav Petkov wrote:
> On Tue, Nov 02, 2010 at 11:26:54AM -0400, Thomas Gleixner wrote:
> > Ok, I'm waiting for Boris to get us the confirmation from HW folks.
> 
> Ok, I don't have much but it could be something. We could use the
> minimum tick u16 value in the ACPI HPET table, offset 53:
> 
> Main Counter Minimum   2 53 Unit: Clock tick
> Clock_tick in Periodic      The minimum clock ticks can be set without lost
> Mode                        interrupts while the counter is programmed to operate in
> *Note#3                     periodic mode
> 
> ...
> 
> * Note #3: This field is written by BIOS and may be chipset and/or
> platform dependent. This indicates the minimum value that must be used
> for any counter programmed in periodic mode to avoid lost interrupts.
> For any counter x that has been configured for periodic mode, the number
> can be programmed in any Tx_Compare Register must be greater than P,
> where P = (Minimum Period) / (Main counter period) in order to avoid
> lost interrupts.
> 
> However, we don't know (yet) whether this can be used in the
> non-periodic mode too. My gut feeling says yes but I wouldn't trust it.
> 
> We went and collected that value a bunch of systems and it looks like it
> would need more massaging (read: capping) since some BIOSen simply write
> crap in it. It ranges from
> 
> - 0x37ee on old nVidia and Intel boards (this is definitely crap, I
> can't imagine a minimum ticks value of 14318 for a HPET but who knows)
> 
> - 0x1000 on a HP machine (also fishy)
> 
> - 0x10, 0x14 on current SBxxx boards
> 
> - 0x80 on newer Intel boards

"min tick: 20" on my machine. Given that 12 is running stable here, maybe
the value is a bit too large?

> and it looks like 0x80 is also the default value which we can use as a
> capping value. Btw, I've been running the following on the machine in
> question for a while now and no lockups so far.
> 
> Opinions?
> 
> ---
>  arch/x86/include/asm/hpet.h |    1 +
>  arch/x86/kernel/acpi/boot.c |   12 +++++++++---
>  arch/x86/kernel/hpet.c      |    3 ++-
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
> index 2c392d6..01d9480 100644
> --- a/arch/x86/include/asm/hpet.h
> +++ b/arch/x86/include/asm/hpet.h
> @@ -68,6 +68,7 @@ extern unsigned long force_hpet_address;
>  extern u8 hpet_blockid;
>  extern int hpet_force_user;
>  extern u8 hpet_msi_disable;
> +extern u16 hpet_min_tick;
>  extern int is_hpet_enabled(void);
>  extern int hpet_enable(void);
>  extern void hpet_disable(void);
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 71232b9..37b93e8 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -772,9 +772,6 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
>  		hpet_address >>= 32;
>  	}
>  #endif
> -	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx\n",
> -	       hpet_tbl->id, hpet_address);
> -
>  	/*
>  	 * Allocate and initialize the HPET firmware resource for adding into
>  	 * the resource tree during the lateinit timeframe.
> @@ -790,6 +787,15 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
>  	hpet_res->start = hpet_address;
>  	hpet_res->end = hpet_address + (1 * 1024) - 1;
>  
> +	hpet_min_tick = hpet_tbl->minimum_tick;
> +	if (hpet_min_tick > 0x80) {
> +		printk(KERN_WARNING PREFIX "Limiting HPET read delay to 0x80.\n");
> +		hpet_min_tick = 0x80;
> +	}
> +
> +	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx min tick: %d\n",
> +		hpet_tbl->id, hpet_address, hpet_min_tick);
> +
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index e49c3b9..a0b790a 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -40,6 +40,7 @@ u8					hpet_msi_disable;
>  static unsigned long			hpet_num_timers;
>  #endif
>  static void __iomem			*hpet_virt_address;
> +u16					hpet_min_tick = 0x80;

Wouldn't:

+u16                                  hpet_min_tick;

make more sense, if you want to use the value detected in boot.c?

>  struct hpet_dev {
>  	struct clock_event_device	evt;
> @@ -408,7 +409,7 @@ static int hpet_next_event(unsigned long delta,
>  	 */
>  	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
>  
> -	return res < 8 ? -ETIME : 0;
> +	return res < hpet_min_tick ? -ETIME : 0;
>  }
>  
>  static void hpet_legacy_set_mode(enum clock_event_mode mode,

-- 
Markus
