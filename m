Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab2I3JjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:39:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39696 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2I3JjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
	<CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com>
Date: Sun, 30 Sep 2012 11:39:09 +0200
Message-ID: <CAOY=C6HwrWm20rOz2r2rUmq0PcmG9CeGW9hJQzw_RrJhzb9JqQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
From: Stijn Devriendt <highguy@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 11:22 PM, Roland Stigge <stigge@antcom.de> wrote:
>
> The recurring task of providing simultaneous access to GPIO lines
> (especially
> for bit banging protocols) needs an appropriate API.
>
> This patch adds a kernel internal "Block GPIO" API that enables
> simultaneous
> access to several GPIOs in the same gpio_chip (bit mapped). Further, it
> adds a
> sysfs interface (/sys/class/gpio/gpiochipXX/block).
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>
> ---
> NOTE: This is only useful if individual drivers implement the .get_block()
> and
> .set_block() functions. I'm providing an example implementation for
> max730x
> (see next patch), and can provide further driver patches after API review.
>
> Thanks in advance!
>

Hi Roland,

In our kernel tree we have similar code. If you like I can request
permission
to share. I can, however, already give you an update on the basic structure,
perhaps
it's useful now.

For the first part, the drivers need to implement a the gpio interface for
groups.
gpio_set_multi, gpio_get_multi, gpio_direction_input_multi,
gpio_direction_output_multi. Each of them gets a 'u32 mask'.

Secondly, gpiolib gets some new code to handle groups:
groups are requested via a list of gpio ids. Mind that order is respected:
request( [1, 5, 2, 4] ) followed by a set(0x5) will translate to
gpio_set_multi( 0x18 ). An opaque gpio_group struct is used to keep track.
This means the gpiolib interface also has a u32 mask, but translation is
done for the gpio-drivers.

There is some code to request groups via device-tree (again respecting
order)
and there are also platform driver structures.

gpiolib was also extended to export groups into sysfs, respecting policy
(input, output, user-selectable) and to make softlinks to groups in other
driver's subdir. (One driver we use this in is a power-sequencer with 2
gpios selecting a margining profile, this driver then has the gpio_group
exported in it's sysfs dir as .../profile, allowing H/W engineers to select
the profile without voltage glitches)

There's also a separate driver, that does nothing more than exporting
both individual pins and groups to userspace based on platform description
or devicetree. This is probably less interesting for mainline, since we're
abusing device-tree to do away with some init script that can do the same.

The rationale behind a 32bit mask is that typical processors can at most
set one processor-word worth of GPIOs at once and there are probably
few chips with over 32GPIOs on a single gpio_chip anyway.
Nevertheless, in the era of 64bit, it's definitely possible to go for u64
instead.

Let me know if this looks like something usable to you.

Regards,
Stijn
