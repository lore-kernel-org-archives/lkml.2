Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1LERgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:36:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6518 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab1LERgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:36:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 05 Dec 2011 09:36:32 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Mon, 5 Dec 2011 09:36:30 -0800
Subject: RE: [PATCH 2/2 v5] pinctrl: introduce generic pin config
Thread-Topic: [PATCH 2/2 v5] pinctrl: introduce generic pin config
Thread-Index: AcyzZxdoztcfhJo6Q7q82gr3EztjegADGQMA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B7703C@HQMAIL01.nvidia.com>
References: <1322736902-11297-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDB0312@HQMAIL01.nvidia.com>
 <CACRpkdaGaYdQagOkFxfRpV=oxyxab40X5zzpeCamTCksuHQAaw@mail.gmail.com>
In-Reply-To: <CACRpkdaGaYdQagOkFxfRpV=oxyxab40X5zzpeCamTCksuHQAaw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, December 05, 2011 9:01 AM:
> On Thu, Dec 1, 2011 at 10:56 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote: 
...
> >> +enum pin_config_param {
> >> +     PIN_CONFIG_BIAS_DISABLE,
> >> +     PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
...
> >> +     PIN_CONFIG_WAKEUP,
> >> +     PIN_CONFIG_END,
> >> +};
> >
> > This enum conflates both "parameter" and "value" into a single enum space.
> 
> I call these "parameter" and "argument" but I get it.
> 
> > The patch introduces to_config_packed() and friends specifically to pack
> > both param and value into a single unsigned long, but then defines the
> > "param" to encompass "value" as well. That seems inconsistent. Instead,
> > shouldn't you have something more like:
> >
> > enum pin_config_param {
> >        PIN_CONFIG_BIAS,
> >        PIN_CONFIG_DRIVE,
> >        PIN_CONFIG_INPUT_SCHMITT,
> >        PIN_CONFIG_INPUT_DEBOUNCE,
...
> >        PIN_CONFIG_WAKEUP,
> >        PIN_CONFIG_END,
> > };
> >
> > /* Value for PIN_CONFIG_BIAS */
> > enum pin_config_bias_value {
> >        PIN_CONFIG_BIAS_DISABLE,
> >        PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
> >        PIN_CONFIG_BIAS_PULL_UP,
> >        PIN_CONFIG_BIAS_PULL_DOWN,
> >        PIN_CONFIG_BIAS_HIGH,
> >        PIN_CONFIG_BIAS_GROUND,
> > };
> 
> But if I can control the resistance of the pull-up resistor
> that brings us to a triplet: {parameter, type, argument}
> like this to set the generic pull-up to 100 kOhm:
> 
> set_generic_bias(PIN_CONFIG_BIAS, PIN_CONFIG_BIAS_PULL_UP, 100000);
> 
> parameter = BIAS
> type = PULL_UP
> argument = 100 kOhm

I think that selecting what the value of pull-up is and enabling/disabling
pull-up are separate things, so you'd have:

set PIN_CONFIG_PULL_UP_RESISTANCE 100000
set PIN_CONFIG_BIAS PULL_UP

Of course, this probably ties into which of the following options your chip
HW has:

a) Pull-up 100K or pull-up 10K or pull-down or tri-state

b) Pull-up or pull-down or tri-state, with a second register field to
set pull-up at 100k or 10k.

... which then goes back to the discussion of whether attempting to
shoe-horn every SoC into a standardized parameter set makes sense.

> I essentially squash { parameter, type } into a single
> enum here, then use the argument to supply the
> value.
> 
> > /* Value for PIN_CONFIG_DRIVE */
> > enum pin_config_drive_value {
> >        PIN_CONFIG_DRIVE_PUSH_PULL,
> >        PIN_CONFIG_DRIVE_OPEN_DRAIN,
> >        PIN_CONFIG_DRIVE_OPEN_SOURCE,
> >        PIN_CONFIG_DRIVE_OFF,
> > };
> >
> > /*
> >  * Value for:
> >  * PIN_CONFIG_INPUT_SCHMITT,
> >  * PIN_CONFIG_INPUT_DEBOUNCE,
> 
> Don't you mean we would then have
> 
> pin_config_param {
>    PIN_CONFIG_INPUT_MODE,
>    ...
> }
> 
> enum pin_config_input_mode_value {
>     PIN_CONFIG_INPUT_MODE_SCHMITT,
>     PIN_CONFIG_INPUT_MODE_DEBOUNCE,
> };

Schmitt and debounce seem like completely orthogonal HW features to me,
so I wouldn't make them mutually exclusive.

> >  * PIN_CONFIG_LOW_POWER_MODE,
> >  * PIN_CONFIG_WAKEUP,
> >  * PIN_CONFIG_END,
> >  */
> 
> etc.
> 
> I think it might be sub-dividing it too much, but it certainly
> doesn't hurt the implementation much to split it in three,
> say 8 bits parameter 8 bits type 16 bits argument if that is
> preferable what do others say?

That doesn't seem quite right to me. I guess I can't really describe why
though; it just feels wrong to be going that way.

-- 
nvpublic

