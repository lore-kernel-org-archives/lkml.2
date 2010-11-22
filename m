Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0KVLgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 06:36:47 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2483 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0KVLgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 06:36:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: What should poll() return when a device is unregistered ? (was "media: Media device node support")
Date: Mon, 22 Nov 2010 12:36:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-23-generic; KDE/4.4.5; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com, linux-kernel@vger.kernel.org
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com> <201011221008.06852.hverkuil@xs4all.nl> <201011221141.27945.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011221141.27945.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011221236.40194.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 22, 2010 11:41:27 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 22 November 2010 10:08:06 Hans Verkuil wrote:
> > On Monday, November 22, 2010 00:35:54 Laurent Pinchart wrote:
> > > Hi Jonathan,
> > > 
> > > I forgot to answer one of your comments.
> > > 
> > > On Wednesday 17 November 2010 01:31:15 Jonathan Corbet wrote:
> > > 
> > > [snip]
> > > 
> > > > > +static unsigned int media_poll(struct file *filp,
> > > > > +			       struct poll_table_struct *poll)
> > > > > +{
> > > > > +	struct media_devnode *mdev = media_devnode_data(filp);
> > > > > +
> > > > > +	if (!mdev->fops->poll || !media_devnode_is_registered(mdev))
> > > > > +		return DEFAULT_POLLMASK;
> > > > > +	return mdev->fops->poll(filp, poll);
> > > > > +}
> > > > 
> > > > If it's not registered, I would expect poll() to return an error.
> > > 
> > > Agreed. I'll return POLLERR | POLLHUP in that case. Is that fine with you
> > > ?
> > 
> > When I looked at this for the core code I decided to just return POLLERR.
> 
> I've copied the usbdevfs code which returns POLLERR | POLLHUP when devices are 
> disconnected.
> 
> > That seemed to be what the majority of other usb drivers do. ALSA returns
> > POLLERR | POLLNVAL, by the way, which I think is a poor choice.
> 
> Indeed, POLLNVAL has a clear semantics that doesn't apply here.

In fact, POLLNVAL is currently only set by ./sound/core/init.c and by
./drivers/media/video/zoran/zoran_driver.c. In both cases it's rather dubious.

> > This doesn't really seem to be standardized :-(
> 
> CC'ing LKML with the question.
> 
> POLLERR | POLLHUP and POLLERR won't make a difference to select(), but we 
> should still standardize on a poll() return code when devices are unregistered 
> and/or - for hot-pluggable devices - disconnected (for V4L devices 
> unregistered usually means disconnected) ?

Drivers return POLLERR, POLLERR|POLLHUP or POLLHUP in case of a disconnect.
I'm leaning towards POLLHUP as the most appropriate poll return value for a
USB disconnect.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
