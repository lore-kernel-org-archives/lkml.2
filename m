Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab2HNTcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:32:24 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49876 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756867Ab2HNTcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <1344807757-2217-3-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-3-git-send-email-rydberg@euromail.se>
Date: Tue, 14 Aug 2012 12:32:21 -0700
Message-ID: <CAF8JNhJzu9wW52PbydVuH9y8TwOs=mPO0DJn0aJBpsh-wETzuQ@mail.gmail.com>
Subject: Re: [PATCH 02/19] Input: Improve the events-per-packet estimate
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 2:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Many MT devices send a number of keys along with the mt information.
> This patch makes sure that there is room for them in the packet
> buffer.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/input.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 6e90705..8ebf116 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1777,6 +1777,9 @@ static unsigned int input_estimate_events_per_packet(struct input_dev *dev)
>                 if (test_bit(i, dev->relbit))
>                         events++;
>
> +       /* Make room for KEY and MSC events */
> +       events += 7;

Hi Henrik,

It is nice to get rid of the redundant pieces and to incorporate
common functions. Thank you.

I have a question about the code above though.  Why do we use 7
instead of going through the keys like:

	for (i = 0; i < KEY_MAX; i++)
		if (test_bit(i, dev->keybit))
			events++;

Ping

> +
>         return events;
>  }
>
> @@ -1815,6 +1818,7 @@ int input_register_device(struct input_dev *dev)
>  {
>         static atomic_t input_no = ATOMIC_INIT(0);
>         struct input_handler *handler;
> +       unsigned int packet_size;
>         const char *path;
>         int error;
>
> @@ -1827,9 +1831,9 @@ int input_register_device(struct input_dev *dev)
>         /* Make sure that bitmasks not mentioned in dev->evbit are clean. */
>         input_cleanse_bitmasks(dev);
>
> -       if (!dev->hint_events_per_packet)
> -               dev->hint_events_per_packet =
> -                               input_estimate_events_per_packet(dev);
> +       packet_size = input_estimate_events_per_packet(dev);
> +       if (dev->hint_events_per_packet < packet_size)
> +               dev->hint_events_per_packet = packet_size;
>
>         /*
>          * If delay and period are pre-set by the driver, then autorepeating
> --
> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
