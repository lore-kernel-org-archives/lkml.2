Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1BAJdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:33:12 -0500
Received: from smtp.nokia.com ([147.243.1.47]:52840 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1BAJdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:33:09 -0500
Subject: Re: [PATCH v6 0/3] input: Add support for ECI (multimedia)
 accessories
From: Tapio Vihuri <tapio.vihuri@nokia.com>
Reply-To: tapio.vihuri@nokia.com
To: ext Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: peter.ujfalusi@nokia.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
In-Reply-To: <20110201085823.GB17706@core.coreip.homeip.net>
References: <1296482634-31666-1-git-send-email-tapio.vihuri@nokia.com>
	 <20110201085823.GB17706@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Tue, 01 Feb 2011 11:32:41 +0200
Message-ID: <1296552761.4168.40.camel@dell>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 00:58 -0800, ext Dmitry Torokhov wrote:
> Hi Tapio,
> 
> On Mon, Jan 31, 2011 at 04:03:51PM +0200, tapio.vihuri@nokia.com wrote:
> > 
> > This patch set introduce Multimedia Headset Accessory support for
> > Nokia phones. Technically those are known as ECI (Enhancement Control Interface)
> > 	
> > If headset has many buttons, like play, vol+, vol- etc. then it is propably ECI
> > accessory.
> > 
> > Among several buttons ECI accessories contains memory for storing several
> > parameters.
> > 
> > This ECI input driver provides the following features:
> >  - reading ECI configuration memory
> >  - ECI buttons as input events
> > 
> > Drive is constructed as follows:
> >  - ECI accessory input driver deals with headset accessory
> >  - ECI bus control driver deals the HW transfering data to/from headset
> >  - platform data match used HW
> 
> I finally had a chance to look though the patches more closely and I do
> not understand why you decided to introduce the platform device in
> addition to I2C device. You end up with 2 artificially separated bodies of
> code that are not viable on their own. The ECI module with it's platform
> device is not usable without the controller; the controller can not be
> registered without the ECI device initialized; there are ordering
> issues, both initialization and PM-wise and you are forced to support
> only one device.
> 
> Is there going to be an SPI interface as well? If not then fold it all
> together and have I2C device as the only device involved. If SPI is a
> possibility then look in drivers such as adxl34x, ad714x and others that
> are split into core module and bus interface implementations.
> 
> Thanks.
> 

Hi Dmitry

Thank you for reviewing.

The reasoning for separating driver to the two parts is having both
common and different hardware.

The ECI input, as platform device is common part and only dealing with
the accessory HW (meaning the headset accessory).
This is standardiced part of system, where specification guarantee HW
behaving same way accross several headset accessories.
The accessory is plugged to the terminal using four pin AV-cable, much
same way as USB mouse.
I just didn't see need to introduce new bus type for one wire ECI data
link, hence platform device.

The ECI controller, as I2C device is the variable part of the system.
In this case it's microcontroller in I2C bus, but there are other
versions too.
There is no specification about these controller's internals, and those
are quite different.
It is also possible to use other buses too for connecting controller to
terminal, like SPI.

The idea was that if ECI is used in device, just take ECI input driver
and select the ECI controller which is used in the platform.

And as long as the ECI controller driver use the same interface to ECI
input driver, evetrything works OK.
This allows also dynamic selection of used control device. I mean we can
compile several ECI controllers as modules and detect the HW at
initialization.

I use the ad714x as example, but I can take second look on that too.

Please let me know if this is making sense.

Thanks,
Tapio

