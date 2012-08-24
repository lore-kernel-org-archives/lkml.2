Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab2HXEHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:07:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39611 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2HXEHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <1344807757-2217-8-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se> <1344807757-2217-8-git-send-email-rydberg@euromail.se>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 24 Aug 2012 12:07:23 +0800
X-Google-Sender-Auth: 6hCVZOisT3bF5OcMYsM7uLyhw50
Message-ID: <CAGS+omCRsi=irbHXsDah48nOOMHYrNCCsnstCdqUTRvi=ZU99Q@mail.gmail.com>
Subject: Re: [PATCH 07/19] Input: evdev - Add the events() callback
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 5:42 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> By sending a full frame of events at the same time, the irqsoff
> latency at heavy load is brought down from 200 us to 100 us.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/evdev.c | 68 +++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 47 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index a0692c5..1bf4ce5 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -54,16 +54,9 @@ struct evdev_client {
>  static struct evdev *evdev_table[EVDEV_MINORS];
>  static DEFINE_MUTEX(evdev_table_mutex);
>
> -static void evdev_pass_event(struct evdev_client *client,
> -                            struct input_event *event,
> -                            ktime_t mono, ktime_t real)
> +static void __pass_event(struct evdev_client *client,
> +                        const struct input_event *event)
>  {
> -       event->time = ktime_to_timeval(client->clkid == CLOCK_MONOTONIC ?
> -                                       mono : real);
> -
> -       /* Interrupts are disabled, just acquire the lock. */
> -       spin_lock(&client->buffer_lock);
> -
>         client->buffer[client->head++] = *event;
>         client->head &= client->bufsize - 1;
>
> @@ -86,42 +79,74 @@ static void evdev_pass_event(struct evdev_client *client,
>                 client->packet_head = client->head;
>                 kill_fasync(&client->fasync, SIGIO, POLL_IN);
>         }
> +}
> +
> +static void evdev_pass_values(struct evdev_client *client,
> +                             const struct input_value *vals, size_t count,
> +                             ktime_t mono, ktime_t real)
> +{
> +       struct evdev *evdev = client->evdev;
> +       const struct input_value *v;
> +       struct input_event event;
> +       bool wakeup = false;
> +
> +       event.time = ktime_to_timeval(client->clkid == CLOCK_MONOTONIC ?
> +                                     mono : real);
> +
> +       /* Interrupts are disabled, just acquire the lock. */
> +       spin_lock(&client->buffer_lock);
> +
> +       for (v = vals; v != vals + count; v++) {
> +               event.type = v->type;
> +               event.code = v->code;
> +               event.value = v->value;
> +               __pass_event(client, &event);
> +               if (v->type == EV_SYN && v->code == SYN_REPORT)
> +                       wakeup = true;
> +       }
>
>         spin_unlock(&client->buffer_lock);
> +
> +       if (wakeup)
> +               wake_up_interruptible(&evdev->wait);
>  }
>
>  /*
> - * Pass incoming event to all connected clients.
> + * Pass incoming events to all connected clients.
>   */
> -static void evdev_event(struct input_handle *handle,
> -                       unsigned int type, unsigned int code, int value)
> +static void evdev_events(struct input_handle *handle,
> +                        const struct input_value *vals, size_t count)
>  {
>         struct evdev *evdev = handle->private;
>         struct evdev_client *client;
> -       struct input_event event;
>         ktime_t time_mono, time_real;
>
>         time_mono = ktime_get();
>         time_real = ktime_sub(time_mono, ktime_get_monotonic_offset());
>
> -       event.type = type;
> -       event.code = code;
> -       event.value = value;
> -
>         rcu_read_lock();
>
>         client = rcu_dereference(evdev->grab);
>
>         if (client)
> -               evdev_pass_event(client, &event, time_mono, time_real);
> +               evdev_pass_values(client, vals, count, time_mono, time_real);
>         else
>                 list_for_each_entry_rcu(client, &evdev->client_list, node)
> -                       evdev_pass_event(client, &event, time_mono, time_real);
> +                       evdev_pass_values(client, vals, count,
> +                                         time_mono, time_real);

Hi Henrik,

Reading the time just once and applying it as the timestamp to an
entire frame is very nice.
However, is it ever possible for the SYN_REPORT to get delayed until
the next batch of input_values, therefore breaking the assumption that
the SYN_REPORT timestamp applies to the rest of the input_values for
its frame?

Also, bonus points if the input driver could set this input frame
timestamp based on when it first saw a hardware interrupt rather then
when evdev gets around to sending the frame to userspace.  This could
potentially remove a lot of the timing jitter userspace sees when
computing ballistics based on input event timestamps.

Thanks!
-Daniel

>
>         rcu_read_unlock();
> +}
>
> -       if (type == EV_SYN && code == SYN_REPORT)
> -               wake_up_interruptible(&evdev->wait);
> +/*
> + * Pass incoming event to all connected clients.
> + */
> +static void evdev_event(struct input_handle *handle,
> +                       unsigned int type, unsigned int code, int value)
> +{
> +       struct input_value vals[] = { { type, code, value } };
> +
> +       evdev_events(handle, vals, 1);
>  }
>
>  static int evdev_fasync(int fd, struct file *file, int on)
> @@ -1050,6 +1075,7 @@ MODULE_DEVICE_TABLE(input, evdev_ids);
>
>  static struct input_handler evdev_handler = {
>         .event          = evdev_event,
> +       .events         = evdev_events,
>         .connect        = evdev_connect,
>         .disconnect     = evdev_disconnect,
>         .fops           = &evdev_fops,
> --
> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
