Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab1CYILG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:11:06 -0400
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:32981 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1CYILA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:11:00 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 25 Mar 2011 09:14:42 +0100
To: Jeff Brown <jeffbrown@android.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Brown <jeffbrown@google.com>
Subject: Re: [PATCH 3/4] input: evdev: Indicate buffer overrun with
 SYN_DROPPED.
Message-ID: <20110325081442.GA5664@polaris.bitmath.org>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-4-git-send-email-jeffbrown@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300842244-42723-4-git-send-email-jeffbrown@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q326P-0002Sj-JG.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1Q326P-0002Sj-JG e90e49b14ab182da6a9866030bd1fe3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 7f42d3a..203ed70 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -57,14 +57,20 @@ static void evdev_pass_event(struct evdev_client *client,
>  {
>  	/*
>  	 * Interrupts are disabled, just acquire the lock.
> -	 * Make sure we don't leave with the client buffer
> -	 * "empty" by having client->head == client->tail.
> +	 * When the client buffer is full, replace the tail with SYN_DROPPED
> +	 * to let the client know that events were dropped.  Ensure that the
> +	 * head and tail never coincide so the buffer does not appear "empty".
>  	 */
>  	spin_lock(&client->buffer_lock);
> -	do {
> -		client->buffer[client->head++] = *event;
> -		client->head &= client->bufsize - 1;
> -	} while (client->head == client->tail);
> +	client->buffer[client->head++] = *event;
> +	client->head &= client->bufsize - 1;
> +	if (client->head == client->tail) {
> +		client->tail = (client->tail + 1) & (client->bufsize - 1);
> +		client->buffer[client->tail].time = event->time;
> +		client->buffer[client->tail].type = EV_SYN;
> +		client->buffer[client->tail].code = SYN_DROPPED;
> +		client->buffer[client->tail].value = 0;
> +	}

It looks like this will eventually fill the entire buffer with
SYN_DROPPED events if the client does not catch up.

Thanks,
Henrik
