Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab0FWGTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:19:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44869 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0FWGTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vch3OmMVXZXh56TE9Aibt/uC8WMJVz23+vPNUO0iLiXUOZdKefrJ1ciD7n5xIlQz0p
         y/eZfyV4o1Pe918vUVtpFc05xFskq1mwOoF4KGqn0BjgE6Wu9oaz3+7lGHSR2kCPQJMn
         IU1M3DqH5YEIS43+miWBX6WsBDw5C0nB19qbA=
Date: Tue, 22 Jun 2010 23:19:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH] input: evdev: Use multi-reader buffer to save space
 (rev5)
Message-ID: <20100623061939.GB11187@core.coreip.homeip.net>
References: <1277059734-2939-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277059734-2939-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, Jun 20, 2010 at 08:48:54PM +0200, Henrik Rydberg wrote:
> @@ -149,11 +148,29 @@ static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
>  
>  static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>  {
> +	struct input_dev *dev = evdev->handle.dev;
> +	int head, tail;
> +
>  	if (evdev->grab != client)
>  		return  -EINVAL;
>  
> +	spin_lock_irq(&dev->event_lock);
> +
> +	head = client->head;
> +	tail = client->tail;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(client, &evdev->client_list, node) {
> +		client->head = head;
> +		client->tail = tail;
> +	}
> +	rcu_read_unlock();
> +
>  	rcu_assign_pointer(evdev->grab, NULL);
>  	synchronize_rcu();

You may not call synchronize_rcu() while holding spinlock and with
interrupts off.

> +
> +	spin_unlock_irq(&dev->event_lock);
> +
>  	input_release_device(&evdev->handle);
>  
>  	return 0;
> @@ -162,6 +179,7 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>  static void evdev_attach_client(struct evdev *evdev,
>  				struct evdev_client *client)
>  {
> +	client->head = client->tail = evdev->head;
>  	spin_lock(&evdev->client_lock);

So what happens if we advance evdev->head here but before we added the
new client to the list? I guess we'll have to wait till next event and
then client will read both of them...

Overall I am starting getting concerned about proper isolation between
clients. Right now, if one client stops reading events and another one
issues grab then the first client will only get events that were
accumulated before grab tookm place. With the new shared buffer the
first client may get "grabbed" events if it stop for long enough for
buffer to wrap around.

Do we really same that much memory here? We normally do not have that
many users connected to event devices at once...

Thanks.

-- 
Dmitry
