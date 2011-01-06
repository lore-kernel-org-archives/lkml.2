Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1AFWUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:20:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:55699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab1AFWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:20:12 -0500
Date: Thu, 6 Jan 2011 14:19:12 -0800
From: Greg KH <gregkh@suse.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v7 01/12] media: Media device node support
Message-ID: <20110106221912.GA31328@suse.de>
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1292844995-7900-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20101223033253.GA14692@suse.de>
 <201012241259.39148.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012241259.39148.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 12:59:38PM +0100, Laurent Pinchart wrote:
> Hi Greg,
> 
> Thank you for the review.
> 
> On Thursday 23 December 2010 04:32:53 Greg KH wrote:
> > On Mon, Dec 20, 2010 at 12:36:24PM +0100, Laurent Pinchart wrote:
> > > The media_devnode structure provides support for registering and
> > > unregistering character devices using a dynamic major number. Reference
> > > counting is handled internally, making device drivers easier to write
> > > without having to solve the open/disconnect race condition issue over
> > > and over again.
> > 
> > What race condition are you referring to?
> 
> In a nutshell, the race between device disconnection, which results in the 
> device instance being delete (if not in use of course), and open() calls from 
> userspace. The problem has been solved in V4L a couple of releases ago after 
> suffering from this race for a too long time. As V4L devices (and now media 
> devices) need to create both a struct device and a struct cdev instance, 
> careful locking is needed.

Ok, that's not really nice, but I guess it is needed.

> > > +config MEDIA_CONTROLLER
> > > +	bool "Media Controller API (EXPERIMENTAL)"
> > > +	depends on EXPERIMENTAL
> > > +	---help---
> > > +	  Enable the media controller API used to query media devices internal
> > > +	  topology and configure it dynamically.
> > > +
> > > +	  This API is mostly used by camera interfaces in embedded platforms.
> > 
> > That's nice, but why should I enable this?  Or will drivers enable it
> > automatically?
> 
> Drivers depending on the media controller API will enable this, yes. The 
> option will probably removed later when the API won't be deemed as 
> experimental anymore.
> 
> > > +#define MEDIA_NUM_DEVICES	256
> > 
> > Why this limit?
> 
> Because I'm using a bitmap to store the used minor numbers, and I thus need a 
> limit. I could get rid of it of it by using a linked list, but that will not 
> be efficient (you could argue that the list will hold a few entries only most 
> of the time, but in that case a limit of 256 minors wouldn't be a problem 
> :-)).

As it's only needed to be looked up at open() time, why not just make it
dynamic?

> > > +#define MEDIA_NAME		"media"
> > 
> > Are you sure this is a good name for a camera?
> 
> It's not just camera. Media devices are... well, media devices. Basically 
> anything that can handle audio and/or video streams. The media controller API 
> can be used by plain audio devices.

Ok.

> > > +static dev_t media_dev_t;
> > 
> > Only one major number?  Is it always dynamic?
> 
> Yes, one major and (for now) 256 minors. Is there a problem with it being 
> dynamic ?

No, just curious.

> > > +
> > > +/*
> > > + *	Active devices
> > > + */
> > > +static DEFINE_MUTEX(media_devnode_lock);
> > > +static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
> > > +
> > > +/* Called when the last user of the media device exits. */
> > > +static void media_devnode_release(struct device *cd)
> > > +{
> > > +	struct media_devnode *mdev = to_media_devnode(cd);
> > > +
> > > +	mutex_lock(&media_devnode_lock);
> > > +
> > > +	/* Delete the cdev on this minor as well */
> > > +	cdev_del(&mdev->cdev);
> > > +
> > > +	/* Mark device node number as free */
> > > +	clear_bit(mdev->minor, media_devnode_nums);
> > > +
> > > +	mutex_unlock(&media_devnode_lock);
> > > +
> > > +	/* Release media_devnode and perform other cleanups as needed. */
> > > +	if (mdev->release)
> > > +		mdev->release(mdev);
> > > +}
> > 
> > You forgot to free the device structure here as well, right?
> 
> That will be done by the release callback. The media_devnode structure is 
> embedded in the media_device structure, which will be embedded in driver-
> specific structures.

Ok.

