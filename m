Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab2ERHV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:21:57 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:2021
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758430Ab2ERHVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:21:55 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 18 May 2012 15:26:14 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH RFC 1/1] pinctrl: improve gpio support for dt
Message-ID: <20120518072613.GJ10347@shlinux2.ap.freescale.net>
References: <1337090839-21224-1-git-send-email-b29396@freescale.com>
 <4FB55A35.1010902@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB55A35.1010902@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 04:06:13AM +0800, Stephen Warren wrote:
> On 05/15/2012 08:07 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > For dt, the gpio base may be dynamically allocated, thus the original
> > implementation of gpio support based on static gpio number and pin id
> > map may not be easy to use for dt.
> > 
> > One solution is a) use alias id for gpio node and refer to it in gpio
> > range, then we can get the fixed the gpio devices for this range and
> > b) get gpio chip from node which is specified in gpio range structure,
> > then get the dynamically allocated gpio chip base and c) using the chip
> > gpio base and offset to map to a physical pin id for dt.
> 
> As I just mentioned in response to Shawn's driver, I don't think that
> using the aliases node is the way to go here.
> 
Correct, i originally thought we need alias id to fix the gpio chip we're using,
Now i realized that a gpio np already fix the gpio chip which this range
represents. So i think we should remove alias id.

> Instead, what about the following:
> 
> /*
>  * This function parses property @propname in DT node @np. This property
>  * is a list of phandles, with optional @cellskip cells between them.
>  * For each entry in ranges, the phandle at index
>  * range[i].id * (1 + @cellskip) is written into range[i].np
>  */
> int pinctrl_dt_gpio_ranges_add_np(struct pinctrl_gpio_range *ranges,
> 				  int nranges,
> 				  struct device_node *np,
> 				  const char *propname,
> 				  int cellskip);
> 
> Note: cellskip is usually 0. However, to allow the same code to be used
> for pinctrl-simple/pinctrl-generic's GPIO mapping table, we allow
> additional cells between the phandles.
> 
This is a good idea to find the gpio nodes for the ranges.
I once had a similar idea but felt it's not suitable for one range
taking a list of all gpio nodes as parameter in my original implementation.
But it's very easy fixed by your API, take a list of ranges. :-)

> For example, Tegra might have:
> 
> gpio-controllers = <&tegra_gpio>; // there's just 1
> 
> i.MX23 might have:
> 
> gpio-controllers = <&gpio0 &gpio1 &gpio2 &gpio3>; // it has 4 banks
> 
> whereas pinctrl-simple/pinctrl-generic might want to put the entire
> range table in this property, so might do something like:
> 
> gpio-ranges =	<&gpio0 $gpio_offset $pin_offset $count>
> 		<&gpio1 $gpio_offset $pin_offset $count> ...;
> 
> and hence set cellskip to 3. the pinctrl-simple/pinctrl-generic code
> would need to parse the other 3 cells itself.
> 
I like this way. :-)
You made me come up a few more thoughts on it.
Why shouldn't we use this format as a standard binding way for gpio ranges
in pinctrl core and let core handle it totally for creating the range table?

This format has enough information for core to do that and it is fully comply
with the non-dt implementation way and should work for dt too.
We already parse pinctrl mapping in a standard way in core, so why not gpio
ranges mapping?

For example, i.MX28 might have:
gpio-ranges =	<&gpio0 0 0 8>
 		<&gpio0 16 16 13>
 		<&gpio1 0 32 32>
		.........
Tegra might have:
gpio-ranges = <&tegra_gpio 0 0 TEGRA_GPIO_NUM>;

IMX, similar to pinctrl-generic might have:
gpio-ranges = <&gpio0 0 IMX_PIN_X 1>
	      <&gpio0 1 IMX_PIN_X 1>
	      <&gpio0 2 IMX_PIN_X 1>
	      ..........

The only concern is i'm not sure if any other SoC needs more cells for
this format since we want this to be a standard bind format.
But for now i did not see any need, people may raise it if any.

> The algorithm is roughly:
> 
> prop = get_property(propname)
> for range in ranges:
>     if not range.np:
>         phandle = get_phandle_by_index(prop, range.id);
> 
If doing in the core, user do not need to specify the range.id any more.
Instead, the range.id will be set to -1 by default since the id of gpios
for dt is -1.

> Have a second function that converts the np pointer to gpio chips. This
> could be used if the np field was obtained somewhere other than by
> calling pinctrl_dt_add_np_to_ranges():
> 
> int pinctrl_dt_gpio_ranges_np_to_gc(struct pinctrl_gpio_range *ranges,
> 				    int nranges);
> 
> Note: For any np where of_node_to_gpiochip() fails,
> pinctrl_dt_gpio_ranges_np_to_gc() should return -EPROBE_DEFER so that
> the pinctrl driver can wait for the GPIO driver to probe before continuing.
Correct. We should do like that.

> 
> The algorithm is roughly:
> 
> for range in ranges:
>     if range.gc:
>         continue
>     if not range.np:
>         continue
>     range.gc = of_node_to_gpiochip(range.np)
>     if not range.gc:
>         return -EPROBE_DEFER
> 
> Have a third function which converts gpio chip plus offset into the
> range's real base. This would be useful even when not using DT:
> 
> int pinctrl_gpio_ranges_recalc_bases(struct pinctrl_gpio_range *ranges,
> 				     int nranges);
> 
As above, if we do it in core, then user do not need to make the decision
to call which of these three functions.
The core will handle it transparently to drivers.

> The algorithm is roughly:
> 
> for range in ranges:
>     // only convert things not already set
>     if range.base:
>         continue
>     if not range.gc:
>         continue
>     range.base = base(range.gc) + range.offset
> 
> One could imagine helper functions that wrapped all those 3 functions
> into 1 call for drivers to use.
> 
> Does that sound like a reasonable idea?
> 
The idea is really good.
Thanks a lot Stephen.
I just put some more thoughts based on it.
Do you think that is reasonable?

Regards
Dong Aisheng

