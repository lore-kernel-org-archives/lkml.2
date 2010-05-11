Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab0EKRUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:20:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42993 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0EKRUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U7lwdrzo84I6DBja3lKt6GjhqF9Kwh9SrwrEhKFiyZ0Cni7gNflQqEG4xCsEF/dj9G
         kFOVtUOs7zmBSg4Avmpp2dmn8HmyEJSCbnav44P6bOi0qfvoqlDz6XhvhBtAwleflowp
         IPzVHleuoriKjXsSdubHQnNt4BjBRBD3nAP/0=
Date: Tue, 11 May 2010 21:20:03 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Matt Reimer <mreimer@vpop.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Tejun Heo <tj@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/3] power/ds2760_battery: make charge_now and
 charge_full writeable
Message-ID: <20100511172003.GA19937@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <1273595926-26249-2-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1273595926-26249-2-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 06:38:45PM +0200, Daniel Mack wrote:
[...]
> +static int ds2760_battery_set_property(struct power_supply *psy,
> +				       enum power_supply_property psp,
> +				       const union power_supply_propval *val)
> +{
> +	int ret = -EPERM;
> +	unsigned char tmp;
> +	struct ds2760_device_info *di = to_ds2760_device_info(psy);
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_CHARGE_FULL:
> +		/* the interface counts in uAh, convert the value */
> +		ds2760_battery_write_rated_capacity(di, (val->intval / 1000L) /
> +							RATED_CAPACITY_FACTOR);

OK, Mark hinted that you should not change rated (design)
capacity, ever. You've made CHARGE_FULL writable, which now
actually changes CHARGE_FULL_DESIGN (which reports
rated_capacity). Obviously, this isn't acceptable.

I understand that you might want to change rated capacity for
your custom battery setups, and that's fine. After all, it's
your hardware, and you have a right to break it. :-)

But to do so,

1. Could you at least change this back to
   POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, so it'll be clear what
   exactly this prop is actually changing, and

2. Can we introduce Kconfig symbol BATTERY_DS2760_UNSAFE_OPS,
   and put an #ifdefs for this property? It should be
   'default n', of course. Plus we can #ifdef the rated_capacity
   module param as well.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
