Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1AJOIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:08:34 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41990 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1AJOIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:08:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC/PATCH v7 01/12] media: Media device node support
Date: Mon, 10 Jan 2011 15:09:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012241259.39148.laurent.pinchart@ideasonboard.com> <20110106221912.GA31328@suse.de>
In-Reply-To: <20110106221912.GA31328@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101101509.13793.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thursday 06 January 2011 23:19:12 Greg KH wrote:
> On Fri, Dec 24, 2010 at 12:59:38PM +0100, Laurent Pinchart wrote:
> > On Thursday 23 December 2010 04:32:53 Greg KH wrote:
> > > On Mon, Dec 20, 2010 at 12:36:24PM +0100, Laurent Pinchart wrote:
> > > > +config MEDIA_CONTROLLER
> > > > +	bool "Media Controller API (EXPERIMENTAL)"
> > > > +	depends on EXPERIMENTAL
> > > > +	---help---
> > > > +	  Enable the media controller API used to query media devices
> > > > internal +	  topology and configure it dynamically.
> > > > +
> > > > +	  This API is mostly used by camera interfaces in embedded
> > > > platforms.
> > > 
> > > That's nice, but why should I enable this?  Or will drivers enable it
> > > automatically?
> > 
> > Drivers depending on the media controller API will enable this, yes. The
> > option will probably removed later when the API won't be deemed as
> > experimental anymore.
> > 
> > > > +#define MEDIA_NUM_DEVICES	256
> > > 
> > > Why this limit?
> > 
> > Because I'm using a bitmap to store the used minor numbers, and I thus
> > need a limit. I could get rid of it of it by using a linked list, but
> > that will not be efficient (you could argue that the list will hold a
> > few entries only most of the time, but in that case a limit of 256
> > minors wouldn't be a problem
> > 
> > :-)).
> 
> As it's only needed to be looked up at open() time, why not just make it
> dynamic?

How so ? With include/linux/idr.h ?

> > > > +/* Override for the open function */
> > > > +static int media_open(struct inode *inode, struct file *filp)
> > > > +{
> > > > +	struct media_devnode *mdev;
> > > > +	int ret;
> > > > +
> > > > +	/* Check if the media device is available. This needs to be done
> > > > with +	 * the media_devnode_lock held to prevent an open/unregister
> > > > race: +	 * without the lock, the device could be unregistered and
> > > > freed between +	 * the media_devnode_is_registered() and
> > > > get_device() calls, leading to +	 * a crash.
> > > > +	 */
> > > > +	mutex_lock(&media_devnode_lock);
> > > > +	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);
> > > 
> > > By virtue of having the reference to the module held by the vfs, this
> > > shouldn't ever go away, even if the lock is not held.
> > 
> > inode->i_cdev is set to NULL by cdev_default_release() which can be
> > called from media_devnode_unregister(). I could move to container_of
> > outside the lock, but in that case I would have to check for mdev ==
> > NULL || !mdev_devnode_is_registered(mdev) (or move the NULL check inside
> > mdev_devnode_is_registered). Is that what you would like ?
> 
> As container_of _ALWAYS_ returns a valid pointer, you can't check it for
> NULL. I don't know, it just doesn't seem correct here, but if you are sure
> it's working properly, I'll not push the issue.

I haven't found any issue with it. I'm not sure why it would be incorrect to 
be honest. Am I missing something ?

> > > Then that's fine, but you can put the lock after the container_of(),
> > > right?
> > 
> > If I add a NULL check (as explained above), yes.
> 
> Again, you can't check for NULL as the result of container_of() that
> does not work (hint, container_of() is just pointer math, without ever
> looking at the original pointer value.)

Yes, my bad, I meant inode->i_cdev == NULL || 
!mdev_devnode_is_registered(mdev). If I moved the container_of outside of the 
locked section I would need to add an extra check inside, and I don't think 
the resulting locked section will get any smaller.

> > > > +	/* and increase the device refcount */
> > > > +	get_device(&mdev->dev);
> > > 
> > > How is that holding anything into memory?
> > 
> > That will prevent the device instance from being freed until the device
> > is closed, thereby holding both the device instance and the cdev
> > instance in memory.
> 
> Tricky :)

Tell me about it. I've spent lots of time on this issue in V4L2 a while ago. 
Fortunately refcount nightmares are getting less frequent ;-)

> > > Anyway, it looks like what you really want is an "easier" way to handle
> > > a cdev and a struct device that will export the proper information to
> > > userspace, right?
> > > 
> > > Why not do this generically, fixing up the cdev interface (which really
> > > needs it) and not tie it to media devices at all, making it possible
> > > for _everyone_ to use this type of infrastructure?
> > > 
> > > That seems like the better thing to do here.
> > 
> > Sounds like a good idea. You're a better cdev expert than me, so could
> > you give me a few pointers ? Do you want me to create a new object that
> > will hold a struct cdev and a struct device together, or to embed the
> > device structure into the existing cdev structure ?
> 
> I don't really know, all I know is that cdev is a difficult thing to
> handle at times, but not everyone who uses it needs a struct device.
> But some people do (as this code shows), so I guess it needs to be a
> whole new structure/interface that binds the two together like you just
> did.  I think that would be good for a lot more places other than just
> the media subsystem, so it should go into the core kernel instead.

There are so few direct struct cdev users in the kernel that I'm beginning to 
wonder if this is the right way to go or if I'm just using cdev in a way it 
hasn't been designed to be used. My understanding was that I needed an 
instance of struct cdev per minor, but many subsystems seems to handle cdev 
differently. Is there any detailed documentation regarding how it should be 
used ?

-- 
Regards,

Laurent Pinchart
