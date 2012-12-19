Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2LSMcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:32:16 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:60669 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2LSMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:32:07 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] i2c-core: Add gpio based bus arbitration implementation
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, khali@linux-fr.org, ben-linux@fluff.org,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        grundler@chromium.org, naveen@chromium.org,
        broonie@opensource.wolfsonmicro.com
In-Reply-To: <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com> <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
Date: Wed, 19 Dec 2012 12:32:01 +0000
Message-Id: <20121219123201.B636A3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 11:20:53 +0530, Naveen Krishna Chatradhi <ch.naveen@samsung.com> wrote:
> The arbitrator is a general purpose function which uses two GPIOs to
> communicate with another device to claim/release a bus.
> 
> i2c_transfer()
> 	if adapter->gpio_arbit
> 		i2c_bus_claim();
> 			__i2c_transfer();
> 		i2c_bus_release();
> 
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Cc: Grant Grundler <grundler@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Hi Naveen,

I'm not convinced on the design of this protocol. It won't scale beyond
2 bus masters and it seems very specific to the design of a specific
piece of hardware. I don't think it is mature enough to bake into the
core i2c infrastructure or bindings. Nor do I think it will handle other
busses properly.

I can see two alternatives here.
1) build in hooks for doing i2c bus claim/release, but don't put this
specific implementation into the core infrastructure
2) Create an i2c bridge driver. This would kind of be like an i2c
multiplexer, but it would only have one bus and it would include the
knowledge of how to use the GPIO lines for bus arbitration.

I think option 2 would be the cleanest option. It would be straight
forward to design a binding for it by placing a node between the i2c
bus and all the i2c clients. For example:

i2c@60000000 {
	compatible = "acme,some-i2c-device";
	#address-cells = <1>;
	#size-cells = <0>;

	i2c-bridge {
		#address-cells = <1>;
		#size-cells = <0>;
		compatible = "samaung,i2c-gpio-arbitrate";

		bus-arbitration-gpios = <&gpf0 3 1 0 0>, /* AP_CLAIM */
			<&gpe0 4 0 3 0>; /* EC_CLAIM */
	
		bus-arbitration-slew-delay-us = <10>;
		bus-arbitration-wait-retry-us = <2000>;
		bus-arbitration-wait-free-us = <50000>;

		i2c@52 {
			// Normal i2c device
		};
	};
};

I don't know what the state of the i2c subsystem is with regard to
supporting i2c multiplexer devices, so there might be some changes
needed there, but I can't see it being particularly complex. It should
just be a device in the middle. Any i2c device that is a child of the
bridge would send transfers to the bridge, and the bridge would be
responsible to claim the bus and then pass the transfer through
unchanged.

That eliminates the problem of trying to design an arbitration scheme
that works for all.

g.

