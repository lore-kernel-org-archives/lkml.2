Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0CUNrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:47:05 -0400
Received: from bamako.nerim.net ([62.4.17.28]:62880 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab0CUNrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:47:01 -0400
Date: Sun, 21 Mar 2010 14:46:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Wolfram Sang <w.sang@pengutronix.de>, kernel-janitors@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 12/24] media/video: fix dangling pointers
Message-ID: <20100321144655.4747fd2a@hyperion.delvare>
In-Reply-To: <201003202302.49526.hverkuil@xs4all.nl>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
	<1269094385-16114-13-git-send-email-w.sang@pengutronix.de>
	<201003202302.49526.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Sat, 20 Mar 2010 23:02:49 +0100, Hans Verkuil wrote:
> On Saturday 20 March 2010 15:12:53 Wolfram Sang wrote:
> > Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> > structure it points to. Also fix drivers which do this _after_ the structure
> > was freed already.
> 
> I feel I am missing something here. Why does clientdata have to be set to
> NULL when we are tearing down the device anyway?

We're not tearing down the device, that's the point. We are only
unbinding it from its driver. The device itself survives the operation.

(This is different from the legacy i2c binding model where the device
itself would indeed be removed at that point, and that would be the
reason why so many i2c drivers have it wrong now.)

> And if there is a good reason for doing this, then it should be done in
> v4l2_device_unregister_subdev or even in the i2c core, not in each drivers.

Mark Brown (Cc'd) suggested this already, but I have mixed feelings
about this. My reasoning is:

1* It is good practice to have memory freed not too far from where it
was allocated, otherwise there is always a risk of unmatched pairs. In
this regard, it seems preferable to let each i2c driver kfree the
device memory it kalloc'd, be it in probe() or remove().

2* References to allocated memory should be dropped before that memory
is freed. This means that we want to call i2c_set_clientdata(c, NULL)
before kfree(d). As a corollary, we can't do the former in i2c-core and
the later in device drivers.

So we are in the difficult situation where we can't do both in i2c-core
because that violates point 1 above, we can't do half in i2c-core and
half in device drivers because this violates point 2 above, so we fall
back to doing both in device drivers, which doesn't violate any point
but duplicates the code all around.

Now, if we decide to handle this at a deeper driver model layer
(i2c-core instead of device drivers) then I'm not sure why we would
stop there... Wouldn't it be the driver core's job to clear the
reference and free the allocated memory?

I get the feeling that this would be a job for managed resources as
some drivers already do for I/O ports and IRQs. Managed resources don't
care about symmetry of allocation and freeing, by design (so it can
violate point 1 above.) Aha! Isn't it exactly what devm_kzalloc() is
all about?

At this point, I guess that each subsystem maintainer can decide to
either apply Wolfram's patch, or switch the drivers to managed
resources. Very nice that we don't have to make this a subsystem-wide
decision, so every actor can do the changes if/when they see fit.

> And why does coccinelle apparently find this in e.g. cs5345.c but not in
> saa7115.c, which has exactly the same construct? For that matter, I think
> almost all v4l i2c drivers do this.

That I can't say, sorry.

-- 
Jean Delvare
