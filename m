Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0H3HMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:12:54 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:35043 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0H3HMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:12:53 -0400
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Sundar <sunder.svit@gmail.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <AANLkTim=Zq7Pxixdwe_H-659cLZ2yybediDURGwvoO3=@mail.gmail.com>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
	 <1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
	 <AANLkTim=Zq7Pxixdwe_H-659cLZ2yybediDURGwvoO3=@mail.gmail.com>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Mon, 30 Aug 2010 10:12:41 +0300
Message-Id: <1283152361.16404.22.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sundar,

On Sat, 2010-08-28 at 18:10 +0200, ext Sundar wrote:
> Hi Samu,
> 
> few minor comments,
> 
> On Fri, Aug 27, 2010 at 5:24 PM, Samu Onkalo <samu.p.onkalo@nokia.com> wrote:
> > +
> > +struct ak8974_chip {
> > +       struct miscdevice       miscdev;
> > +       struct mutex            lock;   /* Serialize access to chip */
> > +       struct mutex            users_lock;
> > +       struct i2c_client       *client;
> > +       struct regulator_bulk_data regs[2];
> > +       struct work_struct      work;
> > +       wait_queue_head_t       misc_wait;
> > +       loff_t                  offset;
> > +
> > +       int                     max_range;
> > +       int                     users;
> > +
> > +       const char              *id;
> > +       u8                      info[2];
> > +
> > +       s16                     x, y, z; /* Latest measurements */
> > +       s8                      axis_x;
> > +       s8                      axis_y;
> > +       s8                      axis_z;
> > +       bool                    valid;
> > +
> > +       char                    name[20];
> > +};
> 
> This can be static ?

It is filled based on the detected chip type.

> 
> > +
> > +       ak8974_regulators_off(chip);
> > +
> 
> [..]
> 
> > +       if (err < 0) {
> > +               dev_err(&chip->client->dev, "Device registration failed\n");
> > +               goto fail3;
> > +       }
> 
> [..]
> 
> > +       return 0;
> > +fail4:
> > +       misc_deregister(&chip->miscdev);
> > +fail3:
> > +       ak8974_regulators_off(chip);
> 
> in case of fail3, regulators get disabled twice. i think we will have
> unbalanced calls to the supplies then.
> 

Yes, you are correct.


> > +
> > +
> > +#ifdef CONFIG_PM
> > +static int ak8974_suspend(struct i2c_client *client, pm_message_t mesg)
> > +{
> > +       struct ak8974_chip *chip = i2c_get_clientdata(client);
> > +       mutex_lock(&chip->users_lock);
> > +       if (chip->users > 0)
> > +               ak8974_enable(chip, AK8974_PWR_OFF);
> > +       mutex_unlock(&chip->users_lock);
> > +       return 0;
> > +}
> 
> Can we disable the regulators here too?

It would require some more operations since the chip would loose its
state totally. But yes, it could be done.

-Samu


