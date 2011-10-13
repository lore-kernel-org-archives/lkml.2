Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1JMRZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:25:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42651 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1JMRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:25:32 -0400
Date: Thu, 13 Oct 2011 13:25:27 -0400 (EDT)
Message-Id: <20111013.132527.2221791090526837668.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: ide_port_wait_ready() fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110131241.04759.bzolnier@gmail.com>
References: <201110121659.55961.bzolnier@gmail.com>
	<20111012.150349.1115347260310770962.davem@davemloft.net>
	<201110131241.04759.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 10:25:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 13 Oct 2011 12:41:04 +0200

> David Miller wrote:
> 
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Wed, 12 Oct 2011 16:59:55 +0200
>> 
>> > David Miller wrote:
>> > 
>> >> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> >> Date: Tue, 11 Oct 2011 19:13:18 +0200
>> >> 
>> >> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> >> > Subject: [PATCH] ide: ide_port_wait_ready() fix
>> >> > 
>> >> > Fix for commit a20b2a4 ("ide: skip probe if there are no devices on
>> >> > the port (v2)").  We must check for slave device before failing.
>> >> > 
>> >> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> >> 
>> >> This will mishandle the case where there is no slave in the device
>> >> list.
>> > 
>> > I don't see it:
>> > 
>> > @ -598,7 +598,7 @@ static int ide_port_wait_ready(ide_hwif_
>> >  {
>> >  	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
>> >  	ide_drive_t *drive;
>> > -	int i, rc;
>> > +	int i, rc, prev_rc = 0;
>> >  
>> >  	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
>> >  
>> > @@ -623,8 +623,10 @@ static int ide_port_wait_ready(ide_hwif_
>> >  			tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
>> >  			mdelay(2);
>> >  			rc = ide_wait_not_busy(hwif, 35000);
>> > -			if (rc)
>> > +			if (prev_rc && rc)
>> >  				goto out;
>> > +			prev_rc = rc;
>> > +			rc = 0;
>> >  		} else
>> >  			printk(KERN_DEBUG "%s: ide_wait_not_busy() skipped\n",
>> >  					  drive->name);
>> > 
>> > If there is no slave device but there is a master device the code falls-through
>> > and returns a success.
>> 
>> That's not what we want, if there is only a master device and no slave device
>> in the list this loop is iterating over we want to return the error code
>> in "rc", not zero.
> 
> No, we want to return zero (success) since at least once device was found
> (otherwise we fail probe on some esoteric setups returning -ENODEV from
> ide_wait_not_busy() for master device).
> 
> This is how this function worked before commit a20b2a4 if you want something
> else okay but it needs to work with aforementioned setups.

You unconditionally assign "prev_rc = rc" and set "rc = 0" so if we only run
the loop once, we return zero.

And we do this even if that one device gave a non-zero return value.

That's not what we want.
