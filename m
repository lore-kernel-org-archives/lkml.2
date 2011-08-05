Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1HEKcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:32:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43001 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab1HEKcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:32:47 -0400
Subject: Re: [PATCH] Remove CLOCK_TICK_RATE from acpi_pm clocksource driver
From: John Stultz <john.stultz@linaro.org>
To: dsaxena@plexity.net
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, patches@linaro.org
In-Reply-To: <20110804000830.GD23503@plexity.net>
References: <20110804000830.GD23503@plexity.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Aug 2011 03:32:37 -0700
Message-ID: <1312540357.2764.49.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 17:08 -0700, Deepak Saxena wrote:
> The acpi_pm clocksource driver uses CLOCK_TICK_RATE which is
> defined as PIT_TICK_RATE on x86. This patch cleans it up to
> just use the later so that CLOCK_TICK_RATE can be depecrated.
> 
> Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
> ---
>  drivers/clocksource/acpi_pm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
> index effe797..6b5cf02 100644
> --- a/drivers/clocksource/acpi_pm.c
> +++ b/drivers/clocksource/acpi_pm.c
> @@ -143,7 +143,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
>  #ifndef CONFIG_X86_64
>  #include <asm/mach_timer.h>
>  #define PMTMR_EXPECTED_RATE \
> -  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
> +  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (PIT_TICK_RATE>>10))
>  /*
>   * Some boards have the PMTMR running way too fast. We check
>   * the PMTMR rate against PIT channel 2 to catch these cases.

I suspect the PMTMR_EXPECTED_RATE is not so sensitive that it actually
needs to use CLOCK_TICK_RATE or PIT_TICK_RATE here. 

Instead we probably should rework mach_countup() to return how long it
ran for (in nsecs), since the acpi_pm code really shouldn't need to know
PIT_TICK_RATE details at all.

That said, mach_countup is pretty old and crusty code that is important
to TSC and loop-per-jiffy calibration. So I'm not sure if there's much
gain to digging in and mucking with things there. 

So for now, the PIT_TICK_RATE change seems like a fair change.

Acked-by: John Stultz <john.stultz@linaro.org>

