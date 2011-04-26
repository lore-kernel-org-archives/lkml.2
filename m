Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1DZIdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:33:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55760 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1DZIdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:33:52 -0400
Date: Tue, 26 Apr 2011 09:33:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Expose regulator:set_consumer_device_supply()?
Message-ID: <20110426083350.GA20595@sirena.org.uk>
References: <BANLkTi=dCHXEtv+=+sRaDp_Pt3zQy5o7ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=dCHXEtv+=+sRaDp_Pt3zQy5o7ug@mail.gmail.com>
X-Cookie: I'm also against BODY-SURFING!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 09:16:55PM -0500, Bill Gatliff wrote:
> Guys:

Please always:
- CC maintainers on mails (in this case myself and Liam).
- CC the relevant list (in this case linux-kernel).

> In a nutshell, I have a lot of i2c chips, each of which is powered by
> its own voltage regulator.  Among other things, I'm trying to write
> the i2c drivers so that they are as platform-agnostic as possible,
> because I intend for these drivers to be reused on future platforms
> with different voltage regulator layouts.  On future platforms
> regulators might be shared with multiple i2c chips, for example.

OK, this is absolutely normal for the regulator API.

> What I'm hoping for is i2c driver code that asks for a regulator based
> on the name of the pin to which the regulator is connected.  So
> instead of doing this:

> ... I can do this:
> 
> i2c_chip_probe(i2c_client *this, ...)
> {
> ...
>    /* ask for the regulator connected to our VDD pin */
>    reg = regulator_get(this, "VDD");
> ...
> }

This is exactly what you're supposed to do with the regulator API now.
If you're not doing that the consumer driver is buggy and should be
fixed, it should be written without reference to the board it is running
on.

> The problem with i2c devices is that if you register them with
> i2c_register_board_info(), you don't have a device pointer that you
> can associate a regulator with.  So you have to register the regulator
> after the i2c chip gets registered, which means doing it in the i2c
> chip's probe method.  Ugly, and it won't work when regulators are
> shared between devices.

You can specify the device by either dev_name() or a dev pointer.  You
can use dev_name() at any time without the device having been
instantiated, it would be unusal to use a struct device.

> Any reason why we couldn't expose set_consumer_device_supply(), so
> that I can add a device as a regulator consumer after a regulator is
> already registered?

This would facilitate abuse of the API, we already have enough problems
with people trying to pass regulators as platform data.
