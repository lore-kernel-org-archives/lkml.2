Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab2BXFRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:17:04 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39140 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab2BXFRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:17:02 -0500
Date: Thu, 23 Feb 2012 21:16:49 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC][PATCH 4/7] Input / PM: Add ioctl to block suspend while
 event queue is not empty
Message-ID: <20120224051649.GB7666@count0.beaverton.ibm.com>
References: <201202070200.55505.rjw@sisk.pl>
 <201202220031.46219.rjw@sisk.pl>
 <201202220034.58836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201202220034.58836.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022405-5930-0000-0000-000005803491
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:34:58AM +0100, Rafael J. Wysocki wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> Add a new ioctl, EVIOCSWAKEUPSRC, to attach a wakeup source object to
> an evdev client event queue, such that it will be active whenever the
> queue is not empty.  Then, all events in the queue will be regarded
> as wakeup events in progress and pm_get_wakeup_count() will block (or
> return false if woken up by a signal) until they are removed from the
> queue.  In consequence, if the checking of wakeup events is enabled
> (e.g. throught the /sys/power/wakeup_count interface), the system
> won't be able to go into a sleep state until the queue is empty.
> 
> This allows user space processes to handle situations in which they
> want to do a select() on an evdev descriptor, so they go to sleep
> until there are some events to read from the device's queue, and then
> they don't want the system to go into a sleep state until all the
> events are read (presumably for further processing).  Of course, if
> they don't want the system to go into a sleep state _after_ all the
> events have been read from the queue, they have to use a separate
> mechanism that will prevent the system from doing that and it has
> to be activated before reading the first event (that also may be the
> last one).

I haven't seen this idea mentioned before but I must admit I haven't
been following this thread too closely so apologies (and don't bother
rehashing) if it has:

Could you just add this to epoll so that any fd userspace chooses would be
capable of doing this without introducing potentially ecclectic ioctl
interfaces?

struct epoll_event ev;

epfd = epoll_create1(EPOLL_STAY_AWAKE_SET);
ev.data.ptr = foo;
epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);

Which could be useful because you can put one epollfd in another's epoll
set. Or maybe as an EPOLLKEEPAWAKE flag in the event struct sort of like
EPOLLET:

epfd = epoll_create1(0);
ev.events = EPOLLIN|EPOLLKEEPAWAKE;
epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);

> 
> [rjw: Removed unnecessary checks, changed the names of the new ioctls
>  and the names of the functions that add/remove wakeup source objects
>  to/from evdev clients, modified the changelog.
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/input/evdev.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/input.h |    3 ++
>  2 files changed, 58 insertions(+)
> 
> Index: linux/drivers/input/evdev.c
> ===================================================================
> --- linux.orig/drivers/input/evdev.c
> +++ linux/drivers/input/evdev.c
> @@ -43,6 +43,7 @@ struct evdev_client {
>  	unsigned int tail;
>  	unsigned int packet_head; /* [future] position of the first element of next packet */
>  	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
> +	struct wakeup_source *wakeup_source;
>  	struct fasync_struct *fasync;
>  	struct evdev *evdev;
>  	struct list_head node;
> @@ -75,10 +76,12 @@ static void evdev_pass_event(struct evde
>  		client->buffer[client->tail].value = 0;
> 
>  		client->packet_head = client->tail;
> +		__pm_relax(client->wakeup_source);
>  	}
> 
>  	if (event->type == EV_SYN && event->code == SYN_REPORT) {
>  		client->packet_head = client->head;
> +		__pm_stay_awake(client->wakeup_source);
>  		kill_fasync(&client->fasync, SIGIO, POLL_IN);
>  	}
> 
> @@ -255,6 +258,8 @@ static int evdev_release(struct inode *i
>  	mutex_unlock(&evdev->mutex);
> 
>  	evdev_detach_client(evdev, client);
> +	wakeup_source_unregister(client->wakeup_source);
> +
>  	kfree(client);
> 
>  	evdev_close_device(evdev);
> @@ -373,6 +378,8 @@ static int evdev_fetch_next_event(struct
>  	if (have_event) {
>  		*event = client->buffer[client->tail++];
>  		client->tail &= client->bufsize - 1;
> +		if (client->packet_head == client->tail)
> +			__pm_relax(client->wakeup_source);
>  	}
> 
>  	spin_unlock_irq(&client->buffer_lock);
> @@ -623,6 +630,45 @@ static int evdev_handle_set_keycode_v2(s
>  	return input_set_keycode(dev, &ke);
>  }
> 
> +static int evdev_attach_wakeup_source(struct evdev *evdev,
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

This does not look like it will work well with tasks in different pid
namespaces. What should happen, I think, is the wakeup_source should hold a
reference to either the struct pid of current or current itself. Then
when someone reads the file you should get the pid vnr in the reader's
pid namespace. That way instead of a bogus pid vnr 0 would show up if
"current" here is not in the reader's pid namepsace.

Cheers,
	-Matt Helsley

