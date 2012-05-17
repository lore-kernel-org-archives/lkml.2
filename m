Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965699Ab2EQUGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:06:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53598 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2EQUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:06:16 -0400
Message-ID: <4FB55A35.1010902@wwwdotorg.org>
Date: Thu, 17 May 2012 14:06:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com
Subject: Re: [PATCH RFC 1/1] pinctrl: improve gpio support for dt
References: <1337090839-21224-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1337090839-21224-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 08:07 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> For dt, the gpio base may be dynamically allocated, thus the original
> implementation of gpio support based on static gpio number and pin id
> map may not be easy to use for dt.
> 
> One solution is a) use alias id for gpio node and refer to it in gpio
> range, then we can get the fixed the gpio devices for this range and
> b) get gpio chip from node which is specified in gpio range structure,
> then get the dynamically allocated gpio chip base and c) using the chip
> gpio base and offset to map to a physical pin id for dt.

As I just mentioned in response to Shawn's driver, I don't think that
using the aliases node is the way to go here.

Instead, what about the following:

/*
 * This function parses property @propname in DT node @np. This property
 * is a list of phandles, with optional @cellskip cells between them.
 * For each entry in ranges, the phandle at index
 * range[i].id * (1 + @cellskip) is written into range[i].np
 */
int pinctrl_dt_gpio_ranges_add_np(struct pinctrl_gpio_range *ranges,
				  int nranges,
				  struct device_node *np,
				  const char *propname,
				  int cellskip);

Note: cellskip is usually 0. However, to allow the same code to be used
for pinctrl-simple/pinctrl-generic's GPIO mapping table, we allow
additional cells between the phandles.

For example, Tegra might have:

gpio-controllers = <&tegra_gpio>; // there's just 1

i.MX23 might have:

gpio-controllers = <&gpio0 &gpio1 &gpio2 &gpio3>; // it has 4 banks

whereas pinctrl-simple/pinctrl-generic might want to put the entire
range table in this property, so might do something like:

gpio-ranges =	<&gpio0 $gpio_offset $pin_offset $count>
		<&gpio1 $gpio_offset $pin_offset $count> ...;

and hence set cellskip to 3. the pinctrl-simple/pinctrl-generic code
would need to parse the other 3 cells itself.

The algorithm is roughly:

prop = get_property(propname)
for range in ranges:
    if not range.np:
        phandle = get_phandle_by_index(prop, range.id);

Have a second function that converts the np pointer to gpio chips. This
could be used if the np field was obtained somewhere other than by
calling pinctrl_dt_add_np_to_ranges():

int pinctrl_dt_gpio_ranges_np_to_gc(struct pinctrl_gpio_range *ranges,
				    int nranges);

Note: For any np where of_node_to_gpiochip() fails,
pinctrl_dt_gpio_ranges_np_to_gc() should return -EPROBE_DEFER so that
the pinctrl driver can wait for the GPIO driver to probe before continuing.

The algorithm is roughly:

for range in ranges:
    if range.gc:
        continue
    if not range.np:
        continue
    range.gc = of_node_to_gpiochip(range.np)
    if not range.gc:
        return -EPROBE_DEFER

Have a third function which converts gpio chip plus offset into the
range's real base. This would be useful even when not using DT:

int pinctrl_gpio_ranges_recalc_bases(struct pinctrl_gpio_range *ranges,
				     int nranges);

The algorithm is roughly:

for range in ranges:
    // only convert things not already set
    if range.base:
        continue
    if not range.gc:
        continue
    range.base = base(range.gc) + range.offset

One could imagine helper functions that wrapped all those 3 functions
into 1 call for drivers to use.

Does that sound like a reasonable idea?
