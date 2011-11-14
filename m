Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1KNRSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:18:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8803 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1KNRSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:18:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 Nov 2011 09:18:10 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 14 Nov 2011 09:18:07 -0800
Subject: RE: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Topic: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Index: AcyirVadWEAPke7RSD6czZcmSyaDpAAQz5JA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, November 14, 2011 2:11 AM:
> When requesting a single GPIO pin to be muxed in, some controllers
> will need to poke a different value into the control register
> depending on whether the pin will be used for GPIO output or GPIO
> input. So pass this info along for the gpio_request_enable()
> function, we assume this is not needed for the gpio_free_disable()
> function for the time being.

I'm not sure this API change makes sense.

Functions gpio_direction_{input,output} already exist to configure the
direction of a GPIO, and drivers should already be using them. These have
to work to allow drivers to toggle the direction dynamically. Requiring
them to additionally pass this same information to the pinmux driver when
setting up the pinmux seems like extra redundant work.

Instead, shouldn't it work like this:

* If the pinmux driver implementation behind pinmux_request_gpio() needs
to know the direction when configuring the HW, default to input for safety;
that will prevent the SoC driving a signal on a GPIO that's driven by some
other device.

* Rely exclusively on gpio_direction_{input,output} to allow drivers to
configure the direction.

* If the pinmux HW needs programming in response to the gpio_direction_*
calls, have the GPIO and pinmux driver internally communicate to achieve
this.

Does that seem reasonable?

-- 
nvpublic