> > > +static ssize_t media_read(struct file *filp, char __user *buf,
> > > +		size_t sz, loff_t *off)
> > > +{
> > > +	struct media_devnode *mdev = media_devnode_data(filp);
> > > +
> > > +	if (!mdev->fops->read)
> > > +		return -EINVAL;
> > > +	if (!media_devnode_is_registered(mdev))
> > > +		return -EIO;
> > 
> > How could this happen?
> 
> This can happen when a USB device is disconnected for instance.

But what's to keep that from happening on the next line as well?  That
doesn't seem like a check you can ever be sure about, so I wouldn't do
it at all.

> > And are you sure -EIO is correct?
> 
> -ENXIO is probably better (I always confuse that with -ENODEV).
> 
> > > +	return mdev->fops->read(filp, buf, sz, off);
> > > +}
> > > +
> > > +static ssize_t media_write(struct file *filp, const char __user *buf,
> > > +		size_t sz, loff_t *off)
> > > +{
> > > +	struct media_devnode *mdev = media_devnode_data(filp);
> > > +
> > > +	if (!mdev->fops->write)
> > > +		return -EINVAL;
> > > +	if (!media_devnode_is_registered(mdev))
> > > +		return -EIO;
> > 
> > Same as above, and same comment in other places (poll, ioctl.)
> 
> OK.
> 
> > > +/* Override for the open function */
> > > +static int media_open(struct inode *inode, struct file *filp)
> > > +{
> > > +	struct media_devnode *mdev;
> > > +	int ret;
> > > +
> > > +	/* Check if the media device is available. This needs to be done with
> > > +	 * the media_devnode_lock held to prevent an open/unregister race:
> > > +	 * without the lock, the device could be unregistered and freed between
> > > +	 * the media_devnode_is_registered() and get_device() calls, leading to
> > > +	 * a crash.
> > > +	 */
> > > +	mutex_lock(&media_devnode_lock);
> > > +	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);
> > 
> > By virtue of having the reference to the module held by the vfs, this
> > shouldn't ever go away, even if the lock is not held.
> 
> inode->i_cdev is set to NULL by cdev_default_release() which can be called 
> from media_devnode_unregister(). I could move to container_of outside the 
> lock, but in that case I would have to check for mdev == NULL || 
> !mdev_devnode_is_registered(mdev) (or move the NULL check inside 
> mdev_devnode_is_registered). Is that what you would like ?

As container_of _ALWAYS_ returns a valid pointer, you can't check it for
NULL.  I don't know, it just doesn't seem correct here, but if you are
sure it's working properly, I'll not push the issue.

> > > +	/* return ENXIO if the media device has been removed
> > > +	   already or if it is not registered anymore. */
> > > +	if (!media_devnode_is_registered(mdev)) {
> > > +		mutex_unlock(&media_devnode_lock);
> > > +		return -ENXIO;
> > > +	}
> > 
> > So you can unregister a device at any time, even if the device is open,
> > or about to be opened?
> 
> That's correct. That way drivers don't need to care about unregister/open 
> races, media_devnode will handle it for them.

Ok.

> > Then that's fine, but you can put the lock after the container_of(), right?
> 
> If I add a NULL check (as explained above), yes.

Again, you can't check for NULL as the result of container_of() that
does not work (hint, container_of() is just pointer math, without ever
looking at the original pointer value.)

> > > +	/* and increase the device refcount */
> > > +	get_device(&mdev->dev);
> > 
> > How is that holding anything into memory?
> 
> That will prevent the device instance from being freed until the device is 
> closed, thereby holding both the device instance and the cdev instance in 
> memory.

Tricky :)

> > Don't you want to keep the module that the fops pointer in the device in
> > memory, not necessarily the device itself?
> 
> The cdev owner pointer is set to the fops owner. Unless I'm mistaken it will 
> keep the module in memory. I need to keep the device in memory (or rather the 
> media_devnode structure that embeds it) to handle file operations on a device 
> that gets unregistered after it has been opened.

Ok.

> > > +	mutex_unlock(&media_devnode_lock);
> > > +
> > > +	filp->private_data = mdev;
> > > +
> > > +	if (mdev->fops->open) {
> > > +		ret = mdev->fops->open(filp);
> > > +		if (ret) {
> > > +			put_device(&mdev->dev);
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > No reference counting for the fops?  Why not?
> 
> Because cdev already increments the owner refcount on open().

Ok.

> > Anyway, it looks like what you really want is an "easier" way to handle
> > a cdev and a struct device that will export the proper information to
> > userspace, right?
> > 
> > Why not do this generically, fixing up the cdev interface (which really
> > needs it) and not tie it to media devices at all, making it possible for
> > _everyone_ to use this type of infrastructure?
> > 
> > That seems like the better thing to do here.
> 
> Sounds like a good idea. You're a better cdev expert than me, so could you 
> give me a few pointers ? Do you want me to create a new object that will hold 
> a struct cdev and a struct device together, or to embed the device structure 
> into the existing cdev structure ?

I don't really know, all I know is that cdev is a difficult thing to
handle at times, but not everyone who uses it needs a struct device.
But some people do (as this code shows), so I guess it needs to be a
whole new structure/interface that binds the two together like you just
did.  I think that would be good for a lot more places other than just
the media subsystem, so it should go into the core kernel instead.

thanks,

greg k-h
