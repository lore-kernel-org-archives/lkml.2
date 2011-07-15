Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab1GOMRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 08:17:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33277 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750767Ab1GOMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 08:17:03 -0400
Date: Fri, 15 Jul 2011 21:16:50 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110715121646.GA10026@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
 <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715123121.735688a6@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715123121.735688a6@endymion.delvare>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 12:31:21PM +0200, Jean Delvare wrote:

> The driver was previously using the SMBus API and could thus work with
> SMBus (non-I2C) controllers. After your change, an I2C controller is
> mandatory. Are you sure this is OK for all users?

I'd be *utterly* astonished if it ever caused any issues, embedded
systems like those that have regulators just don't have anything less
than full I2C support, it's exceptionally rare to see any direct SMBus
support in the hardware at all - the only example I can see in the tree
is Blackfin and that is a proper I2C controller too, it just seems that
someone overdesigned the hardware a little.

Basically, for something like a regulator it's just not an issue.

> As a general comment, this requirement will considerably limit the
> interest of regmap for I2C devices (at least in its current form.) Many
> systems out there only have SMBus controllers, and more importantly,
> most I2C device drivers are meant to be portable across systems and
> thus rely on the SMBus API. The i2c documentation encourages driver
> authors to do this.

Right, so for pretty much anything except PCs the main reason for using
the SMBus API is that it provides the sort of data mangling to the bus
functionality that the regmap API provides.  The main thing it's missing
for drivers like this one is that it doesn't have a read/modify/write
operation, otherwise there would be no current value in switching to the
regmap API.  As far as I can tell this isn't really a big deal except
for those device classes like hwmon which are frequently deployed in
PCs, anything else just won't care.

This should be reasonably simple to handle in the regmap API, just teach
the I2C module to fall back to using the SMBus operations if the
controller is limited to that.  This should be done incrementally as it
adds complexity, and ideally would be done by someone with some access
to hardware that can use the SMBus API (I don't have any myself) so they
can test.

Does that sound reasonable to you?

> >  static int tps_65023_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
> >  {
> > -	int err, data;

*Please* could people delete unneeded context from mails?
