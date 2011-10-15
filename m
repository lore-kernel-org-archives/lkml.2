Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1JODBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 23:01:46 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:13580
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab1JODBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 23:01:45 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371K168aJ1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 15 Oct 2011 11:12:16 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stijn Devriendt <highguy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
Subject: Re: pinctrl_config APIs, and other pinmux questions
Message-ID: <20111015031215.GA29039@S2100-06.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
 <20111014145900.GA28728@S2100-06.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A275@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A275@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 08:53:33AM -0700, Stephen Warren wrote:
> Shawn Guo wrote at Friday, October 14, 2011 8:59 AM:
> > It might be a good place for me to catch up the pinctrl subsystem
> > discussion, as far as imx migration concerned.
> > 
> > I have not read the backlog of all the previous discussion, so please
> > excuse me if something I put here have been discussed.
> > 
> > On Thu, Oct 13, 2011 at 01:59:55PM -0700, Stephen Warren wrote:
> > > Linus, (and other people interested in pinmux!)
> > >
> > > I've started to look at porting the Tegra pinmux driver to your pinctrl
> > > subsystem. In order to replace the existing pinmux driver, I need a way
> > > to support configuring options such as tri-state, pull-up/down, drive-
> > > strength, etc.
> ...
> > > 2) Enhance the pin controller subsystem to support configuring these
> > > properties.
> >
> > Yeah.  I remember Linus.W originally named the subsystem pinmux and
> > changed it to pinctrl later for that he wants to cover not only pinmux
> > but also pin/pad configuration with this subsystem.
> 
> AIUI, the pin control subsystem is intended to encompass both pin muxing
> and pin configuration, it's just that the pin configuration part isn't
> fleshed out yet, and will be via a separate ops structure that the overall
> driver can provide.
> 
> ...
> > > I propose adding the following to pinctrl_ops:
> > >
> > > int (*pin_config)(unsigned pin, u32 param, u32 data);
> > > int (*group_config)(unsigned group, u32 param, u32 data);
> ...
> > > Having both config_pin and config_group functions:
> > >
> > > Tegra at least has settings that are applicable to groups. Most (all??)
> > > other SoCs apply configurations to individual pins. I think we need
> > > separate functions to make this explicit, so the function knows if it's
> > > looking up selector as a pin name (ID) or a group name (ID).
> > >
> > The "group" defined in this subsystem does not necessarily require
> > multiple pins be controlled by single register at hardware level.
> > A group of pins muxed for given function can be controlled by hardware
> > in the way of individual pin.  Similar to pinmux, I guess that the
> > interface between pincfg and core can take group only, and leave the
> > mapping between group and pins to the driver.  Single-pin function can
> > be a particular case of group-pins.
> 
> That's true; we could define a group for each pin, which no function uses
> as a legal group/position, but does allow config() to be used.
> 
> > > Issue 2: Do we need a new "pin settings" table passed from the board to
> > > the pin controller core?
> > >
> > > Issue 3: Do we need to change "pin settings" on-the-fly, or only at boot?
> ...
> > > However, if we ever want things to change dynamically (say, suspend/
> > > resume), or only be activated when a device initializes (just like the
> > > mux settings), we need to enhance struct pinmux_map to contain either
> > > mux settings or config settings; perhaps rework it as follows:
> >
> > I would think that we need to enhance pinmux_map to contain both mux
> > *and* config settings.  To me, the mapping seems to be a group of pins
> > with specific mux and config settings for a given function.
> > 
> > > enum pinmux_map_type {
> > >     MUX,
> > >     PIN_CONFIG,
> > >     GROUP_CONFIG
> > > };
> > >
> > > struct pinmux_map {
> > >         const char *name;
> > >         struct device *ctrl_dev;
> > >         const char *ctrl_dev_name;
> > >         enum pinmux_map_type type;
> > >         union {
> > >             struct {
> > >                 const char *function;
> > >                 const char *group;
> > >             } mux;
> > >             struct {
> > >                 u32 param;
> > >                 u32 data;
> > >             } config;
> > >         } data;
> > >         struct device *dev;
> > >         const char *dev_name;
> > >         const bool hog_on_boot;
> > > };
> > 
> > If the config has limited number of possible settings for given
> > function, we can probably enumerate it in pinctrl driver just like
> > what we are doing with pinmux option, and add parameter "config" to
> > pinmux_map to select pincfg option for given mapping.
> > 
> > @@ -46,6 +46,7 @@ struct pinmux_map {
> >         const char *ctrl_dev_name;
> >         const char *function;
> >         const char *group;
> > +       const char *config;
> >         struct device *dev;
> >         const char *dev_name;
> >         const bool hog_on_boot;
> > 
> > > Such that pinmux_enable would both activate all the mux settings, and
> > > also call pin/group_config based on the mapping table.
> 
> Having the driver expose a list of all possible combinations of pin
> configurations seems impractical, for the same reason as I objected to
> the original proposal for how the driver listed functions; there are
> simply far too many pin config parameters and legal value to list the
> entire set of combinations.
> 
I did not mean to list the entire set of combinations.  For given
function, the applicable number of config should be very limited.
For most cases, it could be just one.  For imx6q usdhc example, it's
3, for 50M, 100M and 200M SD bus clock cases.

Regards,
Shawn

