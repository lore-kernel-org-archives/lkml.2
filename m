Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1G1Pbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:31:33 -0400
Received: from relay.parallels.com ([195.214.232.42]:38276 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1G1Pbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:31:31 -0400
Message-ID: <4E3180C9.4000601@openvz.org>
Date: Thu, 28 Jul 2011 19:31:21 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>
Subject: [stable-longterm] x86: HPET: Chose a paranoid safe value for the
 ETIME check
References: <alpine.LFD.2.00.1012131222420.2653@localhost6.localdomain6> <tip-f1c18071ad70e2a78ab31fc26a18fcfa954a05c6@git.kernel.org>
In-Reply-To: <tip-f1c18071ad70e2a78ab31fc26a18fcfa954a05c6@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this v2.6.37-rc5-64-gf1c1807 and v2.6.36-rc4-167-g995bd3b should be merged into longterm/stable kernels.
We also found the same bug in RHEL6 kernel. (nohz kernel stuck and wait for HPET wraparound)
This HPET-bug really annoying, while fix is tiny.

tip-bot for Thomas Gleixner wrote:
> Commit-ID:  f1c18071ad70e2a78ab31fc26a18fcfa954a05c6
> Gitweb:     http://git.kernel.org/tip/f1c18071ad70e2a78ab31fc26a18fcfa954a05c6
> Author:     Thomas Gleixner<tglx@linutronix.de>
> AuthorDate: Mon, 13 Dec 2010 12:43:23 +0100
> Committer:  Thomas Gleixner<tglx@linutronix.de>
> CommitDate: Mon, 13 Dec 2010 13:42:44 +0100
>
> x86: HPET: Chose a paranoid safe value for the ETIME check
>
> commit 995bd3bb5 (x86: Hpet: Avoid the comparator readback penalty)
> chose 8 HPET cycles as a safe value for the ETIME check, as we had the
> confirmation that the posted write to the comparator register is
> delayed by two HPET clock cycles on Intel chipsets which showed
> readback problems.
>
> After that patch hit mainline we got reports from machines with newer
> AMD chipsets which seem to have an even longer delay. See
> http://thread.gmane.org/gmane.linux.kernel/1054283 and
> http://thread.gmane.org/gmane.linux.kernel/1069458 for further
> information.
>
> Boris tried to come up with an ACPI based selection of the minimum
> HPET cycles, but this failed on a couple of test machines. And of
> course we did not get any useful information from the hardware folks.
>
> For now our only option is to chose a paranoid high and safe value for
> the minimum HPET cycles used by the ETIME check. Adjust the minimum ns
> value for the HPET clockevent accordingly.
>
> Reported-Bistected-and-Tested-by: Markus Trippelsdorf<markus@trippelsdorf.de>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> LKML-Reference:<alpine.LFD.2.00.1012131222420.2653@localhost6.localdomain6>
> Cc: Simon Kirby<sim@hostway.ca>
> Cc: Borislav Petkov<bp@alien8.de>
> Cc: Andreas Herrmann<Andreas.Herrmann3@amd.com>
> Cc: John Stultz<johnstul@us.ibm.com>
> ---
>   arch/x86/kernel/hpet.c |   26 ++++++++++++++++----------
>   1 files changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index ae03cab..4ff5968 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -27,6 +27,9 @@
>   #define HPET_DEV_FSB_CAP		0x1000
>   #define HPET_DEV_PERI_CAP		0x2000
>
> +#define HPET_MIN_CYCLES			128
> +#define HPET_MIN_PROG_DELTA		(HPET_MIN_CYCLES + (HPET_MIN_CYCLES>>  1))
> +
>   #define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
>
>   /*
> @@ -299,8 +302,9 @@ static void hpet_legacy_clockevent_register(void)
>   	/* Calculate the min / max delta */
>   	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
>   							&hpet_clockevent);
> -	/* 5 usec minimum reprogramming delta. */
> -	hpet_clockevent.min_delta_ns = 5000;
> +	/* Setup minimum reprogramming delta. */
> +	hpet_clockevent.min_delta_ns = clockevent_delta2ns(HPET_MIN_PROG_DELTA,
> +							&hpet_clockevent);
>
>   	/*
>   	 * Start hpet with the boot cpu mask and make it
> @@ -393,22 +397,24 @@ static int hpet_next_event(unsigned long delta,
>   	 * the wraparound into account) nor a simple count down event
>   	 * mode. Further the write to the comparator register is
>   	 * delayed internally up to two HPET clock cycles in certain
> -	 * chipsets (ATI, ICH9,10). We worked around that by reading
> -	 * back the compare register, but that required another
> -	 * workaround for ICH9,10 chips where the first readout after
> -	 * write can return the old stale value. We already have a
> -	 * minimum delta of 5us enforced, but a NMI or SMI hitting
> +	 * chipsets (ATI, ICH9,10). Some newer AMD chipsets have even
> +	 * longer delays. We worked around that by reading back the
> +	 * compare register, but that required another workaround for
> +	 * ICH9,10 chips where the first readout after write can
> +	 * return the old stale value. We already had a minimum
> +	 * programming delta of 5us enforced, but a NMI or SMI hitting
>   	 * between the counter readout and the comparator write can
>   	 * move us behind that point easily. Now instead of reading
>   	 * the compare register back several times, we make the ETIME
>   	 * decision based on the following: Return ETIME if the
> -	 * counter value after the write is less than 8 HPET cycles
> +	 * counter value after the write is less than HPET_MIN_CYCLES
>   	 * away from the event or if the counter is already ahead of
> -	 * the event.
> +	 * the event. The minimum programming delta for the generic
> +	 * clockevents code is set to 1.5 * HPET_MIN_CYCLES.
>   	 */
>   	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
>
> -	return res<  8 ? -ETIME : 0;
> +	return res<  HPET_MIN_CYCLES ? -ETIME : 0;
>   }
>
>   static void hpet_legacy_set_mode(enum clock_event_mode mode,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

