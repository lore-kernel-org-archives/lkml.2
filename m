Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1IFSF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:05:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41996 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752435Ab1IFSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:05:51 -0400
Date: Tue, 6 Sep 2011 10:54:39 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Blockers on IIO usage of regmap.
Message-ID: <20110906175435.GA2924@opensource.wolfsonmicro.com>
References: <4E6600A8.4020101@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6600A8.4020101@cam.ac.uk>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 12:14:48PM +0100, Jonathan Cameron wrote:

> Just a quick heads up that the big blocker for
> us making more use of regmap is lack of default
> control of cs_change for spi buses.  That leads to

Looking at what you've got here there's nothing interesting with /CS
here, it's all about the data formatting.  Certainly you've not
mentioned anything odd with /CS in any of the code.

> TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXX
> RX  XXXXXXXXXXX Da0.....Da7  Db0.....Db7  etc

This is the standard one that most things do so is already supported.

> TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXXXX
> RX  XXXXXXXXXXX XXXXXXXXXXX  Da0.....Da7  Db0....Db7

This is just inserting a delay so should be trivial to implement and
doesn't even look terribly SPI specific, just set a flag and it should
be fine.  All we need here is someone to actually implement it.  I guess
the delay will be OK for any read?

> TX  Ada0...Ada7  Adb1...Adb7 Adc1...Adc7  etc
> RX  XXXXXXXXXXX  Da0.....Da7 Db0.....Db7  etc

This one is much more of a contortion to implement - it's pretty SPI
specific to stream the register addresses and it's really not what the
system is set up for.  On the other hand if you can come up with a
taseful way to implement it then I don't see a problem.

> So basically we need some bus specific 'mode' hook somewhere.
> Given we have separate init functions for the buses could we
> add a struct regmap_spi_config to the parameter list?

Or just embed stuff into the main config structure at least for the
delay.  Nothing there seems too outrageous, and the delay sounds like
something someone might do on other buses (the delay will be to allow
time for the ADCs or whatever to set up).
