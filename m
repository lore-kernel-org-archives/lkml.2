Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab2EXQlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:41:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43554 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab2EXQlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:41:13 -0400
Date: Thu, 24 May 2012 18:41:01 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        marc@cpdesign.com.au, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524164101.GW3710@pengutronix.de>
References: <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
 <201205242338.41420.marc@cpdesign.com.au>
 <5844466.kI7qR0Os9A@laptop>
 <20120524163604.GM5361@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120524163604.GM5361@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 05:36:05PM +0100, Mark Brown wrote:
> On Thu, May 24, 2012 at 06:16:50PM +0200, Philippe Rétornaz wrote:
> 
> > Well, I think I found out why it's not working on mc13783.
> > With regmap, each transfert is done with 8bits words. The SPI hardware assert 
> > the SS signal only during 8 bits "register" transfert then deassert the SS. 
> > Then the SS is asserted and 24bits (3 bytes) are transfered (datas).
> > This clearly violate the datasheet which say SS must be asserted for the 
> > *whole* transfert: register + data.
> 
> > This is why the old code used a 32bits word transfert, it ensured that the SPI 
> > hardware was keeping SS asserted without interruptions.
> 
> > Is there any way to tell regmap to use 32bits transfert with the following 
> > configuration (or doing it in a single shot 4x8bits):
> 
> I think this is just a plain bug in the SPI controller driver.  I think
> I have seen it before in some FSL BSPs (I do remember having to fall
> back to the bitbanging driver), it's surprising that it's also present
> in the mainline driver so perhaps it's something different.  The driver
> is deasserting chip select between transfers but it should only do so at
> the end of the message unless told otherwise by the caller setting
> cs_change.  regmap-spi uses spi_write_then_read() which does a single
> spi_message for the write and read parts of the transfer.
> 
> If this is actually the issue the usual fix for this if the SPI
> controller hardware can't be persuaded to do the right thing is to put
> the chip select pin in GPIO mode and manage it by hand, though looking
> at the driver it appears it should be doingn that already.  If you
> change to using the bitbanging SPI driver it should do the right thing
> (but will obviously be hideously slow), that ought to be at least a good
> reference for expected behaviour here.
The imx spi driver can do both (GPIO and hardware CS) because not all
pins that can do hardware CS are available as GPIO.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
