Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab0FWQyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:54:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34592 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0FWQyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FDI3esL0D2yQI0BZx2FaqUHsf8ku0E1s2Uk2J2u37Sb5k17ANkTSflt9HPrfMSnbIO
         60bXpNWtumddNSwnVyoSRd1GUSH7HyHWkLdIoDYnL3g7M16oW8WWDDkmVyLnRIlypR1L
         UhYy1gO/gNCt3GV4vnja9EjNZoPh/w3zaBzk4=
MIME-Version: 1.0
In-Reply-To: <1277291686-7153-3-git-send-email-rydberg@euromail.se>
References: <1277291686-7153-1-git-send-email-rydberg@euromail.se>
	<1277291686-7153-2-git-send-email-rydberg@euromail.se>
	<1277291686-7153-3-git-send-email-rydberg@euromail.se>
Date: Wed, 23 Jun 2010 09:54:19 -0700
Message-ID: <AANLkTilWSe-rdy1johctU6CXdV11Iiw8GkTTQOrsE2aO@mail.gmail.com>
Subject: Re: [PATCH 2/5] input: Use driver hint to compute the evdev buffer 
	size (rev3)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Ping Cheng <pingc@wacom.com>, Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

I like this patchset. Along with the mtdev patchset submitted to x.org
by Chase, I see a great collaboration for the MT support.  Keep up the
good work.

I have a minor comment inline.

Thank you.

Ping

On Wed, Jun 23, 2010 at 4:14 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Some devices, in particular MT devices, produce a lot of data.  This
> leads to a high frequency of lost packets in evdev, which by default
> uses a fairly small event buffer. Let the drivers hint the average
> number of events per packet for the device by calling the
> input_set_events_per_packet(), and use that information when computing
> the evdev buffer size.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/evdev.c |    5 ++++-
>  include/linux/input.h |   17 +++++++++++++++++
>  2 files changed, 21 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 5d84e59..728802f 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -11,6 +11,7 @@
>  #define EVDEV_MINOR_BASE       64
>  #define EVDEV_MINORS           32
>  #define EVDEV_MIN_BUFFER_SIZE  64
> +#define EVDEV_BUF_PACKETS      8
>
>  #include <linux/poll.h>
>  #include <linux/sched.h>
> @@ -51,7 +52,9 @@ static DEFINE_MUTEX(evdev_table_mutex);
>
>  static int evdev_compute_buffer_size(struct input_dev *dev)
>  {
> -       return EVDEV_MIN_BUFFER_SIZE;
> +       int nev = dev->hint_events_per_packet * EVDEV_BUF_PACKETS;
> +       nev = max(nev, EVDEV_MIN_BUFFER_SIZE);
> +       return roundup_pow_of_two(nev);

I think we have a backward compatibility issue here. This routine will
return 7 when nev falls to the default value
(EVDEV_MIN_BUFFER_SIZE/64).  This could happen to those drivers that
don't report MT events or forget/don't feel the need to set
hint_events_per_packet since the old BUFFER_SIZE worked perfectly for
them.  We need to keep the return value for those drivers as 64 so we
could allocate the same space as it was in [PATCH 1/5].

>  }
>
>  static void evdev_pass_event(struct evdev_client *client,
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 20e4eac..9e024b6 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -1162,6 +1162,8 @@ struct input_dev {
>        unsigned long ffbit[BITS_TO_LONGS(FF_CNT)];
>        unsigned long swbit[BITS_TO_LONGS(SW_CNT)];
>
> +       unsigned int hint_events_per_packet;
> +
>        unsigned int keycodemax;
>        unsigned int keycodesize;
>        void *keycode;
> @@ -1439,6 +1441,21 @@ static inline void input_mt_slot(struct input_dev *dev, int slot)
>
>  void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
>
> +/**
> + * input_set_events_per_packet - tell handlers about the driver event rate
> + * @dev: the input device used by the driver
> + * @nev: the average number of events between calls to input_sync()
> + *
> + * If the event rate sent from a device is unusually large, use this
> + * function to set the expected event rate. This will allow handlers
> + * to set up an approriate buffer size for the event stream, in order
> + * to minimize information loss.
> + */
> +static inline void input_set_events_per_packet(struct input_dev *dev, int nev)
> +{
> +       dev->hint_events_per_packet = nev;
> +}
> +
>  static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
>  {
>        dev->absmin[axis] = min;
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
