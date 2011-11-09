Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1KIMvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:51:25 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:28438 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1KIMvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:51:23 -0500
Date: Wed, 9 Nov 2011 13:51:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max1111) change sysfs interface to
  in[0-3]_input in millivolts
Message-ID: <20111109135115.40195f65@endymion.delvare>
In-Reply-To: <CAMPhdO-LLzPLfTzwf721ut75KYcGtAsW3VeqYusAG+jw-=yVXg@mail.gmail.com>
References: <1320837303-30697-1-git-send-email-eric.y.miao@gmail.com>
	<20111109132238.0a35ccee@endymion.delvare>
	<CAMPhdO-LLzPLfTzwf721ut75KYcGtAsW3VeqYusAG+jw-=yVXg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011 20:33:27 +0800, Eric Miao wrote:
> On Wed, Nov 9, 2011 at 8:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > Hi Eric,
> >
> > On Wed,  9 Nov 2011 19:15:03 +0800, Eric Miao wrote:
> >> This patch fixed the inconsistent max1111 sysfs interface as pointed
> >> out by Jean Delvare:
> >>
> >>     It was pointed to me that the max1111 driver doesn't implement the
> >>     standard sysfs interface for hwmon drivers (as described in
> >>     Documentation/hwmon/sysfs-interface). It exports files adc[0-3]_in,
> >>     which
> >>     aren't part of the standard interface. Presumably these should be
> >>     renamed to in[0-3]_input. Renaming them is probably not sufficient
> >>     though, as I see no scaling done in the driver. As the MAX1111 chip has
> >>     a documented full scale of 2.048V, I take it that the LSB of the ADC
> >>     has a weight of 8 mV. Exporting raw register values to user-space is
> >>     not OK.
> >>
> >> Reported-by: Jean Delvare <khali@linux-fr.org>
> >> Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
> >> ---
> >>  drivers/hwmon/max1111.c |   13 +++++++------
> >>  1 files changed, 7 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
> >> index c97b78e..0e9fcfd 100644
> >> --- a/drivers/hwmon/max1111.c
> >> +++ b/drivers/hwmon/max1111.c
> >> @@ -106,11 +106,12 @@ static ssize_t show_adc(struct device *dev,
> >>       if (ret < 0)
> >>               return ret;
> >>
> >> -     return sprintf(buf, "%d\n", ret);
> >> +     /* assume the reference voltage to be 2.048V */
> >> +     return sprintf(buf, "%d\n", 2048 * 256 / ret);
> >
> > I bet you did not actually test your changes? ret == 0 would obviously
> > crash the driver. The formula looks wrong anyway, should be 2048 *
> > ret / 256. Or in short ret * 8, i.e. LSB weight of the ADC is 8 mV.
> >
> 
> Oops, shame to death.
> 
> How about simply '2048 * ret / 256' to make it clear and leave it to
> the compiler to optimize?

I find the concept of LSB weight clear enough, but ultimately that's up
to you, as long as the compiler actually optimizes it.

-- 
Jean Delvare
