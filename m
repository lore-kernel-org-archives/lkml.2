Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab2BCAEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:04:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32842 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2BCAEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:04:05 -0500
Message-ID: <4F2B24AC.1020408@gmail.com>
Date: Fri, 03 Feb 2012 01:05:00 +0100
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Input: Add EVIOC mechanism for MT slots
References: <1328036403-2827-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1328036403-2827-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 08:00 PM, Henrik Rydberg wrote:
> This patch adds the ability to extract MT slot data via a new ioctl,
> EVIOCGMTSLOTS. The function returns an array of slot values for the
> specified ABS_MT event type.
> 
> Example of user space usage:
> 
> struct INPUT_MT_REQUEST(64) req;
> req.code = ABS_MT_POSITION_X;
> if (ioctl(fd, EVIOCGMTSLOTS(sizeof(req)), &req) < 0)
> 	return -1;
> for (i = 0; i < 64; i++)
> 	printf("slot %d: %d\n", i, req.values[i]);
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Dmitry,
> 
> Here is v3 of the EVIOC patch for MT slots. The number of slots if
> gone, the struct is simplified, targeting userland, and calling the
> ioctl with a smaller struct will return the first set of slots.
> 
> Cheers,
> Henrik
> 
> 
>  drivers/input/evdev.c |   27 ++++++++++++++++++++++++++-
>  include/linux/input.h |   23 +++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 76457d5..e4cad16 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -20,7 +20,7 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <linux/input.h>
> +#include <linux/input/mt.h>
>  #include <linux/major.h>
>  #include <linux/device.h>
>  #include "input-compat.h"
> @@ -623,6 +623,28 @@ static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
>  	return input_set_keycode(dev, &ke);
>  }
>  
> +static int evdev_handle_mt_request(struct input_dev *dev,
> +				   unsigned int size,
> +				   int __user *ip)
> +{
> +	const struct input_mt_slot *mt = dev->mt;
> +	unsigned int code;
> +	int max_slots;
> +	int i;
> +
> +	if (get_user(code, &ip[0]))
> +		return -EFAULT;
> +	if (!input_is_mt_value(code))
> +		return -EINVAL;
> +
> +	max_slots = (size - sizeof(__u32)) / sizeof(__s32);
> +	for (i = 0; i < dev->mtsize && i < max_slots; i++)
> +		if (put_user(input_mt_get_value(&mt[i], code), &ip[1 + i]))
> +			return -EFAULT;
> +
> +	return 0;
> +}
> +
>  static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  			   void __user *p, int compat_mode)
>  {
> @@ -708,6 +730,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  		return bits_to_user(dev->propbit, INPUT_PROP_MAX,
>  				    size, p, compat_mode);
>  
> +	case EVIOCGMTSLOTS(0):
> +		return evdev_handle_mt_request(dev, size, ip);
> +
>  	case EVIOCGKEY(0):
>  		return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
>  
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 3862e32..1e7e2e5 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -99,6 +99,28 @@ struct input_keymap_entry {
>  	__u8  scancode[32];
>  };
>  
> +/**
> + * struct INPUT_MT_REQUEST(num_slots) - used by EVIOCGMTSLOTS ioctl
> + * @code: ABS_MT code to read
> + * @values: value array, one value per slot
> + *
> + * The struct definition is used to create an appropriate MT slot message
> + * buffer in userland. Before the call, code is set to the wanted ABS_MT
> + * event type. On return, the value array is filled with the slot values
> + * for the specified ABS_MT code.
> + *
> + * The call argument (len) is the size of the return buffer, which should
> + * satisfy len >= sizeof(struct INPUT_MT_REQUEST(num_slots)).  If len is
> + * too small to fit all available slots, the first num_slots are returned.
> + *
> + * If the request code is not an ABS_MT value, -EINVAL is returned.
> + */
> +#define INPUT_MT_REQUEST(num_slots)					\
> +	{								\
> +		__u32 code;						\
> +		__s32 values[num_slots];				\

I think this assumes a userspace C compiler that can handle variable
length arrays. This would require only compiling in C source code at the
C99 standard or later. It looks like C++ doesn't even allow variable
length arrays, though gcc handles it. According to:

http://www.cplusplus.com/forum/beginner/1601/

it looks like Borland c++ compilers may not be able to compile this :(.

-- Chase
