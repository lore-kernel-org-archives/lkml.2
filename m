Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1DEMCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:02:37 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:42815 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1DEMCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:02:35 -0400
X-Greylist: delayed 1302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 08:02:35 EDT
X-SENDER-IP: [85.230.173.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuNEADz/mk1V5q1yPGdsb2JhbACJFZxUCwEBAQE3Moh5uhINhV4EkQuCKA
X-IronPort-AV: E=Sophos;i="4.63,303,1299452400"; 
   d="scan'208";a="179969703"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 5 Apr 2011 13:41:18 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jeff Brown <jeffbrown@android.com>, djkurtz@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Brown <jeffbrown@google.com>
Subject: Re: [PATCH v2 3/4] input: evdev: Indicate buffer overrun with
 SYN_DROPPED.
Message-ID: <20110405114118.GA19217@polaris.bitmath.org>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-3-git-send-email-jeffbrown@android.com>
 <20110404213338.GB984@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404213338.GB984@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Input: evdev - indicate buffer overrun with SYN_DROPPED
> 
> From: Jeff Brown <jeffbrown@google.com>
> 
> Add a new EV_SYN code, SYN_DROPPED, to inform the client when input
> events have been dropped from the evdev input buffer due to a
> buffer overrun.  The client should use this event as a hint to
> reset its state or ignore all following events until the next
> packet begins.
> 
> Signed-off-by: Jeff Brown <jeffbrown@android.com>
> [dtor@mail.ru: Implement Henrik's suggestion and drop old events in
>  case of overflow.]
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  Documentation/input/event-codes.txt |    6 ++++++
>  drivers/input/evdev.c               |   33 +++++++++++++++++++++------------
>  include/linux/input.h               |    1 +
>  3 files changed, 28 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
> index d6732a4..e0326a0 100644
> --- a/Documentation/input/event-codes.txt
> +++ b/Documentation/input/event-codes.txt
> @@ -79,6 +79,12 @@ defined only by when they are sent in the evdev event stream.
>    - Used to synchronize and separate touch events. See the
>      multi-touch-protocol.txt document for more information.
>  
> +* SYN_DROPPED:
> +  - Used to indicate buffer overrun in the evdev client's event queue.
> +    Client should ignore all events up to and including next SYN_REPORT
> +    event and query the device (using EVIOCG* ioctls) to obtain its
> +    current state.
> +
>  EV_KEY:
>  ----------
>  EV_KEY events take the form KEY_<name> or BTN_<name>. For example, KEY_A is used
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 7f42d3a..f1c0910 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -39,13 +39,13 @@ struct evdev {
>  };
>  
>  struct evdev_client {
> -	int head;
> -	int tail;
> +	unsigned int head;
> +	unsigned int tail;
>  	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
>  	struct fasync_struct *fasync;
>  	struct evdev *evdev;
>  	struct list_head node;
> -	int bufsize;
> +	unsigned int bufsize;
>  	struct input_event buffer[];
>  };
>  
> @@ -55,16 +55,25 @@ static DEFINE_MUTEX(evdev_table_mutex);
>  static void evdev_pass_event(struct evdev_client *client,
>  			     struct input_event *event)
>  {
> -	/*
> -	 * Interrupts are disabled, just acquire the lock.
> -	 * Make sure we don't leave with the client buffer
> -	 * "empty" by having client->head == client->tail.
> -	 */
> +	/* Interrupts are disabled, just acquire the lock. */
>  	spin_lock(&client->buffer_lock);
> -	do {
> -		client->buffer[client->head++] = *event;
> -		client->head &= client->bufsize - 1;
> -	} while (client->head == client->tail);
> +
> +	client->buffer[client->head++] = *event;
> +	client->head &= client->bufsize - 1;
> +
> +	if (unlikely(client->head == client->tail)) {
> +		/*
> +		 * This effectively "drops" all unconsumed events, leaving
> +		 * EV_SYN/SYN_DROPPED plus the newest event in the queue.
> +		 */
> +		client->tail = (client->head - 2) & (client->bufsize - 1);
> +
> +		client->buffer[client->tail].time = event->time;
> +		client->buffer[client->tail].type = EV_SYN;
> +		client->buffer[client->tail].code = SYN_DROPPED;
> +		client->buffer[client->tail].value = 0;
> +	}
> +
>  	spin_unlock(&client->buffer_lock);
>  
>  	if (event->type == EV_SYN)
> diff --git a/include/linux/input.h b/include/linux/input.h
> index f3a7794..71d3651 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -167,6 +167,7 @@ struct input_keymap_entry {
>  #define SYN_REPORT		0
>  #define SYN_CONFIG		1
>  #define SYN_MT_REPORT		2
> +#define SYN_DROPPED		3
>  
>  /*
>   * Keys and buttons

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
