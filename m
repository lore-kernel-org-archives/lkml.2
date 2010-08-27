Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0H0SIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:08:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64509 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0H0SIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x7H61Mu+9pPoeoaZ6u211nNyfKuLAir3QvhHeBys20c8aBvQQQkfbz0a4lOuGfMNjc
         cbOSMuWQaLynhzd3em8P58W7fcebXL4L9Qqzo+Q2d5bFkinKA8dYDIAifV4OdJwjxwFj
         HjLdGxiCjsyVhswEFFnA4boi7pHMMV1fubUVQ=
Date: Fri, 27 Aug 2010 11:08:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Onkalo Samu <samu.p.onkalo@nokia.com>
Cc: ext Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
Message-ID: <20100827180837.GB13154@core.coreip.homeip.net>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
 <1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
 <20100827133109.1eb974ed@lxorguk.ukuu.org.uk>
 <1282928353.2194.27.camel@noppispoppis.nmp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282928353.2194.27.camel@noppispoppis.nmp.nokia.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 07:59:13PM +0300, Onkalo Samu wrote:
> > 
> > > +static ssize_t ak8974_misc_read(struct file *file, char __user *buf,
> > > +			size_t count, loff_t *offset)
> > > +{
> > > +	struct ak8974_chip *chip = container_of(file->private_data,
> > > +						struct ak8974_chip,
> > > +						miscdev);
> > > +	struct ak8974_data data;
> > 
> > So we have a different API to the ak8975 just posted and to the other
> > existing devices. This needs sorting out across the devices before there
> > is a complete disaster. Right now we have a mix of submissions pending
> > which variously use
> > 
> > 	misc + sysfs
> > 	sysfs
> > 	input (reporting X Y Z etc axes)
> > 
> 
> About year ago I send driver for the same chip with input-device
> interface. During that time I asked from Dmitry Torokhov that is that a
> correct interface for this kind of driver. I understood that input
> should not be used for this kind of sensors.
> 
> sysfs is quite handy interface for small sensors. However, one problem
> is that the driver doesn't know when the interface is in use.
> I ended up to misc device to get information about the usercount for PM
> purposes.
> 
> Dmitry, what is your opinion about using input device interface for this
> kind of sensors?
> 

This is really hard question and I am going back and forth myself.

When considering using input subsystem try answering the following
question - is the device's main purpose is indeed to be a human
interface device or do you want to use input subystem because evdev
interface is convenient? If the answer is former- then it should be in
input (or available through input - let's say IIO-to-input bridge
module). If the answer is latter then input is not the right place for
the device.

Lately I was persuaded that 3-axis accelerometers are mainly used as
input devices so I took adxl driver in and I need to get back and review
cma3000 patch...

> > Someone needs to decide on a single API before it's too late.
> > 
> 
> That is definitely true. Could it be IIO?
> 

I was hpoing that IIO would take care of "unnamed" sensors. Here I mean
sensors that measure something and only user/application know exactly
what it is; the same device might measure different things depending on
setup. Take a temperature sensor - ambient temperature, temperature of
some technological process, patient temperature - it is hard for the
kernel to know which one it would be.

This is in contrast with input system that tries to classify
events so that the event has the same meaning regarless of which device
emitted it - KEY_A means the same regardless of keybord; we may route
them differently (multiseat for example), but the meaning is the same.

-- 
Dmitry
