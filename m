Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab2I3Kuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 06:50:51 -0400
Received: from antcom.de ([188.40.178.216]:48661 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab2I3Kuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:50:50 -0400
Message-ID: <50682402.8020402@antcom.de>
Date: Sun, 30 Sep 2012 12:50:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        bgat@billgatliff.com
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com>
In-Reply-To: <CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/12 11:35, Stijn Devriendt wrote:
> In our kernel tree we have similar code. If you like I can request
> permission
> to share. I can, however, already give you an update on the basic
> structure, perhaps
> it's useful now.
> 
> For the first part, the drivers need to implement a the gpio interface
> for groups.
> gpio_set_multi, gpio_get_multi, gpio_direction_input_multi,
> gpio_direction_output_multi. Each of them gets a 'u32 mask'.
> 
> Secondly, gpiolib gets some new code to handle groups:
> groups are requested via a list of gpio ids. Mind that order is respected:
> request( [1, 5, 2, 4] ) followed by a set(0x5) will translate to
> gpio_set_multi( 0x18 ). An opaque gpio_group struct is used to keep track.
> This means the gpiolib interface also has a u32 mask, but translation is
> done for the gpio-drivers.
> 
> There is some code to request groups via device-tree (again respecting
> order)
> and there are also platform driver structures.
> 
> gpiolib was also extended to export groups into sysfs, respecting policy
> (input, output, user-selectable) and to make softlinks to groups in other
> driver's subdir. (One driver we use this in is a power-sequencer with 2
> gpios selecting a margining profile, this driver then has the gpio_group
> exported in it's sysfs dir as .../profile, allowing H/W engineers to select
> the profile without voltage glitches)
> 
> There's also a separate driver, that does nothing more than exporting
> both individual pins and groups to userspace based on platform description
> or devicetree. This is probably less interesting for mainline, since we're
> abusing device-tree to do away with some init script that can do the same.
> 
> The rationale behind a 32bit mask is that typical processors can at most
> set one processor-word worth of GPIOs at once and there are probably
> few chips with over 32GPIOs on a single gpio_chip anyway.
> Nevertheless, in the era of 64bit, it's definitely possible to go for
> u64 instead.

Hi Stijn,

thank you for your notes!

Besides what I discussed with JC and Linus, I find the unsigned int
(i.e. u32 or u64, depending on the arch) quite appealing. It is a nice
compromise between my general bit mapped data model (variable size *u8
array) and the bool *values list. Even maps easily onto a single sysfs
entry for values, by abstracting a gpio list to an actual data word.

What do others think? JC? Linus? I'm considering this (unsigned int
data) a valid option.

One question: How did you solve the one-value-per-file in the sysfs
interface?

Thanks in advance!

Roland
