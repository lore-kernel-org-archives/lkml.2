Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2DMHK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 03:10:26 -0400
Received: from antcom.de ([188.40.178.216]:50583 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab2DMHKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 03:10:25 -0400
Message-ID: <4F87D157.2020700@antcom.de>
Date: Fri, 13 Apr 2012 09:10:15 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Device tree conversion of spi device vs. controller_data
References: <4F816772.5000607@antcom.de> <20120413032945.0C76B3E07AC@localhost>
In-Reply-To: <20120413032945.0C76B3E07AC@localhost>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 05:29 AM, Grant Likely wrote:
>> upon DT conversion of LPC32xx, I came across the at25 spi eeprom which
>> needs .controller_data in struct spi_board_info for slave registration
>> via spi_register_board_info() (non-DT-case).
>>
>> In the DT case, we need to eliminate this explicit registering call.
>> Therefore, I need to somehow replace the .controller_data passing in the
>> DT case to pass this data to the spi core. But I can't find such a
>> mechanism (v3.4-rc2). Is there already a concept or API that I
>> overlooked (please just point me to it) or what can I do to solve this?
>> (Looks like a general issue for spi slave registration via DT).
> 
> Can you point me at specific code?
> 
> .controller_data is owned by the spi_master driver.  The eeprom driver
> shouldn't be accessing it directly at all; but I'll need to look at
> specific code to really understand what is going on.

Please have a look at arch/arm/mach-lpc32xx/phy3250.c :

static struct pl022_config_chip spi0_chip_info = {
        .com_mode               = INTERRUPT_TRANSFER,
        .iface                  = SSP_INTERFACE_MOTOROLA_SPI,
        .hierarchy              = SSP_MASTER,
        .slave_tx_disable       = 0,
        .rx_lev_trig            = SSP_RX_4_OR_MORE_ELEM,
        .tx_lev_trig            = SSP_TX_4_OR_MORE_EMPTY_LOC,
        .ctrl_len               = SSP_BITS_8,
        .wait_state             = SSP_MWIRE_WAIT_ZERO,
        .duplex                 = SSP_MICROWIRE_CHANNEL_FULL_DUPLEX,
        .cs_control             = phy3250_spi_cs_set,
};

...

        static struct spi_eeprom eeprom = {
                .name = "at25256a",
                .byte_len = 0x8000,
                .page_size = 64,
                .flags = EE_ADDR2,
        };

        static struct spi_board_info info[] = {
                {
                        .modalias = "at25",
                        .max_speed_hz = 5000000,
                        .bus_num = 0,
                        .chip_select = 0,
                        .mode = SPI_MODE_0,
                        .platform_data = &eeprom,
                        .controller_data = &spi0_chip_info,
                },
        };

	spi_register_board_info(info, ARRAY_SIZE(info));

Trying to replace .controller_data at this point with device tree
settings passing, I struggled with missing resp. node properties.

Any hint how this can be done?

Thanks in advance,

Roland
