Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1F3RlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:41:02 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:36208
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751977Ab1F3RlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:41:00 -0400
Message-ID: <4E0CB518.2080703@compulab.co.il>
Date: Thu, 30 Jun 2011 20:40:40 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stanislav Brabec <utx@penguin.cz>
CC: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
References: <1308845380.4533.54.camel@oct.suse.cz>	 <201106301352.21684.marek.vasut@gmail.com>	 <1309445118.4406.47.camel@oct.suse.cz>  <4E0C957F.8080807@compulab.co.il> <1309450406.4406.59.camel@oct.suse.cz>
In-Reply-To: <1309450406.4406.59.camel@oct.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/11 19:13, Stanislav Brabec wrote:

> Igor Grinberg wrote:
>> On 06/30/11 17:45, Stanislav Brabec wrote:
>> I want to
>>> add .needs_regulator bool to ads7846.c and send the patch again to the
>>> list.
>> Please, don't...
>> I thought we've finished discussing the regulator issue...
> The discussion ended without a fix (at least for spitz).

Well, the discussion was mainly about how the regulator API should be used.
The proposed patch, used the regulator API incorrectly.
If I recall correctly, in the end of the discussion,
Mark provided another option for configuring the regulator API,
which is number 3 below.

>  I seen two
> proposals:
> - As ADS7846 hardware does not require dedicated regulator, don't
>   require it in driver and fail only on platforms that have a dedicated
>   regulator.

The thing is that ads7846 chip itself just requires power supply
(as most of the peripheral chips), the one who decides if it will be switchable
is the board vendor and the vendor may use any source for the power supply.
It can be fixed, it can be some kind of discrete LDO or one of the power
supplies coming from the system PMIC.
The ads7846 driver provides the regulator functionality via the regulator API
and it is up to board code to provide the appropriate regulator definitions or
configure the regulator API so the ads7846 will function correctly.

> - Use dummy regulators for all platforms without dedicated ADS7846
>   regulator.

IMO, this is the right way.

>> 1) add regulator definition for ads7846 into the board file
> There is no dedicated regulator on spitz, ADS7846 uses common always-on
> power supply.

Mark,

Is there a kind of regulator for this case (except dummy)?
Some kind of fixed regulator which is not binded to any supply?

>> 2) enable the CONFIG_REGULATOR_DUMMY in your kernel configuration
>> 3) use regulator_use_dummy_regulator() call in the board file.
> OK, I will do 2 or 3. In the new kernel spitz has a regulator, but it is
> not related to ADS7846. And it is actually broken:
>
> I2C: i2c-0: PXA I2C adapter
> Resetting I2C Controller Unit
>  (null): i2c_pxa_abort: called in slave mode
> i2c i2c-1: adapter [pxa_i2c-i2c.1] registered
> i2c 1-000c: uevent
> isl6271a 1-000c: probe
> i2c i2c-1: master_xfer[0] R, addr=0x0c, len=1
> i2c i2c-1: setting to bus master
> i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000442, ICR=000007e0, IBMR=03
> i2c i2c-1: state:i2c_pxa_irq_txempty:932: ISR=00000002, ICR=000007e0, IBMR=03
> i2c i2c-1: Retrying transmission
> i2c i2c-1: setting to bus master
> i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000045, ICR=000007e1, IBMR=00
> i2c i2c-1: state:i2c_pxa_irq_txempty:932: ISR=00000005, ICR=000017ee, IBMR=00
> i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000087, ICR=000017e6, IBMR=00
> print_constraints: vcc_core range: 850 <--> 1600 mV at 1350 mV 
> print_constraints: vcc_core range: 1100 mV 
> isl6271a 1-000c: Failed to set supply vcc_core
> isl6271a 1-000c: failed to register isl6271a
> isl6271a: probe of 1-000c failed with error -16
> i2c i2c-1: client [isl6271a] registered with bus id 1-000c
> I2C: i2c-1: PXA I2C adapter
> ...
> cpufreq: Didn't find vcc_core regulator

This looks like the regulator definitions for spitz are broken and need to be fixed.

-- 
Regards,
Igor.

