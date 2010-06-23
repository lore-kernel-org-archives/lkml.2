Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab0FWLyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 07:54:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25607 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0FWLyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 07:54:40 -0400
Date: Wed, 23 Jun 2010 14:53:52 +0300 (EEST)
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
In-Reply-To: <386783.17931.qm@web180310.mail.gq1.yahoo.com>
Message-ID: <alpine.DEB.2.00.1006231435410.8344@wnav-qrfxgbc>
References: <386783.17931.qm@web180310.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 23 Jun 2010 11:53:54.0627 (UTC) FILETIME=[C1522130:01CB12CA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 19 Jun 2010, ext David Brownell wrote:

>> The point I was trying to make is that there are lots of drivers which 
>> will not work with gpios on sleeping io expanders because they call the 
>> spinlock safe gpio calls.
>
> And they will trigger runtime warnings, and thus eventually get fixed. 
> The way to do that is to check if the GPIO needs the cansleep() call
>
> That's the first category above:  the driver should have used the 
> cansleep() variant, and sotriggers a runtime warning.

Hi David -

Part of the reason why such drivers haven't been fixed might be that the 
runtime warnings are only issued if DEBUG is defined in gpiolib.c:

/* When debugging, extend minimal trust to callers and platform code.
  * Also emit diagnostic messages that may help initial bringup, when
  * board setup or driver bugs are most common.
  *
  * Otherwise, minimize overhead in what may be bitbanging codepaths.
  */
#ifdef	DEBUG
#define	extra_checks	1
#else
#define	extra_checks	0
#endif

...

int __gpio_get_value(unsigned gpio)
{
 	struct gpio_chip	*chip;

 	chip = gpio_to_chip(gpio);
 	WARN_ON(extra_checks && chip->can_sleep);
 	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
}

Do you think it would do more harm than good to unconditionally enable the 
extra checks? I do see the comment about overhead there, but having them 
enabled would probably aid driver developers in fixing existing code and 
choosing the correct calls in the future.


BR,
Jani.
