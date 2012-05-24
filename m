Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781Ab2EXQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:16:59 -0400
Received: from smtp0.epfl.ch ([128.178.224.219]:55657 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755117Ab2EXQQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:16:56 -0400
From: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: marc@cpdesign.com.au
Cc: Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Date: Thu, 24 May 2012 18:16:50 +0200
Message-ID: <5844466.kI7qR0Os9A@laptop>
Organization: EPFL - STI - LSRO1
User-Agent: KMail/4.8.3 (Linux/3.3.5-2.fc16.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <201205242338.41420.marc@cpdesign.com.au>
References: <201205221053.21792.marc@cpdesign.com.au> <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com> <201205242338.41420.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Still reading 0x810 for all registers (0x810000 is the value of
> > register 0 , btw).
> 
> This could mean that all the registers are being sent as 0 and the value is
> shifted by 12 bits. (which is a bit weird). It's also a strange that Shawn's
> board seems to work.
> 
> Do you have any other devices on that SPI that you can verify are working
> correctly? (you said it worked from the bootloader, I'm running out of
> ideas... :| )


Well, I think I found out why it's not working on mc13783.
With regmap, each transfert is done with 8bits words. The SPI hardware assert 
the SS signal only during 8 bits "register" transfert then deassert the SS. 
Then the SS is asserted and 24bits (3 bytes) are transfered (datas).
This clearly violate the datasheet which say SS must be asserted for the 
*whole* transfert: register + data.

This is why the old code used a 32bits word transfert, it ensured that the SPI 
hardware was keeping SS asserted without interruptions.

Is there any way to tell regmap to use 32bits transfert with the following 
configuration (or doing it in a single shot 4x8bits):
To read register 0x42 we need to "write" to SPI:

0x42 << 24

and the mc13783 will answer immediatly in the low-24 bits of the _same_ spi 
exchange.

to write register 0x42 we need to "write" to SPI:

(0x80 | 0x42) << 24  | data

I have an oscilloscope screenshot of a transfert if needed.

Regards,

Philippe




