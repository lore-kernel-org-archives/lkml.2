Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2BKXYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:24:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48142 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab2BKXYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:24:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is not empty.
Date: Sun, 12 Feb 2012 00:28:23 +0100
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
Message-Id: <201202120028.23364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, January 21, 2012, Arve Hjønnevåg wrote:
> Add an ioctl, EVIOCSSUSPENDBLOCK, to block suspend while the event
> queue is not empty. This allows userspace code to process input
> events while the device appears to be asleep.

I have two questions to start with, if you don't mind:

(1) Does Android user space use an analogous interface right now or is it
    a prototype?

(2) What exactly are the use cases for it (ie. what problem does it address
    that cannot be addressed in a different way)?

Rafael

> Signed-off-by: Arve Hjønnevåg <arve@android.com>
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
>  
>  	spin_unlock_irq(&client->buffer_lock);
> @@ -623,6 +635,48 @@ static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
>  	return input_set_keycode(dev, &ke);
>  }
>  
> +static int evdev_enable_suspend_block(struct evdev *evdev,
> +				      struct evdev_client *client)
> +{
> +	struct wakeup_source *ws;
> +	char name[28];
> +
> +	if (client->wakeup_source)
> +		return 0;
> +
> +	snprintf(name, sizeof(name), "%s-%d",
> +		 dev_name(&evdev->dev), task_tgid_vnr(current));
> +
> +	ws = wakeup_source_register(name);
> +	if (!ws)
> +		return -ENOMEM;
> +
> +	spin_lock_irq(&client->buffer_lock);
> +	client->wakeup_source = ws;
> +	if (client->packet_head != client->tail)
> +		__pm_stay_awake(client->wakeup_source);
> +	spin_unlock_irq(&client->buffer_lock);
> +	return 0;
> +}
> +
> +static int evdev_disable_suspend_block(struct evdev *evdev,
> +				       struct evdev_client *client)
> +{
> +	struct wakeup_source *ws;
> +
> +	spin_lock_irq(&client->buffer_lock);
> +	ws = client->wakeup_source;
> +	client->wakeup_source = NULL;
> +	spin_unlock_irq(&client->buffer_lock);
> +
> +	if (ws) {
> +		__pm_relax(ws);
> +		wakeup_source_unregister(ws);
> +	}
> +
> +	return 0;
> +}
> +
>  static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  			   void __user *p, int compat_mode)
>  {
> @@ -696,6 +750,15 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  
>  	case EVIOCSKEYCODE_V2:
>  		return evdev_handle_set_keycode_v2(dev, p);
> +
> +	case EVIOCGSUSPENDBLOCK:
> +		return put_user(!!client->wakeup_source, ip);
> +
> +	case EVIOCSSUSPENDBLOCK:
> +		if (p)
> +			return evdev_enable_suspend_block(evdev, client);
> +		else
> +			return evdev_disable_suspend_block(evdev, client);
>  	}
>  
>  	size = _IOC_SIZE(cmd);
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 3862e32..daf0177 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -129,6 +129,9 @@ struct input_keymap_entry {
>  
>  #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
>  
> +#define EVIOCGSUSPENDBLOCK	_IOR('E', 0x91, int)			/* get suspend block enable */
> +#define EVIOCSSUSPENDBLOCK	_IOW('E', 0x91, int)			/* set suspend block enable */
> +
>  /*
>   * Device properties and quirks
>   */
> 

