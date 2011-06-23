Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab1FWOsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:48:45 -0400
Received: from imr4.ericy.com ([198.24.6.8]:44617 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927Ab1FWOsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:48:43 -0400
Date: Thu, 23 Jun 2011 07:47:55 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: LM95245 driver
Message-ID: <20110623144755.GE28311@ericsson.com>
References: <1308649953-2774-1-git-send-email-alexander.stein@systec-electronic.com>
 <1308770149.8271.600.camel@groeck-laptop>
 <201106231114.52841.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201106231114.52841.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 05:14:52AM -0400, Alexander Stein wrote:
> On Wednesday 22 June 2011 21:15:49 Guenter Roeck wrote:
> > On Tue, 2011-06-21 at 05:52 -0400, Alexander Stein wrote:
> > > An hwmon driver for the National Semiconductor LM95245 dual temperature
> > > sensors chip.
> > > 
> > > Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> > 
> > Overall pretty well written, only I am a bit at loss why you try to deal
> > with the unsigned temperature registers. That adds a bit of complexity
> > to the driver. Given that the signed temperature value range is up to
> > 127 degrees C, and that the chip is only rated up to 125 degrees C, the
> > added complexity doesn't seem to be worth it.
> > 
> > Can you elaborate ?
> 
> Well, AFAIK the 125 degrees C limit is for the chip itself. I didn't found 
> anything about a remote diode limit. Also the remote TCRIT and OS limit range 
> up to 255 degrees C.

Specified accuracy range for the external diode is up to 125 degrees C.

Jean, do you have an opinion here ? I just don't think the added complexity
is worth the theoretical gain in functionality.

> Another point is the optional offset register (not implemented, see below). I 
> could not found much about it, but I guess this is immediately added to the 
> remote temperature register.
> 
You could set it to some value and see what happens.

> > Other comments:
> > 
> > For the interval attribute, idea would be to write the value into the
> > conversion rate register. Your code does not match the interval with the
> > rate programmed into the chip (which is the idea), nor does it update
> > the rate if the interval is changed.
> 
> Well, I noticed that. But I went the way lm95241 does. I'm also unsure which 
> interval to choose, if user specify a unsupported interval. Choose the next 
> small or the next greater one? Maybe you can give me a hint here.
> 
Two bad or wrong implementations don't make it a good one. If the value can be
configured into the lm95241, the code should do it.

The lm90 driver tries to find the closest match, which would be one way to go
and is what I usually do. Another possibility would be to select the next larger
valid interval.

> > Chip address 0x29 is missing.
> 
> Nice catch.
> 
> > It would be nice if the driver would support limit, hysteresis, alarm,
> > and fault attributes.
> 
> Let's see if I find time for that.
> Thanks for the review though.
> 
Um ... that wasn't a review. Just browsing through the code ;).

Another thing I noticed: You are re-configuring the chip during initialization.
This is even though the chip may already have been configured through ROMMON and/or BIOS,
and specifically overrides the external sensor type. That is not a good idea; even
though it may make sense in your application, it may screw up chip configuration
for other users of the chip.

If your BIOS/Firmware does not configure the chip, and you really have to do it
in the driver, one option would be to provide configuration data through optional
platform data.

Thanks,
Guenter
