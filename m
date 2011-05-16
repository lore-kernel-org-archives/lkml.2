Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1EPToJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:44:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1EPToH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cHErvd91Ws+NtWBEVbdNM44udq0XXRsQCZ9k4f556bvx+2cMZPuo/Q86zhkYBkbnEW
         hTGDRj3g0uLjT4eS5K/69DeLtUxs63IFceAeOdcC4gasIn0aIkYkuAQ3dUoDGZndIN1n
         xtvxX1TyyAgO2S0sE8jg2DH2vEwQMk7RsMhGk=
Date: Mon, 16 May 2011 12:44:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [RFC PATCH] input: Add wiichuck driver
Message-ID: <20110516194401.GB18110@core.coreip.homeip.net>
References: <20110512042218.12859.66600.stgit@localhost6.localdomain6>
 <20110516164427.GA21232@core.coreip.homeip.net>
 <20110516183124.GA4875@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516183124.GA4875@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:31:24PM -0600, Grant Likely wrote:
> On Mon, May 16, 2011 at 09:44:27AM -0700, Dmitry Torokhov wrote:
> > Hi Grant,
> > 
> > On Thu, May 12, 2011 at 06:29:44AM +0200, Grant Likely wrote:
> > > This patch adds a driver for the Nintendo Nunchuck (wiimote accessory)
> > > attached to an i2c bus via something like a wiichuck adapter board
> > > from Sparkfun.
> > > 
> > > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > > ---
> > > 
> > > This is RFC because the driver doesn't completely work yet.  The
> > > joystick and buttons work fine.  There is a bug with the accelerometer
> > > reporting though (nothing gets reported), and I'm not even sure I'm
> > > using the right input type for reporting accelerometer values.
> > 
> > Looks quite reasonable and I think that ABS_Rx is reasonable events for
> > accelerometer in this particular case.
> > 
> > A few more comments below.
> 
> Hi Dmitry, thanks for the review.  Replies below.
> 
> > 
> > > Comments welcome.
> > > 
> > >  drivers/input/joystick/Kconfig    |    8 +
> > >  drivers/input/joystick/Makefile   |    1 
> > >  drivers/input/joystick/wiichuck.c |  225 +++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 234 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/input/joystick/wiichuck.c
> > > 
> > > diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
> > > index 56eb471..79f18db 100644
> > > --- a/drivers/input/joystick/Kconfig
> > > +++ b/drivers/input/joystick/Kconfig
> > > @@ -193,6 +193,14 @@ config JOYSTICK_TWIDJOY
> > >  	  To compile this driver as a module, choose M here: the
> > >  	  module will be called twidjoy.
> > >  
> > > +config JOYSTICK_WIICHUCK
> > > +	tristate "Nintendo Nunchuck on i2c bus"
> > > +	depends on I2C
> > > +	select INPUT_POLLDEV
> > > +	help
> > > +	  Say Y here if you have a Nintendo Nunchuck directly attached to
> > > +	  the machine's i2c bus.
> > > +
> > 
> > 	To compile this driver as a module, ...
> 
> That ends up being pretty useless boilerplate.  I've stopped adding
> that line to any of the Kconfig text I maintain.
> 

This tells the user name of the module, that is the reason I have all
input drivers use this boilerplate.

> > > +static void wiichuck_poll(struct input_polled_dev *poll_dev)
> > > +{
> > > +	struct wiichuck_device *wiichuck = poll_dev->private;
> > > +	struct i2c_client *i2c = wiichuck->i2c_client;
> > > +	static uint8_t cmd_byte = 0;
> > > +	struct i2c_msg cmd_msg =
> > > +		{ .addr = i2c->addr, .len = 1, .buf = &cmd_byte };
> > > +	uint8_t b[6];
> > 
> > As mentioned by others these buffers should not be on stack.
> 
> Fixed.
> 
> > 
> > > +	struct i2c_msg data_msg =
> > > +		{ .addr = i2c->addr, .flags = I2C_M_RD, .len = 6, .buf = b };
> > > +	int jx, jy, ax, ay, az;
> > > +	bool c, z;
> > > +
> > > +	switch (wiichuck->state) {
> > > +	case 0:
> > > +		i2c_transfer(i2c->adapter, &cmd_msg, 1);
> > > +		wiichuck->state = 1;
> > 
> > Do you really need to have a state machine here? Why not do both
> > transfers in one poll invocation?
> 
> Mostly because there needs to a gap between setting up the data
> capture and reading the data back.

How long is the gap? You should be able simply sleep in the poll().

>  I could flip things around to
> setup the next transfer after reading the previous, but in my current
> version I also add state for handling hotplug of the wiimote
> accessories, so I think the state machine is still warranted.
> 
> > > +	set_bit(EV_KEY, input_dev->evbit);
> > > +	set_bit(BTN_C, input_dev->keybit); /* buttons */
> > > +	set_bit(BTN_Z, input_dev->keybit);
> > 
> > I prefer __set_bit() here since there is no concurrency.
> 
> In general, I avoid using __* versions of functions unless it is
> actually important that I do so.  I'm not concerned about slightly
> higher overhead here, and I'd rather my code set a good example.

In case of xxx_bit() __xxx_bit() is not an "internal, call only if you
are really sure" version but regular, non-atomic one. Unfortunately the
naming chosen used double underscores for them.

I prefer drivers using set_bit() and clear_bit() only if atomicity is
important, in all other cases underscored versions are more appropriate.

Thanks.

-- 
Dmitry
