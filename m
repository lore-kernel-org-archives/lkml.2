Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0DFVpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:45:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59197 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0DFVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EvEUa1Y7zbc2diiIEAhpuwgD3FttA3oG1IeIv70t5CBisGK+6qvLXg4U2ucd2EXAEm
         mXw4NlJSvESeJ7x16nwyjbQyIHBYxuAN1UPHzjZTKvxfrRCZ9TWKMlyc+YtHKRZOvDPW
         CCFAVOUtyA2zkJPOef7D/kES6cFYhMG4PokV0=
MIME-Version: 1.0
In-Reply-To: <20100303213341.GA654@alarsen.net>
References: <20100303213341.GA654@alarsen.net>
Date: Tue, 6 Apr 2010 23:45:42 +0200
Message-ID: <x2qcd73a99e1004061445j8698c478z9f021d5f3dd8f81b@mail.gmail.com>
Subject: Re: [PATCH 2/2] AT91 slow-clock resume: don't restore the PLL 
	settings when the PLL was off
From: Andrew Victor <avictor.za@gmail.com>
To: Anders Larsen <al@alarsen.net>, julien.langer@gmail.com
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Anders,

> From: Julien Langer <julien.langer@gmail.com>
>
> AT91: Don't try to restore the PLL settings on resume when the PLLs were turned
> off before suspending.
>
> We run into this problem with the PLLB on the at91: ohci-at91 disables the PLLB
> when going to suspend. The slowclock code however tries to do the same: It
> saves the PLLB register value and when restoring the value during resume it
> waits for the PLLB to lock again. However the PLL will never lock and the loop
> would run into its timeout because the slowclock code just stored and restored
> an empty register.
> Fix the problem by only restoring PLLA/PLLB when the registers were != 0.
>
> Signed-off-by: Julien Langer <julien.langer@gmail.com>
> Signed-off-by: Anders Larsen <al@alarsen.net>
> Cc: Andrew Victor <avictor.za@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>

> @@ -199,16 +207,22 @@ ENTRY(at91_slow_clock)
>
>        /* Restore PLLB setting */
>        ldr     r3, .saved_pllbr
> +       cmp r3, #0
> +       beq 5f
>        str     r3, [r1, #(AT91_CKGR_PLLBR - AT91_PMC)]
>
>        wait_pllblock
>
> +5:
>        /* Restore PLLA setting */
>        ldr     r3, .saved_pllar
> +       cmp r3, #0
> +       beq 6f
>        str     r3, [r1, #(AT91_CKGR_PLLAR - AT91_PMC)]
>
>        wait_pllalock
>
> +6:

I don't think it's sufficient skip the "wait for lock" if the
PLLA/PLLB value is 0.
For example, since bit 29 of PLLA is always 1, the wait_pllalock will
always run - even if MULA is 0 (which means the PLLA is disabled) and
will therefore never lock.
Similarly, for other bits in the register which might happen to be set.

The code should rather be something like:
  Save PLLA
  Save PLLB
  ... wait for interrupt ....
  Restore PLLB
  if (PLLB & AT91_PMC_MUL != 0)
      Wait for PLLB to lock
  Restore PLLA
  if (PLLA & AT91_PMC_MUL != 0)
      Wait for PLLA to lock


Regards,
  Andrew Victor
