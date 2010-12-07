Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0LGTlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:41:16 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:57248 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0LGTlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:41:14 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2010 14:41:14 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=LdBdtwn7/S8JCAuN+K30TvwudcuegDK3T0W0lEhUU9pxxE7Gx7wXADZYxCjOcf1Msi
         xzAMuCLiH0s8jKETdxQ3BzldDLRZcNMsCbkTWRLL3/xM7krEStW+8kCMION9zCFsltRZ
         OB5y/bVcOTAM9qnFwnMKMCLcB+r+jXhIbB2dA=
Date: Tue, 7 Dec 2010 11:35:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Message-ID: <20101207193513.GA31411@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
 <AANLkTi=dhFSrAnRHDB4Vcsxh8xqvztpg4Fxyorzu9q7u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=dhFSrAnRHDB4Vcsxh8xqvztpg4Fxyorzu9q7u@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 10:48:04AM -0800, Ping Cheng wrote:
> On Mon, Dec 6, 2010 at 11:25 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Today, userspace sets up an input device based on the data it emits.
> > This is not always enough; a tablet and a touchscreen may emit exactly
> > the same data, for instance, but the former should be set up with a
> > pointer whereas the latter does not need to. Recently, a new type of
> > touchpad has emerged where the buttons are under the pad, which changes
> > handling logic without changing the emitted data. This patch introduces
> > a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
> > about the device resulting in proper setup.
> >
> > Suggested-by: Dmitry Torokhov <dtor@mail.ru>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > Cc: Ping Cheng <pingc@wacom.com>
> > Cc: Chris Bagwell <chris@cnpbagwell.com>
> > ---
> > Hi all,
> >
> > Here is a patch attempting to formulate Dmitry's device type idea. It
> > compiles, but further testing awaits a general consesus on the device
> > types and capabilities to start out with. Are the ones listed here apt
> > for the job?
> >
> > Cheers,
> > Henrik
> >
> >  drivers/input/evdev.c |    6 ++++++
> >  include/linux/input.h |   34 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 40 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> > index e3f7fc6..db78592 100644
> > --- a/drivers/input/evdev.c
> > +++ b/drivers/input/evdev.c
> > @@ -632,6 +632,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
> >                        return -EFAULT;
> >                return 0;
> >
> > +       case EVIOCGDEVINFO:
> > +               if (copy_to_user(p, &dev->devinfo,
> > +                                sizeof(struct input_devinfo)))
> > +                       return -EFAULT;
> > +               return 0;
> > +
> >        case EVIOCGREP:
> >                if (!test_bit(EV_REP, dev->evbit))
> >                        return -ENOSYS;
> > diff --git a/include/linux/input.h b/include/linux/input.h
> > index 6ef4446..8c58d2a 100644
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -57,6 +57,21 @@ struct input_absinfo {
> >  };
> >
> >  /**
> > + * struct input_devinfo - device information via EVIOCGDEVINFO ioctl
> > + * @types: bitmask of types (DEVTYPE_*) matching this device
> > + * @capabilities: bitmask of capabilities (DEVCAPS_*) of this device
> > + *
> > + * This struct provides information about the device needed for
> > + * automatic setup in userspace, such as if the device is direct
> > + * (touchscreen) or indirect (touchpad), and if there are other
> > + * special considerations, such as the touchpad also being a button.
> 
> I guess you are talking about the pad is also a button. What about the
> pad has buttons? And there could be more than one button on it. Can we
> pass the number of buttons on the pad as well?
> 
> > + */
> > +struct input_devinfo {
> > +       __u32 types;
> > +       __u32 capabilities;
> > +};
> > +
> > +/**
> >  * struct input_keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
> >  * @scancode: scancode represented in machine-endian form.
> >  * @len: length of the scancode that resides in @scancode buffer.
> > @@ -91,6 +106,7 @@ struct input_keymap_entry {
> >  #define EVIOCGNAME(len)                _IOC(_IOC_READ, 'E', 0x06, len)         /* get device name */
> >  #define EVIOCGPHYS(len)                _IOC(_IOC_READ, 'E', 0x07, len)         /* get physical location */
> >  #define EVIOCGUNIQ(len)                _IOC(_IOC_READ, 'E', 0x08, len)         /* get unique identifier */
> > +#define EVIOCGDEVINFO          _IOR('E', 0x09, struct input_devinfo)   /* get device information */
> >
> >  #define EVIOCGKEY(len)         _IOC(_IOC_READ, 'E', 0x18, len)         /* get global key state */
> >  #define EVIOCGLED(len)         _IOC(_IOC_READ, 'E', 0x19, len)         /* get all LEDs */
> > @@ -108,6 +124,23 @@ struct input_keymap_entry {
> >  #define EVIOCGRAB              _IOW('E', 0x90, int)                    /* Grab/Release device */
> >
> >  /*
> > + * Device types
> > + */
> > +
> > +#define DEVTYPE_KEYBOARD       0
> > +#define DEVTYPE_MOUSE          1
> > +#define DEVTYPE_JOYSTICK       2
> > +#define DEVTYPE_TOUCHPAD       3
> > +#define DEVTYPE_TABLET         4
> > +#define DEVTYPE_TOUCHSCREEN    5
> 
> TOUCHSCREEN can be finger touch screen and pen touch screen. They are
> different types for clients. Should we add one for pen touch screen,
> something like DEVTYPE_TABLETPC?

No, they are exactly the same as far as this classification is
concerned. No matter what you are touching the working surface with the
expected behavior is that, unlike tablet (which can also be handle
fingers and/or pen) you do not need to have on-screen pointer tracking
your movements.

> 
> > +
> > +/*
> > + * Device capabilities
> > + */
> > +
> > +#define DEVCAPS_PAD_IS_BUTTON  1
> 
> Do we need the following:
> 
> +#define DEVCAPS_PAD_HAS_BUTTONS           2
> +#define DEVCAPS_PAD_HAS_RINGS                  3
> +#define DEVCAPS_PAD_HAS_REL_WHEELS    4
> +#define DEVCAPS_PAD_HAS_ABS_WHEELS    5
> +#define DEVCAPS_PAD_HAS_STRIPS                6

No, you can get all this data from the XXXbits in the device (well, sans
rings/strips as we do not have such events yet). The
DEVCAPS_PAD_IS_BUTTON is to tell userspace that pad itself serves as a
button. The device still emits BTN_LEFT (primary button event) for such
devices but userspace needs to handle it a bit differently.

-- 
Dmitry
