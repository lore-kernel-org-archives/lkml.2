Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab1D0SiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:38:10 -0400
Received: from mx3.wp.pl ([212.77.101.7]:10493 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab1D0SiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:38:07 -0400
Date: Wed, 27 Apr 2011 20:38:19 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA: pata_at91.c bugfixes
Message-ID: <20110427183819.GA2285@localhost.localdomain>
References: <1303299877-12088-1-git-send-email-plyatov@gmail.com>
 <20110423093623.GA3410@localhost.localdomain>
 <4DB6684C.7050505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB6684C.7050505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [8VM0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:38:04AM +0400, Igor Plyatov wrote:
> >On Wed, Apr 20, 2011 at 03:44:37PM +0400, Igor Plyatov wrote:
> >>* Fix "initial_timing" structure initialisation. The "struct ata_timing" must
> >>   contain 10 members, but ".dmack_hold" member was not initialised.
> >>* The AT91SAM9 microcontrollers use special coding scheme for SMC_SETUP,
> >>   SMC_PULSE, SMC_CYCLE registers.
> >>   Old driver operates correctly only with low master clock values, but
> >>   with high master clock it incorrectly calculates SMC values and stops
> >>   to operate, because SMC can be setup only to admissible ranges in special
> >>   format.
> >>   New code correctly calculates SMC registers values, adjusts calculated
> >>   to admissible ranges, enlarges cycles if required and converts values
> >>   into SMC's format.
> >>* Old driver calculates CS_SETUP and CS_PULSE cycles incorrectly
> >>   because of wrong assumptions.
> >>   New code calculates:
> >>       CS_SETUP = SETUP/2
> >If you to this, then {RD,WR}_SETUP have to be equal SETUP + SETUP/2
> >to generate proper setup (t0) time on IDE bus. I think the best way is
err, setup time is t1 

> >set CS_SETUP and CS_HOLD to 0 (what your code do if SETUP and HOLD<=1),
> >but to do this you need to take care of data float (t6z)
> 
> Why so?
> 
> This is not clear for me. Maybe we talk about different things or I
> have wrong
> understanding of ATA timings.
> Can you please look at "Standard Read Cycle" for AT91SAM9 MCU
> http://www.kicad.ru/files/AT91SAM9G20%20bus%20timing.pdf
> , CompactFlash connection schematic
> http://www.kicad.ru/files/CF%20for%20AT91SAM9%20(True%20IDE%20mode).pdf
> and comment my thoughts?
Full "External Bus Interface" section from AT91 spec is important,
because is describe how SMC works internally in CF True IDE mode.

> Here is a legend for "Standard Read Cycle" timing diagram.
> ------------------------------------------------------------------------------
> Read (NRD) signal parameters:
> * t0 = cycle = NRD_CYCLE
> * t1 = setup = NRD_SETUP
> * t2 = pulse = NRD_PULSE
> * t9 = hold = NRD_HOLD
Correct. Also t0 = t1 + t2 + t9 relation must be true.

> Chip Select (NCS) signal parameters:
> * cs_setup = NCS_RD_SETUP
> * cs_pulse = NCS_RD_PULSE
> * cs_cycle = cycle
You can setup that, but they need to have proper relations with NRD.
 
> Notes:
> * The NCS_RD_CYCLE is equal to the NRD_CYCLE for AT91SAM9, because they
>   start/finish simultaneously (HW related).
No, NCS and NRD are different signals, waveforms are different (if configured
differently in SMC controller).

> * The NCS signal is not the same as CS1, CS2 ATA signals! It used only to
>   enable data bus transceiver U2.
Well, they are different signals but connected together. All of these are 
controlled by NCS: CFCE1 (CS1), CFCE2 (CS2), CFRNW (DIR), CFCS0 (OE)
if SMC is configured in True IDE mode. 

Stanislaw
