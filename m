Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1BHRuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:50:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44642 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab1BHRux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:50:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HSBi1FUNyFb+RFcfyM+IsKkQ3rjR1fJkuotET5Ed/V9HQi/GDj6ABE1k4HV10sQPNl
         4v/Es++9T1EBBTADpvwm0e3qxN+/RQsFmH3tmRKAxTMal5Arww6izhVpt+HBHn9pBxk+
         c5ZYgV/myuanz0xlk8GPRuq4/fpKi6oAM85NE=
Date: Tue, 8 Feb 2011 09:50:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Message-ID: <20110208175028.GD4476@core.coreip.homeip.net>
References: <1297121021-3522-1-git-send-email-iws@ovro.caltech.edu>
 <1297121021-3522-2-git-send-email-iws@ovro.caltech.edu>
 <20110208073309.GB906@core.coreip.homeip.net>
 <20110208172046.GB10125@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208172046.GB10125@ovro.caltech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:20:46AM -0800, Ira W. Snyder wrote:
> On Mon, Feb 07, 2011 at 11:33:10PM -0800, Dmitry Torokhov wrote:
> > > +static void data_free_buffer(struct device *dev, struct data_buf *buf)
> > > +{
> > > +	/* It is ok to free a NULL buffer */
> > > +	if (!buf)
> > > +		return;
> > > +
> > > +	/* Make sure the buffer is not on any list */
> > > +	list_del_init(&buf->entry);
> > 
> > And what happens if it is? Should it be WARN_ON(!list_empty()) instead?
> > 
> 
> This was only defensive programming. Everywhere this function is called,
> the buffer has already been removed from the list.

I am concerned as sometimes defencive programming is the sign that we
arenot quite sure how the code works. I believe defensive programming
should be used when providing library-like code, not in local cases.

> > > +
> > > +	list_for_each_entry_safe(buf, tmp, &priv->free, entry) {
> > > +		list_del_init(&buf->entry);
> > > +		spin_unlock_irq(&priv->lock);
> > > +		data_free_buffer(priv->dev, buf);
> > > +		spin_lock_irq(&priv->lock);
> > > +	}
> > 
> > This is messed up. If there is concurrent access to the free list then
> > it is not safe to continue iterating list after releasing the lock, you
> > need to do:
> > 
> > 	spin_lock_irq(&priv->lock);
> > 	while (!list_empty(&priv->free)) {
> > 		buf = list_first_entry(&priv->free, struct data_buf, entry);
> > 		list_del_init(&buf->entry);
> > 		spin_unlock_irq(&priv->lock);
> > 		data_free_buffer(priv->dev, buf);
> > 		spin_lock_irq(&priv->lock);
> > 	}
> > 
> > BUT, the function is only called when you disable (or fail to enable) device
> > which, at this point, should be quiesced, thus all this locking is not
> > really needed.
> > 
> 
> Correct.
> 
> I thought it would be clearer to reviewers if I always used the lock to
> protect a data structure, even when it isn't technically needed.

No, locks should protect wehat needs to be protected. The rest just
muddles water.

> > > +
> > > +	spin_lock_irq(&priv->lock);
> > > +	while (!list_empty(list)) {
> > > +		spin_unlock_irq(&priv->lock);
> > > +
> > > +		ret = wait_event_interruptible(priv->wait, list_empty(list));
> > > +		if (ret)
> > > +			return -ERESTARTSYS;
> > > +
> > > +		spin_lock_irq(&priv->lock);
> > > +	}
> > > +	spin_unlock_irq(&priv->lock);
> > 
> > Locking is not needed - if you disable interrupyts what would put more
> > stuff on the list?
> > 
> 
> The locking is definitely needed.
> 
> You've missed a critical piece of information. There are *two* devices
> we are interacting with here, and BOTH generate interrupts.
> 

No, I did not miss this fact. The point is that when we get to this code
the device _putting_ items on wauiting list is stopped and we only need
to wait for the list to drain. Nobody puts more stuff on it. You can
check fir list_empty() condition without locking.

And if someone _is_ putting more stuff on the list - you are screwed
since list may become non-empty the moment you release the lock.

> > > +
> > > +static ssize_t data_num_buffers_show(struct device *dev,
> > > +				     struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > > +	unsigned int num;
> > > +
> > > +	spin_lock_irq(&priv->lock);
> > > +	num = priv->num_buffers;
> > > +	spin_unlock_irq(&priv->lock);
> > 
> > This spin lock is pointless, priv->num_buffers might be already changed
> > here, you can't guarantee that you show accurate data.
> > 
> 
> Correct, I know this. I just wanted to protect the data structure at all
> points of use in the driver.

Protect from what? integer reads are guaranteed to be complete and you
are not concerned with missing updates as information is obsolete the
moment you release trhe lock.

> Would an atomic_t be better for this, or
> should I just remove the locking completely?

Just remove the locking.

> > > +
> > > +	if (mutex_lock_interruptible(&priv->mutex))
> > > +		return -ERESTARTSYS;
> > 
> > Why don't
> > 
> > 	error = mutex_lock_interruptible(&priv->mutex);
> > 	if (error)
> > 		return error;
> > 
> > - do not clobber perfectly valid error codes.
> > 
> 
> That's what the Linux Device Drivers 3rd Edition book does. See page
> 112. I will change it to fix the return code.
>

LDD3 is quite old by now...

> > > +
> > > +static struct attribute *data_sysfs_attrs[] = {
> > > +	&dev_attr_num_buffers.attr,
> > > +	&dev_attr_buffer_size.attr,
> > > +	&dev_attr_num_inflight.attr,
> > > +	&dev_attr_num_free.attr,
> > > +	&dev_attr_num_used.attr,
> > > +	&dev_attr_num_dropped.attr,
> > > +	&dev_attr_enable.attr,
> > > +	NULL,
> > > +};
> > 
> > Are all of these really needed or most of them are for debug?
> > 
> 
> Most are for debugging. They have proved useful a few times in
> production to track down bugs.
> 

Consider switching over to debugfs then. Or, if you believe the device
is sufficiently bug-free just cut the code.

> > > +
> > > +static ssize_t data_read(struct file *filp, char __user *ubuf, size_t count,
> > > +			 loff_t *f_pos)
> > > +{
> > > +	struct fpga_reader *reader = filp->private_data;
> > > +	struct fpga_device *priv = reader->priv;
> > > +	struct list_head *used = &priv->used;
> > > +	struct data_buf *dbuf;
> > > +	size_t avail;
> > > +	void *data;
> > > +	int ret;
> > > +
> > > +	/* check if we already have a partial buffer */
> > > +	if (reader->buf) {
> > > +		dbuf = reader->buf;
> > > +		goto have_buffer;
> > > +	}
> > > +
> > > +	spin_lock_irq(&priv->lock);
> > > +
> > > +	/* Block until there is at least one buffer on the used list */
> > > +	while (list_empty(used)) {
> > > +		spin_unlock_irq(&priv->lock);
> > > +
> > > +		if (filp->f_flags & O_NONBLOCK)
> > > +			return -EAGAIN;
> > > +
> > > +		if (wait_event_interruptible(priv->wait, !list_empty(used)))
> > > +			return -ERESTARTSYS;
> > > +
> > 
> > And somebody grabs that entry here...
> > 
> > > +		spin_lock_irq(&priv->lock);
> > > +	}
> > > +
> > > +	/* Grab the first buffer off of the used list */
> > > +	dbuf = list_first_entry(used, struct data_buf, entry);
> > 
> > And list is empty so you grabgarbage.
> > 
> > > +	list_del_init(&dbuf->entry);
> > > +
> > > +	spin_unlock_irq(&priv->lock);
> > 
> > Shoudl be:
> > 
> > 	struct data_buf *dbuf = NULL;
> > 	...
> > 
> > 	if (list_empty(&priv->used) && (filp->f_flags & O_NONBLOCK))
> > 		return -EAGAIN;
> > 
> > 	error = wait_event_interruptible(priv->wait, !list_empty(&priv->used);
> > 	if (error)
> > 		return error;
> > 
> > 	spin_lock_irq(&priv->lock);
> > 	if (!list_empty(&priv->used)) {
> > 		buf = list_first_entry(&priv->used, struct data_buf, entry);
> > 		list_del_init(&dbuf->entry);
> > 	}
> > 	spin_unlock_irq(&priv->lock);
> > 
> > 	if (dbuf) {
> > 		.. deal with the buffer
> > 	}
> > 
> 
> I'm pretty sure you're wrong.

And I am certain I am correct. Given that I've even given example how you
can lose your list entry I don't know why you think I did not understand
your code.

> Go back and re-think my loop. This is a
> common idiom straight of out LDD3 pages 153-154.
> 
> You should note that it is only possible to exit the loop with the lock
> held AND !list_empty(used). The lock protects the used list, and
> therefore, there must be a buffer on the list.

No, because you are woken up while not holding the lock so another
reader is free to take it off the list.

> > > +
> > > +static unsigned int data_poll(struct file *filp, struct poll_table_struct *tbl)
> > > +{
> > > +	struct fpga_reader *reader = filp->private_data;
> > > +	struct fpga_device *priv = reader->priv;
> > > +	unsigned int mask = 0;
> > > +
> > > +	poll_wait(filp, &priv->wait, tbl);
> > > +
> > > +	spin_lock_irq(&priv->lock);
> > > +
> > > +	if (!list_empty(&priv->used))
> > > +		mask |= POLLIN | POLLRDNORM;
> > > +
> > > +	spin_unlock_irq(&priv->lock);
> > 
> > No lock is needed.
> > 
> 
> Why not? For example, there are two readers:
> 1) blocked in poll()
> 2) blocked in poll()
> 
> A single buffer gets added to the used list. I should only unblock one
> of them with (POLLIN | POLLRDNORM), correct? Otherwise one of them must
> have a spurious wakeup. I think that's incorrect (or undesirable)
> behavior.

And how your lock prevents both of them wakign up? You are not resetting
wakeup condition in any way.

> 
> Again, it seems very inconsistent and confusing to me to protect the
> used list with a spinlock in some places and not in others.

Please try to think about what exactly you protecting and whether lock
adds any protection or not and it will put your mind at ease.

Thanks.

-- 
Dmitry
