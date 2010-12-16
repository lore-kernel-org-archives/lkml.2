Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0LPAoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:44:14 -0500
Received: from mail-iw0-f180.google.com ([209.85.214.180]:60958 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0LPAoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:44:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qHWIX6yL+D4p1OZQqB8sBZmnxHT0a6hLXlvhSc3oPLTHVBbsYTEvY50bNWkXqXZpFW
         7CHtWpCToM2OxofxCCm3NmybeDF+ffcRFvrB55BcPWHjxVm4FxS6MJr2GVEdicyUUVSm
         I5xbQTXMb/ksy3e78E+sai661BFUSstVgj/js=
Date: Wed, 15 Dec 2010 16:43:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2] input: Introduce device information ioctl
Message-ID: <20101216004358.GA22066@core.coreip.homeip.net>
References: <1292440807-18502-1-git-send-email-rydberg@euromail.se>
 <20101216002941.GC4952@salty.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216002941.GC4952@salty.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:29:42AM +1000, Peter Hutterer wrote:
> On Wed, Dec 15, 2010 at 08:20:07PM +0100, Henrik Rydberg wrote:
> > Today, userspace sets up an input device based on the data it emits.
> > This is not always enough; a tablet and a touchscreen may emit exactly
> > the same data, for instance, but the former should be set up with a
> > pointer whereas the latter does not need to. Recently, a new type of
> > touchpad has emerged where the buttons are under the pad, which
> > changes handling logic without changing the emitted data. This patch
> > introduces a new ioctl, EVIOCGPROP, which enables user access to a set
> > of device properties useful during setup. The properties are given as
> > a bitmap in the same fashion as the event types.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi all,
> > 
> > Here is version two of the device information proposal. In addition to
> > implementing the feedback, this version only defines a single combined
> > type/capabilities field. Since we want to support a device being of
> > multiple types, it suggests that we are really after the properties
> > that make up a type, rather than the types themselves. And since
> > quirks are also properties, we end up with a single bitmap of
> > properties instead.
> > 
> > As an example of how this would work for the
> > touchpad/tablet/touchscreen triplet, there are two properties defined,
> > INPUT_PROP_POINTER and INPUT_PROP_DIRECT. A touchpad is an indirect
> > pointer device, a tablet is a direct pointer device, and the
> > touchscreen is simply a direct device.
> > 
> > What do you think?
> > 
> > Thanks,
> > Henrik
> > 
> > PS. As before, the patch compiles, but is not further tested.
> > 
> >  drivers/input/evdev.c |    4 ++++
> >  drivers/input/input.c |    2 ++
> >  include/linux/input.h |   16 ++++++++++++++++
> >  3 files changed, 22 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> > index e3f7fc6..0cd97e8 100644
> > --- a/drivers/input/evdev.c
> > +++ b/drivers/input/evdev.c
> > @@ -677,6 +677,10 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
> >  #define EVIOC_MASK_SIZE(nr)	((nr) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
> >  	switch (EVIOC_MASK_SIZE(cmd)) {
> >  
> > +	case EVIOCGPROP(0):
> > +		return bits_to_user(dev->propbit, INPUT_PROP_MAX,
> > +				    size, p, compat_mode);
> > +
> >  	case EVIOCGKEY(0):
> >  		return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
> >  
> > diff --git a/drivers/input/input.c b/drivers/input/input.c
> > index 37708d1..ac751ce 100644
> > --- a/drivers/input/input.c
> > +++ b/drivers/input/input.c
> > @@ -1409,6 +1409,7 @@ INPUT_DEV_CAP_ATTR(LED, led);
> >  INPUT_DEV_CAP_ATTR(SND, snd);
> >  INPUT_DEV_CAP_ATTR(FF, ff);
> >  INPUT_DEV_CAP_ATTR(SW, sw);
> > +INPUT_DEV_CAP_ATTR(INPUT_PROP, prop);
> >  
> >  static struct attribute *input_dev_caps_attrs[] = {
> >  	&dev_attr_ev.attr,
> > @@ -1420,6 +1421,7 @@ static struct attribute *input_dev_caps_attrs[] = {
> >  	&dev_attr_snd.attr,
> >  	&dev_attr_ff.attr,
> >  	&dev_attr_sw.attr,
> > +	&dev_attr_prop.attr,
> >  	NULL
> >  };
> >  
> > diff --git a/include/linux/input.h b/include/linux/input.h
> > index b3a1e02..53d6364 100644
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -91,6 +91,7 @@ struct input_keymap_entry {
> >  #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
> >  #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
> >  #define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, len)		/* get unique identifier */
> > +#define EVIOCGPROP(len)		_IOC(_IOC_READ, 'E', 0x09, len)		/* get device properties */
> >  
> >  #define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
> >  #define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, len)		/* get all LEDs */
> > @@ -108,6 +109,18 @@ struct input_keymap_entry {
> >  #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
> >  
> >  /*
> > + * Device properties and quirks
> > + */
> > +
> > +#define INPUT_PROP_POINTER		0x00	/* needs a pointer */
> > +#define INPUT_PROP_DIRECT		0x01	/* direct object manipulation */
> 
> fwiw, I think the common term for these is "direct input devices", at least
> that's how a lot of the research literature refers to them. Might be good to
> use the same term.
> 
> either way, not sure about this one.  I've worked with devices that were
> indirect by nature but used directly. e.g. the magic touchpad could quite
> easily be used as direct input device with an top-down projector. the
> decision to use it as an indirect device is a UI decision.
> Likewise, some mountable direct-touch touchscreens can be used indirectly if
> the touchscreen isn't mounted straight on the display. This is very much a
> setup-specific property and I'm not sure about the value of this
> information.

All of these "props" would have no reflection on the event stream
generated by the device, and exist solely for the benefits of userspace
consumers to help them set up the device automatically and interpret the
data appropriately. As such, if someone uses touchscreen as a tablet, I
believe userspace should allow it, but at the price of manual setup.

If we start seeing cuch devices we could consider EVIOCSPROPS so
infrastructure (udev) could adjust the properties so that upper levels
(X) can still use the data to set up devices properly.

What do you think?

-- 
Dmitry
