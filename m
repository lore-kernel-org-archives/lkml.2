Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab2B0JA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:00:56 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:48829 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2B0JAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:00:55 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 27 Feb 2012 17:07:22 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/20] pinctrl: API changes to support multiple states
 per device
Message-ID: <20120227090721.GB26061@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-20-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329720360-23227-20-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:45:59PM -0700, Stephen Warren wrote:
> The API model is changed from:
> 
> p = pinctrl_get(dev, "state1");
> pinctrl_enable(p);
> ...
> pinctrl_disable(p);
> pinctrl_put(p);
> p = pinctrl_get(dev, "state2");
> pinctrl_enable(p);
> ...
> pinctrl_disable(p);
> pinctrl_put(p);
> 
> to this:
> 
> p = pinctrl_get(dev);
> s1 = pinctrl_lookup_state(p, "state1");
> s2 = pinctrl_lookup_state(p, "state2");
> pinctrl_select_state(p, s1);
> ...
> pinctrl_select_state(p, s2);
> ...
> pinctrl_put(p);
> 
> This allows devices to directly transition between states without
> disabling the pin controller programming and put()/get()ing the
> configuration data each time. This model will also better suit pinconf
> programming, which doesn't have a concept of "disable".
> 
It's exactly what we discussed and wanted.
Thank for the great and hard work.

> The special-case hogging feature of pin controllers is re-written to use
> the regular APIs instead of special-case code. Hence, the pinmux-hogs
> debugfs file is removed; see the top-level pinctrl-handles files for
> equivalent data.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  Documentation/pinctrl.txt         |  153 ++++++++-----
>  arch/arm/mach-u300/core.c         |   28 +--
>  drivers/pinctrl/core.c            |  491 +++++++++++++++++--------------------
>  drivers/pinctrl/core.h            |   24 ++-
>  drivers/tty/serial/sirfsoc_uart.c |   12 +-
>  include/linux/pinctrl/consumer.h  |   55 ++++-
>  include/linux/pinctrl/machine.h   |   21 +-
>  7 files changed, 408 insertions(+), 376 deletions(-)
> 

>  
> @@ -814,7 +817,7 @@ it even more compact which assumes you want to use pinctrl-foo and position
>  0 for mapping, for example:
>  
>  static struct pinctrl_map __initdata mapping[] = {
> -       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> +       PIN_MAP("default", "pinctrl-foo", "i2c0", "foo-i2c.0"),
I remember you said you will also change the PIN_MAP sequence that
place the device name at first.
Will see your further patch.

>  The result of grabbing this mapping from the device with something like
>  this (see next paragraph):
>  
> -	p = pinctrl_get(&device, "8bit");
> +	p = pinctrl_get(dev);
> +	s = pinctrl_lookup_state(p, "8bit");
> +	ret = pinctrl_select_state(p, s);
> +
> +or more simply:
> +
> +	p = pinctrl_get_select(dev, "8bit");
>  
Very glad to see this simply one. :-)

>  foo_probe()
>  {
> -	/* Allocate a state holder named "state" etc */
> -	struct pinctrl p;

> +	/* Allocate a state holder named "foo" etc */
> +	struct foo_state *foo = ...;
>  
> -	p = pinctrl_get(&device, "default");
> -	if IS_ERR(p)
> -		return PTR_ERR(p);
> -	pinctrl_enable(p);
> +	foo->p = pinctrl_get(&device);
> +	if (IS_ERR(foo->p)) {
> +		/* FIXME: clean up "foo" here */
> +		return PTR_ERR(foo->p);
> +	}
> +
> +	foo->s = pinctrl_lookup_state(foo->p, "default");
> +	if (IS_ERR(foo->s)) {
> +		pinctrl_put(foo->p);
> +		/* FIXME: clean up "foo" here */
> +		return PTR_ERR(s);
> +	}
>  
> -	state->p = p;
> +	ret = pinctrl_select_state(s);
s/s/foo->s

> @@ -976,25 +1004,25 @@ System pin control hogging
>  ==========================
>  
>  Pin control map entries can be hogged by the core when the pin controller
> -is registered. This means that the core will attempt to call pinctrl_get() and
> -pinctrl_enable() on it immediately after the pin control device has been
> -registered.
> +is registered. This means that the core will attempt to call pinctrl_get(),
> +lookup_state() and select_state() on it immediately after the pin control
> +device has been registered.
>  
> -This is enabled by simply setting the .dev_name field in the map to the name
> -of the pin controller itself, like this:
> +This occurs for mapping table entries where the client device name is equal
> +to the pin controller device name, and the state name is "active".
>  
>  {
> -	.name = "POWERMAP"
> +	.dev_name = "pinctrl-foo",
> +	.name = "active",
I guess if we really decide to use a fixed state name for hog functions,
we'd better not let users to write the state name, at least provide a macro.

>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "power_func",
> -	.dev_name = "pinctrl-foo",
>  },
>  
>  Since it may be common to request the core to hog a few always-applicable
>  mux settings on the primary pin controller, there is a convenience macro for
>  this:
>  
> -PIN_MAP_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
> +PIN_MAP_SYS_HOG("active", "pinctrl-foo", "power_func")
I remember you had a patch changing this macro a bit.
So here may also need change.

> +static struct pinctrl *find_pinctrl(struct device *dev)
> +{
> +	struct pinctrl *p;
>  
> -	dev_dbg(dev, "pinctrl_get() for state %s\n", name);
> +	list_for_each_entry(p, &pinctrldev_list, node)
s/pinctrldev_list/pinctrl_list ?

> +static struct pinctrl *pinctrl_get_locked(struct device *dev)
> +{
> +	struct pinctrl *p;
>  
> -error:
> -	list_for_each_entry(setting, &p->settings, node)
> -		pinmux_free_setting(setting);
> +	if (WARN_ON(!dev))
> +		return ERR_PTR(-EINVAL);
>  
> -	kfree(p);
> +	p = find_pinctrl(dev);
> +	if (p == NULL)
> +		p = create_pinctrl(dev);
> +	if (IS_ERR(p))
> +		return p;
> +
> +	p->usecount++;
I still can not understand what's the purpose of p->usecount?
For allowing multi times calling of pinctrl_get for on the same device?

> +static inline struct pinctrl * __must_check pinctrl_get_select(
> +					struct device *dev, const char *name)
> +{
> +	struct pinctrl *p;
> +	struct pinctrl_state *s;
> +	int ret;
> +
> +	p = pinctrl_get(dev);
> +	if (IS_ERR(p))
> +		return p;
> +
> +	s = pinctrl_lookup_state(p, name);
> +	if (IS_ERR(s)) {
> +		pinctrl_put(p);
> +		return ERR_PTR(PTR_ERR(s));
> +	}
> +
> +	ret = pinctrl_select_state(p, s);
> +	if (ret < 0) {
> +		pinctrl_put(p);
> +		return ERR_PTR(ret);
s/ERR_PTR(ret)/ret ?

Regards
Dong Aisheng

