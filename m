Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2E3Gqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:46:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57232 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2E3Gqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:46:45 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 6/6] pinctrl: add pinctrl gpio binding support
To: Dong Aisheng <dongas86@gmail.com>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
In-Reply-To: <CAA+hA=QT83wqe8MOi4B4xY4zTGbQPVhKxwuU_A+cPg-U3JicGw@mail.gmail.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-6-git-send-email-b29396@freescale.com> <20120526002950.062683E14F7@localhost> <CAA+hA=QT83wqe8MOi4B4xY4zTGbQPVhKxwuU_A+cPg-U3JicGw@mail.gmail.com>
Date: Wed, 30 May 2012 14:46:41 +0800
Message-Id: <20120530064641.26D383E065C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2012 09:58:06 -0700, Dong Aisheng <dongas86@gmail.com> wrote:
> On Fri, May 25, 2012 at 5:29 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Fri, 25 May 2012 21:36:20 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> >> From: Dong Aisheng <dong.aisheng@linaro.org>
> >>
> >> This patch implements a standard common binding for pinctrl gpio ranges.
> >> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
> >> under their pinctrl devices node with the format:
> >> <&gpio $gpio-specifier $pin_offset $count>
> >> while the gpio phandle and gpio-specifier are the standard approach
> >> to represent a gpio in device tree.
> >> Then we can cooperate it with the gpio xlate function to get the gpio number
> >> from device tree to set up the gpio ranges map.
> >>
> >> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
> >> to parse and register the gpio ranges from device tree.
> >>
> >> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> >> ---
> >> Personally i'm not very satisfied with current solution due to a few reasons:
> >> 1) i can not user standard gpio api to get gpio number
> >> 2) i need to reinvent a new api of_parse_phandles_with_args_ext which i'm not
> >> sure if it can be accepted by DT maintainer.
> >
> > Right, as mentioned in my other email, doing it this way completely
> > breaks the way the phandle-with-args pattern works.  That pattern
> > depends on the phandle node to have a #-cells property telling it how
> > many cells to process for the binding.  Adding additional data cells
> > means the kernel is no longer able to parse multiple entries in the
> > gpios property.
> Hmm, it can still parse multiple entries in the gpios property except
> that it adds two args although it's not related to gpio, but it is useful
> for users for special case like pinctrl gpio ranges map.

Really?  How exactly does it know that each record is longer than
#gpio-cells specifies (I'm speaking from the binding level; not having
custom code that just "knows" the the records have additional
padding).

I have no interest in creating exceptions to the phandle-with-args
pattern since it adds yet more implicit knowledge about how to parse.
For example, the common gpio code can no longer parse a gpios property
that is padded out because the common code doesn't know anything about
padding.

g.

> > Hmmm.... I need more information about this gpio-maps property.  How
> > is it arranged?  What kind of data is in it.  Can you give some
> > specific examples of how hardware would be described with a gpio-maps
> > property?
> >
> For exampe:
> MX6Q_PAD_SD2_DAT2__GPIO_1_13 means MX6Q_PAD_SD2_DAT2 can be used as GPIO_1_13,
> For reference gpio1,13, we usually do: xx-gpios = <gpio1 13 0> in device tree.
> Here we want to create a pin map of gpio1,13 to MX6Q_PAD_SD2_DAT2 for
> pinctrl gpio ranges map,
> the format should be <GPIO_NUMBER PIN_ID NPINS>, then the pinctrl core
> can automatically mux
> the PIN_ID to gpio function by refer to this map.
> For GPIO_NUMBER, we want to use the standard gpio dt represent way
> since the gpio base may
> be dynamically.
> Assume MX6Q_PAD_SD2_DAT2 pin id is 1 and only one pin starting from it
> can be used as gpio.
> Then the gpio-maps for MX6Q_PAD_SD2_DAT2 can be:
> gpio-maps = <gpio1 13 0 1 1>
> 
> We may have several pins can be used as gpio on mx6q.
> Then the gpio-maps may becomes:
> gpio-maps = <gpio1 13 0 1 1>,
>                    <gpio1 14 0 5 1>,
>                    <gpio2 0 0 20 1>,
>                    ................
> 
> Since the format is a little different from the standard gpio
> represent way, so i can not use the standard gpio
> api to parse the gpio number. That's why i need to invent
> of_parse_phandle_args_ext function for this special
> format.
> 
> we still did not find any better way to do that.
> Do you have any suggestion for this special case?

Oh, I see....  Does this gpio-maps property sit beside a normal
"gpios" property?  Or is it in a completely separate node?  If it sits
beside a normal "gpios" property and lines up with the gpio properties
there, then I would just make it a tuple for each gpio.  Ie:

gpios = <&gpio1 13 0>, <&gpio1 14 0>, <&gpio2 0 0>;
gpio-pinmux = <1 1>,   <5 1>,         <20 1>;

g.

