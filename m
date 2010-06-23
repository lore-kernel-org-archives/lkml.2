Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0FWNX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:23:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35457 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0FWNXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:23:55 -0400
Date: Wed, 23 Jun 2010 16:22:31 +0300 (EEST)
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
cc: Ryan Mallon <ryan@bluewatersys.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "gregkh@suse.de" <gregkh@suse.de>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: gpiolib and sleeping gpios
In-Reply-To: <564390.64703.qm@web180307.mail.gq1.yahoo.com>
Message-ID: <alpine.DEB.2.00.1006231601310.7850@wnav-qrfxgbc>
References: <564390.64703.qm@web180307.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 23 Jun 2010 13:22:39.0263 (UTC) FILETIME=[270D1AF0:01CB12D7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Jun 2010, ext David Brownell wrote:

> --- On Wed, 6/23/10, Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
>
>> Hi David -
>> 
>> Part of the reason why such drivers haven't been fixed
>> might be that the runtime warnings are only issued if DEBUG
>> is defined in gpiolib.c:
>
> A very good point.  those cansleep() warnings
> should perhaps be issued more consistently.
>
> (Other warnings are safer to skip.)
>
> I think the normal case for the GPIO calls is
> the spinlock-safe code path, so I'd probably
> ack a patch which incurs the extra costs only
> for gpio chips that are already sleeping.

Hi -

I'd think the most important and useful warning would be about 
gpio_{get,set}_value() in atomic context on a gpio chip that might sleep. 
I seem to have some trouble with my foreign language parser here, so let's 
move to a more natural language - see patch below. ;)

If you'd be willing to accept that, with the overhead of one conditional 
statement in atomic context for non-sleepy chips, I see no reason not to 
go all the way and modify whole gpiolib.c to match extra_check == 1.


BR,
Jani.


diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3ca3654..33d82b7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1527,7 +1527,7 @@ int __gpio_get_value(unsigned gpio)
  	struct gpio_chip	*chip;

  	chip = gpio_to_chip(gpio);
-	WARN_ON(extra_checks && chip->can_sleep);
+	might_sleep_if(chip->can_sleep);
  	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
  }
  EXPORT_SYMBOL_GPL(__gpio_get_value);
@@ -1546,7 +1546,7 @@ void __gpio_set_value(unsigned gpio, int value)
  	struct gpio_chip	*chip;

  	chip = gpio_to_chip(gpio);
-	WARN_ON(extra_checks && chip->can_sleep);
+	might_sleep_if(chip->can_sleep);
  	chip->set(chip, gpio - chip->base, value);
  }
  EXPORT_SYMBOL_GPL(__gpio_set_value);
