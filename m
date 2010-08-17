Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936090Ab0HQSnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:43:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39693 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936083Ab0HQSnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:43:09 -0400
Date: Tue, 17 Aug 2010 20:42:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Paul Thomas <pthomas8589@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (ads7871) Fix ads7871_probe error path
Message-ID: <20100817204255.34fe1408@hyperion.delvare>
In-Reply-To: <AANLkTi=q_jpa3GEQk7+UdAaRiJx2mBiXs4jMx1jyJ-pJ@mail.gmail.com>
References: <1281922277.26991.3.camel@mola>
	<20100817130747.3ee0efb9@hyperion.delvare>
	<AANLkTi=q_jpa3GEQk7+UdAaRiJx2mBiXs4jMx1jyJ-pJ@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 08:15:59 -0700, Paul Thomas wrote:
> On Tue, Aug 17, 2010 at 4:07 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > Hi Alex,
> >
> > On Mon, 16 Aug 2010 09:31:17 +0800, Axel Lin wrote:
> >> We need to call hwmon_device_unregister() if an error is detected after
> >> sucessfully register hwmon device.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >> ---
> >>  drivers/hwmon/ads7871.c |    4 +++-
> >>  1 files changed, 3 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
> >> index b300a20..303db92 100644
> >> --- a/drivers/hwmon/ads7871.c
> >> +++ b/drivers/hwmon/ads7871.c
> >> @@ -201,11 +201,13 @@ static int __devinit ads7871_probe(struct spi_device *spi)
> >>       we need to make sure we really have a chip*/
> >>       if (val != ret) {
> >>               err = -ENODEV;
> >> -             goto error_remove;
> >> +             goto error_unregister;
> >>       }
> >>
> >>       return 0;
> >>
> >> +error_unregister:
> >> +     hwmon_device_unregister(pdata->hwmon_dev);
> >>  error_remove:
> >>       sysfs_remove_group(&spi->dev.kobj, &ads7871_group);
> >>  error_free:
> >
> > The bug is real, but I don't think the fix is correct. You should never
> > have to unregister the hwmon device in the error path, because you
> > should ensure the hardware is there and working _before_ you register
> > the hwmon device.
> >
> > User-space could watch for hwmon devices being added or removed, and
> > you don't want to trigger such events for a device which isn't going to
> > work.
> >
> > So I would suggest reworking the order in which things are done,
> > leaving hwmon_device_register() at the end of the function. This won't
> > only fix the error path, this will also close a race window, as for the
> > moment, the device is exposed to user-space _before_ it it properly
> > initialized, which is wrong.
> >
> > Please send an updated patch and I'll be happy to apply it.
> >
> > --
> > Jean Delvare
> >
> 
> Should the kzalloc,  sysfs_create_group and hwmon_device_register all
> stay in the same order just following the register check? I can send a
> patch for that.

Axel already sent an updated patch, so it's all OK.

-- 
Jean Delvare
