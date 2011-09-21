Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1IUTqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:46:05 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7892 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1IUTqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:46:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Sep 2011 12:45:55 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Date: Wed, 21 Sep 2011 12:45:52 -0700
Subject: RE: [PATCH 1/2] drivers: create a pin control subsystem v7
Thread-Topic: [PATCH 1/2] drivers: create a pin control subsystem v7
Thread-Index: Acx4P0bW05cpOsHiQ/miALRGMXXsdAAVyqtw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1738180167@HQMAIL01.nvidia.com>
References: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321751@HQMAIL01.nvidia.com>
 <CACRpkdZyhkydTutHXfry_dUPK_Ts_jq+5VHcr8XdgrHSExTyww@mail.gmail.com>
In-Reply-To: <CACRpkdZyhkydTutHXfry_dUPK_Ts_jq+5VHcr8XdgrHSExTyww@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Wednesday, September 21, 2011 3:17 AM:
> On Tue, Sep 20, 2011 at 11:58 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Friday, September 16, 2011 6:13 AM:
> >> This creates a subsystem for handling of pin control devices.
> >> These are devices that control different aspects of package
> >> pins.
> >
> > I've read through the documentation and header files, but not the .c files,
> > and this looks almost perfect as far as I can tell right now. I'll try to
> > review the .c files sometime too.
> 
> Great, I'm hunting your Acked-by/Reviewed-by ...

Very close; I was just holding off until we resolved the discussion on
hog'd non-system mapping table entries, and I figured I'd wait until v8
which presumably would delete the pinmux_config function from the header?

> I will likely request inclusion into linux-next soon-ish.
> 
> > I just have one comment:
> >
> >> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
> > ...
> >> +/* External interface to pinmux */
> >> +extern int pinmux_request_gpio(unsigned gpio);
> >> +extern void pinmux_free_gpio(unsigned gpio);
> >> +extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
> >> +extern void pinmux_put(struct pinmux *pmx);
> >> +extern int pinmux_enable(struct pinmux *pmx);
> >> +extern void pinmux_disable(struct pinmux *pmx);
> >> +extern int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data);
> >
> > That definition of pinmux_config doesn't seem as useful as it could be;
> 
> It should be removed. It's just there in the header file, I killed off
> the implementation because specific control of a mux doesn't make
> sense. We want to do stuff to pin groups directly, not related to
> muxing, so that kind of thing needs to be in the generic pinctrl
> interface.

OK.

> > I'd like the ability to execute pinmux_config on a /named/ group, and I
> > can certainly see a use-case for applying it to /named/ pins too.
> 
> That sounds correct to me.
> 
> To abstract things the stuff we can do with the group should be
> something enumerated too. So:
> 
> pinctrl_config_group(const char *pinctrl_device, const char *group,
> const char *mode);
> pinctrl_config_pin(const char *pinctrl_device, int pin, const char *mode);
> 
> So the driver need an API to enumerate pin and group modes.
> 
> I might want to save this thing for post-merge of the basic API and
> pinmux stuff though so we don't try to push too much upfront
> design at once.

Yes, adding in a replacement _config API can certainly be a later patch.

One comment on the API above: I think you want "mode" (or "setting"?)
/and/ a value parameter; Tegra's pull strength definition for example
is:

enum tegra_pull_strength {
        TEGRA_PULL_0 = 0,
        TEGRA_PULL_1,
// ... (every value in between)
        TEGRA_PULL_30,
        TEGRA_PULL_31,
        TEGRA_MAX_PULL,
};

And it seems better to represent that as ("pull", 0) ... ("pull", 31) than
"pull0" .. "pull31" such that the value needs to be parsed out of the "mode"
string somehow by the driver.

-- 
nvpublic

