Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2HTNg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:36:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63437 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2HTNgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:36:23 -0400
MIME-Version: 1.0
In-Reply-To: <1344807757-2217-10-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-10-git-send-email-rydberg@euromail.se>
Date: Mon, 20 Aug 2012 15:36:22 +0200
Message-ID: <CAN+gG=G0P3m03WK8-fcsV5RFWLiXBQvxgaM7qMqHzB-C=tQQUg@mail.gmail.com>
Subject: Re: [PATCH 09/19] Input: MT - Handle frame synchronization in core
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

thanks for this patch set.
I'm also happy when someone tries to factorize and optimize some code.
I have a few concerns though:

On Sun, Aug 12, 2012 at 11:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Collect common frame synchronization tasks in a new function,
> input_mt_sync_frame(). Depending on the flags set, it drops
> unseen contacts and performs pointer emulation.

I was really wondering why you needed to put in input-mt something
that appeared only in hid-multitouch.... until I noted that you are
going to use it for bcm5974.
Maybe you should add a comment on it (otherwise, it seams like you're
just adding unused code). Maybe this would also help people
understanding the *frame thing.

>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/input-mt.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/input/mt.h |  9 ++++++
>  2 files changed, 81 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> index bbb3304..21b105e 100644
> --- a/drivers/input/input-mt.c
> +++ b/drivers/input/input-mt.c
> @@ -14,6 +14,14 @@
>
>  #define TRKID_SGN      ((TRKID_MAX + 1) >> 1)
>
> +static void copy_abs(struct input_dev *dev, unsigned int dst, unsigned int src)
> +{
> +       if (dev->absinfo && test_bit(src, dev->absbit)) {
> +               dev->absinfo[dst] = dev->absinfo[src];
> +               dev->absbit[BIT_WORD(dst)] |= BIT_MASK(dst);
> +       }
> +}
> +
>  /**
>   * input_mt_init_slots() - initialize MT input slots
>   * @dev: input device supporting MT events and finger tracking
> @@ -45,6 +53,28 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
>         input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
>         input_set_abs_params(dev, ABS_MT_TRACKING_ID, 0, TRKID_MAX, 0, 0);
>
> +       if (flags & (INPUT_MT_POINTER | INPUT_MT_DIRECT)) {
> +               __set_bit(EV_KEY, dev->evbit);
> +               __set_bit(BTN_TOUCH, dev->keybit);
> +
> +               copy_abs(dev, ABS_X, ABS_MT_POSITION_X);
> +               copy_abs(dev, ABS_Y, ABS_MT_POSITION_Y);
> +               copy_abs(dev, ABS_PRESSURE, ABS_MT_PRESSURE);
> +       }
> +       if (flags & INPUT_MT_POINTER) {
> +               __set_bit(BTN_TOOL_FINGER, dev->keybit);
> +               __set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
> +               if (num_slots >= 3)
> +                       __set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
> +               if (num_slots >= 4)
> +                       __set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> +               if (num_slots >= 5)
> +                       __set_bit(BTN_TOOL_QUINTTAP, dev->keybit);
> +               __set_bit(INPUT_PROP_POINTER, dev->propbit);
> +       }
> +       if (flags & INPUT_MT_DIRECT)
> +               __set_bit(INPUT_PROP_DIRECT, dev->propbit);
> +
>         /* Mark slots as 'unused' */
>         for (i = 0; i < num_slots; i++)
>                 input_mt_set_value(&mt->slots[i], ABS_MT_TRACKING_ID, -1);
> @@ -87,12 +117,17 @@ void input_mt_report_slot_state(struct input_dev *dev,
>         struct input_mt_slot *slot;
>         int id;
>
> -       if (!mt || !active) {
> +       if (!mt)
> +               return;
> +
> +       slot = &mt->slots[input_abs_get_val(dev, ABS_MT_SLOT)];
> +       slot->frame = mt->frame;
> +
> +       if (!active) {
>                 input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
>                 return;
>         }
>
> -       slot = &mt->slots[input_abs_get_val(dev, ABS_MT_SLOT)];
>         id = input_mt_get_value(slot, ABS_MT_TRACKING_ID);
>         if (id < 0 || input_mt_get_value(slot, ABS_MT_TOOL_TYPE) != tool_type)
>                 id = input_mt_new_trkid(mt);
> @@ -177,3 +212,38 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
>         }
>  }
>  EXPORT_SYMBOL(input_mt_report_pointer_emulation);
> +
> +/**
> + * input_mt_sync_frame() - synchronize mt frame
> + * @dev: input device with allocated MT slots
> + *
> + * Close the frame and prepare the internal state for a new one.
> + * Depending on the flags, marks unused slots as inactive and performs
> + * pointer emulation.
> + */
> +void input_mt_sync_frame(struct input_dev *dev)
> +{
> +       struct input_mt *mt = dev->mt;
> +       struct input_mt_slot *s;
> +
> +       if (!mt)
> +               return;
> +
> +       if (mt->flags & INPUT_MT_DROP_UNUSED) {
> +               for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
> +                       if (s->frame == mt->frame)
> +                               continue;
> +                       input_mt_slot(dev, s - mt->slots);
> +                       input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);

Shouldn't we rely on input_mt_report_slot_state instead of doing it by hand?

> +               }
> +       }
> +
> +       if (mt->flags & INPUT_MT_POINTER)
> +               input_mt_report_pointer_emulation(dev, true);
> +
> +       if (mt->flags & INPUT_MT_DIRECT)
> +               input_mt_report_pointer_emulation(dev, false);

The function input_mt_report_pointer_emulation could be called twice
if the driver has both INPUT_MT_POINTER and INPUT_MT_DIRECT flags. Are
they mutual exclusive?

Cheers,
Benjamin

> +
> +       mt->frame++;
> +}
> +EXPORT_SYMBOL(input_mt_sync_frame);
> diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
> index 03c52ce..a11d485 100644
> --- a/include/linux/input/mt.h
> +++ b/include/linux/input/mt.h
> @@ -15,12 +15,17 @@
>
>  #define TRKID_MAX      0xffff
>
> +#define INPUT_MT_POINTER       0x0001  /* pointer device, e.g. trackpad */
> +#define INPUT_MT_DIRECT                0x0002  /* direct device, e.g. touchscreen */
> +#define INPUT_MT_DROP_UNUSED   0x0004  /* drop contacts not seen in frame */
>  /**
>   * struct input_mt_slot - represents the state of an input MT slot
>   * @abs: holds current values of ABS_MT axes for this slot
> + * @frame: last frame at which input_mt_report_slot_state() was called
>   */
>  struct input_mt_slot {
>         int abs[ABS_MT_LAST - ABS_MT_FIRST + 1];
> +       unsigned int frame;
>  };
>
>  /**
> @@ -28,12 +33,14 @@ struct input_mt_slot {
>   * @trkid: stores MT tracking ID for the next contact
>   * @num_slots: number of MT slots the device uses
>   * @flags: input_mt operation flags
> + * @frame: increases every time input_mt_sync_frame() is called
>   * @slots: array of slots holding current values of tracked contacts
>   */
>  struct input_mt {
>         int trkid;
>         int num_slots;
>         unsigned int flags;
> +       unsigned int frame;
>         struct input_mt_slot slots[];
>  };
>
> @@ -79,4 +86,6 @@ void input_mt_report_slot_state(struct input_dev *dev,
>  void input_mt_report_finger_count(struct input_dev *dev, int count);
>  void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count);
>
> +void input_mt_sync_frame(struct input_dev *dev);
> +
>  #endif
> --
> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
