Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2DYJjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:39:39 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:28216
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756754Ab2DYJjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:39:37 -0400
X-SpamScore: -17
X-BigFish: VS-17(zzbb2dI9371I179dN1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 25 Apr 2012 17:49:36 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 1/2] pinctrl: add pinctrl_provide_dummies interface
 for platforms to use
Message-ID: <20120425094934.GA17631@shlinux2.ap.freescale.net>
References: <1335260023-15859-1-git-send-email-b29396@freescale.com>
 <4F96F847.508@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F96F847.508@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 03:00:23AM +0800, Stephen Warren wrote:
> On 04/24/2012 03:33 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Add a interface pinctrl_provide_dummies for platform to indicate
> > whether it needs use pinctrl dummy state and dummy gpio.
> 
> > @@ -382,7 +396,12 @@ int pinctrl_request_gpio(unsigned gpio)
> >  	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
> >  	if (ret) {
> >  		mutex_unlock(&pinctrl_mutex);
> > -		return -EINVAL;
> > +		if (pinctrl_dummy_gpio) {
> > +			pr_debug("pinctrl: using dummy gpio(%u)\n", gpio);
> > +			return 0;
> > +		} else {
> > +			return -EINVAL;
> > +		}
> >  	}
> 
> The only thing that should be calling pinctrl_request_gpio() is a GPIO
> driver. It should only be calling it for the GPIOs it manages. I'd
> expect that if a platform's pinctrl driver was not yet written to
> support the GPIO functionality, then the GPIO driver would not be
> calling this function.
> 
Hmm, pinctrl gpio is in the same situation as pinctrl state that gpio
driver may be shared between several platforms, with pinctrl support
or not.

> As such, I'm not sure that this part of the change is necessary.
> 
> If it is, then surely all the other pinctrl GPIO APIs need a similar change?
> 
Yes, i missed it, will fix.
Thanks for reminder.

> Finally, how does this interact with deferred probe: How does the code
> know whether the pinctrl driver and/or GPIO range is simply not yet
> registered, or whether it never will be? That'd be the difference
> between returning -EPROBE_DEFER or 0 in the if block above.
> 
Yes, it is an issue.
I don't have any good idea to distinguish them.
It seems regulator has the same issue.
What regulator does is if dummy regulator is used, use dummy gpio instead
regardless of defer probe.
I guess we may use the same way as regulator for pinctrl.
User can decide if using dummy gpio or defer probe since based on their
driver support.

The rule may be if your pinctrl driver supports gpio, then you should not use
dummy gpio. Then the dummy gpio support will not affect the defer probe.

> 
> I'm fine with the other parts of this patch.

Regards
Dong Aisheng

