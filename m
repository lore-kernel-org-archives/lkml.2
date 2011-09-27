Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1I0IA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:00:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45489 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1I0IA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 04:00:58 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1738180164@HQMAIL01.nvidia.com>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321777@HQMAIL01.nvidia.com>
	<CACRpkdY5ETbJxSpwJL-7KZhjOnhwrdT1=djwByek75ye=S9L9w@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1738180164@HQMAIL01.nvidia.com>
Date: Tue, 27 Sep 2011 10:00:56 +0200
Message-ID: <CACRpkdbiWUFPfF9vKV5YpSW68ZTdjwb8NhWZ_9WDoY5Q+aVfvQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 9:39 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Wednesday, September 21, 2011 2:25 AM:
>> On Wed, Sep 21, 2011 at 12:15 AM, Stephen Warren <swarren@nvidia.com> wrote:
>> > Linus Walleij wrote at Friday, September 16, 2011 6:14 AM:
>> >> +     for (i = 0; i < ARRAY_SIZE(u300_mux_hogs); i++) {
>> >> +             struct pinmux *pmx;
>> >> +             int ret;
>> >> +
>> >> +             pmx = pinmux_get(u300_mux_hogs[i].dev, NULL);
>> >> +             if (IS_ERR(pmx)) {
>> >> +                     pr_err("u300: could not get pinmux hog %s\n",
>> >> +                            u300_mux_hogs[i].name);
>> >> +                     continue;
>> >> +             }
>> >> +             ret = pinmux_enable(pmx);
>> >> +             if (ret) {
>> >> +                     pr_err("u300: could enable pinmux hog %s\n",
>> >> +                            u300_mux_hogs[i].name);
>> >> +                     continue;
>> >> +             }
>> >> +             u300_mux_hogs[i].pmx = pmx;
>> >> +     }
>> >> +     return 0;
>> >> +}
>> >> +subsys_initcall(u300_pinmux_fetch);
>> >
>> > Why not just have the pinmux core support hogging on non-"system" mapping
>> > entries; then everything I quoted above except u300_pinmux_map[] could
>> > be deleted, and the "hog" flag set on the last 3 u300_pinmux_map[] entries.
>>
>> Very good question, luckily I have a good answer.
>>
>> There is no way for the pinmux core to traverse the system and look
>> up the apropriate struct device * pointers.
>
> It's unclear to me why that would be needed.
>
> For non-system mappings, either the device-driver in question will be
> get'ing and enabling them (this case isn't relevant to this discussion),
> or they'll be hogged. In the hog case, I doubt anything would ever want
> to disable them and switch the device to a different mapping entry; if
> that were the case, the entries shouldn't be hogged, but get/enabled by
> the device anyway. Hence, I don't see the need for an activation of a
> hog'd non-system mapping entry to care about the device fields that are
> in the mapping table at all; they could just be ignored couldn't they?

I don't think so, atleast not in this case. I think it is helpful for the system
to know which device is related to the specific hog, so it turns up in
debugfs etc "aha, it is hogged for that device" etc. Not doing that
makes the subsystem loose relevant information.

So for that reason I prefer to pass in the relevant struct device *
pointers, atleast when they're readily available as in this boardfile.

If they are not available, or hard to get at, we could just redefine
them as system mappings and remove the device fields, but
in this case I'd say let's keep it around.

Yours,
Linus Walleij
