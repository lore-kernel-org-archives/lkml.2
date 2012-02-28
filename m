Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2B1DfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 22:35:18 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:47769 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2B1DfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 22:35:16 -0500
X-SpamScore: -25
X-BigFish: VS-25(zz9371I146fK179dN1432Nea8N98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 28 Feb 2012 11:41:30 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/20] pinctrl: Enhance mapping table to support pin
 config operations
Message-ID: <20120228034129.GB1249@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-21-git-send-email-swarren@nvidia.com>
 <20120227122117.GA15593@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCFEF@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCFEF@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 11:02:01AM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Monday, February 27, 2012 5:21 AM:
> > On Sun, Feb 19, 2012 at 11:46:00PM -0700, Stephen Warren wrote:
> > > The pinctrl mapping table can now contain entries to:
> > > * Set the mux function of a pin group
> > > * Apply a set of pin config options to a pin or a group
> > >
> > > This allows pinctrl_select_state() to apply pin configs settings as well
> > > as mux settings.
> > >
> > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ...
> > > +The mapping table may also contain pin configuration entries. It's common for
> > > +each pin/group to have a number of configuration entries that affect it, so
> > > +the table entries for configuration reference an array of config parameters
> > > +and values. An example using the convenience macros is shown below:
> > > +
> > > +static unsigned long i2c_grp_configs[] = {
> > > +	FOO_PIN_DRIVEN,
> > > +	FOO_PIN_PULLUP,
> > > +};
> > > +
> > > +static unsigned long i2c_pin_configs[] = {
> > > +	FOO_OPEN_COLLECTOR,
> > > +	FOO_SLEW_RATE_SLOW,
> > > +};
> > > +
> > > +static struct pinctrl_map __initdata mapping[] = {
> > > +	PIN_MAP_MUX_GROUP("foo-i2c.0", "default", "pinctrl-foo", "i2c0", "i2c0"),
> > > +	PIN_MAP_MUX_CONFIGS_GROUP("foo-i2c.0", "default", "pinctrl-foo", "i2c0", i2c_grp_configs),
> > > +	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", "default", "pinctrl-foo", "i2c0scl", i2c_pin_configs),
> > > +	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", "default", "pinctrl-foo", "i2c0sda", i2c_pin_configs),
> >
> > I still have not read all over this patch.
> > But one question i'm considering is that
> > will this way here also work for "virtual" group?
> > For example, the virtual group "i2c_grp_configs" may actually contains
> > the config for each pin in that group?
> > The core will handle this difference or let each driver to handle it?
> 
> Since the core has no knowledge of virtual groups, everything has to be
> handled inside the pin controller driver: When the core asks the driver
> to enumerate the groups it supports, those virtual groups must be included
> in the list. The mapping table may contain entries to configure those
> virtual groups, which will be passed on to the driver to implement as it
> sees fit. So, in short, yes, I believe this handles virtual groups just
> fine.
> 
Ok, great.

> > > @@ -1022,7 +1074,7 @@ Since it may be common to request the core to hog a few always-applicable
> > >  mux settings on the primary pin controller, there is a convenience macro for
> > >  this:
> > >
> > > -PIN_MAP_SYS_HOG("active", "pinctrl-foo", "power_func")
> >
> > Hmm?
> > Why remove this one?
> 
> In the patch I posted, I simplified the mapping table macros by replacing
> all mux entries with a single macro PIN_MAP_MUX_GROUP(). However, I've
> since modified the patch to include a number of special-case macros, so
> this macro has been added back (albeit under a slightly different name).
>
Sounds good.

> > > +int pinctrl_get_pin_id(struct pinctrl_dev *pctldev,
> > > +		       const char *pin)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < pctldev->desc->npins; i++) {
> > > +		if (pctldev->desc->pins[i].name == NULL)
> > > +			continue;
> > > +		if (!strcmp(pin, pctldev->desc->pins[i].name)) {
> > > +			dev_dbg(pctldev->dev, "found pin id %u for %s\n",
> > > +				i, pin);
> > > +			return i;
> >
> > It looks actually this is not a PIN id.
> > It's just the index of the pin array.
> > Pin has its own id:
> > struct pinctrl_pin_desc {
> > 	unsigned number;
> > 	const char *name;
> > };
> 
> I guess I should just delete this function and call pin_get_from_name()
> instead.
> 
> However, this does raise one question:
> 
> Right now, pin_config_set() calls pin_get_from_name() to find the pin
> ID of a pin. This returns that "number" field in the struct above. This
> is then passed to the pin controller driver's pin_config_set() callback.
> Hence, the pin ID value passed to pin_config_set() can't be used to index
> into the driver's own pin_desc array if the pin numbers are sparse. Is
> that intended? I suppose it's OK since any driver-specific information
> about each pin can't be stored in the pin_desc array anyway, since that
> array has a standard type without space for driver-specific data, and
> any driver-specific array would probably be indexed by the values in the
> .number field, not the pin_desc array index.
It's indeed.

Regards
Dong Aisheng

