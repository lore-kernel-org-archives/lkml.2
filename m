Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2HTJqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:46:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34959 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2HTJqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:46:14 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda0wUW4E3y=ucGRFu5fwwyFWo2dc=4qBaH6CFSOW2ZL_A@mail.gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkda0wUW4E3y=ucGRFu5fwwyFWo2dc=4qBaH6CFSOW2ZL_A@mail.gmail.com>
Date: Mon, 20 Aug 2012 11:46:14 +0200
Message-ID: <CABJ1b_TCF=Jfb0uuoh-M87n6faezj4OqZ4S_nJLA0yKga2-ioQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: mvebu: pinctrl driver core
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/12, Linus Walleij <linus.walleij@linaro.org> wrote:
> Are you taking this patch series through some Marvell tree or do you want
> me to carry it in the pinctrl tree?

Hi Linus,

I think it would be better to take it through the Marvell tree of Jason
Cooper. It is only for Marvell SoCs anyway.

>> +uart1: serial@12100 {
>> +       compatible = "ns16550a";
>> +       reg = <0x12100 0x100>;
>> +       reg-shift = <2>;
>> +       interrupts = <7>;
>> +       clock-frequency = <166666667>;
>
> It's got nothing to do with this patch, but getting a clock frequency
> out of the DT instead of getting it from the clk_get_rate(clk) and
> the clock tree seems absurd... (But maybe this platform does not
> even have a clk implementation?)

It's of_serial's implementation. I patched that once for getting
frequency out of "clocks" property but then I got busy with
porting mach-dove and pinctrl.. Marvell SoCs do have a clk
implementation and as soon as of_serial can handle "clocks"
property it will be used for sure. I can remove "clock-frequency"
from the example anyway as it is not really part of pinctrl
binding documentation.

> (...)
>> +#include <linux/pinctrl/consumer.h>
>
> Why are you including this header?
> (There are valid reasons, state them in a comment,
> e.g. /* to access pinctrl_gpio* in GPIO portions */)

I guess it was a left-over from my experiments with
default pinmux configuration until you pointed me to
the correct way of having the pinctrl itself hog muxes.

I'll remove that include.

>> +struct mvebu_pinctrl {
>> +       struct device *dev;
>> +       struct pinctrl_dev *pctldev;
>> +       struct pinctrl_desc desc;
>> +       void __iomem *base;
>> +       struct mvebu_pinctrl_group *groups;
>> +       unsigned num_groups;
>> +       struct mvebu_pinctrl_function *functions;
>> +       unsigned num_functions;
>> +       unsigned variant;
>> +};
>
> There is some other "variant" field elsewhere that is
> a u8, is this correct? In this and the other case, should
> this "variant" rather be an enum?

I'll review the variant types but inside pinctrl-mvebu variant
is used as a bit mask to distinguish different variants. Anyway,
they should always be the same size.

>> +static int mvebu_common_mpp_get(struct mvebu_pinctrl *pctl,
>> +                               struct mvebu_pinctrl_group *grp,
>> +                               unsigned long *config)
>> +{
>> +       unsigned pin = grp->gid;
>> +       unsigned off = (pin / 8) * 4;
>> +       unsigned shift = (pin % 8) * 4;
>
> Some magic numbers here. Either use relevant #define:s or
> put an inline comment that explains what is going on.

Ok.

>> +static void mvebu_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
>> +                               struct pinctrl_map *map, unsigned
>> num_maps)
>> +{
>> +       kfree(map);
>> +}
>
> Is it possible to use devm_* managed devm_kzalloc() for this map
> so you don't need to free it explicitly?
>
> (Maybe not, just checking.)

Hmm, I guess not as I thought I've read not to use devm_kfree when
you allocate _and_ free stuff on runtime without removing the device
itself, right?

>> diff --git a/drivers/pinctrl/pinctrl-mvebu.h
>> b/drivers/pinctrl/pinctrl-mvebu.h
> (...)
>> +/*
>
> Kerneldoc begins with /** have you really tested to generate
> kerneldoc?

Nope, I wasn't even aware of that, sorry. I just copied it over
from some other pinctrl include. I'll check for compatibility with
kerneldoc.

>> +struct mvebu_mpp_ctrl {
>> +       const char *name;
>> +       u8 pid;
>> +       u8 npins;
>
> So, there will never be > 256 pins on a Marvell platform?

Well, with all current platforms we are well below 100. I guess
256 max (muxable) pins will be enough.

>> + * struct mvebu_mpp_ctrl_setting - describe a mpp ctrl setting
>> + * @val: ctrl setting value
>
> It is not obvious to me what this means, it it possible to elaborate
> on how this member is defined and used?

Well, I see if I can clarify the description but wrt the datasheet it
_should_ be quite obvious.

>> + * @variant: (optional) variant identifier mask
>
> This thing again, there are lots of "variants" around here.
> Is it a candidate for an enum?

As it is a mask, I don't think enum fits here.

>> + * @flags: (private) flags to store gpi/gpo/gpio capabilities
>
> Write something about the two available flags and what they
> mean maybe?

Ok.

>> +#define  MVEBU_SETTING_GPO     (1 << 0)
>> +#define  MVEBU_SETTING_GPI     (1 << 1)
>
> So these are the possible flags I suspect. (Looking good.)

Yes, some mpp pins on Marvell SoCs are out-only, while
normally they are in-out. I haven't seen in-only yet but better
to have the flags ready if someone stumbles upon one.

>> +#if defined(CONFIG_DEBUG_FS)
>> +#define MPP_VAR_FUNCTION(_val, _name, _subname, _mask)         \
>> +       _MPP_VAR_FUNCTION(_val, _name, _subname, _mask)
>> +#else
>> +#define MPP_VAR_FUNCTION(_val, _name, _subname, _mask)         \
>> +       _MPP_VAR_FUNCTION(_val, _name, NULL, _mask)
>> +#endif
>
> This looks a bit kludgy. Is the purpose to save memory
> if debugfs is not used?

Yes, that was the intention. Subnames are not used by pinctrl at all,
other for debugfs files. Although, there are some pins that have two different
settings for the same device name, e.g. sata(prsnt) and sata(act), I don't
think it is a good idea to use the subname but have sata(prsnt) and sata-1(act)
instead. Otherwise, you'll always have to look up the specific function for
each pin. OTOH, I could check for "sata" and take the subname into account
when it is given in marvell,function. But it will not help reducing the required
pinmux descriptions in DT because you still have to distinguish both and
there are only 2 out of ~50 groups that have them for Dove.

> This looks good overall.

Thanks!
In some internal review with Andrew I also added a spinlock to
mvebu_pinconf_get/_set that will protect all calls to generic and specific
_get/_set register accesses. Moreover, I replaced clk_get_sys in pinctrl-dove
with the devm_ counterpart and removed the explicit clk_put.

Sebastian
