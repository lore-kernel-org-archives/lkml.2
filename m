Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0LQTYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:24:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41685 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0LQTYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:24:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RU5Tklfy2xYSRS75NtYjCnd47mEncE6e+ZLQqoeVASIWYAbNE/rbg5T6BXzr/L1NNc
         uWdKfE3KYlDWjZ5/sMSeUXqUUwN+2rnNqwPXnW9y43J7/XXKc+Z3Uxfj5sT3VD4b+QKP
         EEGI/pShSXQoLVf4ZxIn5MJ27AwZNy7pvrbTs=
MIME-Version: 1.0
In-Reply-To: <1292531413-28924-1-git-send-email-rydberg@euromail.se>
References: <1292531413-28924-1-git-send-email-rydberg@euromail.se>
Date: Fri, 17 Dec 2010 11:24:44 -0800
Message-ID: <AANLkTimj3h_oVSj_QA5V=qB7WXXifbWcFtEgA6+6zPZc@mail.gmail.com>
Subject: Re: [PATCH] Input: introduce device information ioctl
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 12:30 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Today, userspace sets up an input device based on the data it emits.
> This is not always enough; a tablet and a touchscreen may emit exactly
> the same data, for instance, but the former should be set up with a
> pointer whereas the latter does not need to. Recently, a new type of
> touchpad has emerged where the buttons are under the pad, which
> changes handling logic without changing the emitted data. This patch
> introduces a new ioctl, EVIOCGPROP, which enables user access to a set
> of device properties useful during setup. The properties are given as
> a bitmap in the same fashion as the event types, and are also made
> available via sysfs.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Reviewed-by: Ping Cheng <pingc@wacom.com>

I wonder if we need to mention this new ioctl somewhere under
Documentation/input or not. INPUT_PROP_SEMI_MT could add useful
information for multi-touch-protocol.txt. The others could play a role
in Chase's new Documentation/input/evdev-codes.txt.

Ping

