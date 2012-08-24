Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab2HXED1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:03:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36546 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2HXEDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:03:21 -0400
MIME-Version: 1.0
In-Reply-To: <1344807757-2217-7-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se> <1344807757-2217-7-git-send-email-rydberg@euromail.se>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 24 Aug 2012 12:03:00 +0800
X-Google-Sender-Auth: GjwxeU7MWEXFcy_qqiBX6U751jc
Message-ID: <CAGS+omC3x31Yq0c10AZzMtfaytUkhTRgkBnhekm=YdzAC5M8vA@mail.gmail.com>
Subject: Re: [PATCH 06/19] Input: Send events one packet at a time
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 5:42 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On heavy event loads, such as a multitouch driver, the irqsoff latency
> can be as high as 250 us.  By accumulating a frame worth of data
> before passing it on, the latency can be dramatically reduced.  As a
> side effect, the special EV_SYN handling can be removed, since the
> frame is now atomic.

This patch(set) is very interesting and exciting.  Thanks!
Some questions and comments inline...

>
> This patch adds the events() handler callback and uses it if it
> exists. The latency is improved by 50 us even without the callback.

How much of the savings is just from reducing the number of
add_input_randomness()  calls from 1-per-input_value to 1-per-frame?

Could you achieve similar savings by only calling add_input_randomness
on the first input_value after each EV_SYN/SYN_REPORT (ie "when sync =
true")?

>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/input-mt.c |   3 +-
>  drivers/input/input.c    | 187 ++++++++++++++++++++++++++++-------------------
>  include/linux/input.h    |  26 +++++--
>  3 files changed, 132 insertions(+), 84 deletions(-)
>
> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> index 58bde77..f956b27 100644
> --- a/drivers/input/input-mt.c
> +++ b/drivers/input/input-mt.c
> @@ -63,7 +63,6 @@ void input_mt_destroy_slots(struct input_dev *dev)
>  {
>         kfree(dev->mt);
>         dev->mt = NULL;
> -       dev->slot = 0;
>  }
>  EXPORT_SYMBOL(input_mt_destroy_slots);
>
> @@ -91,7 +90,7 @@ void input_mt_report_slot_state(struct input_dev *dev,
>                 return;
>         }
>
> -       slot = &mt->slots[dev->slot];
> +       slot = &mt->slots[input_abs_get_val(dev, ABS_MT_SLOT)];
>         id = input_mt_get_value(slot, ABS_MT_TRACKING_ID);
>         if (id < 0 || input_mt_get_value(slot, ABS_MT_TOOL_TYPE) != tool_type)
>                 id = input_mt_new_trkid(mt);
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index a57c4a5..9b6aa15 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -90,46 +90,81 @@ static void input_stop_autorepeat(struct input_dev *dev)
>   * filtered out, through all open handles. This function is called with
>   * dev->event_lock held and interrupts disabled.
>   */
> -static void input_pass_event(struct input_dev *dev,
> -                            unsigned int type, unsigned int code, int value)
> +static size_t input_to_handler(struct input_handle *handle,
> +                                   struct input_value *vals, size_t count)

The only thing that is a little strange with this function is that it
actually changes the 'vals' array due to in-place filtering.  It means
that input_to_handler can't handle const arrays of vals, which may
have a performance impact in some cases (like key repeat).  You are
relying on this behavior since you want to pass the final filtered
input_value array to ->events() without copying, but this seems to be
optimizing the 'filtered' case relative to the (normal?) unfiltered
behavior.  Probably not worth changing, though.

>  {
> -       struct input_handler *handler;
> -       struct input_handle *handle;
> +       struct input_handler *handler = handle->handler;
> +       struct input_value *end = vals;
> +       struct input_value *v;
>
> -       rcu_read_lock();
> +       for (v = vals; v != vals + count; v++) {
> +               if (handler->filter &&

if (handler->filter == false), you could skip the whole loop and just
assign end = vals + count.
Also, the original version assumed that if a handler had the grab, it
couldn't be a filter, and would skip filtering entirely.

> +                   handler->filter(handle, v->type, v->code, v->value))

Maybe we can have a handler->filter_events(handle, vals, count) that
returns the number of events left after filtering.
This would allow more sophisticated filtering that could inspect an
entire frame.

> +                       continue;
> +               if (end != v)
> +                       *end = *v;
> +               end++;
> +       }
>
> -       handle = rcu_dereference(dev->grab);
> -       if (handle)
> -               handle->handler->event(handle, type, code, value);
> -       else {
> -               bool filtered = false;
> +       count = end - vals;
> +       if (!count)
> +               return 0;
>
> -               list_for_each_entry_rcu(handle, &dev->h_list, d_node) {
> -                       if (!handle->open)
> -                               continue;

In the original version, one handler would not call both ->filter()
and ->event().
I'm not sure if that was a bug or a feature.  But, you now make it possible.
However, this opens up the possibility of a filter handler processing
events via its ->event that would get filtered out by a later
handler's filter.

In sum, I think if we assume a handler only has either ->filter or
->event (->events), then we can split this function into two, one that
only does filtering on filters, and one that only passes the resulting
filtered events.

> +       if (handler->events)
> +               handler->events(handle, vals, count);
> +       else
> +               for (v = vals; v != end; v++)
> +                       handler->event(handle, v->type, v->code, v->value);
> +
> +       return count;
> +}
> +
> +/*
> + * Pass values first through all filters and then, if event has not been
> + * filtered out, through all open handles. This function is called with
> + * dev->event_lock held and interrupts disabled.
> + */
> +static void input_pass_values(struct input_dev *dev,
> +                             struct input_value *vals, size_t count)
> +{
> +       struct input_handle *handle;
> +       struct input_value *v;
>
> -                       handler = handle->handler;
> -                       if (!handler->filter) {
> -                               if (filtered)
> -                                       break;
> +       if (!count)
> +               return;
>
> -                               handler->event(handle, type, code, value);
> +       rcu_read_lock();
>
> -                       } else if (handler->filter(handle, type, code, value))
> -                               filtered = true;
> -               }
> +       handle = rcu_dereference(dev->grab);
> +       if (handle) {
> +               count = input_to_handler(handle, vals, count);
> +       } else {
> +               list_for_each_entry_rcu(handle, &dev->h_list, d_node)
> +                       if (handle->open)
> +                               count = input_to_handler(handle, vals, count);
>         }
>
>         rcu_read_unlock();
>
> +       add_input_randomness(vals->type, vals->code, vals->value);
> +
>         /* trigger auto repeat for key events */
> -       if (type == EV_KEY && value != 2) {
> -               if (value)
> -                       input_start_autorepeat(dev, code);
> -               else
> -                       input_stop_autorepeat(dev);
> +       for (v = vals; v != vals + count; v++) {
> +               if (v->type == EV_KEY && v->value != 2) {
> +                       if (v->value)
> +                               input_start_autorepeat(dev, v->code);
> +                       else
> +                               input_stop_autorepeat(dev);
> +               }
>         }
> +}
> +
> +static void input_pass_event(struct input_dev *dev,
> +                            unsigned int type, unsigned int code, int value)
> +{
> +       struct input_value vals[] = { { type, code, value } };
>
> +       input_pass_values(dev, vals, 1);
>  }
>
>  /*
> @@ -146,18 +181,12 @@ static void input_repeat_key(unsigned long data)
>
>         if (test_bit(dev->repeat_key, dev->key) &&
>             is_event_supported(dev->repeat_key, dev->keybit, KEY_MAX)) {
> +               struct input_value vals[] =  {
> +                       { EV_KEY, dev->repeat_key, 2 },
> +                       { EV_SYN, SYN_REPORT, 1 },
> +               };
>
> -               input_pass_event(dev, EV_KEY, dev->repeat_key, 2);
> -
> -               if (dev->sync) {
> -                       /*
> -                        * Only send SYN_REPORT if we are not in a middle
> -                        * of driver parsing a new hardware packet.
> -                        * Otherwise assume that the driver will send
> -                        * SYN_REPORT once it's done.
> -                        */
> -                       input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
> -               }
> +               input_pass_values(dev, vals, 2);
>
>                 if (dev->rep[REP_PERIOD])
>                         mod_timer(&dev->timer, jiffies +
> @@ -170,37 +199,23 @@ static void input_repeat_key(unsigned long data)
>  #define INPUT_IGNORE_EVENT     0
>  #define INPUT_PASS_TO_HANDLERS 1
>  #define INPUT_PASS_TO_DEVICE   2
> +#define INPUT_FLUSH            4
>  #define INPUT_PASS_TO_ALL      (INPUT_PASS_TO_HANDLERS | INPUT_PASS_TO_DEVICE)
>
>  static int input_handle_abs_event(struct input_dev *dev,
>                                   unsigned int code, int *pval)
>  {
>         bool is_mt_event;
> -       int *pold;
> -
> -       if (code == ABS_MT_SLOT) {
> -               /*
> -                * "Stage" the event; we'll flush it later, when we
> -                * get actual touch data.
> -                */
> -               if (dev->mt && *pval >= 0 && *pval < dev->mt->num_slots)
> -                       dev->slot = *pval;
> -
> -               return INPUT_IGNORE_EVENT;
> -       }
> +       int *pold = NULL;
>
>         is_mt_event = input_is_mt_value(code);
>
>         if (!is_mt_event) {
>                 pold = &dev->absinfo[code].value;
>         } else if (dev->mt) {
> -               pold = &dev->mt->slots[dev->slot].abs[code - ABS_MT_FIRST];
> -       } else {
> -               /*
> -                * Bypass filtering for multi-touch events when
> -                * not employing slots.
> -                */
> -               pold = NULL;
> +               int slot = dev->absinfo[ABS_MT_SLOT].value;
> +               if (slot >= 0 && slot < dev->mt->num_slots)
> +                       pold = &dev->mt->slots[slot].abs[code - ABS_MT_FIRST];
>         }
>
>         if (pold) {
> @@ -212,17 +227,11 @@ static int input_handle_abs_event(struct input_dev *dev,
>                 *pold = *pval;
>         }
>
> -       /* Flush pending "slot" event */
> -       if (is_mt_event && dev->slot != input_abs_get_val(dev, ABS_MT_SLOT)) {
> -               input_abs_set_val(dev, ABS_MT_SLOT, dev->slot);
> -               input_pass_event(dev, EV_ABS, ABS_MT_SLOT, dev->slot);
> -       }
> -
>         return INPUT_PASS_TO_HANDLERS;
>  }
>
> -static void input_handle_event(struct input_dev *dev,
> -                              unsigned int type, unsigned int code, int value)
> +static int input_get_disposition(struct input_dev *dev,
> +                         unsigned int type, unsigned int code, int value)
>  {
>         int disposition = INPUT_IGNORE_EVENT;
>
> @@ -235,13 +244,9 @@ static void input_handle_event(struct input_dev *dev,
>                         break;
>
>                 case SYN_REPORT:
> -                       if (!dev->sync) {
> -                               dev->sync = true;
> -                               disposition = INPUT_PASS_TO_HANDLERS;
> -                       }
> +                       disposition = INPUT_PASS_TO_HANDLERS | INPUT_FLUSH;
>                         break;
>                 case SYN_MT_REPORT:
> -                       dev->sync = false;
>                         disposition = INPUT_PASS_TO_HANDLERS;
>                         break;
>                 }
> @@ -326,14 +331,35 @@ static void input_handle_event(struct input_dev *dev,
>                 break;
>         }
>
> -       if (disposition != INPUT_IGNORE_EVENT && type != EV_SYN)
> -               dev->sync = false;
> +       return disposition;
> +}
> +
> +static void input_handle_event(struct input_dev *dev,
> +                              unsigned int type, unsigned int code, int value)
> +{
> +       struct input_value *v;
> +       int disp;
> +
> +       disp = input_get_disposition(dev, type, code, value);
>
> -       if ((disposition & INPUT_PASS_TO_DEVICE) && dev->event)
> +       if ((disp & INPUT_PASS_TO_DEVICE) && dev->event)
>                 dev->event(dev, type, code, value);
>
> -       if (disposition & INPUT_PASS_TO_HANDLERS)
> -               input_pass_event(dev, type, code, value);
> +       if (!dev->vals)
> +               return;
> +
> +       if (disp & INPUT_PASS_TO_HANDLERS) {
> +               v = &dev->vals[dev->num_vals++];
> +               v->type = type;
> +               v->code = code;
> +               v->value = value;
> +       }
> +
> +       if ((disp & INPUT_FLUSH) || (dev->num_vals >= dev->max_vals)) {
> +               if (dev->num_vals >= 2)

I'm not sure about this check.  What if the previous "frame" had
dev->max_vals + 1 events, and so dev->max_vals of them (all but the
SYN_REPORT) were already passed.
We would not get that frame's SYN_REPORT all by itself, so "disp &
INPUT_FLUSH" is true, but dev->num_vals == 1.  We still want to pass
the SYN_REPORT immediately, and not save until we get another full
frame.

Is this even possible?

> +                       input_pass_values(dev, dev->vals, dev->num_vals);
> +               dev->num_vals = 0;
> +       }
>  }
>
>  /**
> @@ -361,7 +387,6 @@ void input_event(struct input_dev *dev,
>         if (is_event_supported(type, dev->evbit, EV_MAX)) {
>
>                 spin_lock_irqsave(&dev->event_lock, flags);
> -               add_input_randomness(type, code, value);
>                 input_handle_event(dev, type, code, value);
>                 spin_unlock_irqrestore(&dev->event_lock, flags);
>         }
> @@ -842,8 +867,7 @@ int input_set_keycode(struct input_dev *dev,
>             __test_and_clear_bit(old_keycode, dev->key)) {
>
>                 input_pass_event(dev, EV_KEY, old_keycode, 0);
> -               if (dev->sync)
> -                       input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
> +               input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
>         }
>
>   out:
> @@ -1425,6 +1449,7 @@ static void input_dev_release(struct device *device)
>         input_ff_destroy(dev);
>         input_mt_destroy_slots(dev);
>         kfree(dev->absinfo);
> +       kfree(dev->vals);
>         kfree(dev);
>
>         module_put(THIS_MODULE);
> @@ -1845,6 +1870,14 @@ int input_register_device(struct input_dev *dev)
>         if (dev->hint_events_per_packet < packet_size)
>                 dev->hint_events_per_packet = packet_size;
>
> +       dev->num_vals = 0;
> +       dev->max_vals = max(dev->hint_events_per_packet, packet_size);
> +
> +       kfree(dev->vals);
How could this already be non-NULL?  Is it possible to re-register a device?

A huge optimization to input event processing is pretty exciting!

-Daniel

> +       dev->vals = kcalloc(dev->max_vals, sizeof(*dev->vals), GFP_KERNEL);
> +       if (!dev->vals)
> +               return -ENOMEM;
> +
>         /*
>          * If delay and period are pre-set by the driver, then autorepeating
>          * is handled by the driver itself and we don't do it in input.c.
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 76d6788..1f7f172 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -1169,6 +1169,18 @@ struct ff_effect {
>  #include <linux/mod_devicetable.h>
>
>  /**
> + * struct input_value - input value representation
> + * @type: type of value (EV_KEY, EV_ABS, etc)
> + * @code: the value code
> + * @value: the value
> + */
> +struct input_value {
> +       __u16 type;
> +       __u16 code;
> +       __s32 value;
> +};
> +
> +/**
>   * struct input_dev - represents an input device
>   * @name: name of the device
>   * @phys: physical path to the device in the system hierarchy
> @@ -1204,7 +1216,6 @@ struct ff_effect {
>   * @timer: timer for software autorepeat
>   * @rep: current values for autorepeat parameters (delay, rate)
>   * @mt: pointer to multitouch state
> - * @slot: MT slot currently being transmitted
>   * @absinfo: array of &struct input_absinfo elements holding information
>   *     about absolute axes (current value, min, max, flat, fuzz,
>   *     resolution)
> @@ -1241,7 +1252,6 @@ struct ff_effect {
>   *     last user closes the device
>   * @going_away: marks devices that are in a middle of unregistering and
>   *     causes input_open_device*() fail with -ENODEV.
> - * @sync: set to %true when there were no new events since last EV_SYN
>   * @dev: driver model's view of this device
>   * @h_list: list of input handles associated with the device. When
>   *     accessing the list dev->mutex must be held
> @@ -1285,7 +1295,6 @@ struct input_dev {
>         int rep[REP_CNT];
>
>         struct input_mt *mt;
> -       int slot;
>
>         struct input_absinfo *absinfo;
>
> @@ -1307,12 +1316,14 @@ struct input_dev {
>         unsigned int users;
>         bool going_away;
>
> -       bool sync;
> -
>         struct device dev;
>
>         struct list_head        h_list;
>         struct list_head        node;
> +
> +       size_t num_vals;
> +       size_t max_vals;
> +       struct input_value *vals;
>  };
>  #define to_input_dev(d) container_of(d, struct input_dev, dev)
>
> @@ -1373,6 +1384,9 @@ struct input_handle;
>   * @event: event handler. This method is being called by input core with
>   *     interrupts disabled and dev->event_lock spinlock held and so
>   *     it may not sleep
> + * @events: event sequence handler. This method is being called by
> + *     input core with interrupts disabled and dev->event_lock
> + *     spinlock held and so it may not sleep
>   * @filter: similar to @event; separates normal event handlers from
>   *     "filters".
>   * @match: called after comparing device's id with handler's id_table
> @@ -1409,6 +1423,8 @@ struct input_handler {
>         void *private;
>
>         void (*event)(struct input_handle *handle, unsigned int type, unsigned int code, int value);
> +       void (*events)(struct input_handle *handle,
> +                      const struct input_value *vals, size_t count);
>         bool (*filter)(struct input_handle *handle, unsigned int type, unsigned int code, int value);
>         bool (*match)(struct input_handler *handler, struct input_dev *dev);
>         int (*connect)(struct input_handler *handler, struct input_dev *dev, const struct input_device_id *id);
> --
> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
