Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0LWDeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 22:34:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0LWDep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 22:34:45 -0500
Date: Wed, 22 Dec 2010 19:32:53 -0800
From: Greg KH <gregkh@suse.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v7 01/12] media: Media device node support
Message-ID: <20101223033253.GA14692@suse.de>
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1292844995-7900-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292844995-7900-2-git-send-email-laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 12:36:24PM +0100, Laurent Pinchart wrote:
> The media_devnode structure provides support for registering and
> unregistering character devices using a dynamic major number. Reference
> counting is handled internally, making device drivers easier to write
> without having to solve the open/disconnect race condition issue over
> and over again.

What race condition are you referring to?

> +config MEDIA_CONTROLLER
> +	bool "Media Controller API (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL
> +	---help---
> +	  Enable the media controller API used to query media devices internal
> +	  topology and configure it dynamically.
> +
> +	  This API is mostly used by camera interfaces in embedded platforms.

That's nice, but why should I enable this?  Or will drivers enable it
automatically?


> +#define MEDIA_NUM_DEVICES	256

Why this limit?

> +#define MEDIA_NAME		"media"

Are you sure this is a good name for a camera?

> +static dev_t media_dev_t;

Only one major number?  Is it always dynamic?

> +
> +/*
> + *	Active devices
> + */
> +static DEFINE_MUTEX(media_devnode_lock);
> +static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
> +
> +/* Called when the last user of the media device exits. */
> +static void media_devnode_release(struct device *cd)
> +{
> +	struct media_devnode *mdev = to_media_devnode(cd);
> +
> +	mutex_lock(&media_devnode_lock);
> +
> +	/* Delete the cdev on this minor as well */
> +	cdev_del(&mdev->cdev);
> +
> +	/* Mark device node number as free */
> +	clear_bit(mdev->minor, media_devnode_nums);
> +
> +	mutex_unlock(&media_devnode_lock);
> +
> +	/* Release media_devnode and perform other cleanups as needed. */
> +	if (mdev->release)
> +		mdev->release(mdev);
> +}

You forgot to free the device structure here as well, right?

> +static ssize_t media_read(struct file *filp, char __user *buf,
> +		size_t sz, loff_t *off)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->read)
> +		return -EINVAL;
> +	if (!media_devnode_is_registered(mdev))
> +		return -EIO;

How could this happen?  And are you sure -EIO is correct?

> +	return mdev->fops->read(filp, buf, sz, off);
> +}
> +
> +static ssize_t media_write(struct file *filp, const char __user *buf,
> +		size_t sz, loff_t *off)
> +{
> +	struct media_devnode *mdev = media_devnode_data(filp);
> +
> +	if (!mdev->fops->write)
> +		return -EINVAL;
> +	if (!media_devnode_is_registered(mdev))
> +		return -EIO;

Same as above, and same comment in other places (poll, ioctl.)

> +/* Override for the open function */
> +static int media_open(struct inode *inode, struct file *filp)
> +{
> +	struct media_devnode *mdev;
> +	int ret;
> +
> +	/* Check if the media device is available. This needs to be done with
> +	 * the media_devnode_lock held to prevent an open/unregister race:
> +	 * without the lock, the device could be unregistered and freed between
> +	 * the media_devnode_is_registered() and get_device() calls, leading to
> +	 * a crash.
> +	 */
> +	mutex_lock(&media_devnode_lock);
> +	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);

By virtue of having the reference to the module held by the vfs, this
shouldn't ever go away, even if the lock is not held.

> +	/* return ENXIO if the media device has been removed
> +	   already or if it is not registered anymore. */
> +	if (!media_devnode_is_registered(mdev)) {
> +		mutex_unlock(&media_devnode_lock);
> +		return -ENXIO;
> +	}

So you can unregister a device at any time, even if the device is open,
or about to be opened?  Then that's fine, but you can put the lock after
the container_of(), right?

> +	/* and increase the device refcount */
> +	get_device(&mdev->dev);

How is that holding anything into memory?  Don't you want to keep the
module that the fops pointer in the device in memory, not necessarily
the device itself?

> +	mutex_unlock(&media_devnode_lock);
> +
> +	filp->private_data = mdev;
> +
> +	if (mdev->fops->open) {
> +		ret = mdev->fops->open(filp);
> +		if (ret) {
> +			put_device(&mdev->dev);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}

No reference counting for the fops?  Why not?

Anyway, it looks like what you really want is an "easier" way to handle
a cdev and a struct device that will export the proper information to
userspace, right?

Why not do this generically, fixing up the cdev interface (which really
needs it) and not tie it to media devices at all, making it possible for
_everyone_ to use this type of infrastructure?

That seems like the better thing to do here.

thanks,

greg k-h
