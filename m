Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2BOXPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:15:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab2BOXPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:15:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is not empty.
Date: Thu, 16 Feb 2012 00:18:59 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1327112659-31145-1-git-send-email-arve@android.com>
In-Reply-To: <1327112659-31145-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202160018.59187.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, January 21, 2012, Arve Hjønnevåg wrote:
> Add an ioctl, EVIOCSSUSPENDBLOCK, to block suspend while the event
> queue is not empty. This allows userspace code to process input
> events while the device appears to be asleep.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>

Minor nit below.

> ---
>  drivers/input/evdev.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/input.h |    3 ++
>  2 files changed, 66 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 76457d5..e212757 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -43,6 +43,7 @@ struct evdev_client {
>  	unsigned int tail;
>  	unsigned int packet_head; /* [future] position of the first element of next packet */
>  	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
> +	struct wakeup_source *wakeup_source;
>  	struct fasync_struct *fasync;
>  	struct evdev *evdev;
>  	struct list_head node;
> @@ -75,10 +76,14 @@ static void evdev_pass_event(struct evdev_client *client,
>  		client->buffer[client->tail].value = 0;
>  
>  		client->packet_head = client->tail;
> +		if (client->wakeup_source)
> +			__pm_relax(client->wakeup_source);
>  	}
>  
>  	if (event->type == EV_SYN && event->code == SYN_REPORT) {
>  		client->packet_head = client->head;
> +		if (client->wakeup_source)
> +			__pm_stay_awake(client->wakeup_source);
>  		kill_fasync(&client->fasync, SIGIO, POLL_IN);
>  	}
>  
> @@ -255,6 +260,10 @@ static int evdev_release(struct inode *inode, struct file *file)
>  	mutex_unlock(&evdev->mutex);
>  
>  	evdev_detach_client(evdev, client);
> +	if (client->wakeup_source) {
> +		__pm_relax(client->wakeup_source);
> +		wakeup_source_unregister(client->wakeup_source);
> +	}
>  	kfree(client);
>  
>  	evdev_close_device(evdev);
> @@ -373,6 +382,9 @@ static int evdev_fetch_next_event(struct evdev_client *client,
>  	if (have_event) {
>  		*event = client->buffer[client->tail++];
>  		client->tail &= client->bufsize - 1;
> +		if (client->wakeup_source &&
> +		    client->packet_head == client->tail)
> +			__pm_relax(client->wakeup_source);
>  	}

Since __pm_relax(), __pm_stay_awake() and wakeup_source_unregister() all
check if the argument is not NULL, you can simply drop the
client->wakeup_source checks.

Also with the fix I've just posted:

http://marc.info/?l=linux-pm&m=132934445508717&w=4

I think it won't be necessary to call __pm_relax() before
wakeup_source_unregister() any more.

Thanks,
Rafael
