Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab2EWN1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:27:18 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42404 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791Ab2EWN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:27:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VS-14(zz154dM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
X-FB-SS: 0,
Date: Wed, 23 May 2012 21:30:27 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH RFC v3 3/3] pinctrl: add pinctrl gpio binding support
Message-ID: <20120523133026.GC27055@shlinux2.ap.freescale.net>
References: <1337779362-31259-1-git-send-email-b29396@freescale.com>
 <1337779362-31259-3-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337779362-31259-3-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, May 23, 2012 at 09:22:42PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This patch implements a standard common binding for pinctrl gpio ranges.
> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
> under their pinctrl devices node with the format:
> <&gpio $gpio_offset $pin_offset $npin>.
> 
> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
> to parse and register the gpio ranges from device tree.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> ChangeLog v2->v3:
> * standardise the gpio ranges node name to 'gpio-maps'. Each SoC should use this
>   node name to define gpio ranges.
> * defer probe if can not get gpiochip from node in case gpio driver is still
>   not loaded.
> * some other minor fixes suggested by Stephen Warren.
> 
I still did not use try_module_get for gpio ranges to prevent gpio modules from going
away after a bit more thinking.

A few reasons:
1) gpio ranges are only raw data which does not depend on gpio module
2) if the gpio chip is going away, the gpio request will fail without touch pinctrl
stuff. So it seems doesn't matter if gpio module is going away for pinctrl.
3) For non-dt, the gpiochip parameter of gpio ranges is also optional and does not
require gpio chip to be exist. It looks reasonable to me to be like that.
So i'm wondering if we really need to add this checking.

Even if we need to do that, the right place may be pinctrl_add_gpio_range which not
related to this series like:
int pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
                            struct pinctrl_gpio_range *range)
{
...
        if (range->gc) {
                if (!try_module_get(range->gc->owner))
                        return -ENODEV;
        }
...
}
So i sent this series first and let that issue to be discussed later.

Regards
Dong Aisheng

