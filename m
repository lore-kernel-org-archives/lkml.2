Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768663Ab2KOS1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:27:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37040 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992484Ab2KOS1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:27:42 -0500
Message-ID: <50A5341A.4040806@wwwdotorg.org>
Date: Thu, 15 Nov 2012 11:27:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
References: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com> <50A15A54.3090803@wwwdotorg.org> <20121113063546.GD18224@opensource.wolfsonmicro.com> <CACRpkdY-tye5LNOwxQ-XrjM-x9RffAvj-tPfsFQA3ZWOY8P-Vw@mail.gmail.com> <20121115152652.44c567d5@skate> <CACRpkdaXCA9ZDbkGTtdtFBWLhBKQmPf1=EgnLhUSqKOT1xU7oQ@mail.gmail.com>
In-Reply-To: <CACRpkdaXCA9ZDbkGTtdtFBWLhBKQmPf1=EgnLhUSqKOT1xU7oQ@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 10:24 AM, Linus Walleij wrote:
> On Thu, Nov 15, 2012 at 3:26 PM, Thomas Petazzoni
> <thomas.petazzoni@free-electrons.com> wrote:
> 
>> At ELCE, I've discussed with one person having an interesting use case:
>> they are using the same pin for two different purposes during the
>> system operation.
>>
>> At boot time, this pin is muxed as a SPI pin and is used to program the
>> bitstream of a FPGA. This is done in Linux, through a userspace
>> application.
>>
>> Then, once it is done, this pin is remuxed as a UART pin, and used to
>> communicate with another device on the board.
> 
> This is not related to the current discussion but interesting
> anyway...
> 
>> If the pinctrl configuration is done at probe() time inside the driver
>> core, then how can this kind of use case be supported? If each driver
>> does its own muxing, we could think of letting the SPI and UART driver
>> only do their muxing when the device is opened, and remove their muxing
>> when the device is closed, so that such sharing of pins for two
>> separate functions could be supported. Is this something we want to
>> support?
> 
> This is trivial to support after this commit in the current patch
> queue:
> commit 1a78958dc212f3698fdc543857af80155cb30f7f
> pinctrl: reserve pins when states are activated
> 
> Just define function maps for both devices using the same
> pins. Since the devices need to actively release their
> pins they need to go to a state which does not mux in
> any pins, so that the pins will be free:ed.
> 
> This state can be any arbitrary string, but if so desired
> for consistency we can define something like
> #define PINCTRL_STATE_DECOUPLED "decoupled"
> in include/linux/pinctrl/pinctrl-state.h to clearly
> mark that this is a state where the device is not
> using any pins at all.

Well, you'd also need to explicitly code the pinmux logic into the UART
driver, so that the UART's default state didn't prevent the SPI driver
from temporarily acquiring the pin to program the FPGA. It's rather
nasty to put that into the UART driver, which would presumably otherwise
be completely generic and not need runtime pinmux state changes. I
wonder if interjecting a mux driver between the UART/SPI and the pins
would help here, although presumably the UART driver would still need
some way of interacting with the mux driver which wouldn't be any better...

