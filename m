Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0LJEie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 23:38:34 -0500
Received: from nm16.bullet.mail.ne1.yahoo.com ([98.138.90.79]:46435 "HELO
	nm16.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755273Ab0LJEid convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 23:38:33 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 506669.47896.bm@omp1039.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZRUT7PWnKyUjSSN4dzzoFewowwwIfDuooSXbXI1cb1no6in1+oq89KJgyNtD90vshqu9tbux3UyebsrgiVzio38gAEbuEP24/d1O53IbBX4AE57sQSCLvVTvteQCRn1+kL8hOgJ+1//CjmhiqfZCNyMWF6d/NhkHvCUxllNSKgE=;
Message-ID: <795969.76999.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: OgbqUhkVM1lYP5uzgOhDbZ22b9CpDMRHVFA.RIKGxwFqhZc
 Ic1f0lFovcrdQZilaGmny7rK04mpmt5FOWF98Q.8kzoZGWubEngEWNvYCK4x
 5sTGn86DW91kjeveLG6Js16uKYPNr9wfxd7Ej4_9i1jKKym96O51DSntcSwO
 k_QRM8CGhITgGTBJ3ve7nT34WdKDuDLppSVyyaMOpjBKn2kVxO7diXNNH80w
 m29wLuRf4k7NQ38FzVET5xBPaUvAyMFER4xZTbeQBJ3zFnfaUs7n1.SoYCAC
 ankL_w.dYis0T0xrBeu.E6NK5FnSjTgn3rwTE9_bGsTldVucH6vAauRnFueD
 eiTy.kytBtQBcSbWaJYbKbGltTb1Rza9fO7SVRg6h_GNeFCM54pPVbzO27bs
 so7fflaE.QIzc
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Thu, 9 Dec 2010 20:38:31 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH v2 0/3] slower spi-gpio
To: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <cover.1291925752.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 12/9/10, Ben Gardiner <bengardiner@nanometrics.ca> wrote:


> This a continuation of the previous
> RFC [1]; we

You know, the spi-gpio code was written so it
would not need Kconfiguration, and I'd like
to see that continued.

Surely the minimal configuration you'd need
could be wrapped up in #defineslike the
actual GPIO numbers are wrapped up in.

Heck, nothing outside your patches needs your
:slow it way the heck down" option, so there's
no point to exposing it  via Kconfig;
such stuff is routinely embedded in C code.


 are interested in running a
> bitbanged SPI bus with a limited rate of transfer,

Would it make more sense to have a separate
slowed-down veresion of the driver, maybe just
custom defs for our hardware plus the current
driver body, as explained in the driver code
(last time I looked at it, anyway).

It bothers me to think of cluttering the
current driver with slowdowns

Or just have the "be slow" options private to
the driver instance, like "which GPIOs" is??

