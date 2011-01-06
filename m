Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1AFX1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:27:35 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3169 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1AFX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:27:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC/PATCH v7 01/12] media: Media device node support
Date: Fri, 7 Jan 2011 00:27:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012241259.39148.laurent.pinchart@ideasonboard.com> <20110106221912.GA31328@suse.de>
In-Reply-To: <20110106221912.GA31328@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070027.11150.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 06, 2011 23:19:12 Greg KH wrote:

<snip>

> > > > +static ssize_t media_read(struct file *filp, char __user *buf,
> > > > +		size_t sz, loff_t *off)
> > > > +{
> > > > +	struct media_devnode *mdev = media_devnode_data(filp);
> > > > +
> > > > +	if (!mdev->fops->read)
> > > > +		return -EINVAL;
> > > > +	if (!media_devnode_is_registered(mdev))
> > > > +		return -EIO;
> > > 
> > > How could this happen?
> > 
> > This can happen when a USB device is disconnected for instance.
> 
> But what's to keep that from happening on the next line as well?

Nothing.

> That
> doesn't seem like a check you can ever be sure about, so I wouldn't do
> it at all.

Actually, there is a reason why this was done for v4l (and now the media
API): typically, once a USB disconnect happens V4L drivers will call
video_unregister_device() which calls device_unregister. Afterwards the
device node should reject any new file operations except for release().

Obviously, this check can be done in the driver as well, but doing this
check in the V4L core has the advantage of 1) consistent return codes and
2) drivers no longer have to check.

Of course, since the disconnect can happen at any time drivers still need
to be able to handle errors from the USB subsystem due to disconnects, but
that is something they always have to do.

> 
> > > And are you sure -EIO is correct?
> > 
> > -ENXIO is probably better (I always confuse that with -ENODEV).

I wondered why V4L uses -EIO and I think it is related to the V4L2 specification
of the read() function:

EIO
I/O error. This indicates some hardware problem or a failure to communicate with
a remote device (USB camera etc.).

Well, I guess a disconnect can be seen as a failure to communicate :-)

I think that ENODEV is much better. After all, there is no device
anymore after a disconnect.

Is there some standard for this?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
