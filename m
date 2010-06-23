Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab0FWIMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:12:54 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:56135 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab0FWIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:12:51 -0400
Message-ID: <4C21C1C3.5050708@euromail.se>
Date: Wed, 23 Jun 2010 10:11:47 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH] input: evdev: Use multi-reader buffer to save space (rev5)
References: <1277059734-2939-1-git-send-email-rydberg@euromail.se> <20100623061939.GB11187@core.coreip.homeip.net>
In-Reply-To: <20100623061939.GB11187@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORL42-0003tG-5s.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1ORL42-0003tG-5s 591bf1e449466b0e3b1f316d89a36764
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Henrik,
> 
> On Sun, Jun 20, 2010 at 08:48:54PM +0200, Henrik Rydberg wrote:
>> @@ -149,11 +148,29 @@ static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
>>  
>>  static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>>  {
>> +	struct input_dev *dev = evdev->handle.dev;
>> +	int head, tail;
>> +
>>  	if (evdev->grab != client)
>>  		return  -EINVAL;
>>  
>> +	spin_lock_irq(&dev->event_lock);
>> +
>> +	head = client->head;
>> +	tail = client->tail;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(client, &evdev->client_list, node) {
>> +		client->head = head;
>> +		client->tail = tail;
>> +	}
>> +	rcu_read_unlock();
>> +
>>  	rcu_assign_pointer(evdev->grab, NULL);
>>  	synchronize_rcu();
> 
> You may not call synchronize_rcu() while holding spinlock and with
> interrupts off.

Thanks.

>> +
>> +	spin_unlock_irq(&dev->event_lock);
>> +
>>  	input_release_device(&evdev->handle);
>>  
>>  	return 0;
>> @@ -162,6 +179,7 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>>  static void evdev_attach_client(struct evdev *evdev,
>>  				struct evdev_client *client)
>>  {
>> +	client->head = client->tail = evdev->head;
>>  	spin_lock(&evdev->client_lock);
> 
> So what happens if we advance evdev->head here but before we added the
> new client to the list? I guess we'll have to wait till next event and
> then client will read both of them...

Right...

> Overall I am starting getting concerned about proper isolation between
> clients. Right now, if one client stops reading events and another one
> issues grab then the first client will only get events that were
> accumulated before grab tookm place. With the new shared buffer the
> first client may get "grabbed" events if it stop for long enough for
> buffer to wrap around.

Doing some research, the semantics of ioctl have obviously been discussed
before, and I believe this points to another such issue. When grabbing a device,
are we guaranteeing that the device no longer sends events to other clients, or
are we guaranteeing that other clients can no longer read the device? If the
latter, clearing all client buffers in conjunction with a grab would be
appropriate, and would solve this issue.

> Do we really same that much memory here? We normally do not have that
> many users connected to event devices at once...

Ok, let's scratch this. Although I think the idea of multi-reader buffers is
sound, it is obviously sufficiently incompatible with the current approach to
produce distastefully complex patches. I will return with a new set which only
fixes the buffer resize problem, and leaves the rest for later.

Thanks,
Henrik

