Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0EAVuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 17:50:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0EAVuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 17:50:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EgWQoRz2tGIblqFAL7qcY8WYa4sM/GbdzgA3TSmyW+R5vcpbgWuuN0C/hKX+whBlD4
         qmYPJedytlwfq6IVEd6giCM4y74VqgQpJLMcVeY1n0hnoGGKlpcS4deKToHsMfbHj2jr
         UcApN6kmFIHtjSnAFFkaHkYp5o83XjtU5Xb7Q=
Date: Sat, 1 May 2010 16:58:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, Greg KH <gregkh@suse.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Pushdown bkl from v4l ioctls
Message-ID: <20100501145848.GA5353@nowhere>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org> <201004290844.29347.hverkuil@xs4all.nl> <201004290910.43412.laurent.pinchart@ideasonboard.com> <201005011155.37057.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005011155.37057.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 11:55:37AM +0200, Hans Verkuil wrote:
> On Thursday 29 April 2010 09:10:42 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Thursday 29 April 2010 08:44:29 Hans Verkuil wrote:
> > > On Thursday 29 April 2010 05:42:39 Frederic Weisbecker wrote:
> > > > Hi,
> > > > 
> > > > Linus suggested to rename struct v4l2_file_operations::ioctl
> > > > into bkl_ioctl to eventually get something greppable and make
> > > > its background explicit.
> > > > 
> > > > While at it I thought it could be a good idea to just pushdown
> > > > the bkl to every v4l drivers that have an .ioctl, so that we
> > > > actually remove struct v4l2_file_operations::ioctl for good.
> > > > 
> > > > It passed make allyesconfig on sparc.
> > > > Please tell me what you think.
> > > 
> > > I much prefer to keep the bkl inside the v4l2 core. One reason is that I
> > > think that we can replace the bkl in the core with a mutex. Still not
> > > ideal of course, so the next step will be to implement proper locking in
> > > each driver. For this some additional v4l infrastructure work needs to be
> > > done. I couldn't proceed with that until the v4l events API patches went
> > > in, and that happened yesterday.
> > > 
> > > So from my point of view the timeline is this:
> > > 
> > > 1) I do the infrastructure work this weekend. This will make it much easier
> > > to convert drivers to do proper locking. And it will also simplify
> > > v4l2_priority handling, so I'm killing two birds with one stone :-)
> > > 
> > > 2) Wait until Arnd's patch gets merged that pushes the bkl down to
> > > v4l2-dev.c
> > > 
> > > 3) Investigate what needs to be done to replace the bkl with a v4l2-dev.c
> > > global mutex. Those drivers that call the bkl themselves should probably be
> > > converted to do proper locking, but there are only about 14 drivers that do
> > > this. The other 60 or so drivers should work fine if a v4l2-dev global lock
> > > is used. At this point the bkl is effectively removed from the v4l
> > > subsystem.
> > > 
> > > 4) Work on the remaining 60 drivers to do proper locking and get rid of the
> > > v4l2-dev global lock. This is probably less work than it sounds.
> > > 
> > > Since your patch moves everything down to the driver level it will actually
> > > make this work harder rather than easier. And it touches almost all drivers
> > > as well.
> > 
> > Every driver will need to be carefully checked to make sure the BKL can be 
> > replaced by a v4l2-dev global mutex. Why would it be more difficult to do so 
> > if the BKL is pushed down to the drivers ?
> 
> The main reason is really that pushing the bkl into the v4l core makes it
> easier to review. I noticed for example that this patch series forgot to change
> the video_ioctl2 call in ivtv-ioctl.c to video_ioctl2_unlocked. And there may
> be other places as well that were missed. Having so many drivers changed also
> means a lot of careful reviewing.


Indeed, that's because I did it in a half automated way and my script
didn't took the direct calls to video_ioctl2() into account, so I had
to check them manually and probably missed a few, I will fix this one and
double check.


> 
> But I will not block this change. However, I do think it would be better to
> create a video_ioctl2_bkl rather than add a video_ioctl2_unlocked. The current
> video_ioctl2 function *is* already unlocked. So you are subtle changing the
> behavior of video_ioctl2. Not a good idea IMHO. And yes, grepping for
> video_ioctl2_bkl is also easy to do and makes it more obvious that the BKL is
> used in drivers that call this.


Totally agreed, will respin with this rename.

Thanks.

