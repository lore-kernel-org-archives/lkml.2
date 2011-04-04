Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1DDWQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:16:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1DDWQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110404213659.GC984@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-4-git-send-email-jeffbrown@android.com> <20110404213659.GC984@core.coreip.homeip.net>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Mon, 4 Apr 2011 15:16:13 -0700
Message-ID: <BANLkTi=0q6DbXki5RhE8eakermnVixN67g@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] input: evdev: Make device readable only when it
 contains a complete packet.
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rydberg@euromail.se, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,
I don't think the new patch is completely correct.

On Mon, Apr 4, 2011 at 2:36 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> I think we should target SYN_REPORT directly. SYN_CONFIG is unused and
> SYN_DROPPED is not interesting till next SYN_REPORT anyway. Given the
> changes to the previous patch I have the following:

Explicitly checking for SYN_REPORT makes sense.  I wasn't sure to do
with SYN_CONFIG before so I tried to keep the condition somewhat
conservative.

Per previous comments on an older iteration of this patch, it probably
makes sense to calculate this flag once in evdev_event and pass it to
evdev_pass_event.

bool full_sync = (type == EV_SYN && code == SYN_REPORT);

> @@ -41,6 +41,7 @@ struct evdev {
>  struct evdev_client {
>        unsigned int head;
>        unsigned int tail;
> +       unsigned int last_syn;  /* position of the last EV_SYN/SYN_REPORT */

This comment for last_syn is not quite right.  We need last_syn to
refer to the position just beyond the last sync.  Otherwise the device
will not become readable until another event is written there.  The
invariants for last_syn should be similar to those for head.

Whereas tail != head means buffer non-empty, tail != last_syn should
mean buffer is readable.

It looks like we almost maintain those invariants here, except for SYN_DROPPED.

>        spinlock_t buffer_lock; /* protects access to buffer, head and tail */
>        struct fasync_struct *fasync;
>        struct evdev *evdev;
> @@ -72,12 +73,16 @@ static void evdev_pass_event(struct evdev_client *client,
>                client->buffer[client->tail].type = EV_SYN;
>                client->buffer[client->tail].code = SYN_DROPPED;
>                client->buffer[client->tail].value = 0;
> +

Should use client->head here so that the SYN_DROPPED is readable.

> +               client->last_syn = client->tail;
>        }
>
>        spin_unlock(&client->buffer_lock);

Can use full_sync or something equivalent instead of repeating the
condition on EV_SYN / SYN_REPORT here.

> -       if (event->type == EV_SYN)
> +       if (event->type == EV_SYN && event->code == SYN_REPORT) {

I don't think it's safe to modify last_syn outside of the spin lock.
This should be done above.

> +               client->last_syn = client->head;
>                kill_fasync(&client->fasync, SIGIO, POLL_IN);
> +       }
>  }

MISSING: We need to also modify evdev_event to only call
wake_up_interruptible when enqueuing a sync.  It does not make sense
to wake up waiters unless the device is about to become readable
again.

This also means we should wake after having written SYN_DROPPED.  We
might need to make evdev_pass_event return (or take by reference) a
boolean that indicates whether at least one client has become
readable.

Pseudo-code:

if (full_sync || evdev_became_readable_for_a_client_due_to_syn_dropped)
    wake_up_interruptible(&evdev->wait);

>  /*
> @@ -387,12 +392,12 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
>        if (count < input_event_size())
>                return -EINVAL;
> -       if (client->head == client->tail && evdev->exist &&
> +       if (client->last_syn == client->tail && evdev->exist &&
>            (file->f_flags & O_NONBLOCK))
>                return -EAGAIN;
>
>        retval = wait_event_interruptible(evdev->wait,
> -               client->head != client->tail || !evdev->exist);
> +               client->last_syn != client->tail || !evdev->exist);
>        if (retval)
>                return retval;
>
> @@ -421,7 +426,7 @@ static unsigned int evdev_poll(struct file *file, poll_table *wait)
>        poll_wait(file, &evdev->wait, wait);
>
>        mask = evdev->exist ? POLLOUT | POLLWRNORM : POLLHUP | POLLERR;
> -       if (client->head != client->tail)
> +       if (client->last_syn != client->tail)
>                mask |= POLLIN | POLLRDNORM;
>
>        return mask;

It looks to me like this patch isn't based on top of your previous
patch for SYN_DROPPED.  Specifically, the SYN_DROPPED should be
inserted before the newly enqueued event but I don't see that above.

Jeff.
