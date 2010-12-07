Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab0LGTpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:45:22 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:54907 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0LGTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=psc3KYUpOovdYq7SKVZfOJALHjt7ZuEpChb4AHDqe8mVjDP6ur4cjawHF/ifV9U2qI
         kpSPorNmWrZTHVCqilOUkeH0I2w0aE8HXDZORr5G9JTovvBp9arDuso2fLPwHDmyWMs6
         wxgEPcajEiw7oLPXlTCurmryQKI0wWglhkZDA=
Date: Tue, 7 Dec 2010 11:37:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Message-ID: <20101207193736.GB31411@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
 <AANLkTi=JcekxsbUXXUmxkUug_+hwiYkDxbCEKEe-DWDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=JcekxsbUXXUmxkUug_+hwiYkDxbCEKEe-DWDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 01:18:41PM -0600, Chris Bagwell wrote:
> On Tue, Dec 7, 2010 at 1:25 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
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
> > + */
> > +struct input_devinfo {
> > +       __u32 types;
> > +       __u32 capabilities;
> > +};
> > +
> 
> "types" sounds like it can support being more then one thing at a time
> but I don't think that is intent from below names.  Should rename to
> "type"?

I'd be wary of restricting device to be only one type. There are some
that are mutually exclusive (toucscreen/touchpad/tablet) but I'd leave
option of mixed-type devices open.

-- 
Dmitry
