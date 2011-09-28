Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1I1IDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:03:22 -0400
Received: from h1778886.stratoserver.net ([85.214.133.74]:42994 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1I1IDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:03:16 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC] Add gpio based voltage switching regulator
Date: Wed, 28 Sep 2011 10:02:54 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
References: <201109260852.19859.heiko@sntech.de> <20110926125155.GH2946@opensource.wolfsonmicro.com>
In-Reply-To: <20110926125155.GH2946@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109281002.57101.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

thanks for your comments.

Am Montag, 26. September 2011, 14:51:55 schrieb Mark Brown:
> On Mon, Sep 26, 2011 at 08:52:18AM +0200, Heiko Stübner wrote:
> > This patch adds support for regulators that can switch between
> > two voltage levels by setting a gpio.
> 
> This really should be scalable beyond two voltages, or at least prepared
> for that possibility.
I think I've come up with a solution for this but would like to make sure I'm
on the right track. So my general idea is to define the platform_data like

static struct switched_voltage_config es600_dcdc3 = {
[...]
	.switch_gpios = {
		GPIO1, /* bit 0 in matrix */
		GPIO2, /* bit 1 in matrix */
	},
	.nr_switch_gpios = 2,
	.switch_matrix = {
		{ .microvolts = 1000000, .gpio_state = (0 << 1) | (0 << 0) },
		{ .microvolts = 1100000, .gpio_state = (0 << 1) | (1 << 0) },
		{ .microvolts = 1200000, .gpio_state = (1 << 1) | (0 << 0) },
		{ .microvolts = 1300000, .gpio_state = (1 << 1) | (1 << 0) },
	},
	.nr_switch_matrix = 4,
[...]
};

i.e. each voltage keeps the target gpio state in a bit-field which makes the
mapping current_state -> voltage in get_voltage very easy.

set_voltage would then look like

	gpio_state = get_gpio_state_for_voltage(microvolts);
	for(ptr = 0; ptr < nr_switch_gpios; ptr++) {
		state = ( gpio_state & (1 << ptr) ) >> ptr;
		gpio_set_value(switch_gpios[ptr], state);
	}

i.e. simply extracting the target setting from the bitfield for each gpio.

If using integers for the state, this would scale up to 16 gpios and
voltage-permutations thereof.

Reasonable?

> > Handling of set_voltage calls with a range that fits neither the
> > low nor the high voltage is determined by the inbetween_high
> > option. When set to 1 the high voltage is used, on 0 the low
> > voltage is used and on -EINVAL an error is returned, disallowing
> > the usage of the voltage range.
> 
> No, don't do this.  If you can't set the requested voltage then fail.
> This is not in the least bit driver specific.
ok

> > @@ -0,0 +1,320 @@
> > +/*
> > + * switched.c
> 
> This needs a better name.
"gpio-regulator"?

I'm quite open to suggestions :-)

> Otherwise this looks good, the main thing is the ability to support more
> voltages.

Heiko
