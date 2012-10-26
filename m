Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2JZJP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:15:58 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:39772 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2JZJPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:15:55 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.898
From: Lars Poeschel <poeschel@lemonage.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Date: Fri, 26 Oct 2012 11:16:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
References: <20120925085559.GL28670@sortiz-mobl> <201210251802.42349.poeschel@lemonage.de> <20121025160651.GO18814@opensource.wolfsonmicro.com>
In-Reply-To: <20121025160651.GO18814@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210261116.01507.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2012 at 18:06:51, Mark Brown wrote:
> Are you saying that whoever designed this USB device has done it so that
> it takes a byte stream with something like RRVV where RR is the register
> and VV is the value?  That's the marshalling, as you'll have seen that's
> done before the buses see the data.

Aaah, I understand! Now your hint that the marshalling should be made 
pluggable makes sense to me.
The device is more complicated and worse. For the first 16 gpio pins it is 
something like 01RR0000FD00VV for setting the value and 03RR00FF00FEVV00 for 
setting the direction. For the second 16 gpio pins it is completly different. 
And yes, for this I completely remarshal what I get marshalled from regmap in 
my bus implementation. This is bad. Thank you for your clarification. This 
was not that clear to me as I began to use regmap and I think it also was not 
to Linus Walleji, as he asked me to change the driver to use regmap. This is 
why he brought you into our discussion.

I am a bit unsure what to do now. Since Linus said he would take my driver 
without regmap, this will be my way for the driver.
I had a look at the regmap code in sense of making the marshalling pluggable. 
It seems that the current assumption is that the register is always the first 
value in the buffer after the marshalling happend which would not fit for my 
device. Changing that is a bit hard. This marshalling is not the only issue. 
For reading values I would need a split buffer or two seperate buffers. 
Reading the device means doing a usb write using the first buffer telling the 
device which register I am interested in and then doing a usb read into the 
second buffer which then contains the actual value of the register. (Both 
transfers marshalled different of course.)

> Is the I/O selection per GPIO or per device?

The I/O selection is per GPIO.
 
> > > So just invalidate the cache and it'll get restored next time we look
> > > at the register.
> > 
> > Yes, this is exactly what I gave as an alternative in my second to last
> > mail. But this invalidates the whole register map although I just want
> > to update one register value.
> 
> So add that functionality to the core if it's not there.

If I reach the limitations of some api/framework/something it is not my first 
idea to change that api but if I did something wrong. But this word from a 
maintainer is clear!
