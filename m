Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0KVKlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:41:21 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:35121 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0KVKlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:41:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: What should poll() return when a device is unregistered ? (was "media: Media device node support")
Date: Mon, 22 Nov 2010 11:41:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com, linux-kernel@vger.kernel.org
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com> <201011220035.55615.laurent.pinchart@ideasonboard.com> <201011221008.06852.hverkuil@xs4all.nl>
In-Reply-To: <201011221008.06852.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011221141.27945.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Monday 22 November 2010 10:08:06 Hans Verkuil wrote:
> On Monday, November 22, 2010 00:35:54 Laurent Pinchart wrote:
> > Hi Jonathan,
> > 
> > I forgot to answer one of your comments.
> > 
> > On Wednesday 17 November 2010 01:31:15 Jonathan Corbet wrote:
> > 
> > [snip]
> > 
> > > > +static unsigned int media_poll(struct file *filp,
> > > > +			       struct poll_table_struct *poll)
> > > > +{
> > > > +	struct media_devnode *mdev = media_devnode_data(filp);
> > > > +
> > > > +	if (!mdev->fops->poll || !media_devnode_is_registered(mdev))
> > > > +		return DEFAULT_POLLMASK;
> > > > +	return mdev->fops->poll(filp, poll);
> > > > +}
> > > 
> > > If it's not registered, I would expect poll() to return an error.
> > 
> > Agreed. I'll return POLLERR | POLLHUP in that case. Is that fine with you
> > ?
> 
> When I looked at this for the core code I decided to just return POLLERR.

I've copied the usbdevfs code which returns POLLERR | POLLHUP when devices are 
disconnected.

> That seemed to be what the majority of other usb drivers do. ALSA returns
> POLLERR | POLLNVAL, by the way, which I think is a poor choice.

Indeed, POLLNVAL has a clear semantics that doesn't apply here.

> This doesn't really seem to be standardized :-(

CC'ing LKML with the question.

POLLERR | POLLHUP and POLLERR won't make a difference to select(), but we 
should still standardize on a poll() return code when devices are unregistered 
and/or - for hot-pluggable devices - disconnected (for V4L devices 
unregistered usually means disconnected) ?

-- 
Regards,

Laurent Pinchart
