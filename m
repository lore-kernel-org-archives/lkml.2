Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0CVUeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:34:05 -0400
Received: from bamako.nerim.net ([62.4.17.28]:64153 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab0CVUeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:34:01 -0400
Date: Mon, 22 Mar 2010 21:33:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wolfram Sang <w.sang@pengutronix.de>, kernel-janitors@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 12/24] media/video: fix dangling pointers
Message-ID: <20100322213358.31e50b3c@hyperion.delvare>
In-Reply-To: <201003211709.56319.hverkuil@xs4all.nl>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
	<20100321144655.4747fd2a@hyperion.delvare>
	<20100321141417.GA19626@opensource.wolfsonmicro.com>
	<201003211709.56319.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans, Mark, Wolfram,

On Sun, 21 Mar 2010 17:09:56 +0100, Hans Verkuil wrote:
> On Sunday 21 March 2010 15:14:17 Mark Brown wrote:
> > On Sun, Mar 21, 2010 at 02:46:55PM +0100, Jean Delvare wrote:
> > > On Sat, 20 Mar 2010 23:02:49 +0100, Hans Verkuil wrote:
> > 
> > > > I feel I am missing something here. Why does clientdata have to be set to
> > > > NULL when we are tearing down the device anyway?
> > 
> > > We're not tearing down the device, that's the point. We are only
> > > unbinding it from its driver. The device itself survives the operation.
> > 
> > That's the subsystem point of view, not the driver point of view.  As
> > far as the driver is concerned the device appears when probe() is called
> > and vanishes after remove() has completed, any management the subsystem
> > does in between is up to it.
> 
> Right. And from the point of view of the driver I see no reason why I would
> have to zero the client data pointer when I know nobody will ever access it
> again. If there is a good reason, then that is (again, from the PoV of the
> driver) completely unexpected and it is guaranteed that driver writers will
> continue to make that mistake in the future.

I can't disagree. Given that there is no way to enforce the rule, it is
likely not everybody will follow it.

> > > 1* It is good practice to have memory freed not too far from where it
> > > was allocated, otherwise there is always a risk of unmatched pairs. In
> > > this regard, it seems preferable to let each i2c driver kfree the
> > > device memory it kalloc'd, be it in probe() or remove().
> > 
> > I agree with this.  There are also some use cases where the device data
> > is actually static (eg, a generic description of the device or a
> > reference to some other shared resource rather than per device allocated
> > data).

>From a technical perspective, there is little rationale to have the
client data pointed to static data. If you could reach it from probe(),
it has to be a global, and if it is a global, you can reach it again
directly from the rest of your code.

That being said, that doesn't mean drivers aren't actually doing it.

> Definitely. Freeing should be done in the i2c drivers.
>  
> > > 2* References to allocated memory should be dropped before that memory
> > > is freed. This means that we want to call i2c_set_clientdata(c, NULL)
> > > before kfree(d). As a corollary, we can't do the former in i2c-core and
> > > the later in device drivers.
> > 
> > This is where the mismatch between the subsystem view of the device
> > lifetime and the driver view of the device lifetime comes into play.
> > For the driver once the device is unregistered the device no longer
> > exists - if the driver tries to work with the device it's buggy.  This
> > means that to the driver returning from the remove() function is
> > dropping the reference to the data and there's no reason for the driver
> > to take any other action.
> > 
> > The device may hang around after the remove() has happened, but if the
> > device driver knows or cares about it then it's doing something wrong.
> > Similarly on probe() we can't assme anything about the pointer since
> > even if we saw the device before we can't guarantee that some other
> > driver didn't do so as well.  The situation is similar to that with
> > kfree() - we don't memset() data we're freeing with that, even though it
> > might contain pointers to other things.

I'm not sure if this comparison really holds. When you free memory,
nobody is supposed to use that memory afterwards, so whether it contains
pointers to other memory locations is irrelevant. Unbinding a device
doesn't make it disappear, it might still get access, now or later, so
the value of struct device members is more relevant. But of course we
can discuss the guarantees made on these struct members over the
device's lifetime. I don't this is documented anywhere.

> Indeed. The client data is for the client. Once the client is gone (unbound)
> the client data can safely be set back to NULL.
>  
> > > So we are in the difficult situation where we can't do both in i2c-core
> > > because that violates point 1 above, we can't do half in i2c-core and
> > > half in device drivers because this violates point 2 above, so we fall
> > > back to doing both in device drivers, which doesn't violate any point
> > > but duplicates the code all around.
> > 
> > Personally I'd much rather just not bother setting the driver data in
> > the removal path, it seems unneeded.  I had assumed that the subsystem
> > code cared for some reason when I saw the patch series.
> 
> Anyway, should this really be necessary, then for the media drivers this
> should be done in v4l2_device_unregister_subdev() and not in every driver.
> 
> But this just feels like an i2c core thing to me. After remove() is called
> the core should just set the client data to NULL. If there are drivers that
> rely on the current behavior, then those drivers should be reviewed first as
> to the reason why they need it.

I tend to agree, now.

Wolfram, how do you feel about this? I feel a little sorry that I more
or less encouraged you to submit this patch series, and now I get to
agree with the objections which were raised against it.

My key motivation was that I wanted i2c_set_clientdata() to be called
before kfree(). Now that everybody seems to agree that the latter
belongs to the drivers while the former belongs to lower layers
(i2c-core or even driver core), this is not going to happen. So I guess
we want to remove calls to i2c_set_clientdata(NULL) from all drivers
and have only one in i2c-core for now?

-- 
Jean Delvare
