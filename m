Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2BFIb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:31:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35847 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2BFIb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <1328515542-3779-1-git-send-email-rydberg@euromail.se>
References: <1328515542-3779-1-git-send-email-rydberg@euromail.se>
From: Daniel Kurtz <djkurtz@google.com>
Date: Mon, 6 Feb 2012 16:31:36 +0800
Message-ID: <CAGS+omD9aVcLKZnTi=8FfpUxeERHxxrWr4NM2GX+1LL1716awQ@mail.gmail.com>
Subject: Re: [PATCH v4] Input: Add EVIOC mechanism for MT slots
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, chasedouglas@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 4:05 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> This patch adds the ability to extract MT slot data via a new ioctl,
> EVIOCGMTSLOTS. The function returns an array of slot values for the
> specified ABS_MT event type.

Henrik,

Instead of returning the values of just one event type, can you please
return values for all defined MT event types for all slots?  Userspace
can already know how big such an array would be required, since it can
probe to determine how many ABS_MT types have been defined.

It seems like the most common use case for this API is to fetch the
complete "initial state" when a userspace program first attaches to a
(stateful) evdev device.  Fetching all at once would be slightly more
efficient, and would resolve (or at worst minimize) race conditions
that could occur if input events are arriving while userspace is still
slowly ioctl'ing out the event type initial states, one at a time.

If there are strong use cases for 'just probe one event type', perhaps
you can keep the proposed API, but allow a special event type value,
like "ABS_MT_*", to fetch all?

BTW, I am very happy that you are finally plugging this particular
issue since it has been bugging me for many months.  We sometimes use
a userspace tools to record evdev events for a touch device while a
user is performing a multitouch gesture.  If the userspace tool starts
while there are already contacts on the device, there is currently no
unambiguous way to determine what that initial state should have been.
 Thus, some information is always lost.  This patch would allow us to
address this in the tools.  I've just been to busy/lazy to propose a
fix of my own :).

-Daniel

>
> Example of user space usage:
>
> struct { unsigned code; int values[64]; } req;
> req.code = ABS_MT_POSITION_X;
> if (ioctl(fd, EVIOCGMTSLOTS(sizeof(req)), &req) < 0)
>        return -1;
> for (i = 0; i < 64; i++)
>        printf("slot %d: %d\n", i, req.values[i]);
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Here is the fourth version of the patch.
>
> Rather than over-specifying the ioctl binary format by introducing a
> struct object that does not fit everyone, this version simply leaves
> all object definitions to userland.
>
> Thanks,
> Henrik
>
>  drivers/input/evdev.c |   27 ++++++++++++++++++++++++++-
>  include/linux/input.h |   25 +++++++++++++++++++++++++
>  2 files changed, 51 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 76457d5..e4cad16 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -20,7 +20,7 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <linux/input.h>
> +#include <linux/input/mt.h>
>  #include <linux/major.h>
>  #include <linux/device.h>
>  #include "input-compat.h"
> @@ -623,6 +623,28 @@ static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
>        return input_set_keycode(dev, &ke);
>  }
>
> +static int evdev_handle_mt_request(struct input_dev *dev,
> +                                  unsigned int size,
> +                                  int __user *ip)
> +{
> +       const struct input_mt_slot *mt = dev->mt;
> +       unsigned int code;
> +       int max_slots;
> +       int i;
> +
> +       if (get_user(code, &ip[0]))
> +               return -EFAULT;
> +       if (!input_is_mt_value(code))
> +               return -EINVAL;
> +
> +       max_slots = (size - sizeof(__u32)) / sizeof(__s32);
> +       for (i = 0; i < dev->mtsize && i < max_slots; i++)
> +               if (put_user(input_mt_get_value(&mt[i], code), &ip[1 + i]))
> +                       return -EFAULT;
> +
> +       return 0;
> +}
> +
>  static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>                           void __user *p, int compat_mode)
>  {
> @@ -708,6 +730,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>                return bits_to_user(dev->propbit, INPUT_PROP_MAX,
>                                    size, p, compat_mode);
>
> +       case EVIOCGMTSLOTS(0):
> +               return evdev_handle_mt_request(dev, size, ip);
> +
>        case EVIOCGKEY(0):
>                return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
>
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 3862e32..af26443 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -114,6 +114,31 @@ struct input_keymap_entry {
>  #define EVIOCGUNIQ(len)                _IOC(_IOC_READ, 'E', 0x08, len)         /* get unique identifier */
>  #define EVIOCGPROP(len)                _IOC(_IOC_READ, 'E', 0x09, len)         /* get device properties */
>
> +/**
> + * EVIOCGMTSLOTS(len) - get MT slot values
> + *
> + * The ioctl buffer argument should be binary equivalent to
> + *
> + * struct input_mt_request_layout {
> + *     __u32 code;
> + *     __s32 values[num_slots];
> + * };
> + *
> + * where num_slots is the (arbitrary) number of MT slots to extract.
> + *
> + * The ioctl size argument (len) is the size of the buffer, which
> + * should satisfy len = (num_slots + 1) * sizeof(__s32).  If len is
> + * too small to fit all available slots, the first num_slots are
> + * returned.
> + *
> + * Before the call, code is set to the wanted ABS_MT event type. On
> + * return, values[] is filled with the slot values for the specified
> + * ABS_MT code.
> + *
> + * If the request code is not an ABS_MT value, -EINVAL is returned.
> + */
> +#define EVIOCGMTSLOTS(len)     _IOC(_IOC_READ, 'E', 0x0a, len)
> +
>  #define EVIOCGKEY(len)         _IOC(_IOC_READ, 'E', 0x18, len)         /* get global key state */
>  #define EVIOCGLED(len)         _IOC(_IOC_READ, 'E', 0x19, len)         /* get all LEDs */
>  #define EVIOCGSND(len)         _IOC(_IOC_READ, 'E', 0x1a, len)         /* get all sounds status */
> --
> 1.7.9
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Daniel Kurtz | Software Engineer | djkurtz@google.com | 650.204.0722