> ---
>  drivers/input/evdev.c       |    4 ++++
>  drivers/input/input.c       |   15 +++++++++++++++
>  drivers/input/misc/uinput.c |    4 ++++
>  include/linux/input.h       |   16 ++++++++++++++++
>  include/linux/uinput.h      |    1 +
>  5 files changed, 40 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index e3f7fc6..0cd97e8 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -677,6 +677,10 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  #define EVIOC_MASK_SIZE(nr)    ((nr) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
>        switch (EVIOC_MASK_SIZE(cmd)) {
>
> +       case EVIOCGPROP(0):
> +               return bits_to_user(dev->propbit, INPUT_PROP_MAX,
> +                                   size, p, compat_mode);
> +
>        case EVIOCGKEY(0):
>                return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
>
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 37708d1..c3e5fc7 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1318,11 +1318,26 @@ static ssize_t input_dev_show_modalias(struct device *dev,
>  }
>  static DEVICE_ATTR(modalias, S_IRUGO, input_dev_show_modalias, NULL);
>
> +static int input_print_bitmap(char *buf, int buf_size, unsigned long *bitmap,
> +                             int max, int add_cr);
> +
> +static ssize_t input_dev_show_properties(struct device *dev,
> +                                        struct device_attribute *attr,
> +                                        char *buf)
> +{
> +       struct input_dev *input_dev = to_input_dev(dev);
> +       int len = input_print_bitmap(buf, PAGE_SIZE, input_dev->propbit,
> +                                    INPUT_PROP_MAX, true);
> +       return min_t(int, len, PAGE_SIZE);
> +}
> +static DEVICE_ATTR(properties, S_IRUGO, input_dev_show_properties, NULL);
> +
>  static struct attribute *input_dev_attrs[] = {
>        &dev_attr_name.attr,
>        &dev_attr_phys.attr,
>        &dev_attr_uniq.attr,
>        &dev_attr_modalias.attr,
> +       &dev_attr_properties.attr,
>        NULL
>  };
>
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index bea8972..82542a1 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -680,6 +680,10 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>                        retval = uinput_set_bit(arg, swbit, SW_MAX);
>                        break;
>
> +               case UI_SET_PROPBIT:
> +                       retval = uinput_set_bit(arg, propbit, INPUT_PROP_MAX);
> +                       break;
> +
>                case UI_SET_PHYS:
>                        if (udev->state == UIST_CREATED) {
>                                retval = -EINVAL;
> diff --git a/include/linux/input.h b/include/linux/input.h
> index b3a1e02..8d9c76c 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -91,6 +91,7 @@ struct input_keymap_entry {
>  #define EVIOCGNAME(len)                _IOC(_IOC_READ, 'E', 0x06, len)         /* get device name */
>  #define EVIOCGPHYS(len)                _IOC(_IOC_READ, 'E', 0x07, len)         /* get physical location */
>  #define EVIOCGUNIQ(len)                _IOC(_IOC_READ, 'E', 0x08, len)         /* get unique identifier */
> +#define EVIOCGPROP(len)                _IOC(_IOC_READ, 'E', 0x09, len)         /* get device properties */
>
>  #define EVIOCGKEY(len)         _IOC(_IOC_READ, 'E', 0x18, len)         /* get global key state */
>  #define EVIOCGLED(len)         _IOC(_IOC_READ, 'E', 0x19, len)         /* get all LEDs */
> @@ -108,6 +109,18 @@ struct input_keymap_entry {
>  #define EVIOCGRAB              _IOW('E', 0x90, int)                    /* Grab/Release device */
>
>  /*
> + * Device properties and quirks
> + */
> +
> +#define INPUT_PROP_POINTER             0x00    /* needs a pointer */
> +#define INPUT_PROP_DIRECT              0x01    /* direct input devices */
> +#define INPUT_PROP_BUTTONPAD           0x02    /* has button(s) under pad */
> +#define INPUT_PROP_SEMI_MT             0x03    /* touch rectangle only */
> +
> +#define INPUT_PROP_MAX                 0x1f
> +#define INPUT_PROP_CNT                 (INPUT_PROP_MAX + 1)
> +
> +/*
>  * Event types
>  */
>
> @@ -1090,6 +1103,7 @@ struct ff_effect {
>  * @phys: physical path to the device in the system hierarchy
>  * @uniq: unique identification code for the device (if device has it)
>  * @id: id of the device (struct input_id)
> + * @propbit: bitmap of device properties and quirks
>  * @evbit: bitmap of types of events supported by the device (EV_KEY,
>  *     EV_REL, etc.)
>  * @keybit: bitmap of keys/buttons this device has
> @@ -1173,6 +1187,8 @@ struct input_dev {
>        const char *uniq;
>        struct input_id id;
>
> +       unsigned long propbit[BITS_TO_LONGS(INPUT_PROP_CNT)];
> +
>        unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
>        unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
>        unsigned long relbit[BITS_TO_LONGS(REL_CNT)];
> diff --git a/include/linux/uinput.h b/include/linux/uinput.h
> index 05f7fed2..d28c726 100644
> --- a/include/linux/uinput.h
> +++ b/include/linux/uinput.h
> @@ -104,6 +104,7 @@ struct uinput_ff_erase {
>  #define UI_SET_FFBIT           _IOW(UINPUT_IOCTL_BASE, 107, int)
>  #define UI_SET_PHYS            _IOW(UINPUT_IOCTL_BASE, 108, char*)
>  #define UI_SET_SWBIT           _IOW(UINPUT_IOCTL_BASE, 109, int)
> +#define UI_SET_PROPBIT         _IOW(UINPUT_IOCTL_BASE, 110, int)
>
>  #define UI_BEGIN_FF_UPLOAD     _IOWR(UINPUT_IOCTL_BASE, 200, struct uinput_ff_upload)
>  #define UI_END_FF_UPLOAD       _IOW(UINPUT_IOCTL_BASE, 201, struct uinput_ff_upload)
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
