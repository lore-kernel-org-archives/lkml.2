Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2B2Gkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:40:41 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:30471
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426Ab2B2Gkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:40:40 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 29 Feb 2012 14:46:34 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/6] pinctrl: API changes to support multiple states
 per device
Message-ID: <20120229064633.GA14703@shlinux2.ap.freescale.net>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <1330460852-23486-5-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330460852-23486-5-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 01:27:30PM -0700, Stephen Warren wrote:
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
> The special-case hogging feature of pin controllers is re-written to use
> the regular APIs instead of special-case code. Hence, the pinmux-hogs
> debugfs file is removed; see the top-level pinctrl-handles files for
> equivalent data.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Make use of PINCTRL_STATE_DEFAULT, split out some documentation
> cleanup into an earlier patch. Various minor fixes. Fixes due to
> rebasing on updated earlier patches. Remove usecount field from struct
> pinctrl; allow only one concurrent pinctrl_get() per device.
> 
Glad to hear this.

The whole patch looks pretty good to me.
A few trivial comments, else
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

> +static struct pinctrl *find_pinctrl(struct device *dev)
> +{
> +	struct pinctrl *p;
> +
> +	list_for_each_entry(p, &pinctrldev_list, node)
s/pinctrldev_list/pinctrl_list ?

> -static void pinctrl_disable_locked(struct pinctrl *p)
> +static int pinctrl_select_state_locked(struct pinctrl *p,
> +				       struct pinctrl_state *state)
>  {
> -	struct pinctrl_setting *setting;
> +	struct pinctrl_setting *setting, *setting2;
> +	int ret;
>  
> -	if (p == NULL)
> -		return;
> +	if (p->state == state)
> +		return 0;
>  
> -	if (--p->usecount == 0) {
> -		list_for_each_entry(setting, &p->settings, node)
> -			pinmux_disable_setting(setting);
> +	if (p->state) {
> +		/*
> +		 * The set of groups with a mux configuration in the old state
> +		 * may not be identical to the set of groups with a mux setting
> +		 * in the new state. While this might be unusual, it's entirely
> +		 * possible for the "user"-supplied mapping table to be written
> +		 * that way. For each group that was configured in the old state
> +		 * but not in the new state, this code puts that group into a
> +		 * safe/disabled state.
It means the old state function of some groups may not have been disabled before
enabling the new function mode.
May it be a little error-prone?
Maybe we can not depend on user to disable a function before enable another for
a group when doing pinmux_enable_setting considering they may be different
registers.

> +		 */
> +		list_for_each_entry(setting, &p->state->settings, node) {
> +			bool found = false;
> +			list_for_each_entry(setting2, &state->settings, node) {
> +				if (setting2->group_selector ==
> +						setting->group_selector) {
> +					found = true;
> +					break;
> +				}
> +			}
> +			if (!found)
> +				pinmux_disable_setting(setting);
> +		}
> +	}
> +
> +	p->state = state;
> +
> +	/* Apply all the settings for the new state */
> +	list_for_each_entry(setting, &state->settings, node) {
> +		ret = pinmux_enable_setting(setting);
> +		if (ret < 0) {
> +			/* FIXME: Difficult to return to prev state */
> +			return ret;
> +		}
>  	}
> +
> +	return 0;
>  }
>  
>  /**

Regards
Dong Aisheng

