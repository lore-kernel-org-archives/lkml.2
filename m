Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979Ab2D0SDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:03:50 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:35926 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676Ab2D0SDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:03:48 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Device tree conversion of spi device vs. controller_data
To: Roland Stigge <stigge@antcom.de>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4F87D157.2020700@antcom.de>
References: <4F816772.5000607@antcom.de> <20120413032945.0C76B3E07AC@localhost> <4F87D157.2020700@antcom.de>
Date: Fri, 27 Apr 2012 12:03:44 -0600
Message-Id: <20120427180344.F023D3E171B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 09:10:15 +0200, Roland Stigge <stigge@antcom.de> wrote:
> On 04/13/2012 05:29 AM, Grant Likely wrote:
> >> upon DT conversion of LPC32xx, I came across the at25 spi eeprom which
> >> needs .controller_data in struct spi_board_info for slave registration
> >> via spi_register_board_info() (non-DT-case).
> >>
> >> In the DT case, we need to eliminate this explicit registering call.
> >> Therefore, I need to somehow replace the .controller_data passing in the
> >> DT case to pass this data to the spi core. But I can't find such a
> >> mechanism (v3.4-rc2). Is there already a concept or API that I
> >> overlooked (please just point me to it) or what can I do to solve this?
> >> (Looks like a general issue for spi slave registration via DT).
> > 
> > Can you point me at specific code?
> > 
> > .controller_data is owned by the spi_master driver.  The eeprom driver
> > shouldn't be accessing it directly at all; but I'll need to look at
> > specific code to really understand what is going on.
> 
> Please have a look at arch/arm/mach-lpc32xx/phy3250.c :
> 
> static struct pl022_config_chip spi0_chip_info = {
>         .com_mode               = INTERRUPT_TRANSFER,
>         .iface                  = SSP_INTERFACE_MOTOROLA_SPI,
>         .hierarchy              = SSP_MASTER,
>         .slave_tx_disable       = 0,
>         .rx_lev_trig            = SSP_RX_4_OR_MORE_ELEM,
>         .tx_lev_trig            = SSP_TX_4_OR_MORE_EMPTY_LOC,
>         .ctrl_len               = SSP_BITS_8,
>         .wait_state             = SSP_MWIRE_WAIT_ZERO,
>         .duplex                 = SSP_MICROWIRE_CHANNEL_FULL_DUPLEX,
>         .cs_control             = phy3250_spi_cs_set,

phy3250_spi_cs_set is only a wrapper around gpio_set_value().  GPIO CS
manipulation should be handled by the core pl022 spi driver, so that
gets rid of the hardest part of this conversion (callbacks in platform
data).

The pl022_config_chip structure is 100% owned by the spi controller
(pl022).  If the bus driver depends on this structure, then it is the
responsibility of the bus driver to allocate one and set the
controller data pointer for each of the child devices.  You may need
to add pl022-specific properties to each of the child nodes to
populate this data correctly if it cannot be determined with other
means.

There is no existing API for this since it is entirely pl022 specific
code.

> };
> 
> ...
> 
>         static struct spi_eeprom eeprom = {
>                 .name = "at25256a",
>                 .byte_len = 0x8000,
>                 .page_size = 64,
>                 .flags = EE_ADDR2,

This data is easy and is 'owned' by the eeprom data.  It can be
directly converted into device tree properties in the eeprom node.

>         };
> 
>         static struct spi_board_info info[] = {
>                 {
>                         .modalias = "at25",
>                         .max_speed_hz = 5000000,
>                         .bus_num = 0,
>                         .chip_select = 0,
>                         .mode = SPI_MODE_0,
>                         .platform_data = &eeprom,
>                         .controller_data = &spi0_chip_info,
>                 },
>         };

Everything in spi_board_info directly translates over to DT today.  You
shouldn't have any problems here.

> 
> 	spi_register_board_info(info, ARRAY_SIZE(info));
> 
> Trying to replace .controller_data at this point with device tree
> settings passing, I struggled with missing resp. node properties.
> 
> Any hint how this can be done?
> 
> Thanks in advance,
> 
> Roland

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
