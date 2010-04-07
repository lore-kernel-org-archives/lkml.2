Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab0DGRLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:11:11 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16626 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab0DGRLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:11:06 -0400
Date: Wed, 07 Apr 2010 19:11:05 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/8] sched: __wake_up_locked() exported
In-reply-to: <20100407152922.GB13425@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vasx0rg07p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <20100407152922.GB13425@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 07, 2010 at 03:41:29PM +0200, Michal Nazarewicz wrote:
>> The __wake_up_locked() function has been exported in case modules need it.

On Wed, 07 Apr 2010 17:29:22 +0200, Greg KH <greg@kroah.com> wrote:
> What module needs it?

FunctionFS (f_fs) uses it (thus FunctionFS Gadget (g_ffs) uses it).

> Why is it needed?

The FunctionFS uses wait_queue_head_t's spinlock to protect a data
structure (a queue) used by FunctionFS.

In an earlier version of the code there was another spinlock for
the queue alone thus when waiting for an event the following had
to be used:

#v+
spin_lock(&queue.lock);
while (queue.empty) {
	spin_unlock(&queue.lock);
	wait_event(&queue.wait_queue, !queue.empty);
	spin_lock(&queue.lock);
}
...
spin_unlock(&queue.lock);
#v-

I disliked this code very much and at first hoped that there's some
"wait_event_holding_lock()" macro which would define the loop shown
above (similar to user-space condition variables; see
pthread_cond_wait(3) <http://linux.die.net/man/3/pthread_cond_wait>).

What makes matter worse is that wait_event() calls prepare_to_wait()
which locks the wait_queue_head_t's spinlock so in the end we have
unlock one spinlock prior to locking another in situation where one
spinlock would suffice.

In searching for a better solution I stumbled across fs/timerfd.c which
used the wait_queue_head_t's spinlock to lock it's own structures:

* http://lxr.linux.no/#linux+v2.6.33/fs/timerfd.c#L39
* http://lxr.linux.no/#linux+v2.6.33/fs/timerfd.c#L106

So, in the end, I decided to use the same approach in FunctionFS and
hence by using wait_queue_head_t's spinlock I removed one (unneeded)
spinlock and decreased number of spin_lock and spin_unlock operations,
ie. to something like (simplified code):

#v+
spin_lock(&queue.wait_queue.lock);
my_wait_event_locked(&queue.wait_queue, !queue.empty);
...
spin_unlock(&queue.lock);
#v-

where my_wait_event_locked() is a function that does what wait_event()
does but assumes the wait_queue_head_t's lock is held when entering
and leaves it held when exiting.

> Are you sure that you really need it?

I could live without it but I strongly believe the code is somehow
cleaner and more optimised when __wake_up_locked() is used.


To be more concrete I attach the actual code (parts not important in current
discussion have been stripped).  The most important parts are
__ffs_ep0_read_wait_for_events() function, the FFS_NO_SETUP case in
ffs_ep0_read() and ffs_event_add().

#v+
/****************************** Waiting ******************************/
static int __ffs_ep0_read_wait_for_events(struct ffs_data *ffs)
{
	/* We are holding ffs->ev.waitq.lock */
	DEFINE_WAIT(wait);
	int ret = 0;

	wait.flags |= WQ_FLAG_EXCLUSIVE;
	__add_wait_queue_tail(&ffs->ev.waitq, &wait);

	do {
		set_current_state(TASK_INTERRUPTIBLE);
		if (signal_pending(current)) {
			ret = -ERESTARTSYS;
			break;
		}

		spin_unlock_irq(&ffs->ev.waitq.lock);
		schedule();
		spin_lock_irq(&ffs->ev.waitq.lock);
	} while (!ffs->ev.count);

	__remove_wait_queue(&ffs->ev.waitq, &wait);
	__set_current_state(TASK_RUNNING);
	return ret;
}

/****************************** Popping ******************************/
static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
				     size_t n)
{
	/* We are holding ffs->ev.waitq.lock and ffs->mutex and we need
	 * to release them. */

	struct usb_functionfs_event events[n];
	unsigned i = 0;
	do {
		events[i].type = ffs->ev.types[i];
		/* ... */
	} while (++i < n);
	ffs->ev.count = 0;

	spin_unlock_irq(&ffs->ev.waitq.lock);
	mutex_unlock(&ffs->mutex);
	return unlikely(__copy_to_user(buf, events, sizeof events))
		? -EFAULT : sizeof events;
}

/****************************** Entry from user space ******************************/
static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
			    size_t len, loff_t *ptr)
{
	struct ffs_data *ffs = file->private_data;
	size_t n;
	char *data;
	int ret;

	/* Acquire mutex */
	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
	if (unlikely(ret < 0))
		return ret;

	spin_lock_irq(&ffs->ev.waitq.lock);
	switch (FFS_SETUP_STATE(ffs)) {
	case FFS_SETUP_CANCELED:
		ret = -EIDRM;
		break;

	case FFS_NO_SETUP:
		n = len / sizeof(struct usb_functionfs_event);
		if (unlikely(!n)) {
			ret = -EINVAL;
			break;
		}

		if ((file->f_flags & O_NONBLOCK) && !ffs->ev.count) {
			ret = -EAGAIN;
			break;
		}

		if (!ffs->ev.count &&
		    unlikely(__ffs_ep0_read_wait_for_events(ffs))) {
			ret = -EINTR;
			break;
		}

		return __ffs_ep0_read_events(ffs, buf,
					     min(n, (size_t)ffs->ev.count));


	case FFS_SETUP_PENDING:
		if (ffs->ev.setup.bRequestType & USB_DIR_IN) {
			ret = __ffs_ep0_stall(ffs);
			break;
		}

		len = min(len, (size_t)le16_to_cpu(ffs->ev.setup.wLength));

		spin_unlock_irq(&ffs->ev.waitq.lock);

		data = ffs_prepare_buffer(NULL, len); /* basically kmalloc() */
		if (unlikely(IS_ERR(data))) {
			ret = PTR_ERR(data);
			goto done_mutex;
		}

		spin_lock_irq(&ffs->ev.waitq.lock);

		/* the state of setup could have changed from
		 * FFS_SETUP_PENDING to FFS_SETUP_CANCELED so we need
		 * to check for that. */
		if (FFS_SETUP_STATE(ffs) == FFS_SETUP_CANCELED) {
			kfree(data);
			ret = -EIDRM;
			break;
		}

		/* unlocks spinlock */
		ret = __ffs_ep0_queue_wait(ffs, data, len);
		if (likely(ret > 0) && unlikely(__copy_to_user(buf, data, len)))
			ret = -EFAULT;
		kfree(data);
		goto done_mutex;
	}
	spin_unlock_irq(&ffs->ev.waitq.lock);
done_mutex:
	mutex_unlock(&ffs->mutex);
	return ret;
}

/****************************** Adding ******************************/
static void __ffs_event_add(struct ffs_data *ffs,
			    enum usb_functionfs_event_type type)
{
	/* Abort any unhandled setup */
	if (ffs->setup_state == FFS_SETUP_PENDING)
		ffs->setup_state = FFS_SETUP_CANCELED;

         /* ... some events may get nuked here */

	ffs->ev.types[ffs->ev.count++] = type;
	wake_up_locked(&ffs->ev.waitq);
}

static void ffs_event_add(struct ffs_data *ffs,
			  enum usb_functionfs_event_type type)
{
	unsigned long flags;
	spin_lock_irqsave(&ffs->ev.waitq.lock, flags);
	__ffs_event_add(ffs, type);
	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
}
#v-

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