(I notice you didn't even check the GPIOs to see
if they are sleeping calls (e.g. over I2C), which
would have been preferable to a static always-slow
Kconfig option.  (But not to an always-slow object
vs the current default always-fast model.

I still need to be able to get multi-megabit
SPI clock rates out of the standard spi-gpio
code base.  (When I've had to use spi-gpio it
has never been a performance issue; the code
was written to facilitate inner bitbang loops
of about half a dozen instructions (ARM).

These recent patches look to be de-tuning badly,
or at least optimizing for slowness not speed,
which seems the wrong default.

- Dave


> including the delay between
> CS assertion and the beginning of data transfer. We also
> would like to do this 
> with the GPIOs on an IO expander.
> 
> The following three changes have been identified so far as
> being required to 
> achieve this. spidelay() must be implemented, the delay
> specified in
> controller_state should be honoured when a transfer begins
> and finally the 
> _cansleep gpio set functions should be used so that GPIOs
> on an expander can
> be used. 
> 
> This is alot of compile-time functionality switching
> though. I wonder if this
> kind of patching of spi-gpio would be acceptable or not;
> given the recent
> events in polled gpio-keys I feel that maybe a new
> 'spi-gpio-limited' driver 
> might be preferred.
> 
> [1] http://article.gmane.org/gmane.linux.kernel/1065748
> 
> Ben Gardiner (3):
>   [RFC] spi-gpio: implement spidelay() for platforms
> that configure
>     SLOWER_SPI_GPIO
>   [RFC] spi_bitbang : get nsecs delay from cs during
> transfer
>   [RFC] spi-gpio: use _cansleep when
> CONFIG_SLOWER_SPI_GPIO is defined
> 
>  drivers/spi/Kconfig   
>    |   17 +++++++++++++++++
>  drivers/spi/spi_bitbang.c |   15
> +++++++++------
>  drivers/spi/spi_gpio.c    |   18
> +++++++++++++++---
>  3 files changed, 41 insertions(+), 9 deletions(-)
> 
> ---
> 
> Changes since v1:
>  * rebased to  2.6.37-rc5
>  * introduced patch 2/3 and 3/3
> 
> This time around I tested the changes by registering a
> spi-gpio bus intance
> on the user DIP switches of the da850evm baseboard which
> are connected to a 
> pca953x-compatible I2C gpio expander. Then I did a few 
> 'echo hello > /dev/spidev0.0' commands and checked the
> behaviour of the bus
> on a scope. I was unable to test the speed of this bus
> without the patchset
> this time since using the GPIOs on the expander requires
> patch 3/3. I found 
> that the SCLK speed was roughly 300Hz where 500Hz was
> requested.
> 
> Here is a snip of the board-setup code that registers the
> spi-gpio bus:
> 
> static struct spi_gpio_platform_data bb_spi_gpio_pdata = {
>     .sck   
>     = -1 /* assigned at runtime */,
>     .mosi   
>     = -1 /* assigned at runtime */,
>     .miso   
>     = -1 /* assigned at runtime */,
>     .num_chipselect = 1,
> };
> 
> static struct platform_device bb_spi_gpio = {
>     .name   
>     = "spi_gpio",
>     .id       
> = 0,
>     .dev   
>     = {
>        
> .platform_data    = &bb_spi_gpio_pdata,
>     },
> };
> 
> static struct spi_board_info bb_spi_devices[] = {
>     {
>        
> .modalias    = "spidev",
>        
> .max_speed_hz    = 500,
>        
> .bus_num    = 0,
>        
> .chip_select    = 0,
>        
> .mode        = SPI_MODE_0,
>         .controller_data =
> (void *) -1 /* assigned at runtime */,
>     },
> };
> 
> static int bb_spi_gpio_init(unsigned gpio)
> {
>     int ret;
> 
>     bb_spi_gpio_pdata.sck = gpio +
> DA850_EVM_BB_EXP_USER_SW1;
>     bb_spi_gpio_pdata.mosi = gpio +
> DA850_EVM_BB_EXP_USER_SW2;
>     bb_spi_gpio_pdata.miso = -1 /* nothing
> connected ATM */;
> 
>     bb_spi_devices[0].controller_data =
> (void *) gpio +
>            
>            
> DA850_EVM_BB_EXP_USER_SW3;
> 
>     ret =
> spi_register_board_info(bb_spi_devices,
>            
>        
> ARRAY_SIZE(bb_spi_devices));
>     if (ret) {
>         pr_warning("could not
> register spi devices");
>         goto
> spi_gpio_fail_devices;
>     }
> 
>     ret =
> platform_device_register(&bb_spi_gpio);
>     if (ret) {
>         pr_warning("could not
> register spi-gpio driver instance");

>         goto
> spi_gpio_fail_bus;
>     }
> 
>     return 0;
> spi_gpio_fail_bus:
>     /* no unregister board info function
> available*/
> spi_gpio_fail_devices:
>     return ret;
> }
> 
> static int da850_evm_bb_expander_setup(struct i2c_client
> *client,
>            
>            
> unsigned gpio, unsigned ngpio,
>            
>            
> void *c)
> {
>     int ret;
> 
>     /*
>      * Register the switches and
> pushbutton on the baseboard as a gpio-keys
>      * device.
>      */
>     da850_evm_bb_keys_init(gpio);
>     ret =
> platform_device_register(&da850_evm_bb_keys_device);
>     if (ret) {
>         pr_warning("Could not
> register baseboard GPIO expander keys");
>         goto
> io_exp_setup_sw_fail;
>     }
> 
>     da850_evm_bb_leds_init(gpio);
>     ret =
> platform_device_register(&da850_evm_bb_leds_device);
>     if (ret) {
>         pr_warning("Could not
> register baseboard GPIO expander LEDS");
>         goto
> io_exp_setup_leds_fail;
>     }
> 
>     ret = bb_spi_gpio_init(gpio);
>     if (ret) {
>         pr_warning("Could not
> register spi-gpio bus");
>         goto
> io_exp_setup_spi_fail;
>     }
> 
>     return 0;
> 
> io_exp_setup_spi_fail:
>    
> platform_device_unregister(&da850_evm_bb_leds_device);
> io_exp_setup_leds_fail:
>    
> platform_device_unregister(&da850_evm_bb_keys_device);
> io_exp_setup_sw_fail:
>     return ret;
> }
> 
