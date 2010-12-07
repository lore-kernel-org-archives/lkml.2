Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0LGS4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:56:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37005 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab0LGS4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u2ofFqIegWhZ52ZGZPhEb9qyqsAx/S6sielf8na7fzSOc0jxa9k89fIXfh7Eon+N6J
         Kd1rH0JD2usngX8P9phwzB0rV2AmRZuz7huS+xQ/TKKSvC5lfzPNGLvchXlBJgRilQp/
         Dq06qHiISkVQrWXYxdZEHN1g9RRYoC0CvuEm8=
MIME-Version: 1.0
In-Reply-To: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
Date: Tue, 7 Dec 2010 10:48:04 -0800
Message-ID: <AANLkTi=dhFSrAnRHDB4Vcsxh8xqvztpg4Fxyorzu9q7u@mail.gmail.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 11:25 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Today, userspace sets up an input device based on the data it emits.
> This is not always enough; a tablet and a touchscreen may emit exactly
> the same data, for instance, but the former should be set up with a
> pointer whereas the latter does not need to. Recently, a new type of
> touchpad has emerged where the buttons are under the pad, which changes
> handling logic without changing the emitted data. This patch introduces
> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
> about the device resulting in proper setup.
>
> Suggested-by: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> Cc: Ping Cheng <pingc@wacom.com>
> Cc: Chris Bagwell <chris@cnpbagwell.com>
> ---
> Hi all,
>
> Here is a patch attempting to formulate Dmitry's device type idea. It
> compiles, but further testing awaits a general consesus on the device
> types and capabilities to start out with. Are the ones listed here apt
> for the job?
>
> Cheers,
> Henrik
>
>  drivers/input/evdev.c |    6 ++++++
>  include/linux/input.h |   34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index e3f7fc6..db78592 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -632,6 +632,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>                        return -EFAULT;
>                return 0;
>
> +       case EVIOCGDEVINFO:
> +               if (copy_to_user(p, &dev->devinfo,
> +                                sizeof(struct input_devinfo)))
> +                       return -EFAULT;
> +               return 0;
> +
>        case EVIOCGREP:
>                if (!test_bit(EV_REP, dev->evbit))
>                        return -ENOSYS;
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 6ef4446..8c58d2a 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -57,6 +57,21 @@ struct input_absinfo {
>  };
>
>  /**
> + * struct input_devinfo - device information via EVIOCGDEVINFO ioctl
> + * @types: bitmask of types (DEVTYPE_*) matching this device
> + * @capabilities: bitmask of capabilities (DEVCAPS_*) of this device
> + *
> + * This struct provides information about the device needed for
> + * automatic setup in userspace, such as if the device is direct
> + * (touchscreen) or indirect (touchpad), and if there are other
> + * special considerations, such as the touchpad also being a button.

I guess you are talking about the pad is also a button. What about the
pad has buttons? And there could be more than one button on it. Can we
pass the number of buttons on the pad as well?

> + */
> +struct input_devinfo {
> +       __u32 types;
> +       __u32 capabilities;
> +};
> +
> +/**
>  * struct input_keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
>  * @scancode: scancode represented in machine-endian form.
>  * @len: length of the scancode that resides in @scancode buffer.
> @@ -91,6 +106,7 @@ struct input_keymap_entry {
>  #define EVIOCGNAME(len)                _IOC(_IOC_READ, 'E', 0x06, len)         /* get device name */
>  #define EVIOCGPHYS(len)                _IOC(_IOC_READ, 'E', 0x07, len)         /* get physical location */
>  #define EVIOCGUNIQ(len)                _IOC(_IOC_READ, 'E', 0x08, len)         /* get unique identifier */
> +#define EVIOCGDEVINFO          _IOR('E', 0x09, struct input_devinfo)   /* get device information */
>
>  #define EVIOCGKEY(len)         _IOC(_IOC_READ, 'E', 0x18, len)         /* get global key state */
>  #define EVIOCGLED(len)         _IOC(_IOC_READ, 'E', 0x19, len)         /* get all LEDs */
> @@ -108,6 +124,23 @@ struct input_keymap_entry {
>  #define EVIOCGRAB              _IOW('E', 0x90, int)                    /* Grab/Release device */
>
>  /*
> + * Device types
> + */
> +
> +#define DEVTYPE_KEYBOARD       0
> +#define DEVTYPE_MOUSE          1
> +#define DEVTYPE_JOYSTICK       2
> +#define DEVTYPE_TOUCHPAD       3
> +#define DEVTYPE_TABLET         4
> +#define DEVTYPE_TOUCHSCREEN    5

TOUCHSCREEN can be finger touch screen and pen touch screen. They are
different types for clients. Should we add one for pen touch screen,
something like DEVTYPE_TABLETPC?

> +
> +/*
> + * Device capabilities
> + */
> +
> +#define DEVCAPS_PAD_IS_BUTTON  1

Do we need the following:

+#define DEVCAPS_PAD_HAS_BUTTONS           2
+#define DEVCAPS_PAD_HAS_RINGS                  3
+#define DEVCAPS_PAD_HAS_REL_WHEELS    4
+#define DEVCAPS_PAD_HAS_ABS_WHEELS    5
+#define DEVCAPS_PAD_HAS_STRIPS                6

Thank you.

Ping

> +
> +/*
>  * Event types
>  */
>
> @@ -1177,6 +1210,7 @@ struct input_dev {
>        const char *phys;
>        const char *uniq;
>        struct input_id id;
> +       struct input_devinfo devinfo;
>
>        unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
>        unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
