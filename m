Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1F3SBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:01:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58967 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752181Ab1F3SBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:01:43 -0400
Date: Thu, 30 Jun 2011 11:01:10 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Stanislav Brabec <utx@penguin.cz>, Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
Message-ID: <20110630180105.GA5064@opensource.wolfsonmicro.com>
References: <1308845380.4533.54.camel@oct.suse.cz>
 <201106301352.21684.marek.vasut@gmail.com>
 <1309445118.4406.47.camel@oct.suse.cz>
 <4E0C957F.8080807@compulab.co.il>
 <1309450406.4406.59.camel@oct.suse.cz>
 <4E0CB518.2080703@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0CB518.2080703@compulab.co.il>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 08:40:40PM +0300, Igor Grinberg wrote:
> On 06/30/11 19:13, Stanislav Brabec wrote:
> > Igor Grinberg wrote:

> >> I thought we've finished discussing the regulator issue...

> > The discussion ended without a fix (at least for spitz).

> Well, the discussion was mainly about how the regulator API should be used.
> The proposed patch, used the regulator API incorrectly.
> If I recall correctly, in the end of the discussion,
> Mark provided another option for configuring the regulator API,
> which is number 3 below.

The discussion ended with you guys having the three different options
that would work, you just need to use one of them.

> >  I seen two
> > proposals:
> > - As ADS7846 hardware does not require dedicated regulator, don't
> >   require it in driver and fail only on platforms that have a dedicated
> >   regulator.

> The thing is that ads7846 chip itself just requires power supply

Right, and the regulator API hides the non-switchability of the supply
from the driver so there's no need for the driver to worry about how the
supplies are wired up.  It just turns the regulator on when it needs it
and turns it off when it doesn't.

> >> 1) add regulator definition for ads7846 into the board file
> > There is no dedicated regulator on spitz, ADS7846 uses common always-on
> > power supply.

> Is there a kind of regulator for this case (except dummy)?
> Some kind of fixed regulator which is not binded to any supply?

This is just a fixed voltage regulator, support for that has been in the
kernel since the regulator API was merged.  This is the best solution,
it ensures that you don't mistakenly activate dummy reglators for
supplies that really need software control.

> > i2c i2c-1: Retrying transmission
> > i2c i2c-1: setting to bus master
> > i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000045, ICR=000007e1, IBMR=00
> > i2c i2c-1: state:i2c_pxa_irq_txempty:932: ISR=00000005, ICR=000017ee, IBMR=00
> > i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000087, ICR=000017e6, IBMR=00

This looks like you've got I2C I/O issues talking to something.

> > print_constraints: vcc_core range: 850 <--> 1600 mV at 1350 mV 
> > print_constraints: vcc_core range: 1100 mV 

This looks like there's two definitions for vcc_core.
